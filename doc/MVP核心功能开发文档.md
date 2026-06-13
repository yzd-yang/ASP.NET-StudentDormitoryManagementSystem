# 智慧宿舍（SmartDorm）— MVP 核心功能开发文档

---

## 一、MVP 范围定义

本文档定义学生宿舍管理系统的**最小可行产品（MVP）**，聚焦核心业务流程，快速实现可用系统。

### MVP 核心功能

| 模块 | 功能 | 优先级 | 状态 |
|------|------|--------|------|
| 认证 | 登录、注册、验证码 | P0 | ✅ 已完成 |
| 学生端 | 查看宿舍信息、故障报修、个人中心 | P0 | ✅ 已完成 |
| 学生端 | 选宿批次、抢宿舍 | P0 | ✅ 已完成 |
| 管理端 | 宿舍分配、报修处理 | P0 | ✅ 已完成 |
| 管理端 | 通知公告管理 | P0 | ✅ 已完成 |
| 管理端 | 选宿批次管理 | P0 | ✅ 已完成 |
| 管理端 | 系统管理（管理员、楼宇、院系） | P0 | ✅ 已完成 |

### 不需要的功能

- 费用缴纳
- 访客管理
- 操作日志/实时动态

---

## 二、技术栈

| 层次 | 技术 |
|------|------|
| 后端框架 | ASP.NET Web Forms 4.8 |
| 编程语言 | C# |
| 数据库 | MySQL 8.0 |
| 数据访问 | ADO.NET + MySql.Data |
| 前端 | HTML + CSS + JavaScript + ASP.NET 服务器控件 |
| 图标库 | Material Symbols Outlined |
| Web 服务器 | IIS / Visual Studio IIS Express |

---

## 三、项目目录结构

```
SmartDorm/
├── App_Code/
│   ├── DBHelper.cs              # 数据库访问封装
│   ├── UserBLL.cs               # 用户业务逻辑（登录、注册）
│   ├── DormBLL.cs               # 宿舍业务逻辑
│   └── RepairBLL.cs             # 报修业务逻辑
├── admin/
│   ├── login.aspx               # 管理端登录
│   ├── MasterPage.master        # 管理端母版页（左侧边栏）
│   ├── dashboard.aspx           # 控制台/仪表盘
│   ├── allocation.aspx          # 宿舍分配管理
│   ├── repair.aspx              # 报修管理
│   ├── notice.aspx              # 通知公告管理
│   ├── batch.aspx               # 选宿批次管理
│   ├── building.aspx            # 楼宇管理（占位页）
│   └── system.aspx              # 系统管理
├── student/
│   ├── MasterPage.master        # 学生端母版页（底部Tab导航）
│   ├── home.aspx                # 我的宿舍/首页
│   ├── notice-detail.aspx       # 公告详情
│   ├── repair.aspx              # 故障报修
│   ├── profile.aspx             # 个人中心
│   ├── batch.aspx               # 选宿批次列表
│   └── grab-dorm.aspx           # 选/抢宿舍
├── Bin/
│   └── MySql.Data.dll           # MySQL驱动
├── css/
│   ├── style.css                # 全局样式
│   ├── student.css              # 学生端样式
│   └── admin.css                # 管理端样式
├── Uploads/
│   ├── avatars/                 # 头像
│   └── repair/                  # 报修照片
├── sql/
│   ├── create_tables.sql        # 建表脚本（11张表）
│   └── init_data.sql            # 测试数据
├── login.aspx                   # 公共登录页
├── register.aspx                # 注册页
├── reset-password.aspx          # 重置密码页
├── checkcode.aspx               # 验证码
├── web.config                   # 配置文件
└── Default.aspx                 # 默认页（跳转登录）
```

---

## 四、数据库设计

### 4.1 连接配置

```xml
<!-- web.config -->
<connectionStrings>
  <add name="MySQLConnectionString"
       connectionString="Server=localhost;Port=3306;Database=smartdorm;Uid=root;Pwd=123456;CharSet=utf8mb4;"
       providerName="MySql.Data.MySqlClient" />
</connectionStrings>
```

### 4.2 数据表（共12张）

