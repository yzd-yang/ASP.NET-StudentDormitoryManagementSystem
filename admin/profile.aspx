<%@ Page Language="C#" MasterPageFile="~/admin/MasterPage.master" AutoEventWireup="true" CodeFile="profile.aspx.cs" Inherits="admin_profile" ResponseEncoding="utf-8" %>

<asp:Content ID="Content1" ContentPlaceHolderID="title" runat="server">个人中心 - SmartDorm</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="head" runat="server">
    <style>
        .profile-hero {
            background:rgba(255,255,255,0.6); backdrop-filter:blur(12px); border-radius:20px;
            padding:32px; border:1px solid rgba(255,255,255,0.5); margin-bottom:24px; position:relative; overflow:hidden;
        }
        .profile-hero::before {
            content:''; position:absolute; top:-60px; right:-60px; width:200px; height:200px;
            background:rgba(73,234,206,0.12); border-radius:50%; filter:blur(40px);
        }
        .profile-hero-content { display:flex; gap:24px; align-items:center; position:relative; z-index:1; }
        .profile-avatar-wrap { position:relative; flex-shrink:0; }
        .profile-avatar {
            width:100px; height:100px; border-radius:50%; background:linear-gradient(135deg, var(--primary), var(--primary-dark));
            display:flex; align-items:center; justify-content:center; border:4px solid #fff;
            box-shadow:0 4px 16px rgba(0,0,0,0.08); font-size:40px; font-weight:700; color:var(--on-primary);
        }
        .profile-info { flex:1; }
        .profile-name { font-size:28px; font-weight:800; color:var(--on-surface); }
        .profile-role { font-size:14px; color:var(--on-surface-variant); margin-top:4px; }
        .profile-meta { display:flex; gap:20px; margin-top:12px; }
        .profile-meta-item { display:flex; align-items:center; gap:6px; font-size:14px; color:var(--on-surface-variant); }
        .profile-meta-item .material-symbols-outlined { font-size:18px; color:var(--primary); }

        .profile-grid { display:grid; grid-template-columns:1fr 1fr; gap:20px; }
        .profile-card {
            background:rgba(255,255,255,0.6); backdrop-filter:blur(12px); border-radius:20px;
            padding:24px; border:1px solid rgba(255,255,255,0.5);
        }
        .profile-card-header {
            display:flex; align-items:center; gap:10px; padding-bottom:16px;
            border-bottom:1px solid rgba(0,0,0,0.05); margin-bottom:20px;
        }
        .profile-card-header .material-symbols-outlined { color:var(--primary); font-size:24px; }
        .profile-card-title { font-size:18px; font-weight:700; color:var(--on-surface); }
        .profile-field { margin-bottom:16px; }
        .profile-field:last-child { margin-bottom:0; }
        .profile-label { font-size:12px; font-weight:700; color:var(--on-surface-variant); margin-bottom:6px; display:block; text-transform:uppercase; letter-spacing:0.05em; }
        .profile-input {
            width:100%; padding:14px 16px; background:#FFF9E6; border:1px solid transparent;
            border-radius:12px; font-family:inherit; font-size:15px; color:var(--on-surface); outline:none; transition:all 0.2s; box-sizing:border-box;
        }
        .profile-input:focus { border-color:var(--primary); box-shadow:0 0 0 3px rgba(73,234,206,0.12); background:#fff; }
        .profile-input[readonly] { cursor:default; }

        .profile-status-bar {
            background:rgba(255,255,255,0.6); backdrop-filter:blur(12px); border-radius:20px;
            padding:24px; border:1px solid rgba(255,255,255,0.5); border-left:4px solid var(--primary);
            display:flex; align-items:center; justify-content:space-between; margin-bottom:20px;
        }
        .profile-status-left { display:flex; align-items:center; gap:16px; }
        .profile-status-icon {
            width:56px; height:56px; border-radius:50%; background:rgba(73,234,206,0.15);
            display:flex; align-items:center; justify-content:center;
        }
        .profile-status-icon .material-symbols-outlined { color:var(--primary); font-size:28px; }
        .profile-status-title { font-size:18px; font-weight:700; color:var(--on-surface); }
        .profile-status-sub { font-size:14px; color:var(--on-surface-variant); margin-top:2px; }
        .profile-status-badge { display:inline-block; padding:6px 16px; border-radius:20px; font-size:14px; font-weight:700; background:rgba(73,234,206,0.15); color:#006b5c; }

        .profile-save-btn {
            display:flex; align-items:center; gap:8px; padding:14px 28px; background:var(--primary); color:var(--on-primary);
            border:none; border-radius:14px; font-size:15px; font-weight:700; cursor:pointer; box-shadow:0 4px 12px rgba(73,234,206,0.3); font-family:inherit; margin-top:8px;
        }
        .profile-save-btn:hover { box-shadow:0 6px 20px rgba(73,234,206,0.5); }

        .toast { position:fixed; top:20px; left:50%; transform:translateX(-50%) translateY(-100px); z-index:9999; padding:14px 28px; border-radius:14px; font-size:15px; font-weight:700; box-shadow:0 8px 24px rgba(0,0,0,0.15); transition:transform 0.3s ease; display:flex; align-items:center; gap:10px; }
        .toast.show { transform:translateX(-50%) translateY(0); }
        .toast.success { background:var(--primary); color:var(--on-primary); }
        .toast.error { background:var(--error); color:#fff; }

        @media (max-width:768px) { .profile-grid { grid-template-columns:1fr; } .profile-hero-content { flex-direction:column; text-align:center; } }
    </style>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="page-header">
        <div>
            <h1 class="page-title">个人中心</h1>
            <p class="page-subtitle">管理您的个人信息和账号设置</p>
        </div>
    </div>

    <!-- 个人信息卡片 -->
    <div class="profile-hero">
        <div class="profile-hero-content">
            <div class="profile-avatar-wrap">
                <div class="profile-avatar"><asp:Literal ID="litAvatar" runat="server" /></div>
            </div>
            <div class="profile-info">
                <div class="profile-name"><asp:Literal ID="litName" runat="server" /></div>
                <div class="profile-role"><asp:Literal ID="litRole" runat="server" /></div>
                <div class="profile-meta">
                    <div class="profile-meta-item">
                        <span class="material-symbols-outlined">badge</span>
                        <span>工号: <asp:Literal ID="litAdminNo" runat="server" /></span>
                    </div>
                    <div class="profile-meta-item">
                        <span class="material-symbols-outlined">smartphone</span>
                        <span>手机: <asp:Literal ID="litPhone" runat="server" /></span>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- 账号状态 -->
    <div class="profile-status-bar">
        <div class="profile-status-left">
            <div class="profile-status-icon">
                <span class="material-symbols-outlined" style="font-variation-settings:'FILL' 1;">verified_user</span>
            </div>
            <div>
                <div class="profile-status-title">账号状态</div>
                <div class="profile-status-sub">您的账号运行正常，拥有系统管理权限</div>
            </div>
        </div>
        <span class="profile-status-badge">正常运行</span>
    </div>

    <!-- 详细信息 -->
    <div class="profile-grid">
        <!-- 基本信息 -->
        <div class="profile-card">
            <div class="profile-card-header">
                <span class="material-symbols-outlined">person</span>
                <span class="profile-card-title">基本信息</span>
            </div>
            <div class="profile-field">
                <label class="profile-label">姓名</label>
                <asp:TextBox ID="txtName" runat="server" CssClass="profile-input" />
            </div>
            <div class="profile-field">
                <label class="profile-label">工号</label>
                <asp:TextBox ID="txtAdminNo" runat="server" CssClass="profile-input" ReadOnly="true" />
            </div>
            <div class="profile-field">
                <label class="profile-label">手机号</label>
                <asp:TextBox ID="txtPhone" runat="server" CssClass="profile-input" />
            </div>
            <asp:Button ID="btnSaveInfo" runat="server" CssClass="profile-save-btn" Text="保存修改" OnClick="btnSaveInfo_Click" />
        </div>

        <!-- 安全设置 -->
        <div class="profile-card">
            <div class="profile-card-header">
                <span class="material-symbols-outlined">lock</span>
                <span class="profile-card-title">安全设置</span>
            </div>
            <div class="profile-field">
                <label class="profile-label">当前密码</label>
                <asp:TextBox ID="txtCurrentPwd" runat="server" CssClass="profile-input" TextMode="Password" placeholder="请输入当前密码" />
            </div>
            <div class="profile-field">
                <label class="profile-label">新密码</label>
                <asp:TextBox ID="txtNewPwd" runat="server" CssClass="profile-input" TextMode="Password" placeholder="请输入新密码（6-20位）" />
            </div>
            <div class="profile-field">
                <label class="profile-label">确认新密码</label>
                <asp:TextBox ID="txtConfirmPwd" runat="server" CssClass="profile-input" TextMode="Password" placeholder="请再次输入新密码" />
            </div>
            <asp:Button ID="btnChangePwd" runat="server" CssClass="profile-save-btn" Text="修改密码" OnClick="btnChangePwd_Click" />
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
