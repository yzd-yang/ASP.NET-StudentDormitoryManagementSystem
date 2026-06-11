# 智慧宿舍（SmartDorm）— MVP 核心功能开发文档

---

## 一、MVP 范围定义

本文档定义学生宿舍管理系统的**最小可行产品（MVP）**，聚焦核心业务流程，快速实现可用系统。

### MVP 核心功能

| 模块 | 功能 | 优先级 | 状态 |
|------|------|--------|------|
| 认证 | 登录、注册、验证码 | P0 | 已完成 |
| 学生端 | 查看宿舍信息、故障报修 | P0 | 进行中 |
| 管理端 | 宿舍分配、报修处理、楼宇房间管理 | P0 | 进行中 |

### 非 MVP 功能（后续迭代）

- 选宿批次 / 抢宿舍
- 通知公告
- 仪表盘统计图表
- 费用缴纳
- 院系专业管理
- 管理员账号管理

---

## 二、技术栈

| 层次 | 技术 |
|------|------|
| 后端框架 | ASP.NET Web Forms 4.8 |
| 编程语言 | C# |
| 数据库 | MySQL 8.0 |
| 数据访问 | ADO.NET + MySql.Data 6.10.9 |
| 前端 | HTML + CSS + JavaScript + ASP.NET 服务器控件 |
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
│   ├── allocation.aspx          # 宿舍分配管理（待开发）
│   ├── repair.aspx              # 报修管理（待开发）
│   └── building.aspx            # 楼宇房间管理（待开发）
├── student/
│   ├── MasterPage.master        # 学生端母版页（底部Tab导航）
│   ├── home.aspx                # 我的宿舍/首页
│   ├── repair.aspx              # 故障报修（待开发）
│   └── profile.aspx             # 个人中心（待开发）
├── Bin/
│   └── MySql.Data.dll           # MySQL驱动（v6.10.9）
├── css/
│   ├── style.css                # 全局样式
│   ├── student.css              # 学生端样式
│   └── admin.css                # 管理端样式
├── js/
│   └── common.js                # 公共脚本
├── Uploads/
│   ├── avatars/                 # 头像
│   └── repair/                  # 报修照片
├── sql/
│   ├── create_tables.sql        # 建表脚本（11张表）
│   └── init_data.sql            # 测试数据
├── login.aspx                   # 公共登录页
├── register.aspx                # 注册页
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

#### 学生表（Students）

| 字段 | 类型 | 约束 | 说明 |
|------|------|------|------|
| Id | INT | PK, AUTO_INCREMENT | 主键 |
| StudentNo | VARCHAR(20) | UNIQUE, NOT NULL | 学号 |
| Name | VARCHAR(50) | NOT NULL | 姓名 |
| Phone | VARCHAR(11) | NOT NULL | 手机号 |
| Password | VARCHAR(64) | NOT NULL | 密码（MD5） |
| Avatar | VARCHAR(255) | DEFAULT NULL | 头像路径 |
| College | VARCHAR(100) | DEFAULT NULL | 学院 |
| Major | VARCHAR(100) | DEFAULT NULL | 专业 |
| Grade | VARCHAR(20) | DEFAULT NULL | 年级 |
| ClassName | VARCHAR(50) | DEFAULT NULL | 班级 |
| Email | VARCHAR(100) | DEFAULT NULL | 邮箱 |
| EmergencyContact | VARCHAR(50) | DEFAULT NULL | 紧急联系人 |
| EmergencyRelation | VARCHAR(20) | DEFAULT NULL | 关系 |
| EmergencyPhone | VARCHAR(11) | DEFAULT NULL | 紧急联系人电话 |
| Status | TINYINT | DEFAULT 1 | 1正常 0禁用 |
| CreateTime | DATETIME | DEFAULT CURRENT_TIMESTAMP | 注册时间 |

#### 管理员表（Admins）

