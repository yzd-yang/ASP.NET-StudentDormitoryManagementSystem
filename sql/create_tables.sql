-- =============================================
-- 智慧宿舍管理系统 数据库建表脚本
-- 数据库: MySQL 8.0
-- 字符集: utf8mb4
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
    College VARCHAR(100) DEFAULT NULL COMMENT '学院',
    Major VARCHAR(100) DEFAULT NULL COMMENT '专业',
    Grade VARCHAR(20) DEFAULT NULL COMMENT '年级',
    ClassName VARCHAR(50) DEFAULT NULL COMMENT '班级',
    Email VARCHAR(100) DEFAULT NULL COMMENT '邮箱',
    EmergencyContact VARCHAR(50) DEFAULT NULL COMMENT '紧急联系人',
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
    Campus VARCHAR(50) DEFAULT NULL COMMENT '校区',
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
    Description TEXT NOT NULL COMMENT '描述',
    Photos VARCHAR(1000) DEFAULT NULL COMMENT '照片路径JSON',
    ExpectTime DATETIME DEFAULT NULL COMMENT '期望上门时间',
    ContactPhone VARCHAR(11) NOT NULL COMMENT '联系电话',
    Status TINYINT DEFAULT 1 COMMENT '状态: 1待分配 2维修中 3已完成 4已驳回',
    AssignAdminId INT DEFAULT NULL COMMENT '指派技工',
    RejectReason VARCHAR(500) DEFAULT NULL COMMENT '驳回原因',
    CreateTime DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '报修时间',
    CompleteTime DATETIME DEFAULT NULL COMMENT '完成时间',
    FOREIGN KEY (StudentId) REFERENCES Students(Id),
    FOREIGN KEY (RoomId) REFERENCES Rooms(Id),
    FOREIGN KEY (AssignAdminId) REFERENCES Admins(Id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='报修工单表';

-- =============================================
-- 创建索引
-- =============================================
CREATE INDEX idx_students_college ON Students(College);
CREATE INDEX idx_rooms_building ON Rooms(BuildingId);
CREATE INDEX idx_beds_room ON Beds(RoomId);
CREATE INDEX idx_beds_student ON Beds(StudentId);
CREATE INDEX idx_repair_student ON RepairOrders(StudentId);
CREATE INDEX idx_repair_status ON RepairOrders(Status);
CREATE INDEX idx_repair_createtime ON RepairOrders(CreateTime);