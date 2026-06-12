<%@ Page Language="C#" MasterPageFile="~/student/MasterPage.master" AutoEventWireup="true" CodeFile="home.aspx.cs" Inherits="student_home" ResponseEncoding="utf-8" %>

<asp:Content ID="Content1" ContentPlaceHolderID="title" runat="server">我的宿舍 - 智慧宿舍</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="head" runat="server">
    <link href="/css/student.css" rel="stylesheet" />
    <style>
        .dorm-hero {
            position:relative; border-radius:24px; overflow:hidden; height:280px; margin-bottom:32px;
            display:flex; flex-direction:column; justify-content:flex-end; padding:32px;
            background:linear-gradient(135deg, #006b5c 0%, #49EACE 100%); color:#fff;
        }
        .dorm-hero::before { content:''; position:absolute; inset:0; background:linear-gradient(to top, rgba(0,0,0,0.6) 0%, transparent 60%); }
        .dorm-hero-content { position:relative; z-index:1; display:flex; justify-content:space-between; align-items:end; flex-wrap:wrap; gap:16px; }
        .dorm-hero h1 { font-size:32px; font-weight:800; margin-bottom:8px; letter-spacing:-0.02em; }
        .dorm-hero-meta { display:flex; gap:24px; opacity:0.9; font-size:18px; }
        .dorm-hero-meta span { display:flex; align-items:center; gap:8px; }
        .dorm-hero-btn {
            background:rgba(255,255,255,0.15); backdrop-filter:blur(8px); color:#fff;
            padding:10px 20px; border-radius:12px; font-size:14px; font-weight:600;
            border:1px solid rgba(255,255,255,0.2); cursor:pointer; display:flex;
            align-items:center; gap:6px; font-family:inherit; transition:all 0.2s;
        }
        .dorm-hero-btn:hover { background:rgba(255,255,255,0.25); }

        .glass-card {
            background:rgba(255,255,255,0.7); backdrop-filter:blur(12px);
            border:1px solid rgba(255,255,255,0.4); border-radius:24px;
            padding:24px; box-shadow:0 2px 12px rgba(0,0,0,0.04);
        }
        .glass-card:hover { box-shadow:0 8px 24px rgba(73,234,206,0.1); }

        .score-card { background:linear-gradient(135deg, rgba(73,234,206,0.15) 0%, rgba(255,255,255,0.4) 100%); }
        .score-card-header { display:flex; justify-content:space-between; align-items:start; margin-bottom:16px; }
        .score-card-title { font-size:18px; font-weight:700; color:var(--on-surface); }
        .score-card-sub { font-size:13px; color:var(--on-surface-variant); margin-top:2px; }
        .score-value { font-size:56px; font-weight:800; color:var(--on-surface); line-height:1; }
        .score-tag { display:inline-block; padding:4px 14px; border-radius:20px; font-size:14px; font-weight:700; background:rgba(73,234,206,0.2); color:#006b5c; }

        .roommate-section { margin-top:0; }
        .roommate-section-title { font-size:18px; font-weight:700; color:var(--on-surface); margin-bottom:20px; display:flex; align-items:center; gap:10px; }
        .roommate-grid { display:grid; grid-template-columns:1fr 1fr; gap:16px; }
        .roommate-item {
            display:flex; align-items:center; gap:16px; padding:16px;
            background:rgba(255,255,255,0.5); border-radius:20px;
            border:1px solid rgba(255,255,255,0.4); transition:all 0.2s; cursor:pointer;
        }
        .roommate-item:hover { border-color:var(--primary); background:rgba(255,255,255,0.7); transform:translateY(-2px); }
        .roommate-item.self { border:2px solid var(--primary); background:rgba(73,234,206,0.05); }
        .roommate-avatar { width:56px; height:56px; border-radius:50%; background:linear-gradient(135deg, var(--primary), var(--primary-dark)); display:flex; align-items:center; justify-content:center; color:var(--on-primary); font-weight:700; font-size:20px; flex-shrink:0; box-shadow:0 2px 8px rgba(73,234,206,0.2); }
        .roommate-name { font-size:16px; font-weight:700; color:var(--on-surface); }
        .roommate-detail { font-size:14px; color:var(--on-surface-variant); margin-top:2px; }
        .roommate-badge { font-size:10px; padding:2px 8px; border-radius:10px; background:var(--primary); color:var(--on-primary); font-weight:700; }

        .facility-header { display:flex; justify-content:space-between; align-items:center; margin-bottom:20px; }
        .facility-title { font-size:18px; font-weight:700; color:var(--on-surface); display:flex; align-items:center; gap:10px; }
        .facility-sync { font-size:12px; color:var(--on-surface-variant); }
        .facility-grid { display:flex; flex-direction:column; gap:12px; }
        .facility-item {
            display:flex; align-items:center; justify-content:space-between;
            padding:16px; background:rgba(255,255,255,0.5); border-radius:16px;
            border:1px solid rgba(255,255,255,0.4); transition:all 0.2s;
        }
        .facility-item:hover { box-shadow:0 2px 8px rgba(0,0,0,0.04); border-color:var(--primary); }
        .facility-item.error { border-color:rgba(186,26,26,0.15); background:rgba(186,26,26,0.03); }
        .facility-left { display:flex; align-items:center; gap:12px; }
        .facility-icon { width:40px; height:40px; border-radius:12px; display:flex; align-items:center; justify-content:center; }
        .facility-icon.green { background:rgba(73,234,206,0.12); color:var(--primary); }
        .facility-icon.red { background:rgba(186,26,26,0.08); color:var(--error); }
        .facility-name { font-size:14px; font-weight:600; color:var(--on-surface); }
        .facility-status { font-size:12px; font-weight:600; padding:4px 12px; border-radius:20px; }
        .facility-status.ok { background:rgba(73,234,206,0.12); color:#006b5c; }
        .facility-status.error { background:rgba(186,26,26,0.08); color:var(--error); }

        .quick-tools { display:grid; grid-template-columns:1fr 1fr; gap:12px; margin-top:0; }
        .quick-tool {
            display:flex; flex-direction:column; align-items:center; gap:10px;
            padding:20px; background:rgba(255,255,255,0.6); border-radius:16px;
            border:1px solid rgba(255,255,255,0.4); cursor:pointer; transition:all 0.2s; text-decoration:none;
        }
        .quick-tool:hover { background:rgba(73,234,206,0.08); border-color:var(--primary); transform:translateY(-2px); }
        .quick-tool-icon { font-size:28px; color:var(--primary); }
        .quick-tool-label { font-size:13px; font-weight:600; color:var(--on-surface-variant); }

        .report-btn {
            width:100%; padding:16px; background:var(--primary); color:var(--on-primary);
            border:none; border-radius:16px; font-size:15px; font-weight:700; cursor:pointer;
            display:flex; align-items:center; justify-content:center; gap:8px;
            margin-top:16px; box-shadow:0 4px 16px rgba(73,234,206,0.3); transition:all 0.2s; font-family:inherit;
        }
        .report-btn:hover { box-shadow:0 6px 24px rgba(73,234,206,0.5); }

        .section-title { font-size:18px; font-weight:700; color:var(--on-surface); margin-bottom:16px; display:flex; align-items:center; gap:8px; }

        @media (max-width:768px) {
            .dorm-hero { height:auto; min-height:200px; }
            .dorm-hero h1 { font-size:24px; }
            .dorm-hero-meta { font-size:15px; gap:16px; flex-wrap:wrap; }
            .dorm-hero-content { flex-direction:column; align-items:start; }
            .roommate-grid { grid-template-columns:1fr; }
        }
    </style>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <!-- Hero Section -->
    <div class="dorm-hero">
        <div class="dorm-hero-content">
            <div>
                <h1>北校区 3号楼</h1>
                <div class="dorm-hero-meta">
                    <span><span class="material-symbols-outlined" style="font-size:24px">meeting_room</span> 502-A 室</span>
                    <span><span class="material-symbols-outlined" style="font-size:24px">bed</span> 02号床位</span>
                </div>
            </div>
            <a href="profile.aspx" class="dorm-hero-btn">
                <span class="material-symbols-outlined" style="font-size:20px;">edit</span>
                修改个人资料
            </a>
        </div>
    </div>

    <!-- 两栏布局 -->
    <div style="display:grid; grid-template-columns:1fr 380px; gap:24px; align-items:start;">
        <!-- 左栏 -->
        <div style="display:flex; flex-direction:column; gap:24px;">
            <!-- 评分和缴费 -->
            <div style="display:grid; grid-template-columns:1fr 1fr; gap:20px;">
                <div class="glass-card score-card">
                    <div class="score-card-header">
                        <div>
                            <div class="score-card-title">宿舍评分</div>
                            <div class="score-card-sub">基于本月卫生与安全周检</div>
                        </div>
                        <span class="material-symbols-outlined" style="color:var(--primary); font-size:40px; font-variation-settings:'FILL' 1;">stars</span>
                    </div>
                    <div style="display:flex; align-items:end; gap:10px; margin-bottom:20px;">
                        <span class="score-value">94</span>
                        <div style="margin-bottom:6px;">
                            <span class="score-tag">优秀</span>
                            <div style="font-size:12px; color:var(--on-surface-variant); margin-top:4px;">超过 85% 的宿舍</div>
                        </div>
                    </div>
                    <button class="report-btn" style="background:var(--primary); margin-top:0;">查看详细自查报告</button>
                </div>
                <div class="glass-card">
                    <div class="score-card-header">
                        <div>
                            <div class="score-card-title">住宿费缴纳</div>
                            <div class="score-card-sub">2023-2024 秋季学期</div>
                        </div>
                        <span class="material-symbols-outlined" style="color:var(--primary); font-size:40px;">payments</span>
                    </div>
                    <div style="margin-bottom:16px;">
                        <span style="display:inline-block; padding:6px 16px; border-radius:20px; font-size:14px; font-weight:700; background:rgba(73,234,206,0.15); color:#006b5c;">已缴纳</span>
                    </div>
                    <div style="padding-top:16px; border-top:1px solid rgba(73,234,206,0.1); display:flex; justify-content:space-between; align-items:center;">
                        <div>
                            <div style="font-size:13px; color:var(--on-surface-variant);">应缴合计</div>
                            <div style="font-size:24px; font-weight:800; color:var(--on-surface); margin-top:4px;">¥ 1,200.00</div>
                        </div>
                        <a href="#" style="color:var(--primary); font-size:14px; font-weight:600;">查看流水</a>
                    </div>
                </div>
            </div>

            <!-- 我的室友 -->
            <div class="glass-card roommate-section">
                <div style="display:flex; justify-content:space-between; align-items:center; margin-bottom:20px;">
                    <div class="roommate-section-title" style="margin-bottom:0;">
                        <span class="material-symbols-outlined" style="color:var(--primary); font-size:28px;">group</span>
                        我的室友 (4)
                    </div>
                    <a href="#" style="color:var(--primary); font-size:14px; font-weight:600;">管理室友群组</a>
                </div>
                <div class="roommate-grid">
                    <div class="roommate-item self">
                        <div class="roommate-avatar">张</div>
                        <div>
                            <div style="display:flex; align-items:center; gap:8px;">
                                <span class="roommate-name">张伟</span>
                                <span class="roommate-badge">我</span>
                            </div>
                            <div class="roommate-detail">计算机科学与技术 · 2022级</div>
                        </div>
                    </div>
                    <div class="roommate-item">
                        <div class="roommate-avatar">李</div>
                        <div>
                            <div class="roommate-name">李明</div>
                            <div class="roommate-detail">自动化 · 2022级</div>
                        </div>
                    </div>
                    <div class="roommate-item">
                        <div class="roommate-avatar">王</div>
                        <div>
                            <div class="roommate-name">王小红</div>
                            <div class="roommate-detail">数字媒体艺术 · 2022级</div>
                        </div>
                    </div>
                    <div class="roommate-item">
                        <div class="roommate-avatar">赵</div>
                        <div>
                            <div class="roommate-name">赵强</div>
                            <div class="roommate-detail">电子信息工程 · 2022级</div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- 右栏 -->
        <div style="display:flex; flex-direction:column; gap:24px;">
            <!-- 设施状态 -->
            <div class="glass-card">
                <div class="facility-header">
                    <div class="facility-title">
                        <span class="material-symbols-outlined" style="color:var(--primary); font-size:28px;">construction</span>
                        设施状态
                    </div>
                    <span class="facility-sync">最后同步: 10:30 AM</span>
                </div>
                <div class="facility-grid">
                    <div class="facility-item">
                        <div class="facility-left">
                            <div class="facility-icon green"><span class="material-symbols-outlined">ac_unit</span></div>
                            <span class="facility-name">空调系统</span>
                        </div>
                        <span class="facility-status ok">运行正常</span>
                    </div>
                    <div class="facility-item">
                        <div class="facility-left">
                            <div class="facility-icon green"><span class="material-symbols-outlined">water_drop</span></div>
                            <span class="facility-name">热水器</span>
                        </div>
                        <span class="facility-status ok">运行正常</span>
                    </div>
                    <div class="facility-item error">
                        <div class="facility-left">
                            <div class="facility-icon red"><span class="material-symbols-outlined">lightbulb</span></div>
                            <span class="facility-name">照明设施</span>
                        </div>
                        <span class="facility-status error">等待维修</span>
                    </div>
                    <div class="facility-item">
                        <div class="facility-left">
                            <div class="facility-icon green"><span class="material-symbols-outlined">wifi</span></div>
                            <span class="facility-name">校园网</span>
                        </div>
                        <span class="facility-status ok">连接稳定</span>
                    </div>
                </div>
                <a href="repair.aspx" class="report-btn">
                    <span class="material-symbols-outlined">add_circle</span>
                    提交报修申请
                </a>
            </div>

            <!-- 快捷工具 -->
            <div class="glass-card" style="background:linear-gradient(135deg, rgba(73,234,206,0.15) 0%, rgba(255,255,255,0.4) 100%);">
                <div style="font-size:14px; font-weight:700; color:var(--primary); text-transform:uppercase; letter-spacing:0.1em; margin-bottom:16px;">快捷工具</div>
                <div class="quick-tools">
                    <a href="#" class="quick-tool">
                        <span class="material-symbols-outlined quick-tool-icon">event_available</span>
                        <span class="quick-tool-label">宿舍预约</span>
                    </a>
                    <a href="#" class="quick-tool">
                        <span class="material-symbols-outlined quick-tool-icon">policy</span>
                        <span class="quick-tool-label">管理规章</span>
                    </a>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
