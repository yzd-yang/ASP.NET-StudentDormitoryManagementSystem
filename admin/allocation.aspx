<%@ Page Language="C#" MasterPageFile="~/admin/MasterPage.master" AutoEventWireup="true" CodeFile="allocation.aspx.cs" Inherits="admin_allocation" ResponseEncoding="utf-8" MaintainScrollPositionOnPostBack="true" %>

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
        .bed-item:hover { background:rgba(255,255,255,0.6); }
        .bed-left { display:flex; align-items:center; gap:10px; }
        .bed-avatar { width:36px; height:36px; border-radius:50%; background:rgba(73,234,206,0.12); display:flex; align-items:center; justify-content:center; }
        .bed-avatar .material-symbols-outlined { font-size:18px; color:var(--primary); }
        .bed-name { font-size:14px; font-weight:700; color:var(--on-surface); }
        .bed-info { font-size:12px; color:var(--on-surface-variant); }
        .bed-empty-btn {
            display:flex; align-items:center; justify-content:center; gap:8px; padding:14px;
            border:2px dashed rgba(73,234,206,0.3); border-radius:14px; color:var(--on-surface-variant);
            cursor:pointer; transition:all 0.2s; margin-bottom:8px; background:transparent; width:100%; font-family:inherit; font-size:14px;
            text-decoration:none; font-weight:600;
        }
        .bed-empty-btn:hover { border-color:var(--primary); color:var(--primary); background:rgba(73,234,206,0.04); }
        .release-btn { font-size:11px; color:var(--error); cursor:pointer; background:none; border:none; font-family:inherit; font-weight:600; padding:4px 8px; border-radius:6px; }
        .release-btn:hover { background:rgba(186,26,26,0.08); }

        .pagination-bar { display:flex; justify-content:space-between; align-items:center; margin-top:24px; padding-top:20px; border-top:1px solid rgba(73,234,206,0.12); }
        .pagination-info { font-size:13px; color:var(--on-surface-variant); }
        .pagination-btns { display:flex; gap:6px; align-items:center; }
        .page-btn { width:36px; height:36px; display:flex; align-items:center; justify-content:center; border:none; border-radius:10px; cursor:pointer; font-size:13px; font-weight:700; background:transparent; color:var(--on-surface-variant); transition:all 0.2s; font-family:inherit; }
        .page-btn.active { background:var(--primary); color:var(--on-primary); }
        .page-btn:hover:not(.active) { background:rgba(73,234,206,0.1); }

        .modal-overlay { display:none; position:fixed; inset:0; background:rgba(0,0,0,0.4); z-index:1000; align-items:center; justify-content:center; backdrop-filter:blur(4px); }
        .modal-overlay.show { display:flex; }
        .modal-card { background:#fff; border-radius:24px; max-width:500px; width:90%; max-height:85vh; overflow-y:auto; box-shadow:0 20px 60px rgba(0,0,0,0.2); }
        .modal-header { padding:20px 24px; border-bottom:1px solid rgba(0,0,0,0.05); display:flex; justify-content:space-between; align-items:center; }
        .modal-header h3 { font-size:18px; font-weight:700; color:var(--on-surface); }
        .modal-close { width:32px; height:32px; display:flex; align-items:center; justify-content:center; border:none; background:rgba(0,0,0,0.05); border-radius:50%; cursor:pointer; color:var(--on-surface-variant); }
        .modal-body { padding:24px; }
        .modal-search { width:100%; padding:14px 14px 14px 44px; border:1px solid var(--outline-variant); border-radius:14px; background:#FFF9E6; font-family:inherit; font-size:15px; outline:none; transition:all 0.2s; box-sizing:border-box; }
        .modal-search:focus { border-color:var(--primary); box-shadow:0 0 0 3px rgba(73,234,206,0.12); }
        .modal-search-wrap { position:relative; margin-bottom:16px; }
        .modal-search-wrap .material-symbols-outlined { position:absolute; left:14px; top:50%; transform:translateY(-50%); color:var(--primary); font-size:20px; }
        .student-item { display:flex; align-items:center; justify-content:space-between; padding:12px 14px; border-radius:12px; transition:all 0.2s; margin-bottom:8px; border:1px solid rgba(0,0,0,0.05); }
        .student-item:hover { background:rgba(73,234,206,0.08); border-color:var(--primary); }
        .student-left { display:flex; align-items:center; gap:12px; }
        .student-avatar { width:40px; height:40px; border-radius:50%; background:rgba(73,234,206,0.15); display:flex; align-items:center; justify-content:center; font-weight:700; color:var(--primary); font-size:16px; }
        .student-name { font-size:14px; font-weight:700; color:var(--on-surface); }
        .student-detail { font-size:12px; color:var(--on-surface-variant); }
        .student-select-btn { padding:8px 16px; background:var(--primary); color:var(--on-primary); border:none; border-radius:10px; font-size:13px; font-weight:700; cursor:pointer; font-family:inherit; }
        .modal-footer { padding:16px 24px; border-top:1px solid rgba(0,0,0,0.05); display:flex; justify-content:flex-end; gap:12px; }
        .modal-cancel-btn { padding:12px 24px; border:2px solid var(--outline-variant); background:transparent; border-radius:14px; font-size:14px; font-weight:700; cursor:pointer; color:var(--on-surface-variant); font-family:inherit; }

        .modal-filter-select {
            width:100%; padding:10px 12px; border:1px solid var(--outline-variant); border-radius:10px;
            background:#FFF9E6; font-family:inherit; font-size:13px; color:var(--on-surface); outline:none; cursor:pointer;
        }
        .modal-filter-select:focus { border-color:var(--primary); box-shadow:0 0 0 2px rgba(73,234,206,0.12); }

        .empty-msg { text-align:center; padding:40px; color:var(--on-surface-variant); }
        .empty-msg .material-symbols-outlined { font-size:48px; opacity:0.3; display:block; margin-bottom:8px; }

        .toast {
            position:fixed; top:20px; left:50%; transform:translateX(-50%) translateY(-100px); z-index:9999;
            padding:14px 28px; border-radius:14px; font-size:15px; font-weight:700;
            box-shadow:0 8px 24px rgba(0,0,0,0.15); transition:transform 0.3s ease; display:flex; align-items:center; gap:10px;
        }
        .toast.show { transform:translateX(-50%) translateY(0); }
        .toast.success { background:var(--primary); color:var(--on-primary); }
        .toast.error { background:var(--error); color:#fff; }
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
            <span class="alloc-filter-label">楼栋:</span>
            <asp:DropDownList ID="ddlBuilding" runat="server" CssClass="alloc-filter-select" AutoPostBack="true" OnSelectedIndexChanged="ddlBuilding_SelectedIndexChanged">
                <asp:ListItem Value="0" Text="全部楼栋" />
            </asp:DropDownList>
        </div>
        <div class="alloc-filter-field">
            <span class="alloc-filter-label">楼层:</span>
            <asp:DropDownList ID="ddlFloor" runat="server" CssClass="alloc-filter-select">
                <asp:ListItem Value="0" Text="全部楼层" />
            </asp:DropDownList>
        </div>
        <div class="alloc-filter-field">
            <span class="alloc-filter-label">类型:</span>
            <asp:DropDownList ID="ddlRoomType" runat="server" CssClass="alloc-filter-select">
                <asp:ListItem Value="0" Text="全部类型" />
                <asp:ListItem Value="1" Text="双人间" />
                <asp:ListItem Value="2" Text="四人间" />
                <asp:ListItem Value="3" Text="六人间" />
            </asp:DropDownList>
        </div>
        <div class="alloc-filter-field">
            <span class="alloc-filter-label">状态:</span>
            <asp:DropDownList ID="ddlStatus" runat="server" CssClass="alloc-filter-select">
                <asp:ListItem Value="" Text="全部状态" />
                <asp:ListItem Value="empty" Text="全空置" />
                <asp:ListItem Value="partial" Text="有空余" />
                <asp:ListItem Value="full" Text="已满员" />
            </asp:DropDownList>
        </div>
        <div class="alloc-filter-field">
            <span class="alloc-filter-label">房间号:</span>
            <asp:TextBox ID="txtRoomNo" runat="server" CssClass="alloc-filter-input" placeholder="搜索..." style="width:80px;" />
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
                            <asp:Panel ID="pnlOccupied" runat="server" Visible='<%# Convert.ToInt32(Eval("Status")) == 1 %>'>
                                <div class="bed-item">
                                    <div class="bed-left">
                                        <div class="bed-avatar"><span class="material-symbols-outlined">person</span></div>
                                        <div>
                                            <div class="bed-name"><%# Eval("StudentName") %></div>
                                            <div class="bed-info"><%# Eval("StudentNo") %></div>
                                        </div>
                                    </div>
                                    <asp:LinkButton ID="btnRelease" runat="server" CommandName="Release" CommandArgument='<%# Eval("Id") %>' CssClass="release-btn" OnClientClick="return confirm('确定要退宿吗？');">退宿</asp:LinkButton>
                                </div>
                            </asp:Panel>
                            <asp:Panel ID="pnlEmpty" runat="server" Visible='<%# Convert.ToInt32(Eval("Status")) == 0 %>'>
                                <asp:LinkButton ID="btnAllocate" runat="server" CommandName="Allocate" CommandArgument='<%# Eval("Id") %>' CssClass="bed-empty-btn">
                                    <span class="material-symbols-outlined" style="font-size:20px; color:var(--primary);">add_circle</span>
                                    分配床位 <%# Eval("BedNo") %>
                                </asp:LinkButton>
                            </asp:Panel>
                        </ItemTemplate>
                    </asp:Repeater>
                </div>
            </ItemTemplate>
        </asp:Repeater>
    </div>

    <asp:Panel ID="pnlNoRooms" runat="server" Visible="false">
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
    <asp:Panel ID="pnlAllocateModal" runat="server" CssClass="modal-overlay" Style="display:none;">
        <div class="modal-card" style="max-width:560px;">
            <div class="modal-header">
                <h3>床位分配 - <asp:Literal ID="litModalTitle" runat="server" /></h3>
                <asp:Button ID="btnCloseModal" runat="server" CssClass="modal-close" Text="X" OnClick="btnCloseModal_Click" />
            </div>
            <div class="modal-body">
                <asp:HiddenField ID="hfBedId" runat="server" />
                
                <!-- 筛选条件 -->
                <div style="display:grid; grid-template-columns:1fr 1fr; gap:10px; margin-bottom:14px;">
                    <div>
                        <label style="font-size:12px; font-weight:700; color:var(--on-surface-variant); display:block; margin-bottom:4px;">学院</label>
                        <asp:DropDownList ID="ddlCollege" runat="server" CssClass="modal-filter-select" AutoPostBack="true" OnSelectedIndexChanged="ddlCollege_SelectedIndexChanged">
                            <asp:ListItem Value="" Text="全部学院" />
                        </asp:DropDownList>
                    </div>
                    <div>
                        <label style="font-size:12px; font-weight:700; color:var(--on-surface-variant); display:block; margin-bottom:4px;">专业</label>
                        <asp:DropDownList ID="ddlMajor" runat="server" CssClass="modal-filter-select" AutoPostBack="true" OnSelectedIndexChanged="ddlMajor_SelectedIndexChanged">
                            <asp:ListItem Value="" Text="全部专业" />
                        </asp:DropDownList>
                    </div>
                    <div>
                        <label style="font-size:12px; font-weight:700; color:var(--on-surface-variant); display:block; margin-bottom:4px;">年级</label>
                        <asp:DropDownList ID="ddlGrade" runat="server" CssClass="modal-filter-select" AutoPostBack="true" OnSelectedIndexChanged="ddlGrade_SelectedIndexChanged">
                            <asp:ListItem Value="" Text="全部年级" />
                        </asp:DropDownList>
                    </div>
                    <div>
                        <label style="font-size:12px; font-weight:700; color:var(--on-surface-variant); display:block; margin-bottom:4px;">班级</label>
                        <asp:DropDownList ID="ddlClass" runat="server" CssClass="modal-filter-select">
                            <asp:ListItem Value="" Text="全部班级" />
                        </asp:DropDownList>
                    </div>
                </div>

                <!-- 搜索框 -->
                <div class="modal-search-wrap">
                    <span class="material-symbols-outlined">search</span>
                    <asp:TextBox ID="txtSearchStudent" runat="server" CssClass="modal-search" placeholder="输入学号或姓名搜索..." />
                </div>
                
                <asp:Button ID="btnSearchStudent" runat="server" Text="搜索" CssClass="alloc-filter-btn" style="width:100%; margin-bottom:14px; justify-content:center;" OnClick="btnSearchStudent_Click" />
                
                <div style="max-height:300px; overflow-y:auto;">
                    <asp:Repeater ID="rptStudents" runat="server" OnItemCommand="rptStudents_ItemCommand">
                        <ItemTemplate>
                            <div class="student-item">
                                <div class="student-left">
                                    <div class="student-avatar"><%# Eval("Name").ToString().Substring(0, 1) %></div>
                                    <div>
                                        <div class="student-name"><%# Eval("Name") %></div>
                                        <div class="student-detail"><%# Eval("StudentNo") %> · <%# Eval("College") %> · <%# Eval("Major") %> · <%# Eval("Grade") %> <%# Eval("ClassName") %></div>
                                    </div>
                                </div>
                                <asp:LinkButton ID="btnSelectStudent" runat="server" CommandName="Select" CommandArgument='<%# Eval("Id") %>' CssClass="student-select-btn">选择</asp:LinkButton>
                            </div>
                        </ItemTemplate>
                    </asp:Repeater>
                    <asp:Panel ID="pnlNoStudent" runat="server" Visible="true">
                        <div style="text-align:center; padding:20px; color:var(--on-surface-variant);">
                            <p>请输入条件搜索学生</p>
                        </div>
                    </asp:Panel>
                </div>
            </div>
            <div class="modal-footer">
                <asp:Button ID="btnCancel" runat="server" CssClass="modal-cancel-btn" Text="取消" OnClick="btnCloseModal_Click" />
            </div>
        </div>
    </asp:Panel>

    <script type="text/javascript">
        function showAllocateModal() {
            var modal = document.getElementById('<%= pnlAllocateModal.ClientID %>');
            modal.style.display = 'flex';
            document.body.style.overflow = 'hidden';
        }
        function hideAllocateModal() {
            var modal = document.getElementById('<%= pnlAllocateModal.ClientID %>');
            modal.style.display = 'none';
            document.body.style.overflow = '';
        }
        function showToast(msg, type) {
            var toast = document.getElementById('toast');
            toast.className = 'toast ' + type;
            toast.innerHTML = '<span class="material-symbols-outlined">' + (type === 'success' ? 'check_circle' : 'error') + '</span>' + msg;
            toast.classList.add('show');
            setTimeout(function() { toast.classList.remove('show'); }, 3000);
        }
    </script>

    <!-- Toast 提示 -->
    <div id="toast" class="toast"></div>
</asp:Content>
