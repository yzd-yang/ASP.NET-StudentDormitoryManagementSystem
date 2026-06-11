# 智慧宿舍（SmartDorm）— MVP 核心功能开发文档

---

## 一、MVP 范围定义

本文档定义学生宿舍管理系统的**最小可行产品（MVP）**，聚焦核心业务流程，快速实现可用系统。

### MVP 核心功能

| 模块 | 功能 | 优先级 |
|------|------|--------|
| 认证 | 登录、注册、验证码 | P0 |
| 学生端 | 查看宿舍信息、故障报修 | P0 |
| 管理端 | 宿舍分配、报修处理、楼宇房间管理 | P0 |

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
| 数据访问 | ADO.NET + MySql.Data |
| 前端 | HTML + CSS + JavaScript + ASP.NET 服务器控件 |
| Web 服务器 | IIS / Visual Studio IIS Express |

---

## 三、MVP 目录结构

```
SmartDorm/
├── App_Code/
│   ├── DBHelper.cs              # 数据库访问封装
│   ├── StudentBLL.cs            # 学生业务逻辑
│   ├── DormBLL.cs               # 宿舍业务逻辑
│   └── RepairBLL.cs             # 报修业务逻辑
├── admin/
│   ├── login.aspx               # 管理端登录
│   ├── MasterPage.master        # 管理端母版页
│   ├── allocation.aspx          # 宿舍分配管理
│   ├── repair.aspx              # 报修管理
│   └── building.aspx            # 楼宇房间管理
├── student/
│   ├── MasterPage.master        # 学生端母版页
│   ├── home.aspx                # 我的宿舍/首页
│   ├── repair.aspx              # 故障报修
│   └── profile.aspx             # 个人中心
├── Bin/
│   └── MySql.Data.dll           # MySQL驱动
├── css/
│   └── style.css                # 全局样式
├── js/
│   └── common.js                # 公共脚本
├── Uploads/
│   ├── avatars/                 # 头像
│   └── repair/                  # 报修照片
├── login.aspx                   # 公共登录页
├── register.aspx                # 注册页
├── checkcode.aspx               # 验证码
├── web.config                   # 配置文件
└── database.sql                 # 数据库建表脚本
```

---

## 四、数据库设计（MVP 精简版）

### 4.1 连接配置

```xml
<!-- web.config -->
<connectionStrings>
  <add name="MySQLConnectionString"
       connectionString="Server=localhost;Port=3306;Database=smartdorm;Uid=root;Pwd=123456;CharSet=utf8mb4;"
       providerName="MySql.Data.MySqlClient" />
</connectionStrings>
```

### 4.2 数据表

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
| Status | TINYINT | DEFAULT 1 | 1待分配 2维修中 3已完成 4已驳回 |
| AssignAdminId | INT | FK → Admins.Id, NULL | 指派技工 |
| RejectReason | VARCHAR(500) | DEFAULT NULL | 驳回原因 |
| CreateTime | DATETIME | DEFAULT CURRENT_TIMESTAMP | 报修时间 |
| CompleteTime | DATETIME | DEFAULT NULL | 完成时间 |

---

## 五、MVP 功能设计

### 5.1 登录注册模块

#### 5.1.1 登录页

- **路径**：`/login.aspx`
- **字段**：学号/工号 + 密码 + 验证码
- **逻辑**：
  1. 验证验证码
  2. 先查 Students 表，匹配则跳转学生端
  3. 再查 Admins 表，匹配则跳转管理端
  4. 都不匹配提示错误
- **Session**：
  - 学生：`Session["UserId"]`, `Session["UserNo"]`, `Session["Role"]="student"`
  - 管理员：`Session["AdminId"]`, `Session["AdminNo"]`, `Session["Role"]="admin"`

#### 5.1.2 注册页

- **路径**：`/register.aspx`
- **字段**：学号/工号、手机号、密码、确认密码
- **校验**：学号/工号唯一、手机号格式、密码强度（8-20位）

#### 5.1.3 验证码

- **路径**：`/checkcode.aspx`
- **实现**：GDI+ 生成4位随机字符图片，存 `Session["CheckCode"]`

---

