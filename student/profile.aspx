<%@ Page Language="C#" MasterPageFile="~/student/MasterPage.master" AutoEventWireup="true" CodeFile="profile.aspx.cs" Inherits="student_profile" ResponseEncoding="utf-8" %>

<asp:Content ID="Content1" ContentPlaceHolderID="title" runat="server">个人中心 - 智慧宿舍</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="head" runat="server">
    <style>
        .profile-hero {
            background:rgba(255,255,255,0.6); backdrop-filter:blur(12px); border-radius:20px;
            padding:24px; border:1px solid rgba(255,255,255,0.5); margin-bottom:24px; position:relative; overflow:hidden;
        }
        .profile-hero::before {
            content:''; position:absolute; top:-60px; right:-60px; width:180px; height:180px;
            background:rgba(73,234,206,0.12); border-radius:50%; filter:blur(40px);
        }
        .profile-hero-content { display:flex; gap:20px; align-items:start; position:relative; z-index:1; }
        .profile-avatar-wrap { position:relative; flex-shrink:0; }
        .profile-avatar {
            width:100px; height:100px; border-radius:50%; background:linear-gradient(135deg, var(--primary), var(--primary-dark));
            display:flex; align-items:center; justify-content:center; border:3px solid #fff;
            box-shadow:0 4px 16px rgba(0,0,0,0.08); color:var(--on-primary); font-size:36px; font-weight:800;
        }
        .profile-info { flex:1; }
        .profile-name { font-size:24px; font-weight:800; color:var(--on-surface); }
        .profile-student-no { font-size:14px; color:var(--on-surface-variant); margin-top:2px; }
        .profile-meta { display:grid; grid-template-columns:1fr 1fr; gap:10px; margin-top:16px; }
        .profile-meta-item { display:flex; align-items:center; gap:8px; font-size:14px; color:var(--on-surface-variant); }
        .profile-meta-item .material-symbols-outlined { color:var(--primary); font-size:20px; }
        .profile-meta-item strong { color:var(--on-surface); font-weight:700; }

        .profile-edit-btn-lg {
            display:inline-flex; align-items:center; gap:6px; padding:10px 20px;
            background:var(--primary); color:var(--on-primary); border:none; border-radius:12px;
            font-size:14px; font-weight:700; cursor:pointer; box-shadow:0 2px 8px rgba(73,234,206,0.3); transition:all 0.2s; font-family:inherit;
        }
        .profile-edit-btn-lg:hover { box-shadow:0 4px 16px rgba(73,234,206,0.5); }

        .info-card {
            background:rgba(255,255,255,0.6); backdrop-filter:blur(12px); border-radius:20px;
            padding:20px; border:1px solid rgba(255,255,255,0.5); margin-bottom:16px;
        }
        .info-card-header {
            display:flex; align-items:center; justify-content:space-between; gap:10px; padding-bottom:14px;
            border-bottom:1px solid rgba(0,0,0,0.05); margin-bottom:16px;
        }
        .info-card-header-left { display:flex; align-items:center; gap:10px; }
        .info-card-header .material-symbols-outlined { color:var(--primary); font-size:24px; }
        .info-card-title { font-size:16px; font-weight:700; color:var(--on-surface); }
        .info-field { margin-bottom:14px; }
        .info-field:last-child { margin-bottom:0; }
        .info-label { font-size:12px; font-weight:600; color:var(--on-surface-variant); margin-bottom:6px; display:block; }
        .info-value {
            width:100%; padding:12px 14px; background:#FFF9E6; border:1px solid transparent;
            border-radius:12px; font-size:15px; color:var(--on-surface); outline:none; transition:all 0.2s;
            font-family:inherit;
        }
        .info-value:focus { border-color:var(--primary); box-shadow:0 0 0 3px rgba(73,234,206,0.12); background:#fff; }
        .info-value[readonly] { background:rgba(255,249,230,0.5); cursor:default; }
        .info-value[readonly]:focus { border-color:transparent; box-shadow:none; background:rgba(255,249,230,0.5); }
        select.info-value { cursor:pointer; appearance:auto; }
        select.info-value:disabled { background:rgba(255,249,230,0.5); cursor:default; opacity:1; }

        .edit-actions { display:none; gap:10px; margin-top:16px; justify-content:flex-end; }
        .edit-actions.show { display:flex; }
        .btn-save {
            padding:10px 24px; background:var(--primary); color:var(--on-primary); border:none; border-radius:12px;
            font-size:14px; font-weight:700; cursor:pointer; font-family:inherit; transition:all 0.2s;
        }
        .btn-save:hover { box-shadow:0 4px 16px rgba(73,234,206,0.5); }
        .btn-cancel {
            padding:10px 24px; background:transparent; color:var(--on-surface-variant); border:1px solid var(--outline-variant);
            border-radius:12px; font-size:14px; font-weight:700; cursor:pointer; font-family:inherit; transition:all 0.2s;
        }
        .btn-cancel:hover { background:rgba(0,0,0,0.04); }

        .status-bar {
            background:rgba(255,255,255,0.6); backdrop-filter:blur(12px); border-radius:20px;
            padding:20px; border:1px solid rgba(255,255,255,0.5); border-left:4px solid var(--primary);
            display:flex; align-items:center; justify-content:space-between; margin-bottom:16px;
        }
        .status-bar-left { display:flex; align-items:center; gap:16px; }
        .status-bar-icon {
            width:56px; height:56px; border-radius:50%; background:rgba(73,234,206,0.15);
            display:flex; align-items:center; justify-content:center;
        }
        .status-bar-icon .material-symbols-outlined { color:var(--primary); font-size:28px; }
        .status-bar-title { font-size:16px; font-weight:700; color:var(--on-surface); }
        .status-bar-sub { font-size:14px; color:var(--on-surface-variant); margin-top:2px; }
        .status-bar-right { text-align:right; }
        .status-badge { display:inline-block; padding:4px 14px; border-radius:20px; font-size:13px; font-weight:700; }
        .status-badge.allocated { background:rgba(73,234,206,0.15); color:#006b5c; }
        .status-badge.unallocated { background:rgba(251,192,45,0.15); color:#b58900; }
        .status-bar-value { font-size:18px; font-weight:700; color:var(--primary); margin-top:6px; }

        .toast-msg {
            position:fixed; top:20px; left:50%; transform:translateX(-50%) translateY(-100px);
            padding:12px 24px; border-radius:12px; font-size:14px; font-weight:600; z-index:9999;
            transition:transform 0.3s ease; box-shadow:0 4px 12px rgba(0,0,0,0.15);
        }
        .toast-msg.show { transform:translateX(-50%) translateY(0); }
        .toast-msg.success { background:var(--primary); color:var(--on-primary); }
        .toast-msg.error { background:var(--error); color:#fff; }
    </style>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <asp:ScriptManager ID="ScriptManager1" runat="server" />

    <div class="profile-hero">
        <div class="profile-hero-content">
            <div class="profile-avatar-wrap">
                <div class="profile-avatar"><asp:Literal ID="litAvatar" runat="server" /></div>
            </div>
            <div class="profile-info">
                <div style="display:flex; justify-content:space-between; align-items:start; flex-wrap:wrap; gap:12px;">
                    <div>
                        <div class="profile-name"><asp:Literal ID="litName" runat="server" /></div>
                        <div class="profile-student-no">学号: <asp:Literal ID="litStudentNo" runat="server" /></div>
                    </div>
                </div>
                <div class="profile-meta">
                    <div class="profile-meta-item">
                        <span class="material-symbols-outlined">apartment</span>
                        宿舍: <strong><asp:Literal ID="litDorm" runat="server" /></strong>
                    </div>
                    <div class="profile-meta-item">
                        <span class="material-symbols-outlined">smartphone</span>
                        手机: <strong><asp:Literal ID="litPhone" runat="server" /></strong>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <asp:UpdatePanel ID="upProfile" runat="server">
        <ContentTemplate>
            <asp:HiddenField ID="hfEditing" runat="server" Value="0" />
            <div class="info-card">
                <div class="info-card-header">
                    <div class="info-card-header-left">
                        <span class="material-symbols-outlined">badge</span>
                        <span class="info-card-title">个人信息</span>
                    </div>
                    <button type="button" class="profile-edit-btn-lg" onclick="enterEdit()">
                        <span class="material-symbols-outlined" style="font-size:18px;">edit_square</span>
                        编辑资料
                    </button>
                </div>
                <div class="info-field">
                    <label class="info-label">电子邮箱</label>
                    <asp:TextBox ID="txtEmail" runat="server" CssClass="info-value" />
                </div>
                <div class="info-field">
                    <label class="info-label">紧急联系人</label>
                    <asp:TextBox ID="txtEmergencyContact" runat="server" CssClass="info-value" placeholder="姓名 (关系)" />
                </div>
                <div class="info-field">
                    <label class="info-label">紧急联系人电话</label>
                    <asp:TextBox ID="txtEmergencyPhone" runat="server" CssClass="info-value" placeholder="11位手机号" />
                </div>
                <div class="info-field">
                    <label class="info-label">所属学院</label>
                    <asp:DropDownList ID="ddlCollege" runat="server" CssClass="info-value" AutoPostBack="true" OnSelectedIndexChanged="ddlCollege_Changed" />
                </div>
                <div class="info-field">
                    <label class="info-label">专业名称</label>
                    <asp:DropDownList ID="ddlMajor" runat="server" CssClass="info-value" />
                </div>
                <div class="info-field">
                    <label class="info-label">年级</label>
                    <asp:DropDownList ID="ddlGrade" runat="server" CssClass="info-value" />
                </div>
                <div class="info-field">
                    <label class="info-label">班级（选填）</label>
                    <asp:TextBox ID="txtClassName" runat="server" CssClass="info-value" placeholder="例如：计科2301" />
                </div>
                <div id="editActions" class="edit-actions">
                    <asp:Button ID="btnCancel" runat="server" Text="取消" CssClass="btn-cancel" OnClick="btnCancel_Click" CausesValidation="false" />
                    <asp:Button ID="btnSave" runat="server" Text="保存" CssClass="btn-save" OnClick="btnSave_Click" />
                </div>
            </div>

            <div class="status-bar">
                <div class="status-bar-left">
                    <div class="status-bar-icon">
                        <span class="material-symbols-outlined" style="font-variation-settings:'FILL' 1;">bed</span>
                    </div>
                    <div>
                        <div class="status-bar-title">当前入住状态</div>
                        <div class="status-bar-sub"><asp:Literal ID="litSemester" runat="server" /></div>
                    </div>
                </div>
                <div class="status-bar-right">
                    <span class="status-badge" id="spanStatus" runat="server"><asp:Literal ID="litStatus" runat="server" /></span>
                    <div class="status-bar-value"><asp:Literal ID="litStatusDorm" runat="server" /></div>
                </div>
            </div>

            <div id="toastMsg" class="toast-msg"></div>
        </ContentTemplate>
    </asp:UpdatePanel>

    <script type="text/javascript">
        function setReadonlyState() {
            var fields = document.querySelectorAll('#<%= upProfile.ClientID %> input.info-value');
            for (var i = 0; i < fields.length; i++) {
                fields[i].setAttribute('readonly', 'readonly');
                fields[i].style.background = '';
            }
            var selects = document.querySelectorAll('#<%= upProfile.ClientID %> select.info-value');
            for (var i = 0; i < selects.length; i++) {
                selects[i].disabled = true;
            }
        }

        function enterEdit() {
            var fields = document.querySelectorAll('#<%= upProfile.ClientID %> input.info-value');
            for (var i = 0; i < fields.length; i++) {
                fields[i].removeAttribute('readonly');
                fields[i].style.background = '#fff';
            }
            var selects = document.querySelectorAll('#<%= upProfile.ClientID %> select.info-value');
            for (var i = 0; i < selects.length; i++) {
                selects[i].disabled = false;
            }
            document.getElementById('editActions').classList.add('show');
            document.getElementById('<%= hfEditing.ClientID %>').value = '1';
        }

        function exitEdit() {
            setReadonlyState();
            document.getElementById('editActions').classList.remove('show');
            document.getElementById('<%= hfEditing.ClientID %>').value = '0';
        }

        function restoreEdit() {
            if (document.getElementById('<%= hfEditing.ClientID %>').value === '1') {
                enterEdit();
            } else {
                setReadonlyState();
            }
        }

        function showToast(msg, type) {
            var el = document.getElementById('toastMsg');
            el.textContent = msg;
            el.className = 'toast-msg ' + type + ' show';
            setTimeout(function () { el.classList.remove('show'); }, 2500);
        }

        setReadonlyState();
        Sys.WebForms.PageRequestManager.getInstance().add_endRequest(function () {
            restoreEdit();
        });
    </script>
</asp:Content>
