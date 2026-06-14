# AGENTS.md — SmartDorm 学生宿舍管理系统

## 项目概况

ASP.NET Web Forms 4.8 **Website 模型**（非 Web Application），无 `.sln`/`.csproj` 文件。IIS 或 VS IIS Express 直接托管网站目录。

- 后端：C# + ADO.NET + MySql.Data
- 数据库：MySQL 8.0，库名 `smartdorm`，字符集 `utf8mb4`
- 前端：HTML + CSS + JS + ASP.NET 服务器控件

## 必须遵守的编码规则

### 文件编码（最容易踩坑）

所有 `.aspx`、`.aspx.cs`、`.master`、`.master.cs` 文件**必须 UTF-8 with BOM**。缺少 BOM 会导致中文乱码，且错误不会在编译时暴露。

检查 BOM：读取文件前 3 字节，有 BOM 为 `EF BB BF`。

### C# 语法限制

.NET Framework 4.8 默认 C# 7.0 以下，**不支持**：
- 模式匹配：`if (obj is DataTable dt)` → 用 `as` + null 检查
- `out` 变量声明：`int.TryParse(s, out int i)` → 先声明再传入
- 元组解构、`switch` 模式匹配

### @ Page 指令

`.aspx` 文件的 `@ Page` 需加 `ResponseEncoding="utf-8"`。`@ Master` **不支持**此属性，母版页编码由 BOM + web.config 保证。

### SQL 规范

所有数据库操作**必须使用 `MySqlParameter` 参数化查询**，禁止字符串拼接。

## 架构要点

### 目录职责

| 目录 | 说明 |
|------|------|
| `App_Code/` | 业务逻辑层（BLL），Website 模型自动编译，新增 `.cs` 文件即生效，无需手动引用 |
| `admin/` | 管理端页面，母版页 `MasterPage.master`（左侧边栏） |
| `student/` | 学生端页面，母版页 `MasterPage.master`（底部 Tab） |
| `Bin/` | `MySql.Data.dll` 驱动 |
| `css/` | `style.css`（全局）、`student.css`、`admin.css` |
| `sql/` | `create_tables.sql`（建表）、`init_data.sql`（测试数据） |
| `Uploads/` | 头像 `avatars/`、报修照片 `repair/`，需写入权限 |

### 页面文件配对

`.aspx` 和 `.aspx.cs` 是配对文件。改后端逻辑必须同时看 `.aspx` 中的服务器控件定义，否则会引用不存在的控件导致 `CS0103` 错误。

### Session 鉴权模式

每个页面 `Page_Load` 检查 Session，未登录跳转：
- 学生端：检查 `Session["UserId"]`，跳转 `/login.aspx`
- 管理端：检查 `Session["AdminId"]`，跳转 `/admin/login.aspx`

### BLL 层概览

| 文件 | 职责 |
|------|------|
| `DBHelper.cs` | 数据库访问封装（ExecuteNonQuery/Scalar/GetDataTable/GetReader/ExecuteTransaction） |
| `UserBLL.cs` | 登录、注册、学生信息 |
| `DormBLL.cs` | 宿舍/房间/床位/楼宇管理，**`DeptBLL` 类也在此文件末尾**（院系专业 CRUD） |
| `RepairBLL.cs` | 报修工单全生命周期 |
| `AdminBLL.cs` | 管理员账号 CRUD |
| `BatchBLL.cs` | 选宿批次管理 |
| `NoticeBLL.cs` | 通知公告管理 |

## 数据库初始化

```bash
# 1. 建库建表
mysql -u root -p < sql/create_tables.sql
# 2. 导入测试数据
mysql -u root -p smartdorm < sql/init_data.sql
```

连接字符串在 `web.config` 的 `connectionStrings` 节点，默认 `root/123456`。

### 表结构要点（v3.0 范式优化后）

**16 张表**，核心关联链：

```
Colleges → Departments → Students → Beds → Rooms → Buildings
                  ↓
         SelectionBatches → BatchCollegeLimit / BatchMajorLimit / BatchRooms
                  ↓
              Notices → NoticeScope → Buildings
```

