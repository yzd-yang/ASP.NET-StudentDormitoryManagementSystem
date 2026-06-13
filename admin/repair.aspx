<%@ Page Language="C#" MasterPageFile="~/admin/MasterPage.master" AutoEventWireup="true" CodeFile="repair.aspx.cs" Inherits="admin_repair" ResponseEncoding="utf-8" %>

<asp:Content ID="Content1" ContentPlaceHolderID="title" runat="server">报修管理 - SmartDorm</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="head" runat="server">
    <style>
        .repair-header { display:flex; justify-content:space-between; align-items:center; margin-bottom:20px; flex-wrap:wrap; gap:12px; }
        .repair-header h1 { font-size:28px; font-weight:800; color:var(--on-surface); }
        .repair-header p { font-size:15px; color:var(--on-surface-variant); margin-top:4px; }

        .repair-filter { background:rgba(255,255,255,0.5); backdrop-filter:blur(8px); border-radius:16px; padding:16px 18px; border:1px solid rgba(255,255,255,0.4); display:flex; flex-wrap:wrap; gap:14px; align-items:end; margin-bottom:20px; }
        .repair-filter-group { display:flex; flex-direction:column; gap:4px; }
        .repair-filter-label { font-size:12px; font-weight:700; color:var(--on-surface-variant); text-transform:uppercase; letter-spacing:0.05em; }
        .repair-filter-select { padding:10px 14px; border:none; border-radius:10px; background:#FFF9E6; font-family:inherit; font-size:14px; outline:none; min-width:140px; }
        .repair-filter-reset { padding:10px 16px; background:rgba(73,234,206,0.1); color:var(--primary); border:1px solid rgba(73,234,206,0.3); border-radius:10px; font-size:14px; font-weight:700; cursor:pointer; margin-left:auto; font-family:inherit; display:flex; align-items:center; gap:6px; }
        .repair-filter-btn { padding:10px 20px; background:var(--primary); color:var(--on-primary); border:none; border-radius:10px; font-size:14px; font-weight:700; cursor:pointer; font-family:inherit; }

        .repair-stats { display:grid; grid-template-columns:repeat(4,1fr); gap:16px; margin-bottom:24px; }
        .repair-stat { background:rgba(255,255,255,0.6); backdrop-filter:blur(8px); border-radius:16px; padding:18px; border:1px solid rgba(255,255,255,0.5); }
        .repair-stat-header { display:flex; justify-content:space-between; align-items:center; margin-bottom:8px; }
        .repair-stat-label { font-size:13px; font-weight:700; color:var(--on-surface-variant); }
        .repair-stat-icon { width:36px; height:36px; border-radius:10px; display:flex; align-items:center; justify-content:center; }
        .repair-stat-value { font-size:32px; font-weight:800; color:var(--on-surface); }
        .repair-stat-sub { font-size:12px; font-weight:600; margin-top:6px; }

        .repair-table-card { background:rgba(255,255,255,0.6); backdrop-filter:blur(12px); border-radius:16px; border:1px solid rgba(255,255,255,0.5); overflow:hidden; }
        .repair-table { width:100%; border-collapse:collapse; }
        .repair-table th { padding:14px 20px; text-align:left; font-size:13px; font-weight:700; color:var(--on-surface-variant); background:rgba(255,255,255,0.4); border-bottom:1px solid rgba(0,0,0,0.05); }
        .repair-table td { padding:16px 20px; font-size:14px; color:var(--on-surface); border-bottom:1px solid rgba(0,0,0,0.03); }
        .repair-table tr:hover td { background:rgba(73,234,206,0.06); cursor:pointer; }
        .repair-type { display:flex; align-items:center; gap:8px; font-weight:600; }
        .repair-desc { color:var(--on-surface-variant); max-width:200px; overflow:hidden; text-overflow:ellipsis; white-space:nowrap; }
        .repair-status-pill { padding:4px 12px; border-radius:20px; font-size:11px; font-weight:700; }
        .repair-status-pill.s1 { background:rgba(255,183,77,0.12); color:#b58900; }
        .repair-status-pill.s2 { background:rgba(73,234,206,0.12); color:var(--primary); }
        .repair-status-pill.s3 { background:rgba(232,233,236,0.6); color:var(--on-surface-variant); }
        .repair-status-pill.s4 { background:rgba(186,26,26,0.08); color:var(--error); }

        .repair-table-footer { display:flex; justify-content:space-between; align-items:center; padding:14px 20px; background:rgba(255,255,255,0.4); border-top:1px solid rgba(0,0,0,0.05); }
        .repair-pagination { display:flex; gap:6px; }
        .repair-page-btn { width:32px; height:32px; display:flex; align-items:center; justify-content:center; border:1px solid rgba(0,0,0,0.08); border-radius:8px; background:rgba(255,255,255,0.6); cursor:pointer; font-size:13px; font-weight:600; color:var(--on-surface-variant); border:none; font-family:inherit; }
        .repair-page-btn.active { background:var(--primary); color:var(--on-primary); }

        .detail-overlay { display:none; position:fixed; inset:0; background:rgba(0,0,0,0.2); z-index:60; backdrop-filter:blur(4px); }
        .detail-overlay.show { display:block; }
        .detail-panel { position:fixed; top:0; right:0; height:100%; width:520px; max-width:100%; background:rgba(255,255,255,0.95); backdrop-filter:blur(16px); z-index:70; box-shadow:-8px 0 32px rgba(0,0,0,0.1); transform:translateX(100%); transition:transform 0.3s ease; display:flex; flex-direction:column; overflow-y:auto; }
        .detail-panel.show { transform:translateX(0); }
        .detail-header { padding:20px; border-bottom:1px solid rgba(0,0,0,0.05); display:flex; justify-content:space-between; align-items:start; position:sticky; top:0; background:rgba(255,255,255,0.8); backdrop-filter:blur(8px); z-index:1; }
        .detail-title { font-size:18px; font-weight:700; color:var(--on-surface); }
        .detail-sub { font-size:13px; color:var(--on-surface-variant); margin-top:4px; }
        .detail-close { padding:8px; border:none; background:transparent; border-radius:50%; cursor:pointer; color:var(--on-surface-variant); }
        .detail-body { flex:1; padding:20px; }
        .detail-section-title { font-size:14px; font-weight:700; color:var(--on-surface); margin-bottom:12px; }
        .detail-photo { width:100%; aspect-ratio:16/9; background:var(--surface-container); border-radius:14px; overflow:hidden; margin-bottom:20px; display:flex; align-items:center; justify-content:center; color:var(--outline-variant); }
        .detail-info-grid { display:grid; grid-template-columns:1fr 1fr; gap:10px; margin-bottom:20px; }
        .detail-info-item { background:rgba(255,255,255,0.5); border:1px solid rgba(255,255,255,0.4); padding:12px; border-radius:12px; }
        .detail-info-label { font-size:11px; font-weight:700; color:var(--on-surface-variant); text-transform:uppercase; margin-bottom:4px; }
        .detail-info-value { font-size:14px; font-weight:700; color:var(--on-surface); }
        .detail-desc { background:rgba(255,255,255,0.4); border:1px solid rgba(0,0,0,0.04); border-radius:12px; padding:14px; font-size:14px; color:var(--on-surface-variant); line-height:1.7; margin-bottom:20px; }
        .detail-assign { background:rgba(73,234,206,0.05); border:1px solid rgba(73,234,206,0.15); border-radius:14px; padding:16px; margin-bottom:20px; }
        .detail-assign select { width:100%; padding:12px 14px; border:1px solid rgba(0,0,0,0.08); border-radius:12px; background:rgba(255,255,255,0.8); font-family:inherit; font-size:14px; outline:none; margin-bottom:10px; }
        .detail-assign-btn { width:100%; padding:12px; background:var(--primary); color:var(--on-primary); border:none; border-radius:12px; font-size:14px; font-weight:700; cursor:pointer; font-family:inherit; }
        .detail-note { width:100%; min-height:80px; border:1px solid rgba(0,0,0,0.08); border-radius:12px; padding:12px; background:rgba(255,255,255,0.8); font-family:inherit; font-size:14px; resize:none; outline:none; box-sizing:border-box; }
        .detail-footer { padding:16px 20px; border-top:1px solid rgba(0,0,0,0.05); display:grid; grid-template-columns:1fr 1fr; gap:12px; background:rgba(255,255,255,0.4); }
        .detail-footer-btn { padding:12px; border-radius:12px; font-size:14px; font-weight:700; cursor:pointer; display:flex; align-items:center; justify-content:center; gap:6px; font-family:inherit; border:none; }
        .detail-footer-btn.reject { background:transparent; border:1px solid var(--error); color:var(--error); }
        .detail-footer-btn.complete { background:var(--primary); color:var(--on-primary); }

        .empty-msg { text-align:center; padding:40px; color:var(--on-surface-variant); }
        .empty-msg .material-symbols-outlined { font-size:48px; opacity:0.3; display:block; margin-bottom:8px; }

        .toast { position:fixed; top:20px; left:50%; transform:translateX(-50%) translateY(-100px); z-index:9999; padding:14px 28px; border-radius:14px; font-size:15px; font-weight:700; box-shadow:0 8px 24px rgba(0,0,0,0.15); transition:transform 0.3s ease; display:flex; align-items:center; gap:10px; }
        .toast.show { transform:translateX(-50%) translateY(0); }
        .toast.success { background:var(--primary); color:var(--on-primary); }
        .toast.error { background:var(--error); color:#fff; }

        @media (max-width:1024px) { .repair-stats { grid-template-columns:repeat(2,1fr); } }
        @media (max-width:768px) { .repair-stats { grid-template-columns:1fr; } .detail-panel { width:100%; } }
    </style>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="repair-header">
        <div>
            <h1>报修请求管理</h1>
            <p>实时监控和处理校园宿舍的维修服务申请。</p>
        </div>
    </div>

    <!-- 筛选栏 -->
    <div class="repair-filter">
        <div class="repair-filter-group">
            <label class="repair-filter-label">状态</label>
            <asp:DropDownList ID="ddlStatus" runat="server" CssClass="repair-filter-select">
                <asp:ListItem Value="0" Text="全部" />
                <asp:ListItem Value="1" Text="待分配" />
                <asp:ListItem Value="2" Text="维修中" />
                <asp:ListItem Value="3" Text="已完成" />
                <asp:ListItem Value="4" Text="已驳回" />
            </asp:DropDownList>
        </div>
        <div class="repair-filter-group">
            <label class="repair-filter-label">宿舍楼</label>
            <asp:DropDownList ID="ddlBuilding" runat="server" CssClass="repair-filter-select">
                <asp:ListItem Value="0" Text="全部" />
            </asp:DropDownList>
        </div>
        <div class="repair-filter-group">
            <label class="repair-filter-label">报修类型</label>
            <asp:DropDownList ID="ddlRepairType" runat="server" CssClass="repair-filter-select">
                <asp:ListItem Value="0" Text="全部" />
                <asp:ListItem Value="1" Text="水电报修" />
                <asp:ListItem Value="2" Text="家具家电" />
                <asp:ListItem Value="3" Text="网络连接" />
                <asp:ListItem Value="4" Text="其他" />
            </asp:DropDownList>
        </div>
        <asp:Button ID="btnSearch" runat="server" CssClass="repair-filter-btn" Text="筛选" OnClick="btnSearch_Click" />
        <asp:Button ID="btnReset" runat="server" CssClass="repair-filter-reset" Text="重置筛选" OnClick="btnReset_Click" />
    </div>

    <!-- 统计卡片 -->
    <div class="repair-stats">
        <div class="repair-stat">
            <div class="repair-stat-header"><span class="repair-stat-label">待处理工单</span><div class="repair-stat-icon" style="background:rgba(255,183,77,0.1);"><span class="material-symbols-outlined" style="color:#b58900;">pending_actions</span></div></div>
            <div class="repair-stat-value"><asp:Literal ID="litPending" runat="server" Text="0" /></div>
        </div>
        <div class="repair-stat">
            <div class="repair-stat-header"><span class="repair-stat-label">处理中工单</span><div class="repair-stat-icon" style="background:rgba(73,234,206,0.1);"><span class="material-symbols-outlined" style="color:var(--primary);">engineering</span></div></div>
            <div class="repair-stat-value"><asp:Literal ID="litProcessing" runat="server" Text="0" /></div>
        </div>
        <div class="repair-stat">
            <div class="repair-stat-header"><span class="repair-stat-label">今日已完成</span><div class="repair-stat-icon" style="background:rgba(73,234,206,0.1);"><span class="material-symbols-outlined" style="color:var(--primary);">task_alt</span></div></div>
            <div class="repair-stat-value"><asp:Literal ID="litTodayCompleted" runat="server" Text="0" /></div>
        </div>
    </div>

    <!-- 工单列表 -->
    <div class="repair-table-card">
        <div style="overflow-x:auto;">
            <asp:Repeater ID="rptRepairs" runat="server" OnItemCommand="rptRepairs_ItemCommand">
                <HeaderTemplate>
                    <table class="repair-table">
                        <thead><tr><th>工单ID</th><th>报修类型</th><th>宿舍位置</th><th>描述简述</th><th>报修时间</th><th>状态</th><th></th></tr></thead>
                        <tbody>
                </HeaderTemplate>
                <ItemTemplate>
                    <tr onclick="showDetail(<%# Eval("Id") %>)">
                        <td><%# Eval("OrderNo") %></td>
                        <td><div class="repair-type"><span class="material-symbols-outlined" style="color:<%# GetRepairTypeColor(Eval("RepairType")) %>;"><%# GetRepairTypeIcon(Eval("RepairType")) %></span> <%# Eval("TypeName") %></div></td>
                        <td><%# Eval("BuildingName") %> <%# Eval("RoomNo") %></td>
                        <td class="repair-desc"><%# Eval("Description") %></td>
                        <td><%# Convert.ToDateTime(Eval("CreateTime")).ToString("MM-dd HH:mm") %></td>
                        <td><span class="repair-status-pill s<%# Eval("Status") %>"><%# Eval("StatusName") %></span></td>
                        <td><span class="material-symbols-outlined" style="color:var(--on-surface-variant); font-size:20px;">chevron_right</span></td>
                    </tr>
                </ItemTemplate>
                <FooterTemplate>
                        </tbody></table>
                </FooterTemplate>
            </asp:Repeater>
        </div>
        <asp:Panel ID="pnlEmpty" runat="server" Visible="false">
            <div class="empty-msg"><span class="material-symbols-outlined">build</span><p>暂无报修工单</p></div>
        </asp:Panel>
        <div class="repair-table-footer">
            <span style="font-size:13px; color:var(--on-surface-variant);">
                <asp:Literal ID="litPageInfo" runat="server" />
            </span>
            <div class="repair-pagination">
                <asp:Button ID="btnPrev" runat="server" CssClass="repair-page-btn" Text="<" OnClick="btnPrev_Click" />
                <asp:Literal ID="litPageBtns" runat="server" />
                <asp:Button ID="btnNext" runat="server" CssClass="repair-page-btn" Text=">" OnClick="btnNext_Click" />
            </div>
        </div>
    </div>

    <!-- 详情面板 -->
    <div class="detail-overlay" id="detailOverlay" onclick="closeDetail()"></div>
    <div class="detail-panel" id="detailPanel">
        <div class="detail-header">
            <div>
                <div class="detail-title">工单详情</div>
                <div class="detail-sub">
                    <span style="color:var(--primary); font-weight:700;"><asp:Literal ID="litDetailOrderNo" runat="server" /></span>
                    <span style="color:var(--outline-variant);">·</span>
                    由 <asp:Literal ID="litDetailStudent" runat="server" /> 提交
                </div>
            </div>
            <button class="detail-close" onclick="closeDetail()"><span class="material-symbols-outlined">close</span></button>
        </div>
        <div class="detail-body">
            <div class="detail-section-title">现场照片</div>
            <asp:Literal ID="litPhotos" runat="server" />

            <div class="detail-info-grid">
                <div class="detail-info-item"><div class="detail-info-label">学生姓名</div><div class="detail-info-value"><asp:Literal ID="litDetailName" runat="server" /></div></div>
                <div class="detail-info-item"><div class="detail-info-label">学号</div><div class="detail-info-value"><asp:Literal ID="litDetailStudentNo" runat="server" /></div></div>
                <div class="detail-info-item"><div class="detail-info-label">联系电话</div><div class="detail-info-value" style="color:var(--primary);"><asp:Literal ID="litDetailPhone" runat="server" /></div></div>
                <div class="detail-info-item"><div class="detail-info-label">报修分类</div><div class="detail-info-value"><asp:Literal ID="litDetailType" runat="server" /></div></div>
            </div>

            <div class="detail-section-title">报修描述</div>
            <div class="detail-desc"><asp:Literal ID="litDetailDesc" runat="server" /></div>

            <div class="detail-section-title">派工处理</div>
            <div class="detail-assign">
                <asp:HiddenField ID="hfDetailId" runat="server" />
                <asp:DropDownList ID="ddlAssignAdmin" runat="server" />
                <asp:Button ID="btnAssign" runat="server" CssClass="detail-assign-btn" Text="立即确认指派" OnClick="btnAssign_Click" />
            </div>

            <div class="detail-section-title">内部管理备注</div>
            <asp:TextBox ID="txtNote" runat="server" CssClass="detail-note" TextMode="MultiLine" placeholder="此处输入仅管理员可见的工单跟踪记录..." />
            <asp:Button ID="btnSaveNote" runat="server" Text="保存备注" CssClass="detail-assign-btn" style="margin-top:10px;" OnClick="btnSaveNote_Click" />
        </div>
        <div class="detail-footer">
            <asp:Button ID="btnReject" runat="server" CssClass="detail-footer-btn reject" Text="驳回申请" OnClick="btnReject_Click" OnClientClick="return confirm('确定要驳回该报修申请吗？');" />
            <asp:Button ID="btnComplete" runat="server" CssClass="detail-footer-btn complete" Text="确认完成" OnClick="btnComplete_Click" OnClientClick="return confirm('确定该报修已处理完成吗？');" />
        </div>
    </div>

    <div id="toast" class="toast"></div>

    <script type="text/javascript">
        function showDetail(id) {
            __doPostBack('ShowDetail', id);
        }
        function openDetail() {
            document.getElementById('detailOverlay').classList.add('show');
            document.getElementById('detailPanel').classList.add('show');
        }
        function closeDetail() {
            document.getElementById('detailOverlay').classList.remove('show');
            document.getElementById('detailPanel').classList.remove('show');
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
