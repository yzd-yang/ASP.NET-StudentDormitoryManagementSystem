## Why

管理端选宿批次管理页面（`admin/batch.aspx`）点击"编辑"按钮时，弹窗中的学院限定、专业限定、已选宿舍范围三个字段未回显已有数据，导致管理员编辑时看不到原始配置，容易误操作。

## What Changes

- BatchBLL 新增 `GetBatchCollegeLimits(int batchId)` 和 `GetBatchMajorLimits(int batchId)` 方法，查询批次的学院/专业限定
- `rptBatches_ItemCommand` 编辑分支中补充回显：学院限定、专业限定、已选宿舍（`hfSelectedRoomIds` + JS 渲染）
- 编辑模式下通过 `RegisterStartupScript` 将已选房间数据注入 JS，调用 `renderSelectedRooms()` 恢复房间标签显示

## Capabilities

### New Capabilities

- `batch-edit-echo`: 编辑批次弹窗完整回显所有字段数据

### Modified Capabilities

（无）

## Impact

- `App_Code/BatchBLL.cs` — 新增两个查询方法
- `admin/batch.aspx.cs` — 编辑分支补充回显逻辑
- `admin/batch.aspx` — 新增 `renderSelectedRooms()` JS 函数（或复用已有渲染逻辑）
