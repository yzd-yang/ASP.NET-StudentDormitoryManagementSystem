## Context

`admin/batch.aspx` 的编辑功能在 `rptBatches_ItemCommand` 的 `EditBatch` 分支中实现。当前仅回显了批次名称、开始/结束时间、年级限定，缺少学院限定、专业限定、已选宿舍范围的回显。

原因：
- 学院/专业限定存储在关联表 `BatchCollegeLimit`/`BatchMajorLimit` 中，BLL 层无查询方法
- 已选宿舍存储在 `BatchRooms` 表中，已有 `BatchBLL.GetBatchRooms()` 方法，但编辑时未调用
- 房间回显需要 JS 侧配合渲染房间标签

## Goals / Non-Goals

**Goals:**
- 编辑弹窗完整回显所有字段：学院限定、专业限定、已选宿舍范围
- 新增 BLL 方法查询批次的学院/专业限定
- 已选宿舍通过 JS 注入方式回显

**Non-Goals:**
- 不改变创建批次的逻辑
- 不改变弹窗的 UI 布局
- 不改变 `UpdateBatch` 的保存逻辑

## Decisions

### 1. 新增 BLL 查询方法

在 BatchBLL.cs 新增：
- `GetBatchCollegeLimits(int batchId)` — 查询 `BatchCollegeLimit` 表
- `GetBatchMajorLimits(int batchId)` — 查询 `BatchMajorLimit` 表

返回 DataTable，调用方直接读取。

### 2. 学院限定回显

编辑时查出学院限定值，用 `SetDropDownValue(ddlCollegeLimit, collegeName)` 设置下拉框。

### 3. 专业限定回显

先设置学院限定，再通过 `DormBLL.GetMajorsByCollege()` 加载专业列表，然后设置专业限定值。需要在设置学院后再加载专业选项，否则 ddlMajorLimit 中无对应选项。

### 4. 已选宿舍回显

调用 `BatchBLL.GetBatchRooms(batchId)` 获取已选房间，将 RoomId 列表写入 `hfSelectedRoomIds`，同时通过 `RegisterStartupScript` 注入 JS 代码，将房间信息写入 `selectedRooms` 数组并调用 `renderSelectedRooms()` 渲染标签。

## Risks / Trade-offs

- [专业限定依赖学院限定先加载] → 设置顺序：先学院 → 加载专业列表 → 再设专业值
- [房间回显依赖 JS 注入] → 使用 `RegisterStartupScript` 确保在 DOM 加载后执行