关键设计决策：
- `Students` 用 `DepartmentId` 外键（非 College/Major 文本），查询学院/专业需 JOIN `Departments` + `Colleges`
- `SelectionBatches` 的学院/专业限制拆到 `BatchCollegeLimit`/`BatchMajorLimit` 关联表（非 JSON 字段）
- `Notices` 的发送范围拆到 `NoticeScope` 关联表（非 Scope 枚举），无记录=全体
- `BatchRooms(BatchId, RoomId)` 有 UNIQUE 约束

BLL 层查询这些表时普遍使用三表 JOIN：`Students s JOIN Departments d ON s.DepartmentId=d.Id JOIN Colleges c ON d.CollegeId=c.Id`

## 测试账号

| 角色 | 账号 | 密码 |
|------|------|------|
| 学生 | 2023010001 | 123456 |
| 超级管理员 | admin001 | 123456 |
| 宿管 | admin002 | 123456 |

## 前端设计约定

- 主色调：薄荷绿 `#49EACE`，CSS 变量定义在 `css/style.css`
- 图标：Material Symbols Outlined
- 学生端移动端优先（<768px），管理端桌面优先（≥1024px）
- 毛玻璃卡片效果：半透明白色 + `backdrop-filter: blur`

## 年级下拉框数据源

所有年级下拉框统一使用 `DormBLL.GetGradeYearRange()`，基于当前年份前后5年动态生成（如2026年→"2021级"~"2031级"）。不再使用数据库查询或硬编码。

## 选宿批次页面交互模式（`admin/batch.aspx`）

弹窗内联动下拉框采用 **RegisterStartupScript 预加载 + JS 按需读取** 方案：

```
Page_Load → 查 DB → 构建 JSON → RegisterStartupScript 注入 JS 变量
                                       ↓
                            var _bd={"1":{"floors":[1,2,...],"rooms":[...]},...};
                            var _md={"信息工程学院":["计算机科学与技术",...],...};
                                       ↓
选择学院/楼栋/楼层 → JS 直接读 _bd/_md → 填充下拉框+渲染房间
```

- **不要用 HiddenField 存数据**：回发后值丢失
- **不要用 AutoPostBack**：弹窗内回发会导致模态框状态丢失
- **不要用 AJAX handler**：本项目不需要额外的 .ashx 接口
- 每次回发 `RegisterStartupScript` 都会重新注入，确保数据始终可用
- 选中房间用 `hfSelectedRoomIds` HiddenField 传递给服务端保存
- 房间数据含 `R` 字段：`1`=不可选（已被其他批次占用或已满），`0`=可选
- 编辑批次时 `LoadBatchData()` 需在设置 `hfBatchId.Value` 之后调用，排除当前批次房间使其可编辑（`R=0`）
- `UpdateBatch` 方法的 `roomIds` 参数为可选（`int[] roomIds = null`），编辑时必须传入

## 常见陷阱

1. **CS0103 控件不存在**：`.aspx` 中删除了服务器控件但 `.aspx.cs` 仍引用，或反过来
2. **中文乱码**：三要素缺一不可——BOM + `ResponseEncoding` + web.config globalization
3. **抢宿舍并发**：使用数据库事务 + `SELECT ... FOR UPDATE` 行锁
4. **图片上传路径**：头像 `Uploads/avatars/`，报修照片 `Uploads/repair/`，限制 jpg/png、5MB
5. **弹窗内联动下拉框**：不要用 AutoPostBack 或 HiddenField，用 RegisterStartupScript 预加载 + JS 按需读取（详见"选宿批次页面交互模式"）
6. **分页按钮不跳转**：页码按钮通过 `Literal` 渲染为普通 HTML `<button>`，不实现 `IPostBackEventHandler`，`RaisePostBackEvent` 不会触发。必须在 `Page_Load` 中用 `Request.Form["PageBtn"]` 读取页码，且数据加载方法需放在 `if (!IsPostBack)` 外面每次执行