| 字段 | 类型 | 约束 | 说明 |
|------|------|------|------|
| Id | INT | PK, AUTO_INCREMENT | 主键 |
| AdminNo | VARCHAR(20) | UNIQUE, NOT NULL | 工号 |
| Name | VARCHAR(50) | NOT NULL | 姓名 |
| Phone | VARCHAR(11) | NOT NULL | 手机号 |
| Password | VARCHAR(64) | NOT NULL | 密码（MD5） |
| Role | TINYINT | NOT NULL | 1超级管理员 2宿管 3后勤 |
| Status | TINYINT | DEFAULT 1 | 1正常 0禁用 |
| CreateTime | DATETIME | DEFAULT CURRENT_TIMESTAMP | 创建时间 |

#### 楼宇表（Buildings）

| 字段 | 类型 | 约束 | 说明 |
|------|------|------|------|
| Id | INT | PK, AUTO_INCREMENT | 主键 |
| Name | VARCHAR(50) | NOT NULL | 楼宇名称 |
| FloorCount | INT | NOT NULL | 楼层数 |
| RoomsPerFloor | INT | NOT NULL | 每层房间数 |
| Campus | VARCHAR(50) | DEFAULT NULL | 校区 |
| Status | TINYINT | DEFAULT 1 | 1正常 0停用 |
| CreateTime | DATETIME | DEFAULT CURRENT_TIMESTAMP | 创建时间 |

#### 房间表（Rooms）

| 字段 | 类型 | 约束 | 说明 |
|------|------|------|------|
| Id | INT | PK, AUTO_INCREMENT | 主键 |
| BuildingId | INT | FK → Buildings.Id | 所属楼宇 |
| Floor | INT | NOT NULL | 楼层 |
| RoomNo | VARCHAR(20) | NOT NULL | 房间号 |
| RoomType | TINYINT | NOT NULL | 1双人间 2四人间 3六人间 |
| BedCount | INT | NOT NULL | 总床位数 |
| Status | TINYINT | DEFAULT 1 | 1正常 0停用 |
| CreateTime | DATETIME | DEFAULT CURRENT_TIMESTAMP | 创建时间 |

#### 床位表（Beds）

| 字段 | 类型 | 约束 | 说明 |
|------|------|------|------|
| Id | INT | PK, AUTO_INCREMENT | 主键 |
| RoomId | INT | FK → Rooms.Id | 所属房间 |
| BedNo | VARCHAR(10) | NOT NULL | 床位号（A/B/C/D） |
| StudentId | INT | FK → Students.Id, NULL | 入住学生 |
| Status | TINYINT | DEFAULT 0 | 0空置 1已分配 |
| AllocateTime | DATETIME | DEFAULT NULL | 分配时间 |

#### 报修工单表（RepairOrders）

| 字段 | 类型 | 约束 | 说明 |
|------|------|------|------|
| Id | INT | PK, AUTO_INCREMENT | 主键 |
| OrderNo | VARCHAR(30) | UNIQUE, NOT NULL | 工单编号 |
| StudentId | INT | FK → Students.Id | 报修学生 |
| RoomId | INT | FK → Rooms.Id | 报修宿舍 |
| RepairType | TINYINT | NOT NULL | 1水电 2家具家电 3网络 4其他 |
| Description | TEXT | NOT NULL | 描述 |
| Photos | VARCHAR(1000) | DEFAULT NULL | 照片路径JSON |
| ExpectTime | DATETIME | DEFAULT NULL | 期望上门时间 |
| ContactPhone | VARCHAR(11) | NOT NULL | 联系电话 |
| Status | TINYINT | DEFAULT 1 | 1待分配 2维修中 3紧急处理 4已完成 5已驳回 |
| AssignAdminId | INT | FK → Admins.Id, NULL | 指派技工 |
| InternalNote | TEXT | DEFAULT NULL | 内部备注 |
| RejectReason | VARCHAR(500) | DEFAULT NULL | 驳回原因 |
| CreateTime | DATETIME | DEFAULT CURRENT_TIMESTAMP | 报修时间 |
| CompleteTime | DATETIME | DEFAULT NULL | 完成时间 |

