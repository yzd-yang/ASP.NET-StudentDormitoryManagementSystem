# Proposal: 数据库表结构范式优化

## 问题

当前 `create_tables.sql` 存在以下范式违反和设计缺陷：

1. **1NF 违反**：`SelectionBatches.CollegeLimit` / `MajorLimit` 用 VARCHAR 存 JSON 数组，无法用 SQL 查询筛选
2. **3NF 违反**：`Students` 表冗余存储 `College` / `Major` 文本，与 `Departments` 表数据不同步风险
3. **3NF 违反**：`Departments.SortOrder` 语义归属学院而非专业，传递依赖
4. **硬编码枚举**：`Notices.Scope` 硬编码楼宇编号，新增楼宇需改代码
5. **数据矛盾**：`RoomType` 枚举定义（1=双人间）与测试数据（BedCount=4）不一致
6. **缺少约束**：`BatchRooms(BatchId, RoomId)` 无 UNIQUE 约束

## 目标

- 消除 1NF/3NF 违反，减少数据冗余和不一致风险
- 用关联表替代 JSON 字段，支持 SQL 查询
- 用外键替代硬编码枚举，提升可扩展性
- 修正测试数据中的自相矛盾

## 非目标

- 不改变 BLL 层代码（后续单独变更）
- 不改变页面功能逻辑
- 不引入新的 ORM 或查询框架

## 范围

仅修改 `sql/create_tables.sql` 和 `sql/init_data.sql`，新增/修改表结构和测试数据。
