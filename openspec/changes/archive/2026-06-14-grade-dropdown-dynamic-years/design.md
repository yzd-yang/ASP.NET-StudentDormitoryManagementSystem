## Context

当前项目中年级下拉框有三种数据源：
1. `DormBLL.GetGrades()` — 从 Students 表 `SELECT DISTINCT Grade` 获取，依赖已有数据
2. `admin/batch.aspx` 硬编码 — 2023/2024/2025 三个 ListItem 写在 .aspx 中
3. 学生端个人中心和管理端分配页面使用 `DormBLL.GetGrades()`

问题：硬编码需每年手动维护；数据库查询依赖已有学生数据，新部署时无数据则下拉框为空。

## Goals / Non-Goals

**Goals:**
- 所有年级下拉框统一使用基于当前年份±5年的动态数据源
- 新增一个 BLL 方法，返回年份范围列表
- 各页面下拉框统一调用此方法

**Non-Goals:**
- 不改变年级数据在数据库中的存储格式（仍为"2023级"字符串）
- 不改变下拉框的 UI 样式或交互行为
- 不涉及选宿批次的年级限定逻辑（仅改下拉框数据源）

## Decisions

### 1. 新增 `DormBLL.GetGradeYearRange()` 方法

在 DormBLL.cs 中新增静态方法，返回 DataTable（列名 `Grade`，与现有 `GetGrades()` 一致），内容为当前年份-5 到当前年份+5 的年级字符串（如"2021级"~"2031级"）。

**理由**：复用现有 BLL 层模式，返回类型与调用方兼容，改动最小。

### 2. 移除 `DormBLL.GetGrades()` 方法

该方法从 Students 表查询，不再需要。所有调用方改为 `GetGradeYearRange()`。

**理由**：避免两套数据源并存造成混淆。

### 3. batch.aspx 的下拉框改为服务端绑定

移除 .aspx 中硬编码的 `<asp:ListItem>`，在 `batch.aspx.cs` 的 Page_Load 中调用 `GetGradeYearRange()` 绑定。

**理由**：与 allocation.aspx 和 profile.aspx 保持一致的绑定方式。

## Risks / Trade-offs

- [年份范围固定±5年] 如果系统运行超过5年未升级，最早年份会过期 → 低风险，可后续调整范围常量
- [移除 GetGrades()] 如果有其他未发现的调用方会编译失败 → 编译时即可发现并修复
