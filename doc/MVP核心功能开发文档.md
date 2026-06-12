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

### 4.2 数据表（共11张）

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

详细字段定义见 `学生宿舍管理系统开发文档.md` 第五章。

---

## 五、已完成功能

### 5.1 公共模块

#### 登录页（login.aspx）✅
- 学号/工号 + 密码 + 验证码
- 数据库验证，区分学生/管理员角色
- 登录成功后跳转对应首页

#### 注册页（register.aspx）✅
- 学生注册/老师注册标签切换
- 学号、手机号、密码
- 学号唯一性校验

#### 重置密码（reset-password.aspx）✅
- 两步流程：验证身份 → 设置新密码
- 验证学号/工号 + 手机号 + 验证码

#### 验证码（checkcode.aspx）✅
- GDI+ 生成4位随机字符图片
- Session存储验证码

### 5.2 学生端

#### 学生首页（student/home.aspx）✅
- 宿舍信息卡片（校区、楼栋、房间号、床位号）
- 宿舍评分（静态数据，94分优秀）
- 室友列表
- 设施状态（空调、热水器、照明、校园网）
- 提交报修入口
- 快捷工具（宿舍预约、管理规章）

#### 故障报修（student/repair.aspx）✅
- 标签切换：提交申请 / 我的报修
- 提交表单：报修类型、描述、期望时间、联系电话、照片上传
- 我的报修列表：已完成、处理中、待处理三种状态卡片

#### 个人中心（student/profile.aspx）✅
- 个人信息Hero卡片（头像、姓名、学号、宿舍、手机）
- 联系信息（邮箱、紧急联系人）
- 学业信息（学院、专业）
- 入住状态

#### 选宿批次（student/batch.aspx）✅
- 筛选栏（批次名称、楼栋、学院、专业、状态）
- 批次列表表格（含状态标签和操作按钮）
- 选宿小贴士

#### 选/抢宿舍（student/grab-dorm.aspx）✅
- 倒计时区域
- 筛选条件（空床位数）
- 房间卡片网格（含床位选择和抢订按钮）
- 不同房间状态（有空位、满员等）

### 5.3 管理端

#### 仪表盘（admin/dashboard.aspx）✅
- 统计卡片（总房间数、在宿学生、空余床位、今日报修）
- 7日故障报修趋势图（纯CSS柱状图）
- 楼宇入住率分布（进度条）
- 快捷操作面板

#### 宿舍分配管理（admin/allocation.aspx）✅
- 筛选栏（楼栋、房间号）
- 操作按钮（批量导入、导出表格、集中退宿）
- 房间卡片网格（满员、空余、空置三种状态）
- 床位分配操作

#### 报修管理（admin/repair.aspx）✅
- 统计卡片（待处理、处理中、紧急、今日已完成）
- 筛选栏（状态、宿舍楼、报修类型）
- 工单列表表格
- 右侧详情面板（学生信息、报修描述、派工处理、内部备注、驳回/完成按钮）

#### 通知公告管理（admin/notice.aspx）✅
- 发布新公告表单（标题、范围、类别、富文本编辑器、置顶开关、发送开关）
- 已发公告列表（标题、范围、时间、状态、操作）
- 状态筛选（全部、已发布、草稿）
- 分页

#### 选宿批次管理（admin/batch.aspx）✅
- 统计卡片（总批次、进行中、待开始、已结束）
- 筛选栏
- 批次列表表格
- 创建新批次弹窗

#### 系统管理（admin/system.aspx）✅
- 管理员账号管理表格
- 楼宇管理列表
- 批量生成房间表单
- 院系专业树形结构

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
    public static bool UpdateStudentInfo(int studentId, string email, string emergencyContact, string emergencyPhone)
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
    public static bool AllocateBed(int bedId, int studentId)
    public static bool ReleaseBed(int bedId)
    public static DataTable SearchStudents(string keyword)
    public static int GetTotalRooms()
    public static int GetTotalStudents()
    public static int GetAvailableBeds()
}
```

### 6.4 RepairBLL.cs

```csharp
public class RepairBLL
{
    public static string GenerateOrderNo()
    public static bool CreateRepairOrder(int studentId, int roomId, int repairType, string description, string expectTime, string contactPhone)
    public static DataTable GetStudentRepairOrders(int studentId, int status = 0)
    public static DataTable GetAllRepairOrders(int status = 0)
    public static bool AssignRepairOrder(int orderId, int adminId)
    public static bool CompleteRepairOrder(int orderId)
    public static bool RejectRepairOrder(int orderId, string reason)
    public static int GetPendingRepairCount()
    public static int GetProcessingRepairCount()
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

| 功能 | 需新建的BLL | 优先级 |
|------|------------|--------|
| 通知公告CRUD | NoticeBLL.cs | 高 |
| 选宿批次CRUD | BatchBLL.cs | 高 |
| 管理员管理CRUD | AdminBLL.cs | 高 |
| 院系专业管理 | DeptBLL.cs | 高 |
| 老师注册 | UserBLL.RegisterAdmin | 中 |
| 重置密码 | UserBLL.ResetPassword | 中 |
| 宿舍评分 | DormScores表（可选） | 低 |

---

## 十二、编码注意事项

- `.aspx` 和 `.aspx.cs` 是配对文件，改逻辑必须同时理解两者
- `App_Code/` 下的类自动参与编译，新增文件无需手动引用
- 学生端母版页提供底部Tab导航，管理端母版页提供左侧边栏导航
- 所有数据库操作必须使用参数化查询
- 所有 `.aspx` 文件必须使用 UTF-8 with BOM 编码
- `@ Page` 指令需添加 `ResponseEncoding="utf-8"`
- `@ Master` 指令不支持 `ResponseEncoding`，由 BOM 和 web.config 保证编码
