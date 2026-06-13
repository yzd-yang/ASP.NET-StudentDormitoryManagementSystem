<%@ Page Language="C#" MasterPageFile="~/admin/MasterPage.master" AutoEventWireup="true" CodeFile="notice.aspx.cs" Inherits="admin_notice" ResponseEncoding="utf-8" %>

<asp:Content ID="Content1" ContentPlaceHolderID="title" runat="server">通知公告管理 - SmartDorm</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="head" runat="server">
    <style>
        .notice-layout { display:grid; grid-template-columns:380px 1fr; gap:24px; align-items:start; }
        .notice-form-card {
            background:rgba(255,255,255,0.6); backdrop-filter:blur(12px); border-radius:20px;
            padding:24px; border:1px solid rgba(255,255,255,0.5); position:sticky; top:88px;
        }
        .form-section-title { display:flex; align-items:center; gap:10px; margin-bottom:20px; }
        .form-section-icon { padding:8px; background:var(--on-surface); border-radius:10px; color:#fff; display:flex; }
        .form-section-icon .material-symbols-outlined { font-size:20px; }
        .form-section-title h3 { font-size:18px; font-weight:700; color:var(--on-surface); }
        .form-row { display:grid; grid-template-columns:1fr 1fr; gap:12px; }
        .form-group { margin-bottom:16px; }
        .form-group label { display:block; font-size:14px; font-weight:700; color:var(--on-surface); margin-bottom:8px; }
        .form-input, .form-select {
            width:100%; padding:14px 16px; border:none; border-radius:12px; background:#FFF9E6;
            font-family:inherit; font-size:15px; color:var(--on-surface); outline:none; transition:all 0.2s; box-sizing:border-box;
        }
        .form-input:focus, .form-select:focus { background:#fff; border:1px solid var(--primary); box-shadow:0 0 0 3px rgba(73,234,206,0.12); }
        .editor-area {
            width:100%; min-height:180px; border:none; background:transparent; padding:16px;
            font-family:inherit; font-size:15px; color:var(--on-surface); resize:none; outline:none; box-sizing:border-box;
        }
        .toggle-row { display:flex; align-items:center; justify-content:space-between; padding:12px 0; border-top:1px solid rgba(0,0,0,0.05); }
        .toggle-label { font-size:14px; font-weight:600; color:var(--on-surface); }
        .toggle { position:relative; width:48px; height:26px; cursor:pointer; }
        .toggle input { display:none; }
        .toggle-slider { position:absolute; inset:0; background:rgba(0,0,0,0.1); border-radius:13px; transition:0.3s; }
        .toggle-slider::before { content:''; position:absolute; width:20px; height:20px; border-radius:50%; background:#fff; left:3px; top:3px; transition:0.3s; }
        .toggle input:checked + .toggle-slider { background:var(--primary); }
        .toggle input:checked + .toggle-slider::before { transform:translateX(22px); }
        .publish-btn {
            width:100%; padding:16px; background:var(--primary); color:var(--on-primary); border:none;
            border-radius:14px; font-size:16px; font-weight:700; cursor:pointer; display:flex;
            align-items:center; justify-content:center; gap:8px; margin-top:20px; box-shadow:0 4px 16px rgba(73,234,206,0.3); font-family:inherit;
        }
        .notice-list-card {
            background:rgba(255,255,255,0.6); backdrop-filter:blur(12px); border-radius:20px;
            border:1px solid rgba(255,255,255,0.5); overflow:hidden;
        }
        .notice-list-header { display:flex; justify-content:space-between; align-items:center; padding:20px 24px; border-bottom:1px solid rgba(0,0,0,0.05); }
        .notice-list-title { display:flex; align-items:center; gap:10px; font-size:18px; font-weight:700; color:var(--on-surface); }
        .tab-group-sm { display:flex; background:rgba(0,0,0,0.05); border-radius:10px; padding:3px; }
        .tab-btn-sm { padding:6px 16px; border:none; border-radius:8px; font-size:13px; font-weight:700; cursor:pointer; background:transparent; color:var(--on-surface-variant); font-family:inherit; }
        .tab-btn-sm.active { background:var(--on-surface); color:#fff; }
        .notice-table { width:100%; border-collapse:collapse; }
        .notice-table th { padding:14px 24px; text-align:left; font-size:13px; font-weight:700; color:var(--on-surface-variant); background:rgba(0,0,0,0.03); border-bottom:1px solid rgba(0,0,0,0.05); }
        .notice-table td { padding:16px 24px; font-size:14px; color:var(--on-surface); border-bottom:1px solid rgba(0,0,0,0.03); }
        .notice-table tr:hover td { background:rgba(73,234,206,0.04); }
        .notice-title-cell { display:flex; align-items:center; gap:10px; font-weight:700; }
        .notice-scope { font-size:14px; font-weight:700; }
        .notice-category { font-size:10px; text-transform:uppercase; letter-spacing:0.1em; color:var(--on-surface-variant); font-weight:700; }
        .notice-time { font-size:13px; color:var(--on-surface-variant); }
        .notice-status { display:inline-flex; align-items:center; gap:4px; padding:4px 12px; border-radius:20px; font-size:11px; font-weight:700; }
        .notice-status.published { background:rgba(73,234,206,0.15); color:#006b5c; }
        .notice-status.withdrawn { background:rgba(0,0,0,0.05); color:rgba(0,0,0,0.35); }
        .notice-status.draft { background:rgba(255,183,77,0.15); color:#e67e00; }
        .notice-status-dot { width:6px; height:6px; border-radius:50%; display:inline-block; }
        .notice-status.published .notice-status-dot { background:#006b5c; }
        .notice-status.withdrawn .notice-status-dot { background:rgba(0,0,0,0.3); }
        .notice-status.draft .notice-status-dot { background:#e67e00; }
        .notice-actions { display:flex; gap:4px; }
        .notice-action-btn { padding:8px; border:none; background:transparent; border-radius:8px; cursor:pointer; color:var(--on-surface-variant); font-family:inherit; }
        .notice-action-btn:hover { background:rgba(0,0,0,0.04); }
        .notice-action-btn.delete:hover { background:rgba(186,26,26,0.08); color:var(--error); }
        .notice-action-btn .material-symbols-outlined { font-size:18px; }
        .pagination { display:flex; justify-content:space-between; align-items:center; padding:16px 24px; border-top:1px solid rgba(0,0,0,0.05); }
        .pagination-info { font-size:12px; color:var(--on-surface-variant); font-weight:600; }
        .pagination-btns { display:flex; gap:6px; align-items:center; }
        .pagination-btn { width:36px; height:36px; display:flex; align-items:center; justify-content:center; border:none; border-radius:10px; cursor:pointer; font-size:13px; font-weight:700; background:transparent; color:var(--on-surface-variant); font-family:inherit; }
        .pagination-btn.active { background:var(--on-surface); color:#fff; }
        .pagination-btn:hover:not(.active) { background:rgba(0,0,0,0.04); }
        .empty-msg { text-align:center; padding:40px; color:var(--on-surface-variant); }
        .empty-msg .material-symbols-outlined { font-size:48px; opacity:0.3; display:block; margin-bottom:8px; }
        .toast { position:fixed; top:20px; left:50%; transform:translateX(-50%) translateY(-100px); z-index:9999; padding:14px 28px; border-radius:14px; font-size:15px; font-weight:700; box-shadow:0 8px 24px rgba(0,0,0,0.15); transition:transform 0.3s ease; display:flex; align-items:center; gap:10px; }
        .toast.show { transform:translateX(-50%) translateY(0); }
        .toast.success { background:var(--primary); color:var(--on-primary); }
        .toast.error { background:var(--error); color:#fff; }
        @media (max-width: 1024px) { .notice-layout { grid-template-columns:1fr; } }
    </style>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="page-header">
        <div>
            <h1 class="page-title">通知公告管理</h1>
            <p class="page-subtitle">管理并向学生推送最新的宿舍动态、安全提醒及规章制度。</p>
        </div>
    </div>

    <div class="notice-layout">
        <!-- 发布新公告 -->
        <div class="notice-form-card">
            <div class="form-section-title">
                <div class="form-section-icon"><span class="material-symbols-outlined" style="font-variation-settings:'FILL' 1;">edit_square</span></div>
                <h3 id="formTitle" runat="server">发布新公告</h3>
            </div>
            <asp:HiddenField ID="hfNoticeId" runat="server" />
            <div class="form-group">
                <label>公告标题</label>
                <asp:TextBox ID="txtTitle" runat="server" CssClass="form-input" placeholder="输入简洁明了的标题" />
            </div>
            <div class="form-row">
                <div class="form-group">
                    <label>发送范围</label>
                    <asp:DropDownList ID="ddlScope" runat="server" CssClass="form-select">
                        <asp:ListItem Value="0" Text="全体住户" />
                    </asp:DropDownList>
                </div>
                <div class="form-group">
                    <label>公告类别</label>
                    <asp:DropDownList ID="ddlCategory" runat="server" CssClass="form-select">
                        <asp:ListItem Value="1" Text="行政通知" />
                        <asp:ListItem Value="2" Text="安全警示" />
                        <asp:ListItem Value="3" Text="生活服务" />
                        <asp:ListItem Value="4" Text="活动资讯" />
                    </asp:DropDownList>
                </div>
            </div>
            <div class="form-group">
                <label>公告内容</label>
                <div style="border-radius:12px; overflow:hidden; border:1px solid rgba(0,0,0,0.08);">
                    <div style="background:#FFF9E6;">
                        <asp:TextBox ID="txtContent" runat="server" CssClass="editor-area" TextMode="MultiLine" placeholder="在此输入公告正文内容..." />
                    </div>
                </div>
            </div>
            <div class="toggle-row">
                <span class="toggle-label">是否置顶</span>
                <label class="toggle"><asp:CheckBox ID="chkIsTop" runat="server" /><span class="toggle-slider"></span></label>
            </div>
            <div class="toggle-row">
                <span class="toggle-label">立即发送</span>
                <label class="toggle"><asp:CheckBox ID="chkSendNow" runat="server" Checked="true" /><span class="toggle-slider"></span></label>
            </div>
            <asp:Button ID="btnPublish" runat="server" CssClass="publish-btn" OnClick="btnPublish_Click" />
            <asp:Button ID="btnCancelEdit" runat="server" Text="取消编辑" CssClass="publish-btn" style="background:transparent; color:var(--on-surface-variant); border:1px solid var(--outline-variant); box-shadow:none; display:none;" OnClick="btnCancelEdit_Click" />
        </div>

        <!-- 已发公告列表 -->
        <div class="notice-list-card">
            <div class="notice-list-header">
                <div class="notice-list-title"><span class="material-symbols-outlined" style="color:var(--on-surface-variant);">list_alt</span> 已发公告列表</div>
                <div class="tab-group-sm">
                    <asp:Button ID="btnTabAll" runat="server" CssClass="tab-btn-sm active" Text="全部" OnClick="btnTabAll_Click" />
                    <asp:Button ID="btnTabPublished" runat="server" CssClass="tab-btn-sm" Text="已发布" OnClick="btnTabPublished_Click" />
                    <asp:Button ID="btnTabDraft" runat="server" CssClass="tab-btn-sm" Text="草稿" OnClick="btnTabDraft_Click" />
                </div>
            </div>
            <asp:Repeater ID="rptNotices" runat="server" OnItemCommand="rptNotices_ItemCommand">
                <HeaderTemplate>
                    <table class="notice-table"><thead><tr><th>标题</th><th>范围 & 类别</th><th>发布时间</th><th>状态</th><th style="text-align:right;">操作</th></tr></thead><tbody>
                </HeaderTemplate>
                <ItemTemplate>
                    <tr>
                        <td>
                            <div class="notice-title-cell">
                                <%# Convert.ToInt32(Eval("IsTop")) == 1 ? "<span class='material-symbols-outlined' style='color:#f59e0b; font-size:20px; font-variation-settings:\"FILL\" 1;'>keep</span>" : "" %>
                                <%# Eval("Title") %>
                            </div>
                        </td>
                        <td>
                            <div class="notice-scope"><%# GetScopeText(Eval("Id")) %></div>
                            <div class="notice-category"><%# GetCategoryText(Eval("Category")) %></div>
                        </td>
                        <td>
                            <span class="notice-time"><%# Eval("PublishTime") != DBNull.Value ? Convert.ToDateTime(Eval("PublishTime")).ToString("yyyy-MM-dd HH:mm") : "未发布" %></span>
                        </td>
                        <td>
                            <span class="notice-status <%# GetStatusClass(Eval("Status")) %>">
                                <span class="notice-status-dot"></span> <%# GetStatusText(Eval("Status")) %>
                            </span>
                        </td>
                        <td>
                            <div class="notice-actions" style="justify-content:flex-end;">
                                <asp:LinkButton ID="btnEdit" runat="server" CommandName="EditNotice" CommandArgument='<%# Eval("Id") %>' CssClass="notice-action-btn" title="编辑"><span class="material-symbols-outlined">edit</span></asp:LinkButton>
                                <asp:LinkButton ID="btnWithdraw" runat="server" CommandName="WithdrawNotice" CommandArgument='<%# Eval("Id") %>' CssClass="notice-action-btn" title="撤回" Visible='<%# Convert.ToInt32(Eval("Status")) == 1 %>'><span class="material-symbols-outlined">undo</span></asp:LinkButton>
                                <asp:LinkButton ID="btnPublish" runat="server" CommandName="PublishNotice" CommandArgument='<%# Eval("Id") %>' CssClass="notice-action-btn" title="发布" Visible='<%# Convert.ToInt32(Eval("Status")) != 1 %>'><span class="material-symbols-outlined">send</span></asp:LinkButton>
                                <asp:LinkButton ID="btnDelete" runat="server" CommandName="DeleteNotice" CommandArgument='<%# Eval("Id") %>' CssClass="notice-action-btn delete" title="删除" OnClientClick="return confirm('确定要删除该公告吗？');"><span class="material-symbols-outlined">delete</span></asp:LinkButton>
                            </div>
                        </td>
                    </tr>
                </ItemTemplate>
                <FooterTemplate></tbody></table></FooterTemplate>
            </asp:Repeater>
            <asp:Panel ID="pnlEmpty" runat="server" Visible="false">
                <div class="empty-msg"><span class="material-symbols-outlined">campaign</span><p>暂无公告</p></div>
            </asp:Panel>
            <div class="pagination">
                <span class="pagination-info"><asp:Literal ID="litPageInfo" runat="server" /></span>
                <div class="pagination-btns">
                    <asp:Button ID="btnPrev" runat="server" CssClass="pagination-btn" Text="<" OnClick="btnPrev_Click" />
                    <asp:Literal ID="litPageBtns" runat="server" />
                    <asp:Button ID="btnNext" runat="server" CssClass="pagination-btn" Text=">" OnClick="btnNext_Click" />
                </div>
            </div>
        </div>
    </div>

    <div id="toast" class="toast"></div>

    <script type="text/javascript">
        function showToast(msg, type) {
            var toast = document.getElementById('toast');
            toast.className = 'toast ' + type;
            toast.innerHTML = '<span class="material-symbols-outlined">' + (type === 'success' ? 'check_circle' : 'error') + '</span>' + msg;
            toast.classList.add('show');
            setTimeout(function() { toast.classList.remove('show'); }, 3000);
        }
    </script>
</asp:Content>