| 表名 | 用途 | 主要字段 |
|------|------|----------|
| `Students` | 学生信息 | StudentNo, Name, Phone, Password, Avatar, College, Major, Grade |
| `Admins` | 管理员信息 | AdminNo, Name, Phone, Password, Role |
| `Buildings` | 楼宇 | Name, FloorCount, RoomsPerFloor, Campus |
| `Rooms` | 房间 | BuildingId, Floor, RoomNo, RoomType, BedCount |
| `Beds` | 床位 | RoomId, BedNo, StudentId, Status |
| `RepairOrders` | 报修工单 | OrderNo, StudentId, RoomId, RepairType, Description, Photos, Status |
| `Notices` | 通知公告 | Title, Content, Scope, Category, IsTop, Status |
| `SelectionBatches` | 选宿批次 | BatchName, StartTime, EndTime, CollegeLimit, MajorLimit, Status |
| `BatchRooms` | 批次房间关联 | BatchId, RoomId |
| `FacilityStatus` | 设施状态 | RoomId, FacilityType, Status |
| `Departments` | 院系专业 | CollegeName, MajorName |
| `DormScores` | 宿舍评分 | RoomId, Score, WeekStart, CleanScore, SafetyScore |

详细字段定义见 `学生宿舍管理系统开发文档.md` 第五章。

---

## 五、已完成功能

### 5.1 公共模块

#### 登录页（login.aspx）✅
- 学生/管理员标签切换，分开登录
- 学生登录调用 `UserBLL.LoginStudent`，管理员调用 `UserBLL.LoginAdmin`
- 学生无床位时跳转选宿批次页
- 验证码校验

#### 注册页（register.aspx）✅
- 仅学生注册
- 学号、手机号、密码（6位及以上）
- 学号唯一性校验

#### 重置密码（reset-password.aspx）✅
- 两步流程：验证身份 → 设置新密码
- 验证学号/工号 + 手机号 + 验证码

#### 验证码（checkcode.aspx）✅
- GDI+ 生成4位随机字符图片
- Session存储验证码

### 5.2 学生端

#### 学生首页（student/home.aspx）✅
- 宿舍信息（校区、楼栋、房间号、床位号）— 动态数据
- 我的室友列表 — 动态数据
- 我的报修列表（类型、描述、状态）— 动态数据
- 通知公告（最新5条，点击查看详情）— 动态数据
- 快捷工具（报修申请）
- 新增公告详情页（student/notice-detail.aspx）

#### 故障报修（student/repair.aspx）✅
- 标签切换：提交申请 / 我的报修
- 提交表单：报修类型、描述、期望时间、联系电话、照片上传
- 我的报修列表：已完成、处理中、待处理三种状态卡片

#### 个人中心（student/profile.aspx）✅
- 个人信息Hero卡片（头像、姓名、学号、宿舍、手机）— 动态数据
- 个人信息卡片（邮箱、紧急联系人、学院下拉、专业下拉联动、年级、班级选填）— 动态数据
- 点击"编辑资料"进入编辑模式，保存/取消无刷新（UpdatePanel）
- 入住状态栏（已分配/未分配）
- 学院和专业使用 DropDownList，数据来自 Departments 表
- 编辑状态通过 JS 控制，避免 ASP.NET ReadOnly 阻止回发数据

#### 选宿批次（student/batch.aspx）✅
- 根据学生年级/学院/专业自动筛选可参与批次（`BatchBLL.GetBatchesForStudent`）
- 批次列表从数据库加载，显示名称、楼栋、适用年级、专业限定、状态
- 筛选栏支持按关键字和状态筛选
- 进行中批次可点击"进入选宿"，点击前校验必填信息
- 无床位学生顶部导航显示"选宿"按钮

#### 选/抢宿舍（student/grab-dorm.aspx）✅
- 倒计时区域
- 筛选条件（空床位数）
- 房间卡片网格（含床位选择和抢订按钮）
- 不同房间状态（有空位、满员等）

### 5.3 管理端

#### 仪表盘（admin/dashboard.aspx）✅
- 统计卡片（总房间数、在宿学生、空余床位、今日报修）- 动态数据
- 7日故障报修趋势图（纯CSS柱状图）- 动态数据
- 楼宇入住率分布（进度条）- 动态数据
- 快捷操作面板（处理报修、宿舍分配、发布公告，含动态数字）

