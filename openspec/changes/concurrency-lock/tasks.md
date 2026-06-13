# Tasks: 选宿舍并发控制

## 实现清单

- [ ] 1. `DormBLL.cs`：重写 `AllocateBed`（方案B：单一 UPDATE 原子操作）
  - [ ] 1.1 第一步：`UPDATE Beds SET ... WHERE Id=@BedId AND Status=0` 原子分配
  - [ ] 1.2 第二步：`SELECT COUNT(*) FROM Beds WHERE StudentId=@Sid AND Status=1` 检查重复
  - [ ] 1.3 重复时回滚：`UPDATE Beds SET StudentId=NULL, Status=0 WHERE Id=@BedId`
  - [ ] 1.4 返回 false 提示"床位已被抢"

- [ ] 2. `grab-dorm.aspx.cs`：异常处理
  - [ ] 2.1 捕获异常，提示"操作繁忙请重试"
  - [ ] 2.2 分配失败时刷新房间列表

- [ ] 3. 测试
  - [ ] 3.1 单人正常选宿流程
  - [ ] 3.2 两人同时抢同一床位（两个浏览器）
  - [ ] 3.3 已有床位的学生再次抢床位
  - [ ] 3.4 批次结束后尝试抢床位

## 备选升级路径

如方案 B 不能满足需求，升级到方案 C（事务 + FOR UPDATE）：
1. `DBHelper.cs`：新增 `ExecuteInTransaction(Func<...>)` 泛型方法
2. `DormBLL.cs`：改用事务包装