#### 通知公告表（Notices）

| 字段 | 类型 | 约束 | 说明 |
|------|------|------|------|
| Id | INT | PK, AUTO_INCREMENT | 主键 |
| Title | VARCHAR(100) | NOT NULL | 标题 |
| Content | TEXT | NOT NULL | 内容（富文本） |
| Scope | TINYINT | DEFAULT 0 | 0全体 1A栋 2B栋 3C栋 |
| Category | TINYINT | NOT NULL | 1行政通知 2安全警示 3生活服务 4活动资讯 |
| IsTop | TINYINT | DEFAULT 0 | 0否 1是 |
| Status | TINYINT | DEFAULT 0 | 0草稿 1已发布 2已撤回 |
| PublishTime | DATETIME | DEFAULT NULL | 发布时间 |
| AdminId | INT | FK → Admins.Id | 发布人 |
| CreateTime | DATETIME | DEFAULT CURRENT_TIMESTAMP | 创建时间 |

#### 选宿批次表（SelectionBatches）

| 字段 | 类型 | 约束 | 说明 |
|------|------|------|------|
| Id | INT | PK, AUTO_INCREMENT | 主键 |
| BatchName | VARCHAR(100) | NOT NULL | 批次名称 |
| StartTime | DATETIME | NOT NULL | 开始时间 |
| EndTime | DATETIME | NOT NULL | 截止时间 |
| CollegeLimit | VARCHAR(500) | DEFAULT NULL | 学院限定JSON |
| MajorLimit | VARCHAR(500) | DEFAULT NULL | 专业限定JSON |
| GradeLimit | VARCHAR(20) | DEFAULT NULL | 年级限定 |
| Status | TINYINT | DEFAULT 0 | 0待开始 1进行中 2已结束 3已暂停 |
| AdminId | INT | FK → Admins.Id | 创建人 |
| CreateTime | DATETIME | DEFAULT CURRENT_TIMESTAMP | 创建时间 |

#### 批次房间关联表（BatchRooms）

| 字段 | 类型 | 约束 | 说明 |
|------|------|------|------|
| Id | INT | PK, AUTO_INCREMENT | 主键 |
| BatchId | INT | FK → SelectionBatches.Id | 批次ID |
| RoomId | INT | FK → Rooms.Id | 房间ID |

#### 设施状态表（FacilityStatus）

| 字段 | 类型 | 约束 | 说明 |
|------|------|------|------|
| Id | INT | PK, AUTO_INCREMENT | 主键 |
| RoomId | INT | FK → Rooms.Id | 房间ID |
| FacilityType | TINYINT | NOT NULL | 1空调 2热水器 3照明 4网络 |
| Status | TINYINT | DEFAULT 1 | 1正常 2报修中 3故障 |
| UpdateTime | DATETIME | DEFAULT CURRENT_TIMESTAMP | 更新时间 |

#### 院系专业表（Departments）

| 字段 | 类型 | 约束 | 说明 |
|------|------|------|------|
| Id | INT | PK, AUTO_INCREMENT | 主键 |
| CollegeName | VARCHAR(100) | NOT NULL | 学院名称 |
| MajorName | VARCHAR(100) | NOT NULL | 专业名称 |
| SortOrder | INT | DEFAULT 0 | 排序号 |

---

## 五、已完成功能

### 5.1 登录注册模块

#### 登录页（login.aspx）
- 学号/工号 + 密码 + 验证码
- 数据库验证，区分学生/管理员角色
- 登录成功后跳转对应首页

#### 注册页（register.aspx）
- 学生注册：学号、手机号、密码
- 学号唯一性校验
- 密码MD5加密存储

