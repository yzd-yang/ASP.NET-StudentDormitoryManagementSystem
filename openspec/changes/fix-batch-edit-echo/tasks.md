## 1. BLL 层新增方法

- [x] 1.1 在 `App_Code/BatchBLL.cs` 新增 `GetBatchCollegeLimits(int batchId)` 方法，查询 `BatchCollegeLimit` 表返回指定批次的学院限定列表
- [x] 1.2 在 `App_Code/BatchBLL.cs` 新增 `GetBatchMajorLimits(int batchId)` 方法，查询 `BatchMajorLimit` 表返回指定批次的专业限定列表

## 2. 编辑回显逻辑

- [x] 2.1 在 `admin/batch.aspx.cs` 的 `rptBatches_ItemCommand` EditBatch 分支中，补充学院限定回显：调用 `GetBatchCollegeLimits` 查出值，用 `SetDropDownValue` 设置 `ddlCollegeLimit`
- [x] 2.2 补充专业限定回显：先设置学院值，再调用 `DormBLL.GetMajorsByCollege` 加载专业列表，然后用 `SetDropDownValue` 设置 `ddlMajorLimit`
- [x] 2.3 补充已选宿舍回显：调用 `BatchBLL.GetBatchRooms` 获取房间列表，将 RoomId 写入 `hfSelectedRoomIds`，通过 `RegisterStartupScript` 注入 JS 渲染房间标签
