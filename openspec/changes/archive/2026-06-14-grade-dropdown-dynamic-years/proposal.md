## Why

当前年级下拉框数据源不一致：部分页面从 Students 表查询（依赖已有数据），部分页面硬编码年份（需手动维护）。改为基于当前时间年份前后5年自动生成，消除手动维护且保证一致性。

## What Changes

- 新增 BLL 方法，根据当前年份生成前后5年的年级列表（如当前2026年，则生成"2021级"~"2031级"）
- `admin/batch.aspx` 的 `ddlFilterGrade` 和 `ddlGradeLimit` 改为服务端动态绑定，移除硬编码 ListItem
- `admin/allocation.aspx` 的 `ddlGrade` 改用新年份生成方法
- `student/profile.aspx` 的 `ddlGrade` 改用新年份生成方法
- 移除 `DormBLL.GetGrades()` 方法（不再需要从 Students 表查询）

## Capabilities

### New Capabilities

- `grade-year-range`: 基于当前年份前后5年动态生成年级下拉框数据源

### Modified Capabilities

（无现有 spec 需修改）

## Impact

- `App_Code/DormBLL.cs` — 新增 `GetGradeYearRange()` 方法，移除 `GetGrades()` 方法
- `admin/batch.aspx` — 两处硬编码 ListItem 改为服务端绑定
- `admin/batch.aspx.cs` — Page_Load 中绑定年级下拉框
- `admin/allocation.aspx.cs` — `LoadFilterGrades()` 改用新方法
- `student/profile.aspx.cs` — `LoadGradeList()` 改用新方法
