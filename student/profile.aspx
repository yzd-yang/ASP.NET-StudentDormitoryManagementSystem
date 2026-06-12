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
            width:100px; height:100px; border-radius:50%; background:rgba(255,255,255,0.6);
            display:flex; align-items:center; justify-content:center; border:3px solid #fff;
            box-shadow:0 4px 16px rgba(0,0,0,0.08); overflow:hidden;
        }
        .profile-avatar .material-symbols-outlined { font-size:52px; color:var(--outline-variant); }
        .profile-edit-btn {
            position:absolute; bottom:0; right:0; width:32px; height:32px; border-radius:50%;
            background:var(--primary); color:var(--on-primary); display:flex; align-items:center;
            justify-content:center; border:2px solid #fff; box-shadow:0 2px 8px rgba(0,0,0,0.12); cursor:pointer;
        }
        .profile-edit-btn .material-symbols-outlined { font-size:16px; }
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
            display:flex; align-items:center; gap:10px; padding-bottom:14px;
            border-bottom:1px solid rgba(0,0,0,0.05); margin-bottom:16px;
        }
        .info-card-header .material-symbols-outlined { color:var(--primary); font-size:24px; }
        .info-card-title { font-size:16px; font-weight:700; color:var(--on-surface); }
        .info-field { margin-bottom:14px; }
        .info-field:last-child { margin-bottom:0; }
        .info-label { font-size:12px; font-weight:600; color:var(--on-surface-variant); margin-bottom:6px; display:block; }
        .info-value {
            width:100%; padding:12px 14px; background:#FFF9E6; border:1px solid transparent;
            border-radius:12px; font-size:15px; color:var(--on-surface); outline:none; transition:all 0.2s;
        }
        .info-value:focus { border-color:var(--primary); box-shadow:0 0 0 3px rgba(73,234,206,0.12); background:#fff; }

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
        .status-badge { display:inline-block; padding:4px 14px; border-radius:20px; font-size:13px; font-weight:700; background:rgba(221,231,197,0.6); color:var(--on-surface); }
        .status-bar-value { font-size:18px; font-weight:700; color:var(--primary); margin-top:6px; }

        .footer-links { margin-top:24px; padding-top:16px; border-top:1px solid rgba(0,0,0,0.05); display:flex; justify-content:center; gap:24px; }
        .footer-link { font-size:13px; color:var(--on-surface-variant); text-decoration:none; transition:color 0.2s; }
        .footer-link:hover { color:var(--primary); }
    </style>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <!-- 个人信息 Hero -->
    <div class="profile-hero">
        <div class="profile-hero-content">
            <div class="profile-avatar-wrap">
                <div class="profile-avatar">
                    <span class="material-symbols-outlined">person</span>
                </div>
                <div class="profile-edit-btn"><span class="material-symbols-outlined">edit</span></div>
            </div>
            <div class="profile-info">
                <div style="display:flex; justify-content:space-between; align-items:start; flex-wrap:wrap; gap:12px;">
                    <div>
                        <div class="profile-name">张小明</div>
                        <div class="profile-student-no">学号: 2024****001</div>
                    </div>
                    <button class="profile-edit-btn-lg">
                        <span class="material-symbols-outlined" style="font-size:18px;">edit_square</span>
                        编辑资料
                    </button>
                </div>
                <div class="profile-meta">
                    <div class="profile-meta-item">
                        <span class="material-symbols-outlined">apartment</span>
                        宿舍: <strong>南区1号楼 301</strong>
                    </div>
                    <div class="profile-meta-item">
                        <span class="material-symbols-outlined">smartphone</span>
                        手机: <strong>188****5678</strong>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- 联系信息 -->
    <div class="info-card">
        <div class="info-card-header">
            <span class="material-symbols-outlined">contact_mail</span>
            <span class="info-card-title">联系信息</span>
        </div>
        <div class="info-field">
            <label class="info-label">电子邮箱</label>
            <input class="info-value" type="email" value="zhang.xiaoming@university.edu" readonly />
        </div>
        <div class="info-field">
            <label class="info-label">紧急联系人</label>
            <input class="info-value" type="text" value="张大明 (父亲) - 139****1234" readonly />
        </div>
    </div>

    <!-- 学业信息 -->
    <div class="info-card">
        <div class="info-card-header">
            <span class="material-symbols-outlined">school</span>
            <span class="info-card-title">学业信息</span>
        </div>
        <div class="info-field">
            <label class="info-label">所属学院</label>
            <input class="info-value" type="text" value="计算机科学与技术学院" readonly />
        </div>
        <div class="info-field">
            <label class="info-label">专业名称</label>
            <input class="info-value" type="text" value="软件工程" readonly />
        </div>
    </div>

    <!-- 入住状态 -->
    <div class="status-bar">
        <div class="status-bar-left">
            <div class="status-bar-icon">
                <span class="material-symbols-outlined" data-icon="bed" style="font-variation-settings:'FILL' 1;">bed</span>
            </div>
            <div>
                <div class="status-bar-title">当前入住状态</div>
                <div class="status-bar-sub">2024 秋季学期</div>
            </div>
        </div>
        <div class="status-bar-right">
            <span class="status-badge">已分配</span>
            <div class="status-bar-value">南区1号楼 301</div>
        </div>
    </div>

    <!-- 页脚链接 -->
    <div class="footer-links">
        <a href="#" class="footer-link">隐私政策</a>
        <a href="#" class="footer-link">服务协议</a>
        <a href="#" class="footer-link">联系支持</a>
    </div>
</asp:Content>