#### 验证码（checkcode.aspx）
- GDI+ 生成4位随机字符图片
- Session存储验证码

### 5.2 学生端

#### 学生首页（student/home.aspx）
- 显示宿舍信息卡片（校区、楼栋、房间号、床位号）
- 显示室友列表
- 显示设施状态

### 5.3 管理端

#### 管理端母版页（admin/MasterPage.master）
- 左侧边栏导航
- 用户下拉菜单
- 导航分组和徽章

#### 仪表盘（admin/dashboard.aspx）
- 统计卡片（总房间、在宿学生、空余床位、待处理报修）
- 快捷操作入口

---

## 六、业务逻辑层（BLL）

### 6.1 DBHelper.cs

```csharp
// 数据库访问封装
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
// 用户业务逻辑
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
// 宿舍业务逻辑
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
// 报修业务逻辑
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

### 学生端母版页

```csharp
// student/MasterPage.master.cs
protected void Page_Load(object sender, EventArgs e)
{
    if (Session["UserId"] == null)
    {
        Response.Redirect("/login.aspx");
        return;
    }
    string role = Session["Role"] != null ? Session["Role"].ToString() : "";
    if (role != "student")
    {
        Response.Redirect("/login.aspx");
    }
}
```

### 管理端母版页

```csharp
// admin/MasterPage.master.cs
protected void Page_Load(object sender, EventArgs e)
{
    if (Session["AdminId"] == null)
    {
        Response.Redirect("/admin/login.aspx");
        return;
    }
    string role = Session["Role"] != null ? Session["Role"].ToString() : "";
    if (role != "admin")
    {
        Response.Redirect("/admin/login.aspx");
    }
}
```

---

## 九、开发进度

| 阶段 | 内容 | 状态 |
|------|------|------|
| 第一阶段 | 数据库建表脚本、web.config、DBHelper | 已完成 |
| 第二阶段 | 登录、注册、验证码 | 已完成 |
| 第三阶段 | 学生端母版页、首页（宿舍信息展示） | 已完成 |
| 第四阶段 | 学生端故障报修（提交+列表） | 待开发 |
| 第五阶段 | 学生端个人中心 | 待开发 |
| 第六阶段 | 管理端母版页、仪表盘 | 已完成 |
| 第七阶段 | 管理端宿舍分配（分配+退宿） | 待开发 |
| 第八阶段 | 管理端报修管理（派工+完成+驳回） | 待开发 |
| 第九阶段 | 管理端楼宇房间管理 | 待开发 |

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

## 十一、后续迭代计划

| 迭代 | 功能 | 优先级 |
|------|------|--------|
| V1.1 | 学生端故障报修、个人中心 | P0 |
| V1.2 | 管理端宿舍分配、报修管理 | P0 |
| V1.3 | 管理端楼宇房间管理 | P0 |
| V1.4 | 选宿批次、抢宿舍（含并发控制） | P1 |
| V1.5 | 通知公告管理 | P1 |
| V1.6 | 仪表盘统计（ECharts 图表） | P2 |
| V1.7 | 费用缴纳 | P2 |
| V1.8 | 系统管理（管理员账号、院系专业） | P2 |

---

## 十二、注意事项

- `.aspx` 和 `.aspx.cs` 是配对文件，改逻辑必须同时理解两者
- `App_Code/` 下的类自动参与编译，新增文件无需手动引用
- 学生端母版页提供底部Tab导航，管理端母版页提供左侧边栏导航
- 图片上传路径：头像 `Uploads/avatars/`，报修照片 `Uploads/repair/`
- 所有数据库操作必须使用参数化查询
- MySql.Data.dll 版本为 6.10.9，兼容 .NET Framework 4.0
- C# 代码中不要使用 `?.` 空条件运算符（.NET 4.0 不支持）
- 中文字符串使用 Unicode 转义序列避免编码问题