# Design: 选宿舍并发控制方案

## 问题分析

当前 `AllocateBed` 的竞态条件：

```
时间线    学生A                          学生B
──────────────────────────────────────────────────
T1       SELECT COUNT(*) → 0 (无床位)
T2                                      SELECT COUNT(*) → 0 (无床位)
T3       UPDATE ... WHERE Status=0 → 成功
T4                                      UPDATE ... WHERE Status=0 → 成功?!
```

`WHERE Status=0` 能挡住"覆盖已分配床位"，但**不能阻止两人同时通过检查**。更严重的是"检查学生已有床位"和"分配床位"之间没有原子性。

---

## 方案 A：应用层 lock（不推荐）

### 原理
```csharp
private static readonly object _lock = new object();

public static bool AllocateBed(int bedId, int studentId)
{
    lock (_lock)
    {
        // 检查 + 更新
    }
}
```

### 分析
| 维度 | 评价 |
|------|------|
| 复杂度 | 极低 |
| 可靠性 | **极差** — `lock` 仅在单进程内有效，IIS 多工作进程/多服务器部署时无效 |
| 性能 | 差 — 全局锁串行化所有请求 |
| 适用 | 仅限本地开发演示 |

### 结论
**不采用**。Web 场景下 `lock` 不是有效的并发控制手段。

---

## 方案 B：单一 UPDATE 原子操作（推荐 ✅）

### 原理
将"检查 + 分配"合并为一条 SQL，利用 `WHERE` 条件的原子性：

```sql
-- 第一步：原子分配床位（一条 SQL 完成检查+更新）
UPDATE Beds 
SET StudentId=@StudentId, Status=1, AllocateTime=NOW() 
WHERE Id=@BedId AND Status=0;

-- 如果 affected_rows=1，分配成功
-- 如果 affected_rows=0，床位已被占或不存在

-- 第二步：检查学生是否已有其他床位（防重复）
SELECT COUNT(*) FROM Beds WHERE StudentId=@StudentId AND Status=1;
-- 如果 >1，说明有重复，回滚（DELETE 刚才的记录）
```

### 代码实现
```csharp
public static bool AllocateBed(int bedId, int studentId)
{
    // 1. 原子更新：只有 Status=0 才能成功
    string sql = "UPDATE Beds SET StudentId=@Sid, Status=1, AllocateTime=NOW() WHERE Id=@Id AND Status=0";
    int affected = DBHelper.ExecuteNonQuery(sql, new MySqlParameter[] {
        new MySqlParameter("@Sid", studentId),
        new MySqlParameter("@Id", bedId)
    });

    if (affected == 0) return false; // 床位已被占

    // 2. 检查学生是否有重复床位
    string check = "SELECT COUNT(*) FROM Beds WHERE StudentId=@Sid AND Status=1";
    int count = Convert.ToInt32(DBHelper.ExecuteScalar(check, new MySqlParameter[] {
        new MySqlParameter("@Sid", studentId)
    }));

    if (count > 1)
    {
        // 有重复，回滚
        DBHelper.ExecuteNonQuery("UPDATE Beds SET StudentId=NULL, Status=0, AllocateTime=NULL WHERE Id=@Id",
            new MySqlParameter[] { new MySqlParameter("@Id", bedId) });
        return false;
    }

    return true;
}
```

### 分析
| 维度 | 评价 |
|------|------|
| 复杂度 | 低 — 无需事务，无需改 DBHelper |
| 可靠性 | **高** — `UPDATE WHERE Status=0` 是数据库层面的原子操作 |
| 性能 | 极好 — 无锁等待，无事务开销 |
| 缺点 | 第二步检查学生重复床位时有微小窗口（但概率极低，且有补偿回滚） |

### 并发验证
```
时间线    学生A                                    学生B
──────────────────────────────────────────────────────────
T1       UPDATE Beds SET ... WHERE Id=1 AND Status=0
T2       (affected=1, 成功)                        UPDATE Beds SET ... WHERE Id=1 AND Status=0
T3                                                  (affected=0, 床位已被占 → 失败)
结果     ✅ 成功                                    ❌ 失败（正确）
```

---

## 方案 C：事务 + SELECT FOR UPDATE（可选）

### 原理
```sql
START TRANSACTION;
SELECT Status FROM Beds WHERE Id=@BedId FOR UPDATE;  -- 行级锁
-- 检查 + 更新
COMMIT;
```

### 代码实现
```csharp
public static bool AllocateBed(int bedId, int studentId)
{
    return DBHelper.ExecuteInTransaction((conn, tx) =>
    {
        MySqlCommand cmd1 = new MySqlCommand(
            "SELECT Status FROM Beds WHERE Id=@Id FOR UPDATE", conn, tx);
        cmd1.Parameters.AddWithValue("@Id", bedId);
        object status = cmd1.ExecuteScalar();

        if (status == null || Convert.ToInt32(status) != 0)
            return false;

        MySqlCommand cmd2 = new MySqlCommand(
            "SELECT COUNT(*) FROM Beds WHERE StudentId=@Sid AND Status=1", conn, tx);
        cmd2.Parameters.AddWithValue("@Sid", studentId);
        if (Convert.ToInt32(cmd2.ExecuteScalar()) > 0)
            return false;

        MySqlCommand cmd3 = new MySqlCommand(
            "UPDATE Beds SET StudentId=@Sid, Status=1, AllocateTime=NOW() WHERE Id=@Id AND Status=0", conn, tx);
        cmd3.Parameters.AddWithValue("@Sid", studentId);
        cmd3.Parameters.AddWithValue("@Id", bedId);
        return cmd3.ExecuteNonQuery() > 0;
    });
}
```

