<%@ Page Language="C#" MasterPageFile="~/admin/MasterPage.master" AutoEventWireup="true" CodeFile="system.aspx.cs" Inherits="admin_system" ResponseEncoding="utf-8" %>

<asp:Content ID="Content1" ContentPlaceHolderID="title" runat="server">系统管理 - SmartDorm</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="head" runat="server">
    <style>
        .sys-section { background:rgba(255,255,255,0.6); backdrop-filter:blur(12px); border-radius:16px; padding:24px; border:1px solid rgba(255,255,255,0.5); margin-bottom:20px; }
        .sys-section-title { font-size:18px; font-weight:700; color:var(--primary); margin-bottom:20px; }
        .sys-filter { display:flex; flex-wrap:wrap; gap:12px; align-items:center; margin-bottom:20px; }
        .sys-filter-field { position:relative; }
        .sys-filter-field .material-symbols-outlined { position:absolute; left:12px; top:50%; transform:translateY(-50%); font-size:20px; color:var(--outline); }
        .sys-filter-input { padding:10px 14px 10px 40px; border:none; border-radius:10px; background:#FFF9E6; font-family:inherit; font-size:14px; width:220px; outline:none; }
        .sys-filter-input:focus { box-shadow:0 0 0 2px rgba(73,234,206,0.3); }
        .sys-filter-select { padding:10px 14px; border:none; border-radius:10px; background:#FFF9E6; font-family:inherit; font-size:14px; outline:none; min-width:130px; }
        .sys-add-btn {
            display:flex; align-items:center; gap:6px; padding:10px 20px; background:var(--primary); color:var(--on-primary);
            border:none; border-radius:10px; font-size:14px; font-weight:700; cursor:pointer; margin-left:auto; font-family:inherit;
        }
        .sys-table { width:100%; border-collapse:collapse; }
        .sys-table th { padding:12px 16px; text-align:left; font-size:13px; font-weight:700; color:var(--on-surface-variant); border-bottom:1px solid rgba(0,0,0,0.05); }
        .sys-table td { padding:14px 16px; font-size:14px; color:var(--on-surface); border-bottom:1px solid rgba(0,0,0,0.03); }
        .sys-table tr:hover td { background:rgba(73,234,206,0.04); }
        .sys-role-badge { display:inline-block; padding:3px 10px; border-radius:20px; font-size:12px; font-weight:700; }
        .sys-role-badge.admin { background:rgba(219,206,221,0.5); color:var(--on-surface); }
        .sys-role-badge.manager { background:rgba(221,231,197,0.5); color:var(--on-surface); }
        .sys-role-badge.worker { background:rgba(73,234,206,0.12); color:var(--primary); }
        .sys-status { display:flex; align-items:center; gap:6px; font-size:14px; font-weight:600; color:var(--primary); }
        .sys-status-dot { width:8px; height:8px; border-radius:50%; background:var(--primary); }
        .sys-action-link { font-size:13px; font-weight:700; cursor:pointer; background:none; border:none; font-family:inherit; padding:0 4px; }
        .sys-action-link.edit { color:var(--primary); }
        .sys-action-link.reset { color:var(--on-surface-variant); }
        .sys-action-link.delete { color:var(--error); }
        .sys-grid { display:grid; grid-template-columns:1fr 1.5fr 0.8fr; gap:20px; }
        .sys-card { background:rgba(255,255,255,0.6); backdrop-filter:blur(12px); border-radius:16px; padding:20px; border:1px solid rgba(255,255,255,0.5); }
        .sys-card-title { font-size:15px; font-weight:700; color:var(--on-surface); margin-bottom:16px; display:flex; justify-content:space-between; align-items:center; }
        .building-item {
            display:flex; align-items:center; justify-content:space-between; padding:14px;
            background:rgba(255,255,255,0.6); border-radius:12px; margin-bottom:10px; border:1px solid rgba(255,255,255,0.4); transition:all 0.2s;
        }
        .building-item:hover { background:rgba(255,255,255,0.8); }
        .building-left { display:flex; align-items:center; gap:12px; }
        .building-icon { width:44px; height:44px; border-radius:10px; background:rgba(73,234,206,0.12); display:flex; align-items:center; justify-content:center; }
        .building-icon .material-symbols-outlined { color:var(--primary); font-size:24px; }
        .building-name { font-size:14px; font-weight:700; color:var(--on-surface); }
        .building-sub { font-size:12px; color:var(--on-surface-variant); }
        .building-actions { display:flex; gap:4px; }
        .building-action-btn { padding:6px; border:none; background:transparent; border-radius:6px; cursor:pointer; color:var(--on-surface-variant); }
        .building-action-btn:hover { background:rgba(0,0,0,0.04); }
        .building-action-btn.delete:hover { color:var(--error); background:rgba(186,26,26,0.06); }
        .building-action-btn .material-symbols-outlined { font-size:18px; }
        .building-add {
            padding:14px; border:2px dashed rgba(107,122,118,0.3); border-radius:12px; display:flex;
            align-items:center; justify-content:center; gap:6px; color:var(--outline); font-size:14px; font-weight:600; cursor:pointer; background:transparent; width:100%; font-family:inherit;
        }
        .building-add:hover { border-color:var(--primary); color:var(--primary); }
        .batch-gen-form { display:flex; flex-direction:column; gap:14px; }
        .batch-gen-row { display:grid; grid-template-columns:1fr 1fr; gap:12px; }
        .batch-gen-row-3 { display:flex; gap:8px; }
        .batch-gen-row-3 span { display:flex; align-items:center; color:var(--on-surface-variant); }
        .batch-gen-input { width:100%; padding:10px 14px; border:none; border-radius:10px; background:#FFF9E6; font-family:inherit; font-size:14px; outline:none; box-sizing:border-box; }
        .batch-gen-input:focus { box-shadow:0 0 0 2px rgba(73,234,206,0.3); }
        .batch-gen-preview { padding:14px; background:rgba(232,233,236,0.4); border-radius:12px; border:1px solid rgba(0,0,0,0.04); }
        .batch-gen-preview-label { font-size:13px; font-weight:600; color:var(--on-surface-variant); margin-bottom:8px; }
        .batch-gen-summary { font-size:13px; color:var(--primary); font-weight:600; }
        .batch-gen-btn {
            width:100%; padding:12px; background:var(--primary); color:var(--on-primary); border:none;
            border-radius:10px; font-size:14px; font-weight:700; cursor:pointer; font-family:inherit;
        }
        .dept-tree { max-height:350px; overflow-y:auto; }
        .dept-group { margin-bottom:8px; }
        .dept-header { display:flex; align-items:center; gap:8px; padding:8px 4px; cursor:pointer; font-weight:700; color:var(--on-surface); font-size:14px; background:none; border:none; width:100%; text-align:left; font-family:inherit; }
        .dept-header .material-symbols-outlined { font-size:20px; color:var(--primary); }
        .dept-children { padding-left:32px; }
        .dept-child { display:flex; align-items:center; justify-content:space-between; padding:6px 4px; font-size:14px; color:var(--on-surface); }
        .dept-child-actions { display:flex; gap:4px; }
        .dept-child-btn { padding:4px; border:none; background:transparent; border-radius:4px; cursor:pointer; color:var(--outline); font-size:14px; }
        .dept-child-btn:hover { background:rgba(0,0,0,0.04); }
        .dept-child-btn.delete:hover { color:var(--error); }
        .dept-add-btn {
            width:100%; padding:10px; border:2px dashed rgba(73,234,206,0.4); border-radius:10px; background:transparent;
            color:var(--primary); font-size:14px; font-weight:600; cursor:pointer; display:flex; align-items:center; justify-content:center; gap:6px; margin-top:12px; font-family:inherit;
        }
        .dept-add-btn:hover { background:rgba(73,234,206,0.06); }

        .modal-overlay { display:none; position:fixed; inset:0; background:rgba(0,0,0,0.4); z-index:1000; align-items:center; justify-content:center; backdrop-filter:blur(4px); }
        .modal-overlay.show { display:flex; }
        .modal-card { background:#fff; border-radius:24px; max-width:480px; width:90%; box-shadow:0 20px 60px rgba(0,0,0,0.2); }
        .modal-header { padding:20px 24px; border-bottom:1px solid rgba(0,0,0,0.05); display:flex; justify-content:space-between; align-items:center; }
        .modal-header h3 { font-size:18px; font-weight:700; color:var(--on-surface); }
        .modal-close { width:32px; height:32px; display:flex; align-items:center; justify-content:center; border:none; background:rgba(0,0,0,0.05); border-radius:50%; cursor:pointer; color:var(--on-surface-variant); }
        .modal-body { padding:24px; }
        .modal-field { margin-bottom:16px; }
        .modal-field label { display:block; font-size:13px; font-weight:600; color:var(--on-surface-variant); margin-bottom:6px; }
        .modal-input { width:100%; padding:12px 14px; border:1px solid var(--outline-variant); border-radius:12px; background:#FFF9E6; font-family:inherit; font-size:14px; outline:none; box-sizing:border-box; }
        .modal-input:focus { border-color:var(--primary); box-shadow:0 0 0 2px rgba(73,234,206,0.12); }
        .modal-select { width:100%; padding:12px 14px; border:1px solid var(--outline-variant); border-radius:12px; background:#FFF9E6; font-family:inherit; font-size:14px; outline:none; }
        .modal-footer { padding:16px 24px; border-top:1px solid rgba(0,0,0,0.05); display:flex; justify-content:flex-end; gap:12px; }
        .modal-cancel { padding:12px 24px; border:2px solid var(--outline-variant); background:transparent; border-radius:14px; font-size:14px; font-weight:700; cursor:pointer; color:var(--on-surface-variant); font-family:inherit; }
        .modal-confirm { padding:12px 24px; background:var(--primary); color:var(--on-primary); border:none; border-radius:14px; font-size:14px; font-weight:700; cursor:pointer; font-family:inherit; }

        .toast {
            position:fixed; top:20px; left:50%; transform:translateX(-50%) translateY(-100px); z-index:9999;
            padding:14px 28px; border-radius:14px; font-size:15px; font-weight:700;
            box-shadow:0 8px 24px rgba(0,0,0,0.15); transition:transform 0.3s ease; display:flex; align-items:center; gap:10px;
        }
        .toast.show { transform:translateX(-50%) translateY(0); }
        .toast.success { background:var(--primary); color:var(--on-primary); }
        .toast.error { background:var(--error); color:#fff; }

        @media (max-width:1024px) { .sys-grid { grid-template-columns:1fr; } }
    </style>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="page-header">
        <div>
            <h1 class="page-title">系统管理</h1>
            <p class="page-subtitle">管理系统管理员权限及全局基础数据设置</p>
        </div>
    </div>

    <!-- 管理员账号管理 -->
    <div class="sys-section">
        <h2 class="sys-section-title">管理员账号管理</h2>
        <div class="sys-filter">
            <div class="sys-filter-field">
                <span class="material-symbols-outlined">search</span>
                <asp:TextBox ID="txtAdminSearch" runat="server" CssClass="sys-filter-input" placeholder="搜索 ID/姓名/手机号" />
            </div>
            <asp:DropDownList ID="ddlAdminRole" runat="server" CssClass="sys-filter-select">
                <asp:ListItem Value="0" Text="所有角色" />
                <asp:ListItem Value="1" Text="超级管理员" />
                <asp:ListItem Value="2" Text="宿管" />
                <asp:ListItem Value="3" Text="后勤" />
            </asp:DropDownList>
            <asp:DropDownList ID="ddlAdminStatus" runat="server" CssClass="sys-filter-select">
                <asp:ListItem Value="-1" Text="所有状态" />
                <asp:ListItem Value="1" Text="启用" />
                <asp:ListItem Value="0" Text="禁用" />
            </asp:DropDownList>
            <asp:Button ID="btnAdminSearch" runat="server" CssClass="sys-add-btn" Text="搜索" OnClick="btnAdminSearch_Click" style="margin-left:0;" />
            <button type="button" class="sys-add-btn" onclick="showAdminModal()"><span class="material-symbols-outlined" style="font-size:18px;">person_add</span> 新增管理员</button>
        </div>
        <table class="sys-table">
            <thead><tr><th>工号</th><th>姓名</th><th>手机号</th><th>角色</th><th>状态</th><th style="text-align:right;">操作</th></tr></thead>
            <tbody>
                <asp:Repeater ID="rptAdmins" runat="server" OnItemCommand="rptAdmins_ItemCommand">
                    <ItemTemplate>
                        <tr>
                            <td><%# Eval("AdminNo") %></td>
                            <td><strong><%# Eval("Name") %></strong></td>
                            <td><%# Eval("Phone") %></td>
                            <td><span class="sys-role-badge <%# GetRoleBadgeClass(Eval("Role")) %>"><%# Eval("RoleName") %></span></td>
                            <td><span class="sys-status"><span class="sys-status-dot"></span> <%# Convert.ToInt32(Eval("Status")) == 1 ? "启用" : "禁用" %></span></td>
                            <td style="text-align:right;">
                                <asp:LinkButton ID="btnEdit" runat="server" CommandName="EditAdmin" CommandArgument='<%# Eval("Id") %>' CssClass="sys-action-link edit">编辑</asp:LinkButton>
                                <asp:LinkButton ID="btnReset" runat="server" CommandName="ResetPwd" CommandArgument='<%# Eval("Id") %>' CssClass="sys-action-link reset" OnClientClick="return confirm('确定要重置密码为123456吗？');">重置密码</asp:LinkButton>
                                <asp:LinkButton ID="btnDelete" runat="server" CommandName="DeleteAdmin" CommandArgument='<%# Eval("Id") %>' CssClass="sys-action-link delete" OnClientClick="return confirm('确定要删除该管理员吗？');">删除</asp:LinkButton>
                            </td>
                        </tr>
                    </ItemTemplate>
                </asp:Repeater>
            </tbody>
        </table>
    </div>

    <!-- 基础数据管理 -->
    <h2 class="sys-section-title" style="margin-bottom:16px;">基础数据管理</h2>
    <div class="sys-grid">
        <!-- 楼宇管理 -->
        <div class="sys-card">
            <div class="sys-card-title">楼宇管理</div>
            <asp:Repeater ID="rptBuildings" runat="server" OnItemCommand="rptBuildings_ItemCommand">
                <ItemTemplate>
                    <div class="building-item">
                        <div class="building-left">
                            <div class="building-icon"><span class="material-symbols-outlined">apartment</span></div>
                            <div>
                                <div class="building-name"><%# Eval("Name") %> (<%# Eval("Campus") %>)</div>
                                <div class="building-sub"><%# Eval("FloorCount") %>层 | <%# Eval("RoomCount") %>房间</div>
                            </div>
                        </div>
                        <div class="building-actions">
                            <asp:LinkButton ID="btnEditBuilding" runat="server" CommandName="EditBuilding" CommandArgument='<%# Eval("Id") %>' CssClass="building-action-btn"><span class="material-symbols-outlined">edit</span></asp:LinkButton>
                            <asp:LinkButton ID="btnDeleteBuilding" runat="server" CommandName="DeleteBuilding" CommandArgument='<%# Eval("Id") %>' CssClass="building-action-btn delete" OnClientClick="return confirm('确定要删除该楼宇吗？');"><span class="material-symbols-outlined">delete</span></asp:LinkButton>
                        </div>
                    </div>
                </ItemTemplate>
            </asp:Repeater>
            <button type="button" class="building-add" onclick="showBuildingModal()"><span class="material-symbols-outlined">add</span> 添加新楼宇</button>
        </div>

        <!-- 批量生成房间 -->
        <div class="sys-card">
            <div class="sys-card-title">批量生成房间</div>
            <div class="batch-gen-form">
                <div class="batch-gen-row">
                    <div>
                        <label style="font-size:13px; font-weight:600; color:var(--on-surface-variant); display:block; margin-bottom:6px;">选择楼宇</label>
                        <asp:DropDownList ID="ddlGenBuilding" runat="server" CssClass="batch-gen-input" />
                    </div>
                    <div>
                        <label style="font-size:13px; font-weight:600; color:var(--on-surface-variant); display:block; margin-bottom:6px;">房间类型</label>
                        <asp:DropDownList ID="ddlGenRoomType" runat="server" CssClass="batch-gen-input">
                            <asp:ListItem Value="2" Text="四人间" />
                            <asp:ListItem Value="3" Text="六人间" />
                            <asp:ListItem Value="1" Text="双人间" />
                        </asp:DropDownList>
                    </div>
                </div>
                <div class="batch-gen-row">
                    <div>
                        <label style="font-size:13px; font-weight:600; color:var(--on-surface-variant); display:block; margin-bottom:6px;">起始层数 - 结束层数</label>
                        <div class="batch-gen-row-3">
                            <asp:TextBox ID="txtStartFloor" runat="server" CssClass="batch-gen-input" Text="1" TextMode="Number" />
                            <span>-</span>
                            <asp:TextBox ID="txtEndFloor" runat="server" CssClass="batch-gen-input" Text="6" TextMode="Number" />
                        </div>
                    </div>
                    <div>
                        <label style="font-size:13px; font-weight:600; color:var(--on-surface-variant); display:block; margin-bottom:6px;">每层房间数</label>
                        <asp:TextBox ID="txtRoomsPerFloor" runat="server" CssClass="batch-gen-input" Text="20" TextMode="Number" />
                    </div>
                </div>
                <div class="batch-gen-preview">
                    <div class="batch-gen-preview-label">预览说明:</div>
                    <div class="batch-gen-summary">选择楼宇和参数后，点击"执行批量生成"将自动创建房间和床位</div>
                </div>
                <asp:Button ID="btnBatchGen" runat="server" CssClass="batch-gen-btn" Text="执行批量生成" OnClick="btnBatchGen_Click" OnClientClick="return confirm('确定要批量生成房间吗？');" />
            </div>
        </div>

        <!-- 院系结构 -->
        <div class="sys-card">
            <div class="sys-card-title">院系结构</div>
            <div class="dept-tree">
                <asp:Repeater ID="rptDepts" runat="server" OnItemDataBound="rptDepts_ItemDataBound" OnItemCommand="rptDepts_ItemCommand">
                    <ItemTemplate>
                        <div class="dept-group">
                            <button type="button" class="dept-header" onclick="toggleDept(this)">
                                <span class="material-symbols-outlined">keyboard_arrow_down</span>
                                <span class="material-symbols-outlined">account_balance</span>
                                <%# Eval("CollegeName") %>
                            </button>
                            <div class="dept-children">
                                <asp:Repeater ID="rptMajors" runat="server" OnItemCommand="rptMajors_ItemCommand">
                                    <ItemTemplate>
                                        <div class="dept-child">
                                            <span><%# Eval("MajorName") %></span>
                                            <div class="dept-child-actions">
                                                <asp:LinkButton ID="btnEditMajor" runat="server" CommandName="EditMajor" CommandArgument='<%# Eval("Id") %>' CssClass="dept-child-btn"><span class="material-symbols-outlined" style="font-size:16px;">edit</span></asp:LinkButton>
                                                <asp:LinkButton ID="btnDeleteMajor" runat="server" CommandName="DeleteMajor" CommandArgument='<%# Eval("Id") %>' CssClass="dept-child-btn delete" OnClientClick="return confirm('确定要删除该专业吗？');"><span class="material-symbols-outlined" style="font-size:16px;">delete</span></asp:LinkButton>
                                            </div>
                                        </div>
                                    </ItemTemplate>
                                </asp:Repeater>
                            </div>
                        </div>
                    </ItemTemplate>
                </asp:Repeater>
            </div>
            <button type="button" class="dept-add-btn" onclick="showDeptModal()"><span class="material-symbols-outlined" style="font-size:18px;">add</span> 添加学院/专业</button>
        </div>
    </div>

    <!-- 新增/编辑管理员弹窗 -->
    <asp:Panel ID="pnlAdminModal" runat="server" CssClass="modal-overlay" Style="display:none;">
        <div class="modal-card">
            <div class="modal-header">
                <h3><asp:Literal ID="litAdminModalTitle" runat="server" Text="新增管理员" /></h3>
                <asp:Button ID="btnCloseAdminModal" runat="server" CssClass="modal-close" Text="X" OnClick="btnCloseAdminModal_Click" />
            </div>
            <div class="modal-body">
                <asp:HiddenField ID="hfAdminId" runat="server" />
                <div class="modal-field">
                    <label>工号</label>
                    <asp:TextBox ID="txtAdminNo" runat="server" CssClass="modal-input" placeholder="请输入工号" />
                </div>
                <div class="modal-field">
                    <label>姓名</label>
                    <asp:TextBox ID="txtAdminName" runat="server" CssClass="modal-input" placeholder="请输入姓名" />
                </div>
                <div class="modal-field">
                    <label>手机号</label>
                    <asp:TextBox ID="txtAdminPhone" runat="server" CssClass="modal-input" placeholder="请输入手机号" />
                </div>
                <div class="modal-field">
                    <label>角色</label>
                    <asp:DropDownList ID="ddlAdminRoleModal" runat="server" CssClass="modal-select">
                        <asp:ListItem Value="1" Text="超级管理员" />
                        <asp:ListItem Value="2" Text="宿管" />
                        <asp:ListItem Value="3" Text="后勤" />
                    </asp:DropDownList>
                </div>
                <div class="modal-field">
                    <label>状态</label>
                    <asp:DropDownList ID="ddlAdminStatusModal" runat="server" CssClass="modal-select">
                        <asp:ListItem Value="1" Text="启用" />
                        <asp:ListItem Value="0" Text="禁用" />
                    </asp:DropDownList>
                </div>
            </div>
            <div class="modal-footer">
                <asp:Button ID="btnCancelAdmin" runat="server" CssClass="modal-cancel" Text="取消" OnClick="btnCloseAdminModal_Click" />
                <asp:Button ID="btnSaveAdmin" runat="server" CssClass="modal-confirm" Text="保存" OnClick="btnSaveAdmin_Click" />
            </div>
        </div>
    </asp:Panel>

    <!-- 新增/编辑楼宇弹窗 -->
    <asp:Panel ID="pnlBuildingModal" runat="server" CssClass="modal-overlay" Style="display:none;">
        <div class="modal-card">
            <div class="modal-header">
                <h3><asp:Literal ID="litBuildingModalTitle" runat="server" Text="新增楼宇" /></h3>
                <asp:Button ID="btnCloseBuildingModal" runat="server" CssClass="modal-close" Text="X" OnClick="btnCloseBuildingModal_Click" />
            </div>
            <div class="modal-body">
                <asp:HiddenField ID="hfBuildingId" runat="server" />
                <div class="modal-field">
                    <label>楼宇名称</label>
                    <asp:TextBox ID="txtBuildingName" runat="server" CssClass="modal-input" placeholder="如：A座" />
                </div>
                <div class="modal-field">
                    <label>所属校区</label>
                    <asp:TextBox ID="txtBuildingCampus" runat="server" CssClass="modal-input" placeholder="如：北校区" />
                </div>
                <div class="modal-field">
                    <label>楼层数</label>
                    <asp:TextBox ID="txtBuildingFloors" runat="server" CssClass="modal-input" TextMode="Number" Text="6" />
                </div>
                <div class="modal-field">
                    <label>每层房间数</label>
                    <asp:TextBox ID="txtBuildingRooms" runat="server" CssClass="modal-input" TextMode="Number" Text="20" />
                </div>
            </div>
            <div class="modal-footer">
                <asp:Button ID="btnCancelBuilding" runat="server" CssClass="modal-cancel" Text="取消" OnClick="btnCloseBuildingModal_Click" />
                <asp:Button ID="btnSaveBuilding" runat="server" CssClass="modal-confirm" Text="保存" OnClick="btnSaveBuilding_Click" />
            </div>
        </div>
    </asp:Panel>

    <!-- 新增院系/专业弹窗 -->
    <asp:Panel ID="pnlDeptModal" runat="server" CssClass="modal-overlay" Style="display:none;">
        <div class="modal-card">
            <div class="modal-header">
                <h3>添加院系/专业</h3>
                <asp:Button ID="btnCloseDeptModal" runat="server" CssClass="modal-close" Text="X" OnClick="btnCloseDeptModal_Click" />
            </div>
            <div class="modal-body">
                <div class="modal-field">
                    <label>学院名称</label>
                    <asp:TextBox ID="txtCollegeName" runat="server" CssClass="modal-input" placeholder="请输入学院名称" />
                </div>
                <div class="modal-field">
                    <label>专业名称</label>
                    <asp:TextBox ID="txtMajorName" runat="server" CssClass="modal-input" placeholder="请输入专业名称" />
                </div>
            </div>
            <div class="modal-footer">
                <asp:Button ID="btnCancelDept" runat="server" CssClass="modal-cancel" Text="取消" OnClick="btnCloseDeptModal_Click" />
                <asp:Button ID="btnSaveDept" runat="server" CssClass="modal-confirm" Text="保存" OnClick="btnSaveDept_Click" />
            </div>
        </div>
    </asp:Panel>

    <!-- 编辑专业弹窗 -->
    <asp:Panel ID="pnlEditMajorModal" runat="server" CssClass="modal-overlay" Style="display:none;">
        <div class="modal-card">
            <div class="modal-header">
                <h3>编辑专业</h3>
                <asp:Button ID="btnCloseEditMajorModal" runat="server" CssClass="modal-close" Text="X" OnClick="btnCloseEditMajorModal_Click" />
            </div>
            <div class="modal-body">
                <asp:HiddenField ID="hfEditMajorId" runat="server" />
                <div class="modal-field">
                    <label>专业名称</label>
                    <asp:TextBox ID="txtEditMajorName" runat="server" CssClass="modal-input" />
                </div>
            </div>
            <div class="modal-footer">
                <asp:Button ID="btnCancelEditMajor" runat="server" CssClass="modal-cancel" Text="取消" OnClick="btnCloseEditMajorModal_Click" />
                <asp:Button ID="btnSaveEditMajor" runat="server" CssClass="modal-confirm" Text="保存" OnClick="btnSaveEditMajor_Click" />
            </div>
        </div>
    </asp:Panel>

    <div id="toast" class="toast"></div>

    <script type="text/javascript">
        function showAdminModal() {
            document.getElementById('<%= pnlAdminModal.ClientID %>').style.display = 'flex';
        }
        function hideAdminModal() {
            document.getElementById('<%= pnlAdminModal.ClientID %>').style.display = 'none';
        }
        function showBuildingModal() {
            document.getElementById('<%= pnlBuildingModal.ClientID %>').style.display = 'flex';
        }
        function hideBuildingModal() {
            document.getElementById('<%= pnlBuildingModal.ClientID %>').style.display = 'none';
        }
        function showDeptModal() {
            document.getElementById('<%= pnlDeptModal.ClientID %>').style.display = 'flex';
        }
        function hideDeptModal() {
            document.getElementById('<%= pnlDeptModal.ClientID %>').style.display = 'none';
        }
        function showEditMajorModal() {
            document.getElementById('<%= pnlEditMajorModal.ClientID %>').style.display = 'flex';
        }
        function hideEditMajorModal() {
            document.getElementById('<%= pnlEditMajorModal.ClientID %>').style.display = 'none';
        }
        function toggleDept(el) {
            var children = el.nextElementSibling;
            var icon = el.querySelector('.material-symbols-outlined');
            if (children.style.display === 'none') {
                children.style.display = 'block';
                icon.textContent = 'keyboard_arrow_down';
            } else {
                children.style.display = 'none';
                icon.textContent = 'keyboard_arrow_right';
            }
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
