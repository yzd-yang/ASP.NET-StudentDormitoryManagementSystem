<%@ Page Language="C#" MasterPageFile="~/student/MasterPage.master" AutoEventWireup="true" CodeFile="home.aspx.cs" Inherits="student_home" ResponseEncoding="utf-8" %>

<asp:Content ID="Content1" ContentPlaceHolderID="title" runat="server">我的宿舍 - 智慧宿舍</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="head" runat="server">
    <style>
        .home-page { display:flex; flex-direction:column; gap:24px; }
        .home-card {
            background:rgba(255,255,255,0.7); backdrop-filter:blur(12px); -webkit-backdrop-filter:blur(12px);
            border:1px solid rgba(255,255,255,0.42); border-radius:24px; box-shadow:0 1px 8px rgba(0,0,0,0.04);
        }

        .home-hero {
            position:relative; min-height:320px; overflow:hidden; border-radius:24px; padding:48px;
            display:flex; align-items:flex-end;
            background-image:url('https://lh3.googleusercontent.com/aida-public/AB6AXuDvub5epDD0W6jzLzcezGMTa9iGTYLyUSoTqCsMEHR_gRKJ-4ti08NPjhNFwJsWi4TSg7FByjTGKAGcy2H-TN3fa6usYF-05ZNqdYLL1ibSx-RP0eEQx-rhvt8uUhZ-U9_KJbhJE2YCnSVW-Ecihon--9Su1flYTgBzk46fs7ZVT8UOeO9DKEzCPWtXIN3zgZS8B69YLFBhPi1Bf0Zk4daqKfFVk_s0YboPxGXuZD2yKB9VKiVXkvfh0Hj5HSu4xJEWr-mo_jg9OQ'), linear-gradient(135deg, #006b5c 0%, #49EACE 48%, #f5ffdc 100%);
            background-size:cover;
            background-position:center;
        }
        .home-hero::before {
            content:""; position:absolute; inset:0; z-index:1;
            background:linear-gradient(to top, rgba(0,0,0,0.62), rgba(0,0,0,0.18) 58%, rgba(0,0,0,0.04));
        }
        .home-hero-content { position:relative; z-index:2; width:100%; display:flex; align-items:flex-end; justify-content:space-between; gap:24px; color:#fff; }
        .home-hero-title { font-size:48px; line-height:1.12; font-weight:800; margin-bottom:12px; }
        .home-hero-meta { display:flex; align-items:center; gap:24px; flex-wrap:wrap; font-size:18px; opacity:0.94; }
        .home-hero-meta span { display:inline-flex; align-items:center; gap:8px; }
        .home-hero-action {
            display:inline-flex; align-items:center; justify-content:center; gap:8px; padding:10px 24px;
            color:#fff; background:rgba(255,255,255,0.14); border:1px solid rgba(255,255,255,0.26);
            border-radius:16px; font-size:14px; font-weight:700; text-decoration:none; backdrop-filter:blur(8px);
            transition:all 0.2s; white-space:nowrap;
        }
        .home-hero-action:hover { background:rgba(255,255,255,0.24); }

        .home-dashboard { display:grid; grid-template-columns:minmax(0, 2fr) minmax(320px, 1fr); gap:32px; align-items:start; }
        .home-main-column, .home-side-column { display:flex; flex-direction:column; gap:32px; }
        .home-summary-grid { display:grid; grid-template-columns:repeat(2, minmax(0, 1fr)); gap:24px; }

        .home-score-card, .home-pay-card, .home-roommates-card, .home-facility-card, .home-tools-card { padding:24px; }
        .home-card-head { display:flex; justify-content:space-between; align-items:flex-start; gap:16px; margin-bottom:24px; }
        .home-card-title { font-size:24px; line-height:1.25; font-weight:700; color:var(--on-surface); }
        .home-card-subtitle { font-size:13px; color:var(--on-surface-variant); margin-top:4px; }
        .home-card-icon { font-size:40px; color:var(--primary); transition:transform 0.2s; }
        .home-card:hover .home-card-icon { transform:scale(1.08); }
        .home-score-card { background:linear-gradient(135deg, rgba(73,234,206,0.15), rgba(255,255,255,0.42)); }
        .home-score-row { display:flex; align-items:flex-end; gap:12px; margin-bottom:24px; }
        .home-score-value { font-size:56px; font-weight:800; line-height:0.95; color:var(--on-surface); }
        .home-score-label { display:block; font-size:14px; color:#00a08e; font-weight:700; }
        .home-score-hint { font-size:12px; color:var(--on-surface-variant); margin-top:4px; }
        .home-primary-btn {
            width:100%; min-height:52px; border:none; border-radius:16px; background:var(--primary); color:#000;
            font:inherit; font-size:14px; font-weight:700; cursor:pointer; display:flex; align-items:center; justify-content:center; gap:8px;
            box-shadow:0 6px 16px rgba(73,234,206,0.22); text-decoration:none; transition:all 0.2s;
        }
        .home-primary-btn:hover { opacity:0.9; }
        .home-pay-badge { display:inline-flex; align-items:center; padding:6px 16px; border-radius:999px; background:rgba(73,234,206,0.16); color:#006658; font-size:14px; font-weight:800; }
        .home-pay-footer { display:flex; align-items:center; justify-content:space-between; gap:16px; margin-top:28px; padding-top:24px; border-top:1px solid rgba(73,234,206,0.12); }
        .home-pay-label { font-size:14px; color:var(--on-surface-variant); }
        .home-pay-amount { font-size:24px; font-weight:800; color:var(--on-surface); margin-top:4px; }
        .home-pay-link { color:var(--primary); font-size:14px; font-weight:700; text-decoration:none; white-space:nowrap; }
        .home-pay-link:hover { text-decoration:underline; }

        .home-section-head { display:flex; align-items:center; justify-content:space-between; gap:16px; margin-bottom:28px; }
        .home-section-title { display:flex; align-items:center; gap:12px; font-size:24px; line-height:1.25; font-weight:700; color:var(--on-surface); margin:0; }
        .home-section-title .material-symbols-outlined { color:var(--primary); font-size:32px; }
        .home-text-action { border:none; background:transparent; color:var(--primary); font:inherit; font-size:14px; font-weight:700; cursor:pointer; padding:8px 14px; border-radius:14px; white-space:nowrap; }
        .home-text-action:hover { background:rgba(73,234,206,0.1); }
        .home-roommate-grid { display:grid; grid-template-columns:repeat(2, minmax(0, 1fr)); gap:20px; }
        .home-roommate {
            display:flex; align-items:center; gap:20px; min-width:0; padding:20px; border-radius:18px;
            border:1px solid rgba(255,255,255,0.48); background:rgba(255,255,255,0.28); cursor:pointer; transition:all 0.2s;
        }
        .home-roommate:hover { border-color:var(--primary); background:rgba(255,255,255,0.56); }
        .home-roommate.self { border:2px solid var(--primary); background:rgba(73,234,206,0.06); }
        .home-avatar { width:64px; height:64px; border-radius:50%; display:flex; align-items:center; justify-content:center; flex-shrink:0; background:#fff; border:2px solid #fff; box-shadow:0 2px 8px rgba(0,0,0,0.08); color:var(--primary); font-size:22px; font-weight:800; }
        .home-roommate.self .home-avatar { border-color:var(--primary); }
        .home-roommate-info { min-width:0; }
        .home-roommate-name { display:flex; align-items:center; gap:8px; font-size:18px; font-weight:700; color:var(--on-surface); }
        .home-self-badge { padding:2px 8px; border-radius:999px; background:var(--primary); color:#000; font-size:10px; font-weight:800; }
        .home-roommate-major { margin-top:4px; font-size:16px; color:var(--on-surface-variant); overflow:hidden; text-overflow:ellipsis; white-space:nowrap; }

        .home-facility-card { min-height:100%; display:flex; flex-direction:column; }
        .home-sync { font-size:12px; color:var(--on-surface-variant); white-space:nowrap; }
        .home-facility-list { display:flex; flex-direction:column; gap:16px; flex:1; }
        .home-facility-row { display:flex; align-items:center; justify-content:space-between; gap:12px; padding:16px; border-radius:18px; background:rgba(255,255,255,0.42); border:1px solid rgba(255,255,255,0.5); transition:all 0.2s; }
        .home-facility-row:hover { border-color:var(--primary); box-shadow:0 2px 10px rgba(0,0,0,0.04); }
        .home-facility-row.error { background:rgba(186,26,26,0.045); border-color:rgba(186,26,26,0.12); }
        .home-facility-left { display:flex; align-items:center; gap:14px; min-width:0; }
        .home-facility-icon { width:40px; height:40px; border-radius:14px; display:flex; align-items:center; justify-content:center; background:rgba(73,234,206,0.12); color:var(--primary); flex-shrink:0; }
        .home-facility-icon.error { background:rgba(186,26,26,0.1); color:var(--error); }
        .home-facility-name { font-size:14px; font-weight:700; color:var(--on-surface); overflow:hidden; text-overflow:ellipsis; white-space:nowrap; }
        .home-status { padding:5px 12px; border-radius:999px; font-size:12px; font-weight:800; white-space:nowrap; }
        .home-status.ok { background:rgba(73,234,206,0.13); color:#00a08e; }
        .home-status.error { background:rgba(186,26,26,0.09); color:var(--error); }
        .home-repair-btn { margin-top:32px; }

        .home-tools-card { background:linear-gradient(135deg, rgba(73,234,206,0.14), rgba(255,255,255,0.52)); }
        .home-tools-label { margin-bottom:20px; color:var(--primary); font-size:14px; font-weight:800; letter-spacing:0.04em; }
        .home-tools-grid { display:grid; grid-template-columns:repeat(2, minmax(0, 1fr)); gap:14px; }
        .home-tool {
            display:flex; flex-direction:column; align-items:center; justify-content:center; gap:10px; min-height:112px;
            border-radius:18px; border:1px solid rgba(255,255,255,0.46); background:rgba(255,255,255,0.55);
            color:var(--on-surface-variant); text-decoration:none; font-size:13px; font-weight:700; transition:all 0.2s;
        }
        .home-tool:hover { color:var(--on-surface); border-color:var(--primary); background:rgba(73,234,206,0.09); }
        .home-tool .material-symbols-outlined { color:var(--primary); font-size:32px; }

        @media (max-width:1100px) {
            .home-dashboard { grid-template-columns:1fr; }
            .home-summary-grid { grid-template-columns:repeat(2, minmax(0, 1fr)); }
            .home-side-column { display:grid; grid-template-columns:minmax(0, 1fr) minmax(280px, 0.7fr); gap:24px; }
        }
        @media (max-width:767px) {
            .home-page { gap:20px; }
            .home-hero { min-height:260px; padding:28px 22px; border-radius:20px; }
            .home-hero-content { flex-direction:column; align-items:flex-start; justify-content:flex-end; }
            .home-hero-title { font-size:32px; margin-bottom:10px; }
            .home-hero-meta { gap:12px; font-size:15px; }
            .home-hero-action { width:100%; }
            .home-dashboard, .home-main-column, .home-side-column { display:flex; flex-direction:column; gap:20px; }
            .home-summary-grid, .home-roommate-grid, .home-tools-grid { grid-template-columns:1fr; gap:16px; }
            .home-score-card, .home-pay-card, .home-roommates-card, .home-facility-card, .home-tools-card { padding:20px; border-radius:20px; }
            .home-card-title, .home-section-title { font-size:20px; }
            .home-card-icon { font-size:34px; }
            .home-section-head { align-items:flex-start; margin-bottom:20px; }
            .home-text-action { padding:6px 0; }
            .home-roommate { padding:16px; gap:16px; }
            .home-avatar { width:56px; height:56px; }
            .home-roommate-name { font-size:17px; }
            .home-roommate-major { font-size:14px; }
            .home-facility-row { padding:14px; }
        }
        @media (max-width:420px) {
            .home-pay-footer { align-items:flex-start; flex-direction:column; }
            .home-section-head { flex-direction:column; }
            .home-sync { white-space:normal; }
        }
    </style>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="home-page">
        <section class="home-hero home-card">
            <div class="home-hero-content">
                <div>
                    <h1 class="home-hero-title">北校区 3号楼</h1>
                    <div class="home-hero-meta">
                        <span><span class="material-symbols-outlined">meeting_room</span> 502-A 室</span>
                        <span><span class="material-symbols-outlined">bed</span> 02号床位</span>
                    </div>
                </div>
                <a href="profile.aspx" class="home-hero-action">
                    <span class="material-symbols-outlined" style="font-size:20px;">edit</span>
                    修改个人资料
                </a>
            </div>
        </section>

        <div class="home-dashboard">
            <div class="home-main-column">
                <div class="home-summary-grid">
                    <section class="home-card home-score-card">
                        <div class="home-card-head">
                            <div>
                                <h2 class="home-card-title">宿舍评分</h2>
                                <p class="home-card-subtitle">基于本月卫生与安全周检</p>
                            </div>
                            <span class="material-symbols-outlined home-card-icon" style="font-variation-settings:'FILL' 1;">stars</span>
                        </div>
                        <div class="home-score-row">
                            <span class="home-score-value">94</span>
                            <div>
                                <span class="home-score-label">优秀</span>
                                <div class="home-score-hint">超过 85% 的宿舍</div>
                            </div>
                        </div>
                        <button class="home-primary-btn" type="button">查看详细自查报告</button>
                    </section>

                    <section class="home-card home-pay-card">
                        <div class="home-card-head">
                            <div>
                                <h2 class="home-card-title">住宿费缴纳</h2>
                                <p class="home-card-subtitle">2023-2024 秋季学期</p>
                            </div>
                            <span class="material-symbols-outlined home-card-icon">payments</span>
                        </div>
                        <span class="home-pay-badge">已缴纳</span>
                        <div class="home-pay-footer">
                            <div>
                                <div class="home-pay-label">应缴合计</div>
                                <div class="home-pay-amount">¥ 1,200.00</div>
                            </div>
                            <a href="#" class="home-pay-link">查看流水</a>
                        </div>
                    </section>
                </div>

                <section class="home-card home-roommates-card">
                    <div class="home-section-head">
                        <h2 class="home-section-title">
                            <span class="material-symbols-outlined">group</span>
                            我的室友 (4)
                        </h2>
                        <button class="home-text-action" type="button">管理室友群组</button>
                    </div>
                    <div class="home-roommate-grid">
                        <div class="home-roommate self">
                            <div class="home-avatar">张</div>
                            <div class="home-roommate-info">
                                <div class="home-roommate-name">张伟 <span class="home-self-badge">我</span></div>
                                <div class="home-roommate-major">计算机科学与技术 · 2022级</div>
                            </div>
                        </div>
                        <div class="home-roommate">
                            <div class="home-avatar">李</div>
                            <div class="home-roommate-info">
                                <div class="home-roommate-name">李明</div>
                                <div class="home-roommate-major">自动化 · 2022级</div>
                            </div>
                        </div>
                        <div class="home-roommate">
                            <div class="home-avatar">王</div>
                            <div class="home-roommate-info">
                                <div class="home-roommate-name">王小红</div>
                                <div class="home-roommate-major">数字媒体艺术 · 2022级</div>
                            </div>
                        </div>
                        <div class="home-roommate">
                            <div class="home-avatar">赵</div>
                            <div class="home-roommate-info">
                                <div class="home-roommate-name">赵强</div>
                                <div class="home-roommate-major">电子信息工程 · 2022级</div>
                            </div>
                        </div>
                    </div>
                </section>
            </div>

            <aside class="home-side-column">
                <section class="home-card home-facility-card">
                    <div class="home-section-head">
                        <h2 class="home-section-title">
                            <span class="material-symbols-outlined">construction</span>
                            设施状态
                        </h2>
                        <span class="home-sync">最后同步: 10:30 AM</span>
                    </div>
                    <div class="home-facility-list">
                        <div class="home-facility-row">
                            <div class="home-facility-left">
                                <span class="home-facility-icon"><span class="material-symbols-outlined">ac_unit</span></span>
                                <span class="home-facility-name">空调系统</span>
                            </div>
                            <span class="home-status ok">运行正常</span>
                        </div>
                        <div class="home-facility-row">
                            <div class="home-facility-left">
                                <span class="home-facility-icon"><span class="material-symbols-outlined">water_drop</span></span>
                                <span class="home-facility-name">热水器</span>
                            </div>
                            <span class="home-status ok">运行正常</span>
                        </div>
                        <div class="home-facility-row error">
                            <div class="home-facility-left">
                                <span class="home-facility-icon error"><span class="material-symbols-outlined">lightbulb</span></span>
                                <span class="home-facility-name">照明设施</span>
                            </div>
                            <span class="home-status error">等待维修</span>
                        </div>
                        <div class="home-facility-row">
                            <div class="home-facility-left">
                                <span class="home-facility-icon"><span class="material-symbols-outlined">wifi</span></span>
                                <span class="home-facility-name">校园网</span>
                            </div>
                            <span class="home-status ok">连接稳定</span>
                        </div>
                    </div>
                    <a href="repair.aspx" class="home-primary-btn home-repair-btn">
                        <span class="material-symbols-outlined">add_circle</span>
                        提交报修申请
                    </a>
                </section>

                <section class="home-card home-tools-card">
                    <div class="home-tools-label">快捷工具</div>
                    <div class="home-tools-grid">
                        <a href="batch.aspx" class="home-tool">
                            <span class="material-symbols-outlined">event_available</span>
                            宿舍预约
                        </a>
                        <a href="#" class="home-tool">
                            <span class="material-symbols-outlined">policy</span>
                            管理规章
                        </a>
                    </div>
                </section>
            </aside>
        </div>
    </div>
</asp:Content>
