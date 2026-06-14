## ADDED Requirements

### Requirement: 年级下拉框基于当前年份动态生成

系统 SHALL 提供一个 BLL 方法，根据当前时间生成年级列表，范围为当前年份-5 至当前年份+5，格式为"YYYY级"（如"2021级"）。

#### Scenario: 正常生成年级范围
- **WHEN** 当前年份为2026年
- **THEN** 方法返回包含"2021级"到"2031级"共11个选项的列表，按年份降序排列

#### Scenario: 各页面年级下拉框统一使用新方法
- **WHEN** 用户访问 admin/batch.aspx、admin/allocation.aspx、student/profile.aspx 中任一页面
- **THEN** 年级下拉框 SHALL 显示基于当前年份±5年的年级选项

### Requirement: 移除旧的年级数据源方法

`DormBLL.GetGrades()` 方法 SHALL 被移除，所有调用方改为使用新的 `GetGradeYearRange()` 方法。

#### Scenario: 编译无错误
- **WHEN** 移除 `GetGrades()` 并更新所有调用方后
- **THEN** 项目 SHALL 编译通过，无 CS0113 或 CS0103 错误

### Requirement: batch.aspx 下拉框移除硬编码

admin/batch.aspx 中 `ddlFilterGrade` 和 `ddlGradeLimit` 的硬编码 `<asp:ListItem>` SHALL 被移除，改为服务端动态绑定。

#### Scenario: 筛选下拉框动态绑定
- **WHEN** 管理员访问选宿批次页面
- **THEN** 两个年级下拉框 SHALL 显示由 `GetGradeYearRange()` 返回的选项，首项为"全部年级"或"不限"