#### 个人中心（admin/profile.aspx）✅
- 个人信息展示（头像、姓名、角色、工号、手机号）
- 修改基本信息（姓名、手机号）- 默认只读，点击修改后编辑
- 修改密码（验证当前密码，新密码6-20位）

#### 宿舍分配管理（admin/allocation.aspx）✅
- 筛选栏（楼栋下拉、房间号搜索）- 动态数据
- 房间卡片网格（满员、空余、空置三种状态）- 动态数据
- 床位显示（已入住学生信息、空床位可分配）
- 分配床位：搜索学生 → 选择 → 确认分配
- 退宿操作：确认后移除学生床位
- 分页功能

#### 报修管理（admin/repair.aspx）✅
- 统计卡片（待处理、处理中、紧急、今日已完成）- 动态数据
- 筛选栏（状态、宿舍楼、报修类型）- 动态数据
- 工单列表表格（工单号、类型、位置、描述、时间、状态）- 动态数据
- 点击行弹出详情面板（学生信息、报修描述、派工处理、内部备注）
- 指派技工、完成工单、驳回、保存备注功能
- 分页功能

#### 通知公告管理（admin/notice.aspx）✅
- 发布新公告表单（标题、范围、类别、内容、置顶开关、发送开关）- 动态数据
- 已发公告列表（标题、范围、时间、状态、操作）- 动态数据
- 状态筛选（全部、已发布、草稿）- 动态数据
- 编辑/撤回/发布/删除功能
- 分页功能

#### 选宿批次管理（admin/batch.aspx）✅
- 统计卡片（总批次、进行中、待开始、已结束）- 动态数据
- 筛选栏（批次名称、状态、适用年级、学院）- 动态数据
- 批次列表表格（名称、时间、限定条件、状态、操作）- 动态数据
- 创建/编辑批次弹窗（名称、时间、年级/学院/专业限定、房间选择）- 动态数据
- 房间选择：楼栋+楼层筛选，按钮网格点击选择，已选标签显示
- 删除批次功能

#### 系统管理（admin/system.aspx）✅
- 管理员账号管理（搜索、角色/状态筛选、新增、编辑、重置密码、删除）- 动态数据
- 楼宇管理（列表、新增、编辑、删除）- 动态数据
- 房间管理（查看楼宇房间、修改状态、删除、单独添加）- 动态数据
- 批量生成房间（选楼宇、类型、楼层范围、每层房间数）- 动态数据，含验证
- 院系专业管理（树形结构、添加学院/专业、编辑、删除）- 动态数据
- 权限控制：仅超级管理员（Role=1）可访问，其他角色跳转仪表盘

---

## 六、业务逻辑层（BLL）

### 6.1 DBHelper.cs

```csharp
public class DBHelper
{
    public static MySqlConnection GetConnection()
    public static int ExecuteNonQuery(string sql, params MySqlParameter[] parameters)
    public static object ExecuteScalar(string sql, params MySqlParameter[] parameters)
    public static DataTable GetDataTable(string sql, params MySqlParameter[] parameters)
    public static MySqlDataReader GetReader(string sql, params MySqlParameter[] parameters)
    public static bool ExecuteTransaction(string[] sqls, MySqlParameter[][] parameters)
}
```

### 6.2 UserBLL.cs

```csharp
public class UserBLL
{
    public static string GetMD5(string input)
    public static DataTable Login(string userNo, string password)
    public static bool RegisterStudent(string studentNo, string name, string phone, string password)
    public static DataTable GetStudentById(int studentId)
    public static bool UpdateStudentInfo(int studentId, string email, string emergencyContact, string emergencyRelation, string emergencyPhone, string college, string major, string grade, string className)
    public static DataTable GetAdminById(int adminId)
}
```

### 6.3 DormBLL.cs

