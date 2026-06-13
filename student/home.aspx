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

        .home-roommates-card, .home-repair-card, .home-notice-card, .home-tools-card { padding:24px; }
        .home-repair-list { display:flex; flex-direction:column; gap:10px; }
        .home-repair-item {
            display:flex; align-items:center; gap:14px; padding:14px 16px; border-radius:14px;
            background:rgba(255,255,255,0.5); border:1px solid rgba(255,255,255,0.5); transition:all 0.2s;
        }
        .home-repair-item:hover { border-color:var(--primary); }
        .home-repair-icon {
            width:40px; height:40px; border-radius:12px; display:flex; align-items:center; justify-content:center;
            background:rgba(73,234,206,0.12); color:var(--primary); flex-shrink:0;
        }
        .home-repair-icon .material-symbols-outlined { font-size:20px; }
        .home-repair-info { flex:1; min-width:0; }
        .home-repair-desc { font-size:14px; font-weight:600; color:var(--on-surface); overflow:hidden; text-overflow:ellipsis; white-space:nowrap; }
        .home-repair-meta { font-size:12px; color:var(--on-surface-variant); margin-top:2px; }
        .home-repair-status { padding:4px 12px; border-radius:999px; font-size:12px; font-weight:700; white-space:nowrap; flex-shrink:0; }
        .home-repair-status.pending { background:rgba(251,192,45,0.15); color:#b58900; }
        .home-repair-status.processing { background:rgba(73,234,206,0.15); color:#006b5c; }
        .home-repair-status.completed { background:rgba(73,234,206,0.15); color:#006b5c; }
        .home-repair-status.rejected { background:rgba(186,26,26,0.1); color:var(--error); }
        .home-repair-empty { text-align:center; padding:32px 0; color:var(--on-surface-variant); font-size:14px; }
        .home-repair-empty .material-symbols-outlined { font-size:36px; opacity:0.3; display:block; margin-bottom:8px; }
        .home-notice-list { display:flex; flex-direction:column; gap:10px; max-height:420px; overflow-y:auto; }
        .home-notice-list::-webkit-scrollbar { width:4px; }
        .home-notice-list::-webkit-scrollbar-thumb { background:var(--outline-variant); border-radius:4px; }
        .home-notice-item {
            display:flex; align-items:flex-start; gap:12px; padding:14px 16px; border-radius:14px;
            background:rgba(255,255,255,0.5); border:1px solid rgba(255,255,255,0.5);
            transition:all 0.2s; cursor:pointer; text-decoration:none; color:inherit;
        }
        .home-notice-item:hover { border-color:var(--primary); background:rgba(73,234,206,0.06); }
        .home-notice-dot { width:8px; height:8px; border-radius:50%; background:var(--outline-variant); margin-top:7px; flex-shrink:0; }
        .home-notice-dot.top { background:var(--primary); }
        .home-notice-content { flex:1; min-width:0; display:flex; align-items:center; justify-content:space-between; gap:12px; }
        .home-notice-title { font-size:14px; font-weight:600; color:var(--on-surface); overflow:hidden; text-overflow:ellipsis; white-space:nowrap; }
        .home-notice-time { font-size:12px; color:var(--on-surface-variant); white-space:nowrap; flex-shrink:0; }
        .home-notice-empty { display:flex; flex-direction:column; align-items:center; justify-content:center; gap:8px; padding:40px 0; color:var(--on-surface-variant); }
        .home-notice-empty .material-symbols-outlined { font-size:36px; opacity:0.3; }
        .home-tools-card { background:linear-gradient(135deg, rgba(73,234,206,0.14), rgba(255,255,255,0.52)); }
        .home-tools-label { margin-bottom:20px; color:var(--primary); font-size:14px; font-weight:800; letter-spacing:0.04em; }
        .home-tools-grid { display:grid; grid-template-columns:repeat(auto-fit, minmax(120px, 1fr)); gap:14px; }
        .home-tool {
            display:flex; flex-direction:column; align-items:center; justify-content:center; gap:10px; min-height:112px;
            border-radius:18px; border:1px solid rgba(255,255,255,0.46); background:rgba(255,255,255,0.55);
            color:var(--on-surface-variant); text-decoration:none; font-size:13px; font-weight:700; transition:all 0.2s;
        }
        .home-tool:hover { color:var(--on-surface); border-color:var(--primary); background:rgba(73,234,206,0.09); }
        .home-tool .material-symbols-outlined { color:var(--primary); font-size:32px; }

        @media (max-width:1100px) {
            .home-dashboard { grid-template-columns:1fr; }
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
            .home-roommate-grid, .home-tools-grid { grid-template-columns:1fr; gap:16px; }
            .home-roommates-card, .home-repair-card, .home-notice-card, .home-tools-card { padding:20px; border-radius:20px; }
            .home-section-title { font-size:20px; }
            .home-section-head { align-items:flex-start; margin-bottom:20px; }
            .home-text-action { padding:6px 0; }
            .home-roommate { padding:16px; gap:16px; }
            .home-avatar { width:56px; height:56px; }
            .home-roommate-name { font-size:17px; }
            .home-roommate-major { font-size:14px; }
        }
        @media (max-width:420px) {
            .home-section-head { flex-direction:column; }
        }
    </style>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="home-page">
        <section class="home-hero home-card">
            <div class="home-hero-content">
                <div>
                    <h1 class="home-hero-title"><asp:Literal ID="litBuilding" runat="server" Text="未分配宿舍" /></h1>
                    <div class="home-hero-meta">
                        <span><span class="material-symbols-outlined">meeting_room</span> <asp:Literal ID="litRoom" runat="server" /></span>
                        <span><span class="material-symbols-outlined">bed</span> <asp:Literal ID="litBed" runat="server" /></span>
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
                <section class="home-card home-roommates-card">
                    <div class="home-section-head">
                        <h2 class="home-section-title">
                            <span class="material-symbols-outlined">group</span>
                            我的室友 (<asp:Literal ID="litRoommateCount" runat="server" Text="0" />)
                        </h2>
                    </div>
                    <asp:Panel ID="pnlRoommates" runat="server">
                        <div class="home-roommate-grid">
                            <div class="home-roommate self">
                                <div class="home-avatar"><asp:Literal ID="litMyAvatar" runat="server" /></div>
                                <div class="home-roommate-info">
                                    <div class="home-roommate-name"><asp:Literal ID="litMyName" runat="server" /> <span class="home-self-badge">我</span></div>
                                    <div class="home-roommate-major"><asp:Literal ID="litMyMajor" runat="server" /></div>
                                </div>
                            </div>
                            <asp:Repeater ID="rptRoommates" runat="server">
                                <ItemTemplate>
                                    <div class="home-roommate">
                                        <div class="home-avatar"><%# Eval("Name").ToString().Substring(0, 1) %></div>
                                        <div class="home-roommate-info">
                                            <div class="home-roommate-name"><%# Eval("Name") %></div>
                                            <div class="home-roommate-major"><%# Eval("Major") %> · <%# Eval("Grade") %></div>
                                        </div>
                                    </div>
                                </ItemTemplate>
                            </asp:Repeater>
                        </div>
                    </asp:Panel>
                    <asp:Panel ID="pnlNoRoommates" runat="server" Visible="false">
                        <div class="home-repair-empty">
                            <span class="material-symbols-outlined">person_off</span>
                            暂无室友信息
                        </div>
                    </asp:Panel>
                </section>

                <section class="home-card home-repair-card">
                    <div class="home-section-head">
                        <h2 class="home-section-title">
                            <span class="material-symbols-outlined">build</span>
                            我的报修
                        </h2>
                        <a href="repair.aspx" class="home-text-action">报修申请</a>
                    </div>
                    <div class="home-repair-list">
                        <asp:Repeater ID="rptRepairs" runat="server">
                            <ItemTemplate>
                                <div class="home-repair-item">
                                    <div class="home-repair-icon">
                                        <span class="material-symbols-outlined"><%# GetRepairIcon(Eval("RepairType")) %></span>
                                    </div>
                                    <div class="home-repair-info">
                                        <div class="home-repair-desc"><%# Eval("Description") %></div>
                                        <div class="home-repair-meta"><%# Eval("TypeName") %> · <%# Eval("BuildingName") %> <%# Eval("RoomNo") %> · <%# Convert.ToDateTime(Eval("CreateTime")).ToString("MM-dd HH:mm") %></div>
                                    </div>
                                    <span class="home-repair-status <%# GetStatusClass(Convert.ToInt32(Eval("Status"))) %>"><%# Eval("StatusName") %></span>
                                </div>
                            </ItemTemplate>
                        </asp:Repeater>
                        <asp:Literal ID="litNoRepair" runat="server" Visible="false">
                            <div class="home-repair-empty">
                                <span class="material-symbols-outlined">check_circle</span>
                                暂无报修记录
                            </div>
                        </asp:Literal>
                    </div>
                </section>
            </div>

            <aside class="home-side-column">
                <section class="home-card home-notice-card">
                    <div class="home-section-head">
                        <h2 class="home-section-title">
                            <span class="material-symbols-outlined">campaign</span>
                            通知公告
                        </h2>
                    </div>
                    <div class="home-notice-list">
                        <asp:Repeater ID="rptNotices" runat="server">
                            <ItemTemplate>
                                <a href='notice-detail.aspx?id=<%# Eval("Id") %>' class="home-notice-item">
                                    <div class="home-notice-dot <%# Convert.ToInt32(Eval("IsTop")) == 1 ? "top" : "" %>"></div>
                                    <div class="home-notice-content">
                                        <div class="home-notice-title"><%# Eval("Title") %></div>
                                        <div class="home-notice-time"><%# Convert.ToDateTime(Eval("CreateTime")).ToString("MM-dd HH:mm") %></div>
                                    </div>
                                </a>
                            </ItemTemplate>
                        </asp:Repeater>
                        <asp:Literal ID="litNoNotice" runat="server" Visible="false">
                            <div class="home-notice-empty">
                                <span class="material-symbols-outlined">notifications_off</span>
                                <span>暂无公告</span>
                            </div>
                        </asp:Literal>
                    </div>
                </section>

                <section class="home-card home-tools-card">
                    <div class="home-tools-label">快捷工具</div>
                    <div class="home-tools-grid">
                        <a href="repair.aspx" class="home-tool">
                            <span class="material-symbols-outlined">build</span>
                            报修申请
                        </a>
                    </div>
                </section>
            </aside>
        </div>
    </div>
</asp:Content>