### 5.2 学生端模块

#### 5.2.1 我的宿舍首页

- **路径**：`/student/home.aspx`
- **功能**：
  - 宿舍信息卡片（校区、楼栋、房间号、床位号）
  - 室友列表（头像、姓名、学院）
  - 快捷入口：报修、个人中心
- **数据查询**：
  ```sql
  SELECT b.Campus, bd.Name AS BuildingName, r.RoomNo, bed.BedNo
  FROM Beds bed
  JOIN Rooms r ON bed.RoomId = r.Id
  JOIN Buildings bd ON r.BuildingId = bd.Id
  WHERE bed.StudentId = @StudentId
  ```

#### 5.2.2 故障报修

- **路径**：`/student/repair.aspx`
- **Tab 切换**：提交申请 / 我的报修

**提交申请表单**：

| 字段 | 类型 | 必填 | 说明 |
|------|------|------|------|
| 报修类型 | 单选 | 是 | 水电/家具家电/网络/其他 |
| 详细描述 | 文本域 | 是 | 10-500字 |
| 期望上门时间 | 日期时间 | 是 | — |
| 联系电话 | 文本 | 是 | 11位手机号 |
| 现场照片 | 文件上传 | 否 | 最多3张，jpg/png，5MB |

**我的报修列表**：
- 显示：工单编号、报修类型、提交时间、状态标签
- 支持按状态筛选
- 点击查看详情

#### 5.2.3 个人中心

- **路径**：`/student/profile.aspx`
- **功能**：查看/编辑个人信息（邮箱、紧急联系人）
- **只读字段**：学号、姓名、学院、专业、年级

---

### 5.3 管理端模块

#### 5.3.1 宿舍分配管理

- **路径**：`/admin/allocation.aspx`
- **筛选**：楼栋下拉、房间号搜索
- **房间卡片**：显示房间号、入住状态（满员/空余X张/全空置）、已入住/总床位
- **分配操作**：
  1. 点击房间卡片展开床位
  2. 点击空床位弹出分配弹窗
  3. 搜索学生（学号/姓名模糊搜索）
  4. 确认分配
- **退宿操作**：点击已分配床位 → 确认退宿 → 清空 StudentId

#### 5.3.2 报修管理

- **路径**：`/admin/repair.aspx`
- **统计**：待处理数量、处理中数量
- **筛选**：状态、楼栋、报修类型
- **工单列表**：工单ID、类型、宿舍位置、描述、报修时间、状态
- **详情面板**：点击工单展开
  - 现场照片（可放大）
  - 学生信息（姓名、学号、电话）
  - 报修描述
  - 指派技工（下拉选择管理员）
  - 操作按钮：确认完成 / 驳回（需填原因）

**状态流转**：
```
待分配 → 维修中 → 已完成
待分配 → 驳回
```

#### 5.3.3 楼宇房间管理

- **路径**：`/admin/building.aspx`
- **楼宇列表**：名称、楼层数、每层房间数、操作（编辑/删除）
- **新增楼宇**：名称、楼层数、每层房间数、校区
- **批量生成房间**：
  1. 选择楼宇
  2. 输入楼层数、每层房间数
  3. 选择房间类型（双人间/四人间/六人间）
  4. 预览 → 确认批量创建（同时生成对应床位）

---

## 六、数据访问层（DBHelper）