```csharp
public class DormBLL
{
    public static DataTable GetStudentDormInfo(int studentId)
    public static DataTable GetRoommates(int studentId)
    public static DataTable GetBuildings()
    public static DataTable GetRoomsByBuilding(int buildingId)
    public static DataTable GetRoomBeds(int roomId)
    public static bool AllocateBed(int bedId, int studentId)      // 分配床位（含检查学生是否已有床位）
    public static bool ReleaseBed(int bedId)
    public static bool HasBed(int studentId)                       // 检查学生是否有床位
    public static DataTable SearchStudents(string keyword)         // 搜索无床位学生
    public static DataTable SearchStudents(string keyword, string college, string major, string grade, string className) // 多条件搜索
    public static int GetTotalRooms()
    public static int GetTotalStudents()
    public static int GetAvailableBeds()
    public static DataTable GetBuildingOccupancy()
    public static int GetTotalBeds()
    public static DataTable GetAllRooms(...)                       // 获取房间（支持楼层/类型/状态筛选分页）
    public static int GetRoomCount(...)                            // 获取房间数量（支持筛选）
    public static DataTable GetFloorsByBuilding(int buildingId)
    public static DataTable GetAllFloors()
    public static DataTable GetBuildingList()                      // 楼宇列表（含房间数）
    public static bool AddBuilding(...)
    public static bool UpdateBuilding(...)
    public static bool DeleteBuilding(int id)
    public static int BatchCreateRooms(...)                        // 批量生成房间（含床位）
    public static DataTable GetRoomsByBuildingForManage(int buildingId) // 获取楼宇房间（含入住数）
    public static bool AddRoom(...)                                // 添加单个房间（含床位）
    public static bool UpdateRoomStatus(int roomId, int status)   // 切换房间状态
    public static bool DeleteRoom(int roomId)                      // 删除房间（含清除床位）
    public static DataTable GetColleges()
    public static DataTable GetMajorsByCollege(string college)
    public static DataTable GetGrades()
    public static DataTable GetClasses(...)
}
```

### 6.4 RepairBLL.cs

```csharp
public class RepairBLL
{
    public static string GenerateOrderNo()
    public static bool CreateRepairOrder(...)
    public static DataTable GetStudentRepairOrders(int studentId, int status = 0)
    public static DataTable GetAllRepairOrders(int status = 0)
    public static bool AssignRepairOrder(int orderId, int adminId)
    public static bool CompleteRepairOrder(int orderId)
    public static bool RejectRepairOrder(int orderId, string reason)
    public static int GetPendingRepairCount()
    public static int GetProcessingRepairCount()
    public static int GetTodayRepairCount()
    public static int GetUrgentRepairCount()
    public static DataTable GetRepairTrendByDay(int days)
    public static DataTable GetRepairList(...)             // 管理端工单列表（支持筛选分页）
    public static int GetRepairListCount(...)              // 工单总数（支持筛选）
    public static DataTable GetRepairById(int id)          // 获取单个工单详情
    public static DataTable GetRepairStats()               // 统计数据
    public static DataTable GetAdminListForAssign()        // 获取可指派管理员
    public static bool UpdateInternalNote(int orderId, string note) // 保存内部备注
}
```

### 6.5 AdminBLL.cs

```csharp
public class AdminBLL
{
    public static string GetMD5(string input)
    public static DataTable GetAdminList(string keyword, int role, int status)
    public static bool AddAdmin(string adminNo, string name, string phone, string password, int role)
    public static bool UpdateAdmin(int id, string name, string phone, int role, int status)
    public static bool ResetPassword(int id, string newPassword)
    public static bool DeleteAdmin(int id)
}
```

### 6.6 DeptBLL.cs

```csharp
public class DeptBLL
{
    public static DataTable GetDepartmentTree()
    public static bool AddDepartment(string collegeName, string majorName)
    public static bool UpdateDepartment(int id, string majorName)
    public static bool DeleteDepartment(int id)
}
```

### 6.7 BatchBLL.cs

```csharp
public class BatchBLL
{
    public static DataTable GetBatchList(string keyword, int status, string grade, string college)
    public static DataTable GetBatchStats()
    public static DataTable GetBatchesForStudent(string studentGrade, string studentCollege, string studentMajor, string keyword, int status)
    public static bool AddBatch(string batchName, DateTime startTime, DateTime endTime, string gradeLimit, string collegeLimit, string majorLimit, int adminId, int[] roomIds)
    public static bool UpdateBatch(...)
    public static bool DeleteBatch(int id)
    public static DataTable GetBatchRooms(int batchId)
    public static DataTable GetBuildingsForBatch()
    public static DataTable GetRoomsForBatch(int buildingId, int floor)
}
```

### 6.8 NoticeBLL.cs

