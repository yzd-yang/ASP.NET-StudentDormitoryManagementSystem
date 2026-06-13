# Proposal: 选宿舍高并发与锁机制

## 背景

当前 `DormBLL.AllocateBed` 方法的实现：

```csharp
public static bool AllocateBed(int bedId, int studentId)
{
    // 检查学生是否已有床位
    string checkSql = "SELECT COUNT(*) FROM Beds WHERE StudentId=@StudentId AND Status=1";
    // ...
    // 分配床位
    string sql = "UPDATE Beds SET StudentId=@StudentId, Status=1, AllocateTime=NOW() WHERE Id=@Id AND Status=0";
    // ...
}
```

**问题**：两步操作之间没有原子性保证。多个学生同时抢同一个床位时：
1. 学生A 检查 → 无床位 ✓
2. 学生B 检查 → 无床位 ✓
3. 学生A 更新 → 成功
4. 学生B 更新 → 也成功（`Status=0` 条件已不满足，但 `WHERE Status=0` 能挡住）

实际上 `WHERE Status=0` 能防止已分配的床位被覆盖，但**不能防止两个请求同时通过检查**。更严重的是"检查学生已有床位"和"分配床位"之间存在竞态条件。

## 目标

- 保证同一床位只能被一个学生抢到
- 保证同一学生不能重复分配床位
- 在 MySQL + ADO.NET + Web Forms 架构下实现
- 不引入 Redis 或分布式锁等外部依赖

## 非目标

- 不实现排队系统
- 不实现秒杀级别的超高并发优化
- 不改变现有 BLL 层调用方式

## 约束

- 数据库：MySQL 8.0，InnoDB 引擎
- 连接方式：ADO.NET（MySqlConnection）
- 不使用 Entity Framework
- .NET Framework 4.8