### 分析
| 维度 | 评价 |
|------|------|
| 复杂度 | 中 — 需要新增 `ExecuteInTransaction` 泛型方法 |
| 可靠性 | **最高** — 排他锁保证严格串行 |
| 性能 | 较差 — 锁等待，高并发时吞吐量下降 |
| 适用 | 业务逻辑复杂、需要多步读写的场景 |

### 并发验证
```
时间线    学生A                          学生B
──────────────────────────────────────────────────
T1       BEGIN                          (等待)
T2       SELECT ... FOR UPDATE          
T3       (锁定床位1)                    BEGIN
T4       检查 ✓                         (阻塞)
T5       UPDATE → 成功                  
T6       COMMIT                         (获得锁)
T7                                      检查：Status=1 → 失败
T8                                      ROLLBACK
结果     ✅ 成功                         ❌ 失败（正确）
```

---

## 方案 D：乐观锁 + 版本号（可选）

### 原理
在 `Beds` 表加 `Version` 字段，更新时检查版本号：

```sql
-- 先读取版本号
SELECT Version FROM Beds WHERE Id=@BedId AND Status=0;

-- 更新时带版本号
UPDATE Beds SET StudentId=@StudentId, Status=1, AllocateTime=NOW(), Version=Version+1 
WHERE Id=@BedId AND Status=0 AND Version=@OldVersion;
-- affected=0 表示版本已变，有人抢先操作
```

### 代码实现
```csharp
public static bool AllocateBed(int bedId, int studentId)
{
    // 1. 读取版本号
    string getVer = "SELECT Version FROM Beds WHERE Id=@Id AND Status=0";
    object verObj = DBHelper.ExecuteScalar(getVer, new MySqlParameter[] { new MySqlParameter("@Id", bedId) });
    if (verObj == null) return false;
    int oldVersion = Convert.ToInt32(verObj);

    // 2. 带版本号更新
    string sql = @"UPDATE Beds SET StudentId=@Sid, Status=1, AllocateTime=NOW(), Version=Version+1 
                   WHERE Id=@Id AND Status=0 AND Version=@Ver";
    int affected = DBHelper.ExecuteNonQuery(sql, new MySqlParameter[] {
        new MySqlParameter("@Sid", studentId),
        new MySqlParameter("@Id", bedId),
        new MySqlParameter("@Ver", oldVersion)
    });

    if (affected == 0) return false; // 版本已变

    // 3. 检查重复床位（同方案B）
    // ...
}
```

### 分析
| 维度 | 评价 |
|------|------|
| 复杂度 | 中 — 需要加字段、改表结构 |
| 可靠性 | 高 — 版本号冲突时更新失败 |
| 性能 | 好 — 无锁等待 |
| 缺点 | 需要改表结构加 `Version` 列；读-写之间有窗口（但被版本号挡住） |

---

## 方案 E：UNIQUE 约束 + 异常捕获（可选）

### 原理
利用数据库唯一约束防止重复分配。给 `Beds` 表加条件唯一索引（MySQL 不支持部分索引，变通方案）：

```sql
-- 新增辅助表
CREATE TABLE BedAllocations (
    BedId INT NOT NULL UNIQUE,
    StudentId INT NOT NULL UNIQUE,
    AllocateTime DATETIME DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (BedId),
    FOREIGN KEY (StudentId) REFERENCES Students(Id)
);

-- 分配时直接 INSERT，利用 UNIQUE 约束
INSERT INTO BedAllocations (BedId, StudentId) VALUES (@BedId, @StudentId);
-- 如果 BedId 或 StudentId 重复，抛出 DuplicateKeyException
```

### 分析
| 维度 | 评价 |
|------|------|
| 复杂度 | 高 — 需要新增表、改 BLL 逻辑 |
| 可靠性 | **最高** — 数据库层面绝对保证 |
| 性能 | 好 — 无锁，依赖索引 |
| 缺点 | 改动大，需要维护两张表的同步 |

---

## 最终决策

| 方案 | 选择 | 理由 |
|------|------|------|
| A. lock | ✗ | Web 场景无效 |
| **B. 单一 UPDATE** | **✓ 首选** | **最简单可靠，改动最小** |
| C. FOR UPDATE | △ 备选 | 业务变复杂时升级使用 |
| D. 乐观锁 | △ 备选 | 需要改表结构 |
| E. UNIQUE 约束 | ✗ | 改动过大 |

**先实现方案 B，如后续业务复杂度上升再升级到方案 C。**
