<%@ Page Language="C#" MasterPageFile="~/admin/MasterPage.master" AutoEventWireup="true" CodeFile="allocation.aspx.cs" Inherits="admin_allocation" ResponseEncoding="utf-8" %>

<asp:Content ID="Content1" ContentPlaceHolderID="title" runat="server">宿舍分配管理 - SmartDorm</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="head" runat="server">
    <style>
        .alloc-header { display:flex; justify-content:space-between; align-items:end; margin-bottom:20px; flex-wrap:wrap; gap:12px; }
        .alloc-header h1 { font-size:28px; font-weight:800; color:var(--on-surface); }
        .alloc-header p { font-size:15px; color:var(--on-surface-variant); margin-top:4px; }

        .alloc-filter {
            background:rgba(255,255,255,0.5); backdrop-filter:blur(8px); border-radius:16px; padding:16px 18px;
            border:1px solid rgba(255,255,255,0.4); display:flex; flex-wrap:wrap; gap:14px; align-items:center; margin-bottom:20px;
        }
        .alloc-filter-field { display:flex; align-items:center; gap:8px; background:rgba(255,255,255,0.4); padding:8px 14px; border-radius:12px; border:1px solid rgba(73,234,206,0.08); }
        .alloc-filter-label { font-size:13px; font-weight:700; color:var(--on-surface-variant); }
        .alloc-filter-select, .alloc-filter-input { border:none; background:transparent; font-family:inherit; font-size:14px; color:var(--on-surface); outline:none; }
        .alloc-filter-btn {
            padding:10px 20px; background:var(--primary); color:var(--on-primary); border:none;
            border-radius:12px; font-size:14px; font-weight:700; cursor:pointer; display:flex; align-items:center; gap:6px; font-family:inherit;
        }
        .alloc-stats { font-size:14px; font-weight:700; color:var(--primary); margin-left:auto; white-space:nowrap; }

        .room-grid { display:grid; grid-template-columns:repeat(auto-fill, minmax(340px, 1fr)); gap:20px; }
        .room-card {
            background:rgba(255,255,255,0.7); backdrop-filter:blur(12px); border-radius:18px; padding:20px;
            border:1px solid rgba(73,234,206,0.12); position:relative; overflow:hidden; transition:all 0.3s;
        }
        .room-card:hover { transform:translateY(-3px); box-shadow:0 8px 24px rgba(73,234,206,0.15); }
        .room-card::before { content:''; position:absolute; left:0; top:0; bottom:0; width:4px; background:var(--primary); border-radius:2px 0 0 2px; }
        .room-card-header { display:flex; justify-content:space-between; align-items:start; margin-bottom:16px; }
        .room-card-title { font-size:20px; font-weight:700; color:var(--on-surface); }
        .room-card-sub { font-size:13px; color:var(--on-surface-variant); margin-top:2px; }
        .room-status { padding:4px 12px; border-radius:20px; font-size:12px; font-weight:700; }
        .room-status.full { background:rgba(73,234,206,0.12); color:#006b5c; border:1px solid rgba(73,234,206,0.2); }
        .room-status.partial { background:rgba(251,192,45,0.1); color:#b58900; border:1px solid rgba(251,192,45,0.2); }
        .room-status.empty { background:rgba(73,234,206,0.08); color:var(--primary); border:1px solid rgba(73,234,206,0.15); }

        .bed-item {
            display:flex; align-items:center; justify-content:space-between; padding:12px 14px;
            background:rgba(255,255,255,0.4); border-radius:12px; margin-bottom:8px; transition:all 0.2s;
        }
        .bed-item:hover { border-color:rgba(73,234,206,0.3); background:rgba(255,255,255,0.6); }
        .bed-left { display:flex; align-items:center; gap:10px; }
        .bed-avatar { width:36px; height:36px; border-radius:50%; background:rgba(73,234,206,0.12); display:flex; align-items:center; justify-content:center; }
        .bed-avatar .material-symbols-outlined { font-size:18px; color:var(--primary); }
        .bed-name { font-size:14px; font-weight:700; color:var(--on-surface); }
        .bed-info { font-size:12px; color:var(--on-surface-variant); }
        .bed-status { font-size:12px; font-weight:700; color:var(--primary); }
        .bed-empty {
            display:flex; align-items:center; justify-content:center; gap:8px; padding:14px;
            border:2px dashed rgba(73,234,206,0.3); border-radius:14px; color:var(--on-surface-variant);
            cursor:pointer; transition:all 0.2s; margin-bottom:8px; background:transparent; width:100%; font-family:inherit; font-size:14px;
        }
        .bed-empty:hover { border-color:var(--primary); color:var(--primary); background:rgba(73,234,206,0.04); }
        .bed-empty .material-symbols-outlined { color:var(--primary); font-size:20px; }

        .pagination-bar { display:flex; justify-content:space-between; align-items:center; margin-top:24px; padding-top:20px; border-top:1px solid rgba(73,234,206,0.12); }
        .pagination-info { font-size:13px; color:var(--on-surface-variant); }
        .pagination-btns { display:flex; gap:6px; align-items:center; }
        .page-btn { width:36px; height:36px; display:flex; align-items:center; justify-content:center; border:none; border-radius:10px; cursor:pointer; font-size:13px; font-weight:700; background:transparent; color:var(--on-surface-variant); transition:all 0.2s; font-family:inherit; }
        .page-btn.active { background:var(--primary); color:var(--on-primary); }
        .page-btn:hover:not(.active) { background:rgba(73,234,206,0.1); }

        /* 分配弹窗 */
        .modal-overlay { display:none; position:fixed; inset:0; background:rgba(0,0,0,0.4); z-index:1000; align-items:center; justify-content:center; backdrop-filter:blur(4px); }
        .modal-overlay.show { display:flex; }
        .modal-card { background:#fff; border-radius:24px; max-width:500px; width:90%; max-height:85vh; overflow-y:auto; box-shadow:0 20px 60px rgba(0,0,0,0.2); }
        .modal-header { padding:20px 24px; border-bottom:1px solid rgba(0,0,0,0.05); display:flex; justify-content:space-between; align-items:center; }
        .modal-header h3 { font-size:18px; font-weight:700; color:var(--on-surface); }
        .modal-close { width:32px; height:32px; display:flex; align-items:center; justify-content:center; border:none; background:rgba(0,0,0,0.05); border-radius:50%; cursor:pointer; color:var(--on-surface-variant); }
        .modal-body { padding:24px; }
        .modal-search { width:100%; padding:14px 14px 14px 44px; border:1px solid var(--outline-variant); border-radius:14px; background:#FFF9E6; font-family:inherit; font-size:15px; outline:none; transition:all 0.2s; }
        .modal-search:focus { border-color:var(--primary); box-shadow:0 0 0 3px rgba(73,234,206,0.12); }
        .modal-search-wrap { position:relative; margin-bottom:16px; }
        .modal-search-wrap .material-symbols-outlined { position:absolute; left:14px; top:50%; transform:translateY(-50%); color:var(--primary); font-size:20px; }
        .student-item { display:flex; align-items:center; justify-content:space-between; padding:12px 14px; border-radius:12px; cursor:pointer; transition:all 0.2s; margin-bottom:8px; border:1px solid rgba(0,0,0,0.05); }
        .student-item:hover { background:rgba(73,234,206,0.08); border-color:var(--primary); }
        .student-left { display:flex; align-items:center; gap:12px; }
        .student-avatar { width:40px; height:40px; border-radius:50%; background:rgba(73,234,206,0.15); display:flex; align-items:center; justify-content:center; font-weight:700; color:var(--primary); font-size:16px; }
        .student-name { font-size:14px; font-weight:700; color:var(--on-surface); }
        .student-detail { font-size:12px; color:var(--on-surface-variant); }
        .modal-footer { padding:16px 24px; border-top:1px solid rgba(0,0,0,0.05); display:flex; justify-content:flex-end; gap:12px; }
        .modal-cancel { padding:12px 24px; border:2px solid var(--outline-variant); background:transparent; border-radius:14px; font-size:14px; font-weight:700; cursor:pointer; color:var(--on-surface-variant); font-family:inherit; }
        .modal-confirm { padding:12px 24px; background:var(--primary); color:var(--on-primary); border:none; border-radius:14px; font-size:14px; font-weight:700; cursor:pointer; font-family:inherit; box-shadow:0 4px 12px rgba(73,234,206,0.3); }

        .empty-msg { text-align:center; padding:40px; color:var(--on-surface-variant); }
        .empty-msg .material-symbols-outlined { font-size:48px; opacity:0.3; display:block; margin-bottom:8px; }

        .release-btn { font-size:11px; color:var(--error); cursor:pointer; background:none; border:none; font-family:inherit; font-weight:600; padding:4px 8px; border-radius:6px; }
        .release-btn:hover { background:rgba(186,26,26,0.08); }
    </style>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="alloc-header">
        <div>
            <h1>宿舍分配管理</h1>
            <p>实时监控与管理全校宿舍床位资源</p>
        </div>
    </div>

    <div class="alloc-filter">
        <div class="alloc-filter-field">
            <span class="alloc-filter-label">宿舍楼号:</span>
            <asp:DropDownList ID="ddlBuilding" runat="server" CssClass="alloc-filter-select" AutoPostBack="true" OnSelectedIndexChanged="ddlBuilding_SelectedIndexChanged">
                <asp:ListItem Value="0" Text="全部楼栋" />
            </asp:DropDownList>
        </div>
        <div class="alloc-filter-field">
            <span class="alloc-filter-label">房间号:</span>
            <asp:TextBox ID="txtRoomNo" runat="server" CssClass="alloc-filter-input" placeholder="输入房间号..." style="width:120px;" />
        </div>
        <asp:Button ID="btnSearch" runat="server" CssClass="alloc-filter-btn" Text="筛选" OnClick="btnSearch_Click" />
        <span class="alloc-stats">
            <asp:Literal ID="litStats" runat="server" />
        </span>
    </div>

    <div class="room-grid">
        <asp:Repeater ID="rptRooms" runat="server" OnItemDataBound="rptRooms_ItemDataBound">
            <ItemTemplate>
                <div class="room-card">
                    <div class="room-card-header">
                        <div>
                            <div class="room-card-title"><%# Eval("RoomNo") %> 室</div>
                            <div class="room-card-sub"><%# GetRoomType(Eval("RoomType")) %> · <%# Eval("Campus") %></div>
                        </div>
                        <span class='<%# GetStatusCss(Eval("OccupiedBeds"), Eval("TotalBeds")) %>'><%# GetStatusText(Eval("OccupiedBeds"), Eval("TotalBeds")) %></span>
                    </div>
                    <asp:Repeater ID="rptBeds" runat="server" OnItemCommand="rptBeds_ItemCommand">
                        <ItemTemplate>
                            <%# Convert.ToInt32(Eval("Status")) == 1 ? GetOccupiedBedHtml(Eval("StudentName"), Eval("StudentNo"), Eval("Id")) : GetEmptyBedHtml(Eval("BedNo"), Eval("Id")) %>
                        </ItemTemplate>
                    </asp:Repeater>
                </div>
            </ItemTemplate>
        </asp:Repeater>
    </div>

    <asp:Panel ID="pnlEmpty" runat="server" Visible="false">
        <div class="empty-msg">
            <span class="material-symbols-outlined">meeting_room</span>
            <p>暂无房间数据</p>
        </div>
    </asp:Panel>

    <div class="pagination-bar">
        <span class="pagination-info">
            <asp:Literal ID="litPageInfo" runat="server" />
        </span>
        <div class="pagination-btns">
            <asp:Button ID="btnPrev" runat="server" CssClass="page-btn" Text="<" OnClick="btnPrev_Click" />
            <asp:Literal ID="litPageBtns" runat="server" />
            <asp:Button ID="btnNext" runat="server" CssClass="page-btn" Text=">" OnClick="btnNext_Click" />
        </div>
    </div>

    <!-- 分配弹窗 -->
    <div class="modal-overlay" id="allocateModal" runat="server">
        <div class="modal-card">
            <div class="modal-header">
                <h3>床位分配 - <asp:Literal ID="litModalTitle" runat="server" /></h3>
                <button class="modal-close" type="button" onclick="closeModal()"><span class="material-symbols-outlined">close</span></button>
            </div>
            <div class="modal-body">
                <asp:HiddenField ID="hfBedId" runat="server" />
                <div class="modal-search-wrap">
                    <span class="material-symbols-outlined">search</span>
                    <asp:TextBox ID="txtSearchStudent" runat="server" CssClass="modal-search" placeholder="输入学号或姓名搜索..." AutoPostBack="true" OnTextChanged="txtSearchStudent_TextChanged" />
                </div>
                <div style="max-height:300px; overflow-y:auto;">
                    <asp:Repeater ID="rptStudents" runat="server" OnItemCommand="rptStudents_ItemCommand">
                        <ItemTemplate>
                            <div class="student-item">
                                <div class="student-left">
                                    <div class="student-avatar"><%# Eval("Name").ToString().Substring(0, 1) %></div>
                                    <div>
                                        <div class="student-name"><%# Eval("Name") %></div>
                                        <div class="student-detail"><%# Eval("StudentNo") %> · <%# Eval("College") %> · <%# Eval("Major") %></div>
                                    </div>
                                </div>
                                <asp:LinkButton ID="btnSelect" runat="server" CommandName="Select" CommandArgument='<%# Eval("Id") %>' CssClass="modal-confirm" style="padding:8px 16px; font-size:13px;">选择</asp:LinkButton>
                            </div>
                        </ItemTemplate>
                    </asp:Repeater>
                    <asp:Panel ID="pnlNoStudent" runat="server" Visible="false">
                        <div style="text-align:center; padding:20px; color:var(--on-surface-variant);">
                            <p>请输入学号或姓名搜索学生</p>
                        </div>
                    </asp:Panel>
                </div>
            </div>
            <div class="modal-footer">
                <button class="modal-cancel" type="button" onclick="closeModal()">取消</button>
            </div>
        </div>
    </div>

    <!-- 退宿确认弹窗 -->
    <div class="modal-overlay" id="releaseModal" runat="server">
        <div class="modal-card" style="max-width:400px;">
            <div class="modal-header">
                <h3>确认退宿</h3>
                <button class="modal-close" type="button" onclick="closeReleaseModal()"><span class="material-symbols-outlined">close</span></button>
            </div>
            <div class="modal-body">
                <p style="color:var(--on-surface-variant); margin-bottom:16px;">确定要将该学生从床位移除吗？此操作不可撤销。</p>
                <asp:HiddenField ID="hfReleaseBedId" runat="server" />
                <p style="font-weight:700; color:var(--on-surface);">
                    <asp:Literal ID="litReleaseInfo" runat="server" />
                </p>
            </div>
            <div class="modal-footer">
                <button class="modal-cancel" type="button" onclick="closeReleaseModal()">取消</button>
                <asp:Button ID="btnConfirmRelease" runat="server" CssClass="modal-confirm" Text="确认退宿" style="background:var(--error);" OnClick="btnConfirmRelease_Click" />
            </div>
        </div>
    </div>

    <script type="text/javascript">
        function openModal() {
            document.getElementById('<%= allocateModal.ClientID %>').classList.add('show');
            document.body.style.overflow = 'hidden';
        }
        function closeModal() {
            document.getElementById('<%= allocateModal.ClientID %>').classList.remove('show');
            document.body.style.overflow = '';
        }
        function openReleaseModal() {
            document.getElementById('<%= releaseModal.ClientID %>').classList.add('show');
            document.body.style.overflow = 'hidden';
        }
        function closeReleaseModal() {
            document.getElementById('<%= releaseModal.ClientID %>').classList.remove('show');
            document.body.style.overflow = '';
        }
    </script>
</asp:Content>