```csharp
using System;
using System.Data;
using System.Configuration;
using MySql.Data.MySqlClient;

public class DBHelper
{
    private static string connStr = ConfigurationManager.ConnectionStrings["MySQLConnectionString"].ConnectionString;

    public static MySqlConnection GetConnection()
    {
        return new MySqlConnection(connStr);
    }

    public static int ExecuteNonQuery(string sql, params MySqlParameter[] parameters)
    {
        using (MySqlConnection conn = GetConnection())
        {
            conn.Open();
            MySqlCommand cmd = new MySqlCommand(sql, conn);
            if (parameters != null) cmd.Parameters.AddRange(parameters);
            return cmd.ExecuteNonQuery();
        }
    }

    public static object ExecuteScalar(string sql, params MySqlParameter[] parameters)
    {
        using (MySqlConnection conn = GetConnection())
        {
            conn.Open();
            MySqlCommand cmd = new MySqlCommand(sql, conn);
            if (parameters != null) cmd.Parameters.AddRange(parameters);
            return cmd.ExecuteScalar();
        }
    }

    public static DataTable GetDataTable(string sql, params MySqlParameter[] parameters)
    {
        using (MySqlConnection conn = GetConnection())
        {
            conn.Open();
            MySqlCommand cmd = new MySqlCommand(sql, conn);
            if (parameters != null) cmd.Parameters.AddRange(parameters);
            MySqlDataAdapter adapter = new MySqlDataAdapter(cmd);
            DataTable dt = new DataTable();
            adapter.Fill(dt);
            return dt;
        }
    }

    public static MySqlDataReader GetReader(string sql, params MySqlParameter[] parameters)
    {
        MySqlConnection conn = GetConnection();
        conn.Open();
        MySqlCommand cmd = new MySqlCommand(sql, conn);
        if (parameters != null) cmd.Parameters.AddRange(parameters);
        return cmd.ExecuteReader(CommandBehavior.CloseConnection);
    }

    public static bool ExecuteTransaction(params (string sql, MySqlParameter[] param)[] commands)
    {
        using (MySqlConnection conn = GetConnection())
        {
            conn.Open();
            MySqlTransaction transaction = conn.BeginTransaction();
            try
            {
                foreach (var (sql, param) in commands)
                {
                    MySqlCommand cmd = new MySqlCommand(sql, conn, transaction);
                    if (param != null) cmd.Parameters.AddRange(param);
                    cmd.ExecuteNonQuery();
                }
                transaction.Commit();
                return true;
            }
            catch
            {
                transaction.Rollback();
                return false;
            }
        }
    }
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

## 八、页面鉴权示例

### 学生端页面基类

```csharp
// student/MasterPage.master.cs
protected void Page_Load(object sender, EventArgs e)
{
    if (Session["UserId"] == null || Session["Role"]?.ToString() != "student")
    {
        Response.Redirect("/login.aspx");
    }
}
```

### 管理端页面基类

```csharp
// admin/MasterPage.master.cs
protected void Page_Load(object sender, EventArgs e)
{
    if (Session["AdminId"] == null || Session["Role"]?.ToString() != "admin")
    {
        Response.Redirect("/admin/login.aspx");
    }
}
```

---

## 九、MVP 开发计划

| 阶段 | 内容 | 预计周期 |
|------|------|----------|
| 第一阶段 | 数据库建表脚本、web.config、DBHelper | 2天 |
| 第二阶段 | 登录、注册、验证码 | 2天 |
| 第三阶段 | 学生端母版页、首页（宿舍信息展示） | 2天 |
| 第四阶段 | 学生端故障报修（提交+列表） | 2天 |
| 第五阶段 | 学生端个人中心 | 1天 |
| 第六阶段 | 管理端母版页、楼宇房间管理 | 2天 |
| 第七阶段 | 管理端宿舍分配（分配+退宿） | 2天 |
| 第八阶段 | 管理端报修管理（派工+完成+驳回） | 2天 |
| 第九阶段 | 联调测试、Bug修复 | 3天 |

**总计约 18 天**

---

## 十、后续迭代计划

MVP 完成后，按优先级迭代：

| 迭代 | 功能 | 优先级 |
|------|------|--------|
| V1.1 | 选宿批次、抢宿舍（含并发控制） | P1 |
| V1.2 | 通知公告管理 | P1 |
| V1.3 | 仪表盘统计（ECharts 图表） | P2 |
| V1.4 | 费用缴纳 | P2 |
| V1.5 | 系统管理（管理员账号、院系专业） | P2 |

---

## 十一、注意事项

- `.aspx` 和 `.aspx.cs` 是配对文件，改逻辑必须同时理解两者
- `App_Code/` 下的类自动参与编译，新增文件无需手动引用
- 学生端母版页提供底部Tab导航，管理端母版页提供左侧边栏导航
- 图片上传路径：头像 `Uploads/avatars/`，报修照片 `Uploads/repair/`
- 所有数据库操作必须使用参数化查询
