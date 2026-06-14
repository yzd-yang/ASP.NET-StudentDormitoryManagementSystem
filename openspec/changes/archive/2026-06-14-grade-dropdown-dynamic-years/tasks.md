## 1. BLL 层

- [x] 1.1 在 `App_Code/DormBLL.cs` 中新增 `GetGradeYearRange()` 静态方法，返回 DataTable（列名 `Grade`），内容为当前年份-5 到当前年份+5 的"YYYY级"字符串，按降序排列
- [x] 1.2 移除 `App_Code/DormBLL.cs` 中的 `GetGrades()` 方法

## 2. 管理端 batch.aspx

- [x] 2.1 移除 `admin/batch.aspx` 中 `ddlFilterGrade` 的硬编码 `<asp:ListItem>`，只保留首项"全部年级"
- [x] 2.2 移除 `admin/batch.aspx` 中 `ddlGradeLimit` 的硬编码 `<asp:ListItem>`，只保留首项"不限"
- [x] 2.3 在 `admin/batch.aspx.cs` 的 Page_Load 中调用 `DormBLL.GetGradeYearRange()` 绑定两个年级下拉框

## 3. 管理端 allocation.aspx

- [x] 3.1 修改 `admin/allocation.aspx.cs` 的 `LoadFilterGrades()` 方法，改为调用 `DormBLL.GetGradeYearRange()`

## 4. 学生端 profile.aspx

- [x] 4.1 修改 `student/profile.aspx.cs` 的 `LoadGradeList()` 方法，改为调用 `DormBLL.GetGradeYearRange()`
