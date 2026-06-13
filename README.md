# SmartDorm — 学生宿舍管理系统

基于 ASP.NET Web Forms 4.8 的高校学生宿舍管理系统，支持学生端（移动端优先）和管理端（桌面端优先）。

## 功能概览

### 学生端
- **宿舍信息**：查看宿舍分配、室友信息
- **选宿批次**：查看可参与的选宿批次，按年级/学院/专业自动筛选
- **在线选宿**：实时选择空床位，支持并发控制
- **故障报修**：提交报修申请（含图片上传），查看处理进度，取消待处理工单
- **个人中心**：管理学院/专业/年级等个人信息

### 管理端
- **仪表盘**：宿舍统计、入住率、报修趋势图
- **宿舍分配**：按学院/专业/年级筛选学生，手动分配/释放床位
- **报修管理**：工单详情、指派维修人员、完成/驳回，现场照片查看
- **选宿批次**：创建批次、限定学院/专业/年级、选择宿舍范围、自动判断状态
- **通知公告**：发布/编辑公告，按楼宇指定发送范围
- **系统管理**：院系专业管理、楼宇管理

## 技术栈

| 层次 | 技术 |
|------|------|
| 后端 | ASP.NET Web Forms 4.8 / C# |
| 数据库 | MySQL 8.0 (InnoDB) |
| 数据访问 | ADO.NET + MySql.Data |
| 前端 | HTML + CSS + JavaScript + ASP.NET 服务器控件 |
| 图标 | Material Symbols Outlined |
| 部署 | IIS / VS IIS Express |

## 快速开始

### 1. 环境要求
- Visual Studio 2019+
- .NET Framework 4.8
- MySQL 8.0
- IIS 或 IIS Express

### 2. 数据库初始化
```bash
mysql -u root -p < sql/create_tables.sql
mysql -u root -p smartdorm < sql/init_data.sql
```

### 3. 配置连接字符串
编辑 `web.config`，修改数据库连接信息：
```xml
<add name="MySQLConnectionString"
     connectionString="Server=localhost;Port=3306;Database=smartdorm;Uid=root;Pwd=123456;CharSet=utf8mb4;"
     providerName="MySql.Data.MySqlClient" />
```

### 4. 运行
用 Visual Studio 打开项目目录，按 F5 启动。

## 测试账号

| 角色 | 账号 | 密码 |
|------|------|------|
| 学生 | 2023010001 | 123456 |
| 超级管理员 | admin001 | 123456 |
| 宿管 | admin002 | 123456 |

## 项目结构

```
├── App_Code/           # 业务逻辑层（BLL）
│   ├── DBHelper.cs     # 数据库访问封装
│   ├── UserBLL.cs      # 用户业务（登录、注册、学生信息）
│   ├── DormBLL.cs      # 宿舍业务 + DeptBLL（院系管理）
│   ├── RepairBLL.cs    # 报修业务
│   ├── BatchBLL.cs     # 选宿批次业务
│   └── NoticeBLL.cs    # 通知公告业务
├── admin/              # 管理端页面
├── student/            # 学生端页面
├── css/                # 样式文件
├── sql/                # 数据库脚本
├── Uploads/            # 上传文件目录
└── web.config          # 配置文件
```

## 数据库设计

16 张表，核心关联链：
```
Colleges → Departments → Students → Beds → Rooms → Buildings
                  ↓
         SelectionBatches → BatchCollegeLimit / BatchMajorLimit / BatchRooms
                  ↓
              Notices → NoticeScope → Buildings
```

详细说明见 `doc/` 目录下的开发文档。

## 相关文档

- [开发文档](doc/学生宿舍管理系统开发文档.md)
- [问题及解决方案](doc/问题及解决方案.md)
- [并发控制技术方案](doc/选宿舍并发控制技术方案.md)
- [范式优化测试文档](doc/范式优化测试文档.md)

## License

MIT
