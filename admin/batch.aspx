<%@ Page Language="C#" MasterPageFile="~/admin/MasterPage.master" AutoEventWireup="true" CodeFile="batch.aspx.cs" Inherits="admin_batch" ResponseEncoding="utf-8" %>

<asp:Content ID="Content1" ContentPlaceHolderID="title" runat="server">选宿批次管理 - SmartDorm</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="head" runat="server">
    <style>
        .batch-stats { display:grid; grid-template-columns:repeat(4,1fr); gap:16px; margin-bottom:24px; }
        .batch-stat { background:rgba(255,255,255,0.6); backdrop-filter:blur(8px); border-radius:16px; padding:18px; border:1px solid rgba(255,255,255,0.5); display:flex; align-items:center; gap:14px; }
        .batch-stat-icon { width:48px; height:48px; border-radius:12px; display:flex; align-items:center; justify-content:center; }
        .batch-stat-icon .material-symbols-outlined { font-size:24px; }
        .batch-stat-label { font-size:13px; color:var(--on-surface-variant); }
        .batch-stat-value { font-size:24px; font-weight:800; color:var(--on-surface); }

        .batch-filter { background:rgba(255,255,255,0.5); backdrop-filter:blur(8px); border-radius:16px; padding:18px; border:1px solid rgba(255,255,255,0.4); display:flex; flex-wrap:wrap; gap:14px; align-items:end; margin-bottom:20px; }
        .batch-filter-field { display:flex; flex-direction:column; gap:4px; flex:1; min-width:160px; }
        .batch-filter-field label { font-size:12px; font-weight:700; color:var(--on-surface-variant); text-transform:uppercase; letter-spacing:0.05em; }
        .batch-filter-field select, .batch-filter-field input { padding:10px 14px; border:none; border-radius:10px; background:#FFF9E6; font-family:inherit; font-size:14px; color:var(--on-surface); outline:none; }
        .batch-filter-btn { padding:10px 20px; background:var(--primary); color:var(--on-primary); border:none; border-radius:10px; font-size:14px; font-weight:700; cursor:pointer; display:flex; align-items:center; gap:6px; font-family:inherit; }
        .batch-filter-reset { padding:10px 16px; background:transparent; color:var(--on-surface-variant); border:none; border-radius:10px; font-size:14px; font-weight:600; cursor:pointer; font-family:inherit; }

        .batch-table-card { background:rgba(255,255,255,0.6); backdrop-filter:blur(12px); border-radius:16px; border:1px solid rgba(255,255,255,0.5); overflow:hidden; }
        .batch-table-header { display:flex; justify-content:space-between; align-items:center; padding:18px 24px; border-bottom:1px solid rgba(0,0,0,0.05); }
        .batch-table-header h3 { font-size:18px; font-weight:700; color:var(--on-surface); }
        .batch-table { width:100%; border-collapse:collapse; }
        .batch-table th { padding:14px 24px; text-align:left; font-size:13px; font-weight:700; color:var(--on-surface-variant); text-transform:uppercase; letter-spacing:0.05em; background:rgba(232,233,236,0.4); }
        .batch-table td { padding:18px 24px; font-size:14px; color:var(--on-surface); border-bottom:1px solid rgba(0,0,0,0.03); }
        .batch-table tr:hover td { background:rgba(73,234,206,0.04); }
        .batch-table-name { font-size:15px; font-weight:700; color:var(--on-surface); }
        .batch-table-sub { font-size:12px; color:var(--on-surface-variant); margin-top:2px; }
        .batch-time { font-size:13px; display:flex; align-items:center; gap:6px; }
        .batch-time .material-symbols-outlined { font-size:16px; }
        .batch-tags { display:flex; flex-wrap:wrap; gap:4px; }
        .batch-tag { padding:2px 8px; border-radius:4px; font-size:11px; font-weight:700; }
        .batch-tag.green { background:rgba(221,231,197,0.6); color:var(--on-surface); }
        .batch-tag.purple { background:rgba(219,206,221,0.6); color:var(--on-surface); }
        .batch-status-pill { padding:4px 12px; border-radius:20px; font-size:12px; font-weight:700; }
        .batch-status-pill.active { background:rgba(73,234,206,0.15); color:#006b5c; }
        .batch-status-pill.upcoming { background:rgba(255,183,77,0.12); color:#b58900; }
        .batch-status-pill.ended { background:rgba(232,233,236,0.6); color:var(--on-surface-variant); }
        .batch-action-btns { display:flex; gap:4px; justify-content:flex-end; }
        .batch-action-btn { padding:8px; border:none; background:transparent; border-radius:8px; cursor:pointer; color:var(--on-surface-variant); }
        .batch-action-btn:hover { background:rgba(73,234,206,0.12); color:var(--primary); }
        .batch-action-btn.delete:hover { background:rgba(186,26,26,0.08); color:var(--error); }
        .batch-action-btn .material-symbols-outlined { font-size:20px; }

        .create-btn { display:flex; align-items:center; gap:8px; padding:12px 24px; background:var(--primary); color:var(--on-primary); border:none; border-radius:14px; font-size:14px; font-weight:700; cursor:pointer; box-shadow:0 4px 12px rgba(73,234,206,0.3); font-family:inherit; }

        .modal-overlay { display:none; position:fixed; inset:0; background:rgba(0,0,0,0.4); z-index:1000; align-items:center; justify-content:center; backdrop-filter:blur(4px); }
        .modal-card { background:#fff; border-radius:24px; max-width:600px; width:90%; max-height:85vh; overflow-y:auto; box-shadow:0 20px 60px rgba(0,0,0,0.2); }
        .modal-header { background:var(--primary); padding:20px 24px; display:flex; justify-content:space-between; align-items:center; color:var(--on-primary); border-radius:24px 24px 0 0; }
        .modal-header h3 { font-size:18px; font-weight:700; }
        .modal-close { width:32px; height:32px; display:flex; align-items:center; justify-content:center; border:none; background:rgba(255,255,255,0.2); border-radius:50%; cursor:pointer; color:var(--on-primary); }
        .modal-body { padding:24px; }
        .modal-footer { padding:16px 24px; border-top:1px solid rgba(0,0,0,0.05); display:flex; justify-content:flex-end; gap:12px; }
        .form-group { margin-bottom:16px; }
        .form-group label { display:block; font-size:14px; font-weight:600; color:var(--on-surface-variant); margin-bottom:6px; }
        .form-group label .required { color:var(--error); }
        .form-input, .form-select { width:100%; padding:12px 14px; border:1px solid var(--outline-variant); border-radius:12px; background:#FFF9E6; font-family:inherit; font-size:14px; color:var(--on-surface); outline:none; box-sizing:border-box; }
        .form-input:focus, .form-select:focus { border-color:var(--primary); box-shadow:0 0 0 3px rgba(73,234,206,0.12); }
        .form-row { display:grid; grid-template-columns:1fr 1fr; gap:16px; }
        .form-cancel { padding:12px 24px; border:2px solid var(--outline-variant); background:transparent; border-radius:12px; font-size:14px; font-weight:700; cursor:pointer; color:var(--on-surface-variant); font-family:inherit; }
        .form-submit { padding:12px 24px; background:var(--primary); color:var(--on-primary); border:none; border-radius:12px; font-size:14px; font-weight:700; cursor:pointer; font-family:inherit; }

        .room-select { max-height:200px; overflow-y:auto; border:1px solid var(--outline-variant); border-radius:12px; padding:8px; }
        .room-check { display:flex; align-items:center; gap:8px; padding:8px 12px; border-radius:8px; cursor:pointer; }
        .room-check:hover { background:rgba(73,234,206,0.08); }
        .room-check input { accent-color:var(--primary); }

        .empty-msg { text-align:center; padding:40px; color:var(--on-surface-variant); }
        .empty-msg .material-symbols-outlined { font-size:48px; opacity:0.3; display:block; margin-bottom:8px; }

        .room-grid-select { display:grid; grid-template-columns:repeat(5,1fr); gap:8px; }
        .room-btn {
            padding:10px; border:none; border-radius:10px; background:#FFF9E6; color:var(--on-surface-variant);
            font-size:13px; font-weight:600; cursor:pointer; transition:all 0.2s; font-family:inherit; text-align:center; text-decoration:none; display:block;
        }
        .room-btn:hover { background:rgba(73,234,206,0.2); }
        .room-btn.selected { background:var(--primary); color:var(--on-primary); font-weight:700; box-shadow:0 2px 8px rgba(73,234,206,0.3); }

        .toast { position:fixed; top:20px; left:50%; transform:translateX(-50%) translateY(-100px); z-index:9999; padding:14px 28px; border-radius:14px; font-size:15px; font-weight:700; box-shadow:0 8px 24px rgba(0,0,0,0.15); transition:transform 0.3s ease; display:flex; align-items:center; gap:10px; }
        .toast.show { transform:translateX(-50%) translateY(0); }
        .toast.success { background:var(--primary); color:var(--on-primary); }
        .toast.error { background:var(--error); color:#fff; }

        @media (max-width:768px) { .batch-stats { grid-template-columns:repeat(2,1fr); } .form-row { grid-template-columns:1fr; } }
    </style>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="page-header">
        <div>
            <h1 class="page-title">选宿批次管理</h1>
            <p class="page-subtitle">创建并管理全校宿舍分配的各个阶段批次。</p>
        </div>
        <button type="button" class="create-btn" onclick="showCreateModal()">
            <span class="material-symbols-outlined">add_circle</span> 创建新批次
        </button>
    </div>

    <!-- 统计卡片 -->
    <div class="batch-stats">
        <div class="batch-stat">
            <div class="batch-stat-icon" style="background:rgba(73,234,206,0.1);"><span class="material-symbols-outlined" style="color:var(--primary);">analytics</span></div>
            <div><div class="batch-stat-label">总批次</div><div class="batch-stat-value"><asp:Literal ID="litTotalBatches" runat="server" Text="0" /></div></div>
        </div>
        <div class="batch-stat">
            <div class="batch-stat-icon" style="background:rgba(73,234,206,0.15);"><span class="material-symbols-outlined" style="color:#006b5c;">bolt</span></div>
            <div><div class="batch-stat-label">进行中</div><div class="batch-stat-value"><asp:Literal ID="litActiveBatches" runat="server" Text="0" /></div></div>
        </div>
        <div class="batch-stat">
            <div class="batch-stat-icon" style="background:rgba(255,183,77,0.1);"><span class="material-symbols-outlined" style="color:#b58900;">schedule</span></div>
            <div><div class="batch-stat-label">待开始</div><div class="batch-stat-value"><asp:Literal ID="litUpcomingBatches" runat="server" Text="0" /></div></div>
        </div>
        <div class="batch-stat">
            <div class="batch-stat-icon" style="background:rgba(232,233,236,0.6);"><span class="material-symbols-outlined" style="color:var(--on-surface-variant);">check_circle</span></div>
            <div><div class="batch-stat-label">已结束</div><div class="batch-stat-value"><asp:Literal ID="litEndedBatches" runat="server" Text="0" /></div></div>
        </div>
    </div>

    <!-- 筛选 -->
    <div class="batch-filter">
        <div class="batch-filter-field">
            <label>批次名称</label>
            <asp:TextBox ID="txtBatchSearch" runat="server" placeholder="输入批次名称..." />
        </div>
        <div class="batch-filter-field">
            <label>状态</label>
            <asp:DropDownList ID="ddlBatchStatus" runat="server">
                <asp:ListItem Value="-1" Text="全部" />
                <asp:ListItem Value="1" Text="进行中" />
                <asp:ListItem Value="0" Text="待开始" />
                <asp:ListItem Value="2" Text="已结束" />
            </asp:DropDownList>
        </div>
        <asp:Button ID="btnBatchSearch" runat="server" CssClass="batch-filter-btn" Text="筛选" OnClick="btnBatchSearch_Click" />
        <button type="button" class="batch-filter-reset" onclick="document.getElementById('<%= txtBatchSearch.ClientID %>').value=''; document.getElementById('<%= ddlBatchStatus.ClientID %>').selectedIndex=0; document.getElementById('<%= btnBatchSearch.ClientID %>').click();">重置</button>
    </div>

    <!-- 批次列表 -->
    <div class="batch-table-card">
        <div class="batch-table-header"><h3>批次列表</h3></div>
        <table class="batch-table">
            <thead>
                <tr><th>批次名称</th><th>时间范围</th><th>资格限定</th><th>状态</th><th style="text-align:right;">操作</th></tr>
            </thead>
            <tbody>
                <asp:Repeater ID="rptBatches" runat="server" OnItemCommand="rptBatches_ItemCommand">
                    <ItemTemplate>
                        <tr>
                            <td>
                                <div class="batch-table-name"><%# Eval("BatchName") %></div>
                                <div class="batch-table-sub">创建人: <%# Eval("AdminName") %> | 房间数: <%# Eval("RoomCount") %></div>
                            </td>
                            <td>
                                <div class="batch-time"><span class="material-symbols-outlined" style="color:var(--primary);">calendar_today</span> <%# Convert.ToDateTime(Eval("StartTime")).ToString("yyyy-MM-dd HH:mm") %></div>
                                <div class="batch-time" style="margin-top:4px;"><span class="material-symbols-outlined" style="color:var(--error);">event_busy</span> <%# Convert.ToDateTime(Eval("EndTime")).ToString("yyyy-MM-dd HH:mm") %></div>
                            </td>
                            <td>
                                <div class="batch-tags">
                                    <%# GetGradeLimit(Eval("GradeLimit")) %>
                                    <%# GetCollegeLimit(Eval("CollegeLimit")) %>
                                    <%# GetMajorLimit(Eval("MajorLimit")) %>
                                </div>
                            </td>
                            <td><span class="batch-status-pill <%# GetStatusClass(Eval("Status")) %>"><%# GetStatusText(Eval("Status")) %></span></td>
                            <td>
                                <div class="batch-action-btns">
                                    <asp:LinkButton ID="btnEditBatch" runat="server" CommandName="EditBatch" CommandArgument='<%# Eval("Id") %>' CssClass="batch-action-btn" title="编辑"><span class="material-symbols-outlined">edit</span></asp:LinkButton>
                                    <asp:LinkButton ID="btnDeleteBatch" runat="server" CommandName="DeleteBatch" CommandArgument='<%# Eval("Id") %>' CssClass="batch-action-btn delete" title="删除" OnClientClick="return confirm('确定要删除该批次吗？');"><span class="material-symbols-outlined">delete</span></asp:LinkButton>
                                </div>
                            </td>
                        </tr>
                    </ItemTemplate>
                </asp:Repeater>
            </tbody>
        </table>
        <asp:Panel ID="pnlEmpty" runat="server" Visible="false">
            <div class="empty-msg">
                <span class="material-symbols-outlined">event_available</span>
                <p>暂无批次数据</p>
            </div>
        </asp:Panel>
    </div>

    <!-- 创建/编辑批次弹窗 -->
    <asp:Panel ID="pnlBatchModal" runat="server" CssClass="modal-overlay" Style="display:none;">
        <div class="modal-card">
            <div class="modal-header">
                <h3><asp:Literal ID="litModalTitle" runat="server" Text="创建新批次" /></h3>
                <asp:Button ID="btnCloseModal" runat="server" CssClass="modal-close" Text="X" OnClick="btnCloseModal_Click" />
            </div>
            <div class="modal-body">
                <asp:HiddenField ID="hfBatchId" runat="server" />
                <div class="form-group">
                    <label>批次名称 <span class="required">*</span></label>
                    <asp:TextBox ID="txtBatchName" runat="server" CssClass="form-input" placeholder="例如: 2024级大一新生秋季批次" />
                </div>
                <div class="form-row">
                    <div class="form-group">
                        <label>开始时间 <span class="required">*</span></label>
                        <asp:TextBox ID="txtStartTime" runat="server" CssClass="form-input" TextMode="DateTimeLocal" />
                    </div>
                    <div class="form-group">
                        <label>结束时间 <span class="required">*</span></label>
                        <asp:TextBox ID="txtEndTime" runat="server" CssClass="form-input" TextMode="DateTimeLocal" />
                    </div>
                </div>
                <div class="form-row">
                    <div class="form-group">
                        <label>年级限定</label>
                        <asp:DropDownList ID="ddlGradeLimit" runat="server" CssClass="form-select">
                            <asp:ListItem Value="" Text="不限" />
                            <asp:ListItem Value="2023级" Text="2023级" />
                            <asp:ListItem Value="2024级" Text="2024级" />
                            <asp:ListItem Value="2025级" Text="2025级" />
                        </asp:DropDownList>
                    </div>
                    <div class="form-group">
                        <label>学院限定</label>
                        <asp:DropDownList ID="ddlCollegeLimit" runat="server" CssClass="form-select">
                            <asp:ListItem Value="" Text="不限" />
                        </asp:DropDownList>
                    </div>
                </div>
                <div class="form-row">
                    <div class="form-group">
                        <label>专业限定</label>
                        <asp:DropDownList ID="ddlMajorLimit" runat="server" CssClass="form-select">
                            <asp:ListItem Value="" Text="不限" />
                        </asp:DropDownList>
                    </div>
                    <div class="form-group">
                        <label>状态</label>
                        <asp:DropDownList ID="ddlBatchStatusEdit" runat="server" CssClass="form-select">
                            <asp:ListItem Value="0" Text="待开始" />
                            <asp:ListItem Value="1" Text="进行中" />
                            <asp:ListItem Value="2" Text="已结束" />
                        </asp:DropDownList>
                    </div>
                </div>
                <div class="form-group">
                    <label>宿舍范围</label>
                    <div style="display:flex; gap:12px; margin-bottom:12px;">
                        <asp:DropDownList ID="ddlModalBuilding" runat="server" CssClass="form-select" AutoPostBack="true" OnSelectedIndexChanged="ddlModalBuilding_SelectedIndexChanged">
                            <asp:ListItem Value="0" Text="选择楼栋" />
                        </asp:DropDownList>
                        <asp:DropDownList ID="ddlModalFloor" runat="server" CssClass="form-select" AutoPostBack="true" OnSelectedIndexChanged="ddlModalFloor_SelectedIndexChanged">
                            <asp:ListItem Value="0" Text="全部楼层" />
                        </asp:DropDownList>
                    </div>
                    <div style="background:var(--surface-container-low); border-radius:14px; padding:14px; border:1px solid rgba(0,0,0,0.04);">
                        <p style="font-size:12px; color:var(--on-surface-variant); margin-bottom:10px;">点击宿舍号可添加/移除宿舍范围</p>
                        <div class="room-grid-select">
                            <asp:Repeater ID="rptModalRooms" runat="server" OnItemCommand="rptModalRooms_ItemCommand">
                                <ItemTemplate>
                                    <asp:LinkButton ID="btnToggleRoom" runat="server" CommandName="ToggleRoom" CommandArgument='<%# Eval("Id") %>' 
                                        CssClass='<%# IsRoomSelected(Eval("Id")) ? "room-btn selected" : "room-btn" %>'>
                                        <%# Eval("RoomNo").ToString().Split('-')[1] %>
                                    </asp:LinkButton>
                                </ItemTemplate>
                            </asp:Repeater>
                        </div>
                    </div>
                    <div style="display:flex; flex-wrap:wrap; gap:6px; margin-top:10px;">
                        <span style="font-size:12px; color:var(--on-surface-variant);">已选范围:</span>
                        <asp:Repeater ID="rptSelectedRooms" runat="server">
                            <ItemTemplate>
                                <span style="background:rgba(73,234,206,0.15); color:var(--primary); padding:2px 8px; border-radius:4px; font-size:11px; font-weight:700;"><%# Eval("BuildingName") %> <%# Eval("RoomNo") %></span>
                            </ItemTemplate>
                        </asp:Repeater>
                    </div>
                </div>
            </div>
            <div class="modal-footer">
                <asp:Button ID="btnCancelBatch" runat="server" CssClass="form-cancel" Text="取消" OnClick="btnCloseModal_Click" />
                <asp:Button ID="btnSaveBatch" runat="server" CssClass="form-submit" Text="确认创建" OnClick="btnSaveBatch_Click" />
            </div>
        </div>
    </asp:Panel>

    <div id="toast" class="toast"></div>

    <script type="text/javascript">
        function showCreateModal() {
            document.getElementById('<%= pnlBatchModal.ClientID %>').style.display = 'flex';
        }
        function showToast(msg, type) {
            var toast = document.getElementById('toast');
            toast.className = 'toast ' + type;
            toast.innerHTML = '<span class="material-symbols-outlined">' + (type === 'success' ? 'check_circle' : 'error') + '</span>' + msg;
            toast.classList.add('show');
            setTimeout(function() { toast.classList.remove('show'); }, 3000);
        }
    </script>
</asp:Content>
