-- =============================================
-- 智慧宿舍管理系统 完整数据库建表脚本
-- 数据库: MySQL 8.0
-- 字符集: utf8mb4
-- 版本: 2.0
-- 更新日期: 2026-06-12
-- =============================================

-- 创建数据库
CREATE DATABASE IF NOT EXISTS smartdorm DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
USE smartdorm;

-- =============================================
-- 1. 学生表
-- =============================================
DROP TABLE IF EXISTS Students;
CREATE TABLE Students (
    Id INT PRIMARY KEY AUTO_INCREMENT,
    StudentNo VARCHAR(20) NOT NULL UNIQUE COMMENT '学号',
    Name VARCHAR(50) NOT NULL COMMENT '姓名',
    Phone VARCHAR(11) NOT NULL COMMENT '手机号',
    Password VARCHAR(64) NOT NULL COMMENT '密码(MD5)',
    Avatar VARCHAR(255) DEFAULT NULL COMMENT '头像路径',
    College VARCHAR(100) DEFAULT NULL COMMENT '所属学院',
    Major VARCHAR(100) DEFAULT NULL COMMENT '专业名称',
    Grade VARCHAR(20) DEFAULT NULL COMMENT '年级',
    ClassName VARCHAR(50) DEFAULT NULL COMMENT '班级',
    Email VARCHAR(100) DEFAULT NULL COMMENT '电子邮箱',
    EmergencyContact VARCHAR(50) DEFAULT NULL COMMENT '紧急联系人姓名',
    EmergencyRelation VARCHAR(20) DEFAULT NULL COMMENT '关系',
    EmergencyPhone VARCHAR(11) DEFAULT NULL COMMENT '紧急联系人电话',
    Status TINYINT DEFAULT 1 COMMENT '状态: 1正常 0禁用',
    CreateTime DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '注册时间'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='学生表';

-- =============================================
-- 2. 管理员表
-- =============================================
DROP TABLE IF EXISTS Admins;
CREATE TABLE Admins (
    Id INT PRIMARY KEY AUTO_INCREMENT,
    AdminNo VARCHAR(20) NOT NULL UNIQUE COMMENT '工号',
    Name VARCHAR(50) NOT NULL COMMENT '姓名',
    Phone VARCHAR(11) NOT NULL COMMENT '手机号',
    Password VARCHAR(64) NOT NULL COMMENT '密码(MD5)',
    Role TINYINT NOT NULL COMMENT '角色: 1超级管理员 2宿管 3后勤',
    Status TINYINT DEFAULT 1 COMMENT '状态: 1正常 0禁用',
    CreateTime DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='管理员表';

-- =============================================
-- 3. 楼宇表
-- =============================================
DROP TABLE IF EXISTS Buildings;
CREATE TABLE Buildings (
    Id INT PRIMARY KEY AUTO_INCREMENT,
    Name VARCHAR(50) NOT NULL COMMENT '楼宇名称',
    FloorCount INT NOT NULL COMMENT '楼层数',
    RoomsPerFloor INT NOT NULL COMMENT '每层房间数',
    Campus VARCHAR(50) DEFAULT NULL COMMENT '所属校区',
    Status TINYINT DEFAULT 1 COMMENT '状态: 1正常 0停用',
    CreateTime DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='楼宇表';

-- =============================================
-- 4. 房间表
-- =============================================
DROP TABLE IF EXISTS Rooms;
CREATE TABLE Rooms (
    Id INT PRIMARY KEY AUTO_INCREMENT,
    BuildingId INT NOT NULL COMMENT '所属楼宇',
    Floor INT NOT NULL COMMENT '楼层',
    RoomNo VARCHAR(20) NOT NULL COMMENT '房间号',
    RoomType TINYINT NOT NULL COMMENT '类型: 1双人间 2四人间 3六人间',
    BedCount INT NOT NULL COMMENT '总床位数',
    Status TINYINT DEFAULT 1 COMMENT '状态: 1正常 0停用',
    CreateTime DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    FOREIGN KEY (BuildingId) REFERENCES Buildings(Id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='房间表';

-- =============================================
-- 5. 床位表
-- =============================================
DROP TABLE IF EXISTS Beds;
CREATE TABLE Beds (
    Id INT PRIMARY KEY AUTO_INCREMENT,
    RoomId INT NOT NULL COMMENT '所属房间',
    BedNo VARCHAR(10) NOT NULL COMMENT '床位号',
    StudentId INT DEFAULT NULL COMMENT '入住学生',
    Status TINYINT DEFAULT 0 COMMENT '状态: 0空置 1已分配',
    AllocateTime DATETIME DEFAULT NULL COMMENT '分配时间',
    FOREIGN KEY (RoomId) REFERENCES Rooms(Id),
    FOREIGN KEY (StudentId) REFERENCES Students(Id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='床位表';

-- =============================================
-- 6. 报修工单表
-- =============================================
DROP TABLE IF EXISTS RepairOrders;
CREATE TABLE RepairOrders (
    Id INT PRIMARY KEY AUTO_INCREMENT,
    OrderNo VARCHAR(30) NOT NULL UNIQUE COMMENT '工单编号',
    StudentId INT NOT NULL COMMENT '报修学生',
    RoomId INT NOT NULL COMMENT '报修宿舍',
    RepairType TINYINT NOT NULL COMMENT '类型: 1水电 2家具家电 3网络 4其他',
    Description TEXT NOT NULL COMMENT '详细描述',
    Photos VARCHAR(1000) DEFAULT NULL COMMENT '照片路径JSON',
    ExpectTime DATETIME DEFAULT NULL COMMENT '期望上门时间',
    ContactPhone VARCHAR(11) NOT NULL COMMENT '联系电话',
    Status TINYINT DEFAULT 1 COMMENT '状态: 1待分配 2维修中 3紧急处理 4已完成 5已驳回',
    AssignAdminId INT DEFAULT NULL COMMENT '指派技工',
    InternalNote TEXT DEFAULT NULL COMMENT '内部备注',
    RejectReason VARCHAR(500) DEFAULT NULL COMMENT '驳回原因',
    CreateTime DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '报修时间',
    CompleteTime DATETIME DEFAULT NULL COMMENT '完成时间',
    FOREIGN KEY (StudentId) REFERENCES Students(Id),
    FOREIGN KEY (RoomId) REFERENCES Rooms(Id),
    FOREIGN KEY (AssignAdminId) REFERENCES Admins(Id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='报修工单表';

-- =============================================
-- 7. 通知公告表
-- =============================================
DROP TABLE IF EXISTS Notices;
CREATE TABLE Notices (
    Id INT PRIMARY KEY AUTO_INCREMENT,
    Title VARCHAR(100) NOT NULL COMMENT '标题',
    Content TEXT NOT NULL COMMENT '内容(富文本)',
    Scope TINYINT DEFAULT 0 COMMENT '发送范围: 0全体 1A栋 2B栋 3C栋',
    Category TINYINT NOT NULL COMMENT '类别: 1行政通知 2安全警示 3生活服务 4活动资讯',
    IsTop TINYINT DEFAULT 0 COMMENT '是否置顶: 0否 1是',
    Status TINYINT DEFAULT 0 COMMENT '状态: 0草稿 1已发布 2已撤回',
    PublishTime DATETIME DEFAULT NULL COMMENT '发布时间',
    AdminId INT NOT NULL COMMENT '发布人',
    CreateTime DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    FOREIGN KEY (AdminId) REFERENCES Admins(Id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='通知公告表';

-- =============================================
-- 8. 选宿批次表
-- =============================================
DROP TABLE IF EXISTS SelectionBatches;
CREATE TABLE SelectionBatches (
    Id INT PRIMARY KEY AUTO_INCREMENT,
    BatchName VARCHAR(100) NOT NULL COMMENT '批次名称',
    StartTime DATETIME NOT NULL COMMENT '选宿开始时间',
    EndTime DATETIME NOT NULL COMMENT '选宿截止时间',
    CollegeLimit VARCHAR(500) DEFAULT NULL COMMENT '学院限定JSON',
    MajorLimit VARCHAR(500) DEFAULT NULL COMMENT '专业限定JSON',
    GradeLimit VARCHAR(20) DEFAULT NULL COMMENT '年级限定',
    Status TINYINT DEFAULT 0 COMMENT '状态: 0待开始 1进行中 2已结束 3已暂停',
    AdminId INT NOT NULL COMMENT '创建人',
    CreateTime DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    FOREIGN KEY (AdminId) REFERENCES Admins(Id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='选宿批次表';

-- =============================================
-- 9. 批次-房间关联表
-- =============================================
DROP TABLE IF EXISTS BatchRooms;
CREATE TABLE BatchRooms (
    Id INT PRIMARY KEY AUTO_INCREMENT,
    BatchId INT NOT NULL COMMENT '批次ID',
    RoomId INT NOT NULL COMMENT '房间ID',
    FOREIGN KEY (BatchId) REFERENCES SelectionBatches(Id),
    FOREIGN KEY (RoomId) REFERENCES Rooms(Id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='批次房间关联表';

-- =============================================
-- 10. 设施状态表
-- =============================================
DROP TABLE IF EXISTS FacilityStatus;
CREATE TABLE FacilityStatus (
    Id INT PRIMARY KEY AUTO_INCREMENT,
    RoomId INT NOT NULL COMMENT '房间ID',
    FacilityType TINYINT NOT NULL COMMENT '设施类型: 1空调 2热水器 3照明 4网络',
    Status TINYINT DEFAULT 1 COMMENT '状态: 1正常 2报修中 3故障',
    UpdateTime DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '更新时间',
    FOREIGN KEY (RoomId) REFERENCES Rooms(Id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='设施状态表';

-- =============================================
-- 11. 院系专业表
-- =============================================
DROP TABLE IF EXISTS Departments;
CREATE TABLE Departments (
    Id INT PRIMARY KEY AUTO_INCREMENT,
    CollegeName VARCHAR(100) NOT NULL COMMENT '学院名称',
    MajorName VARCHAR(100) NOT NULL COMMENT '专业名称',
    SortOrder INT DEFAULT 0 COMMENT '排序号'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='院系专业表';

-- =============================================
-- 12. 宿舍评分表（可选，页面使用静态数据）
-- =============================================
DROP TABLE IF EXISTS DormScores;
CREATE TABLE DormScores (
    Id INT PRIMARY KEY AUTO_INCREMENT,
    RoomId INT NOT NULL COMMENT '房间ID',
    Score INT NOT NULL COMMENT '评分(0-100)',
    WeekStart DATE NOT NULL COMMENT '评分周期开始日期',
    CleanScore INT DEFAULT NULL COMMENT '卫生分(0-50)',
    SafetyScore INT DEFAULT NULL COMMENT '安全分(0-50)',
    Remark VARCHAR(200) DEFAULT NULL COMMENT '备注',
    CreateTime DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    FOREIGN KEY (RoomId) REFERENCES Rooms(Id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='宿舍评分表';

-- =============================================
-- 创建索引
-- =============================================
CREATE INDEX idx_students_college ON Students(College);
CREATE INDEX idx_students_grade ON Students(Grade);
CREATE INDEX idx_rooms_building ON Rooms(BuildingId);
CREATE INDEX idx_rooms_type ON Rooms(RoomType);
CREATE INDEX idx_beds_room ON Beds(RoomId);
CREATE INDEX idx_beds_student ON Beds(StudentId);
CREATE INDEX idx_beds_status ON Beds(Status);
CREATE INDEX idx_repair_student ON RepairOrders(StudentId);
CREATE INDEX idx_repair_room ON RepairOrders(RoomId);
CREATE INDEX idx_repair_status ON RepairOrders(Status);
CREATE INDEX idx_repair_createtime ON RepairOrders(CreateTime);
CREATE INDEX idx_notices_status ON Notices(Status);
CREATE INDEX idx_notices_publish ON Notices(PublishTime);
CREATE INDEX idx_batches_status ON SelectionBatches(Status);
CREATE INDEX idx_facility_room ON FacilityStatus(RoomId);
CREATE INDEX idx_departments_college ON Departments(CollegeName);
CREATE INDEX idx_scores_room ON DormScores(RoomId);
CREATE INDEX idx_scores_week ON DormScores(WeekStart);