```csharp
public class NoticeBLL
{
    public static DataTable GetNoticeList(string keyword, int status, int pageIndex, int pageSize)
    public static int GetNoticeCount(string keyword, int status)
    public static bool AddNotice(string title, string content, int scope, int category, int isTop, int status, int adminId)
    public static bool UpdateNotice(int id, string title, string content, int scope, int category, int isTop)
    public static bool PublishNotice(int id)
    public static bool WithdrawNotice(int id)
    public static bool DeleteNotice(int id)
    public static DataTable GetNoticeById(int id)
}
```

---

## 七、安全设计

| 项目 | 措施 |
|------|------|
| 密码存储 | MD5 哈希 |
| SQL 注入 | 全部使用 MySqlParameter 参数化查询 |
| 验证码 | GDI+ 动态生成 + Session 校验 |
| 登录校验 | Page_Load 检查 Session，未登录跳转 |
| 文件上传 | 限制类型（jpg/png）、大小（5MB）、重命名存储 |
| 权限隔离 | 学生端/管理端独立母版页 + Session 角色校验 |

---

## 八、页面鉴权

### 学生端页面

```csharp
// 每个学生端页面 Page_Load 中检查
if (Session["UserId"] == null)
{
    Response.Redirect("/login.aspx");
    return;
}
```

### 管理端页面

```csharp
// 每个管理端页面 Page_Load 中检查
if (Session["AdminId"] == null)
{
    Response.Redirect("/admin/login.aspx");
    return;
}
```

---

## 九、开发进度

| 阶段 | 内容 | 状态 |
|------|------|------|
| 第一阶段 | 数据库建表脚本、web.config、DBHelper | ✅ 已完成 |
| 第二阶段 | 登录、注册、验证码 | ✅ 已完成 |
| 第三阶段 | 学生端母版页、首页（宿舍信息展示） | ✅ 已完成 |
| 第四阶段 | 学生端故障报修（提交+列表） | ✅ 已完成 |
| 第五阶段 | 学生端个人中心 | ✅ 已完成 |
| 第六阶段 | 学生端选宿批次、抢宿舍 | ✅ 已完成 |
| 第七阶段 | 管理端母版页、仪表盘 | ✅ 已完成 |
| 第八阶段 | 管理端宿舍分配 | ✅ 已完成 |
| 第九阶段 | 管理端报修管理 | ✅ 已完成 |
| 第十阶段 | 管理端通知公告 | ✅ 已完成 |
| 第十一阶段 | 管理端选宿批次管理 | ✅ 已完成 |
| 第十二阶段 | 管理端系统管理 | ✅ 已完成 |

---

## 十、测试账号

| 角色 | 账号 | 密码 | 说明 |
|------|------|------|------|
| 学生 | 2023010001 | 123456 | 张小明，已分配A-101 |
| 学生 | 2023010003 | 123456 | 王小强，已分配A-101 |
| 学生 | 2023010006 | 123456 | 陈小红，已分配A-102 |
| 管理员 | admin001 | 123456 | 超级管理员 |
| 管理员 | admin002 | 123456 | 宿管 |
| 管理员 | admin004 | 123456 | 后勤 |

---

## 十一、待开发功能（需新建BLL）

| 功能 | 需新建的BLL | 状态 |
|------|------------|------|
| 通知公告CRUD | NoticeBLL.cs | ✅ 已完成 |
| 选宿批次CRUD | BatchBLL.cs | ✅ 已完成 |
| 管理员管理CRUD | AdminBLL.cs | ✅ 已完成 |
| 院系专业管理 | DeptBLL.cs | ✅ 已完成 |
| 老师注册 | UserBLL.RegisterAdmin | 待开发 |
| 重置密码 | UserBLL.ResetPassword | 待开发 |
| 宿舍评分 | DormScores表（可选） | 低优先级 |

---

## 十二、编码注意事项

- `.aspx` 和 `.aspx.cs` 是配对文件，改逻辑必须同时理解两者
- `App_Code/` 下的类自动参与编译，新增文件无需手动引用
- 学生端母版页提供底部Tab导航，管理端母版页提供左侧边栏导航
- 所有数据库操作必须使用参数化查询
- 所有 `.aspx` 文件必须使用 UTF-8 with BOM 编码
- `@ Page` 指令需添加 `ResponseEncoding="utf-8"`
- `@ Master` 指令不支持 `ResponseEncoding`，由 BOM 和 web.config 保证编码
