# Delta for Database Schema

## ADDED Requirements

### Requirement: BatchCollegeLimit 关联表
新增 `BatchCollegeLimit(BatchId, CollegeName)` 表，替代 `SelectionBatches.CollegeLimit` JSON 字段。
- 外键关联 `SelectionBatches(Id)`
- 联合唯一约束 `(BatchId, CollegeName)`

### Requirement: BatchMajorLimit 关联表
新增 `BatchMajorLimit(BatchId, MajorName)` 表，替代 `SelectionBatches.MajorLimit` JSON 字段。
- 外键关联 `SelectionBatches(Id)`
- 联合唯一约束 `(BatchId, MajorName)`

### Requirement: Colleges 独立表
新增 `Colleges(Id, CollegeName, SortOrder)` 表，从 `Departments` 拆出学院维度。
- `CollegeName` UNIQUE
- `Departments` 改为 `CollegeId` 外键关联

### Requirement: NoticeScope 关联表
新增 `NoticeScope(NoticeId, BuildingId)` 表，替代 `Notices.Scope` 硬编码枚举。
- 外键关联 `Notices(Id)` 和 `Buildings(Id)`
- `Scope=0`（全体）不插入记录，查询时以无记录表示全体

### Requirement: BatchRooms 唯一约束
`BatchRooms` 表增加 `UNIQUE(BatchId, RoomId)` 约束，防止同一批次重复添加房间。

## MODIFIED Requirements

### Requirement: Students 表
- 移除 `College VARCHAR(100)` 和 `Major VARCHAR(100)` 文本列
- 新增 `DepartmentId INT` 外键指向 `Departments(Id)`
- 学院和专业信息通过 JOIN `Departments` + `Colleges` 获取

### Requirement: Departments 表
- 移除 `CollegeName VARCHAR(100)` 列
- 新增 `CollegeId INT` 外键指向 `Colleges(Id)`
- `SortOrder` 移至 `Colleges` 表

### Requirement: SelectionBatches 表
- 移除 `CollegeLimit VARCHAR(500)` 和 `MajorLimit VARCHAR(500)` 列
- 限制条件改为通过关联表 `BatchCollegeLimit` / `BatchMajorLimit` 存储

### Requirement: Notices 表
- 移除 `Scope TINYINT` 列
- 发送范围改为通过关联表 `NoticeScope` 存储

### Requirement: Rooms 测试数据
- 修正 `RoomType` 与 `BedCount` 的矛盾：RoomType=1（双人间）对应 BedCount=2，RoomType=2（四人间）对应 BedCount=4，RoomType=3（六人间）对应 BedCount=6

## REMOVED Requirements

（无）
