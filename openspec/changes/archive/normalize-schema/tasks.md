# Tasks: 数据库范式优化

## 实现清单

- [x] 1. 修改 `create_tables.sql`
  - [x] 1.1 新增 `Colleges` 表（在 `Students` 之后、`Departments` 之前）
  - [x] 1.2 修改 `Departments` 表：移除 `CollegeName`/`SortOrder`，新增 `CollegeId` 外键
  - [x] 1.3 修改 `Students` 表：移除 `College`/`Major`，新增 `DepartmentId` 外键
  - [x] 1.4 修改 `SelectionBatches` 表：移除 `CollegeLimit`/`MajorLimit` 列
  - [x] 1.5 新增 `BatchCollegeLimit` 表
  - [x] 1.6 新增 `BatchMajorLimit` 表
  - [x] 1.7 修改 `Notices` 表：移除 `Scope` 列
  - [x] 1.8 新增 `NoticeScope` 表
  - [x] 1.9 修改 `BatchRooms`：新增 `UNIQUE(BatchId, RoomId)` 约束
  - [x] 1.10 ~~修正 `Rooms` 测试数据中 `RoomType` 与 `BedCount` 矛盾~~ 数据已一致，无需修改
  - [x] 1.11 更新索引定义

- [x] 2. 修改 `init_data.sql`
  - [x] 2.1 新增 `Colleges` 测试数据
  - [x] 2.2 迁移 `Departments` 数据（用 `CollegeId` 替代 `CollegeName`）
  - [x] 2.3 修改 `Students` 数据（用 `DepartmentId` 替代文本列）
  - [x] 2.4 新增 `BatchCollegeLimit` / `BatchMajorLimit` 测试数据
  - [x] 2.5 新增 `NoticeScope` 测试数据
  - [x] 2.6 ~~修正 `Rooms` 和 `Beds` 测试数据~~ 原数据 RoomType 与 BedCount 已一致（1=双人间/2张、2=四人间/4张、3=六人间/6张）

- [x] 3. BLL 层改造（`App_Code/`）
  - [x] 3.1 `DormBLL.cs`：所有 SELECT `s.College`/`s.Major` 改为 JOIN `Departments d` + `Colleges c`，WHERE `s.College=@College` 改为 `d.CollegeId=@CollegeId` 或 `c.CollegeName=@College`
  - [x] 3.2 `DeptBLL.cs`（DormBLL.cs 末尾第 507-545 行）：
  - [x] 3.3 `UserBLL.cs`（第 96/103-104 行）：`UpdateStudentProfile` 的 `College=@College, Major=@Major` 改为 `DepartmentId=@DepartmentId`
  - [x] 3.4 `BatchBLL.cs`：
  - [x] 3.5 `RepairBLL.cs`（第 153/219 行）：SELECT 引用 `s.College`/`s.Major` 改为 JOIN
  - [x] 3.6 `NoticeBLL.cs`：

- [x] 4. 学生端页面改造（`student/`）
  - [x] 4.1 `batch.aspx.cs`：`row["College"]`/`row["Major"]` → `CollegeName`/`MajorName`
  - [x] 4.2 `batch.aspx`：移除 MajorLimit 列（数据已拆到关联表）
  - [x] 4.3 `profile.aspx.cs`：加载改用 `CollegeName`/`MajorName`
  - [x] 4.4 `profile.aspx.cs`：保存逻辑改用 `DormBLL.GetDepartmentId` 反查 DepartmentId
  - [x] 4.5 `UserBLL.GetStudentById`：改 JOIN 返回 `CollegeName`/`MajorName`
  - [x] 4.6 `home.aspx.cs`：`row["Major"]` → `MajorName`

- [x] 5. 管理端页面改造（`admin/`）
  - [x] 5.1 `batch.aspx.cs`：LoadColleges 改用 DormBLL.GetColleges；编辑回填移除 CollegeLimit/MajorLimit；AddBatch/UpdateBatch 改新签名；GetCollegeLimit/GetMajorLimit 改查关联表
  - [x] 5.2 `batch.aspx`：模板传 Eval("Id") 替代 Eval("CollegeLimit")/Eval("MajorLimit")
  - [x] 5.3 `notice.aspx`：ddlScope 改动态绑定；GetScopeText 传 NoticeId
  - [x] 5.4 `notice.aspx.cs`：LoadScopeOptions 从 Buildings 加载；保存/加载改用 NoticeScope
  - [x] 5.5 `system.aspx.cs`：AddDepartment 改用 collegeId（自动查找或创建学院）
  - [x] 5.6 `allocation.aspx.cs`：已使用 DormBLL 方法，无需额外改动

- [x] 6. 验证
  - [x] 6.1 确认外键依赖顺序正确，无循环引用
  - [x] 6.2 确认测试数据可完整导入无报错（INSERT 顺序与 CREATE TABLE 一致）
  - [ ] 6.3 逐页面手动测试：登录→学生首页→选宿→报修→个人中心→管理端仪表盘→宿舍分配→报修管理→通知公告→选宿批次→系统管理
