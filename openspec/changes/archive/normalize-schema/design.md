# Design: 数据库范式优化

## 新增表定义

### Colleges
```sql
CREATE TABLE Colleges (
    Id INT PRIMARY KEY AUTO_INCREMENT,
    CollegeName VARCHAR(100) NOT NULL UNIQUE COMMENT '学院名称',
    SortOrder INT DEFAULT 0 COMMENT '排序号'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='学院表';
```

### BatchCollegeLimit
```sql
CREATE TABLE BatchCollegeLimit (
    Id INT PRIMARY KEY AUTO_INCREMENT,
    BatchId INT NOT NULL COMMENT '批次ID',
    CollegeName VARCHAR(100) NOT NULL COMMENT '学院名称',
    FOREIGN KEY (BatchId) REFERENCES SelectionBatches(Id),
    UNIQUE KEY uk_batch_college (BatchId, CollegeName)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='批次学院限制';
```

### BatchMajorLimit
```sql
CREATE TABLE BatchMajorLimit (
    Id INT PRIMARY KEY AUTO_INCREMENT,
    BatchId INT NOT NULL COMMENT '批次ID',
    MajorName VARCHAR(100) NOT NULL COMMENT '专业名称',
    FOREIGN KEY (BatchId) REFERENCES SelectionBatches(Id),
    UNIQUE KEY uk_batch_major (BatchId, MajorName)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='批次专业限制';
```

### NoticeScope
```sql
CREATE TABLE NoticeScope (
    Id INT PRIMARY KEY AUTO_INCREMENT,
    NoticeId INT NOT NULL COMMENT '通知ID',
    BuildingId INT NOT NULL COMMENT '楼宇ID',
    FOREIGN KEY (NoticeId) REFERENCES Notices(Id),
    FOREIGN KEY (BuildingId) REFERENCES Buildings(Id),
    UNIQUE KEY uk_notice_building (NoticeId, BuildingId)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='通知范围';
```

## 修改表变更

### Students
- 移除：`College VARCHAR(100)`, `Major VARCHAR(100)`
- 新增：`DepartmentId INT DEFAULT NULL`，外键 → `Departments(Id)`
- 移除索引：`idx_students_college`
- 新增索引：`idx_students_department ON Students(DepartmentId)`

### Departments
- 移除：`CollegeName VARCHAR(100)`, `SortOrder INT`
- 新增：`CollegeId INT NOT NULL`，外键 → `Colleges(Id)`
- 移除索引：`idx_departments_college`
- 新增索引：`idx_departments_collegeid ON Departments(CollegeId)`

### SelectionBatches
- 移除：`CollegeLimit VARCHAR(500)`, `MajorLimit VARCHAR(500)`

### Notices
- 移除：`Scope TINYINT`

### BatchRooms
- 新增：`UNIQUE KEY uk_batch_room (BatchId, RoomId)`

## 建表顺序

因外键依赖，建表顺序调整为：
1. Students → 2. Admins → 3. Buildings → 4. Rooms → 5. Beds → 6. RepairOrders → 7. **Colleges** → 8. Departments（依赖 Colleges）→ 9. SelectionBatches → 10. **BatchCollegeLimit** / **BatchMajorLimit** → 11. Notices → 12. **NoticeScope** → 13. BatchRooms → 14. FacilityStatus → 15. DormScores

## 测试数据变更

### Students
- 原：`College='信息工程学院', Major='计算机科学与技术'`
- 改：`DepartmentId=1`（对应 Departments 表中计算机科学与技术）

### Rooms 测试数据（已验证，无需修改）
- 经核实，原数据中 RoomType 与 BedCount 已一致：
  - `RoomType=1`（双人间）：BedCount=2 ✓
  - `RoomType=2`（四人间）：BedCount=4 ✓
  - `RoomType=3`（六人间）：BedCount=6 ✓

### 新增 Colleges 数据
```sql
INSERT INTO Colleges (CollegeName, SortOrder) VALUES
('信息工程学院', 1), ('外国语学院', 2), ('经济管理学院', 3), ('艺术设计学院', 4);
```

### Departments 数据迁移
```sql
INSERT INTO Departments (CollegeId, MajorName) VALUES
(1, '计算机科学与技术'), (1, '软件工程'), (1, '网络工程'), (1, '物联网工程'),
(2, '英语'), (2, '日语'), (2, '翻译'),
(3, '工商管理'), (3, '市场营销'), (3, '会计学'), (3, '电子商务'),
(4, '视觉传达设计'), (4, '环境设计'), (4, '产品设计');
```

### NoticeScope 数据
原 `Scope=0`（全体）不插入记录；原 `Scope=1`（A栋）插入 `(NoticeId, BuildingId=1)`。
