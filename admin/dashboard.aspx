<%@ Page Language="C#" MasterPageFile="~/admin/MasterPage.master" AutoEventWireup="true" CodeFile="dashboard.aspx.cs" Inherits="admin_dashboard" ResponseEncoding="utf-8" %>

<asp:Content ID="Content1" ContentPlaceHolderID="title" runat="server">控制台概览 - SmartDorm</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="head" runat="server">
    <style>
        .dash-welcome { display:flex; justify-content:space-between; align-items:center; margin-bottom:24px; flex-wrap:wrap; gap:12px; }
        .dash-welcome h1 { font-size:28px; font-weight:800; color:var(--on-surface); }
        .dash-welcome p { font-size:15px; color:var(--on-surface-variant); margin-top:4px; }
        .dash-actions { display:flex; gap:8px; }
        .dash-date-btn { display:flex; align-items:center; gap:8px; padding:10px 18px; background:rgba(255,255,255,0.6); border:1px solid rgba(0,0,0,0.06); border-radius:12px; font-size:14px; font-weight:600; color:var(--on-surface); cursor:pointer; font-family:inherit; }

        .stat-cards { display:grid; grid-template-columns:repeat(4,1fr); gap:14px; margin-bottom:24px; }
        .stat-card {
            background:rgba(255,255,255,0.6); backdrop-filter:blur(8px); border-radius:16px; padding:18px;
            border:1px solid rgba(255,255,255,0.5); transition:all 0.3s; position:relative; overflow:hidden;
        }
        .stat-card:hover { transform:translateY(-3px); box-shadow:0 8px 24px rgba(73,234,206,0.15); }
        .stat-card.error { border-left:4px solid var(--error); }
        .stat-card-icon { width:42px; height:42px; border-radius:12px; display:flex; align-items:center; justify-content:center; margin-bottom:12px; }
        .stat-card-icon .material-symbols-outlined { font-size:22px; }
        .stat-card-label { font-size:13px; font-weight:600; color:var(--on-surface-variant); }
        .stat-card-value { font-size:26px; font-weight:800; color:var(--on-surface); margin-top:4px; }
        .stat-card-sub { font-size:12px; margin-top:8px; font-weight:600; display:flex; align-items:center; gap:4px; }

        .chart-card {
            background:rgba(255,255,255,0.6); backdrop-filter:blur(8px); border-radius:16px; padding:24px;
            border:1px solid rgba(255,255,255,0.5); margin-bottom:24px;
        }
        .chart-header { display:flex; justify-content:space-between; align-items:center; margin-bottom:24px; }
        .chart-title { font-size:18px; font-weight:700; color:var(--on-surface); }
        .chart-subtitle { font-size:13px; color:var(--on-surface-variant); margin-top:2px; }
        .chart-bars { display:flex; align-items:end; justify-content:space-between; gap:14px; height:200px; padding:0 16px; }
        .chart-bar-group { flex:1; display:flex; flex-direction:column; align-items:center; gap:8px; height:100%; justify-content:flex-end; }
        .chart-bar { width:100%; border-radius:8px 8px 0 0; transition:all 0.3s; position:relative; }
        .chart-bar:hover { filter:brightness(1.1); }
        .chart-bar-label { font-size:13px; font-weight:600; color:var(--on-surface-variant); }
        .chart-bar-value { font-size:11px; font-weight:700; color:var(--on-surface); text-align:center; opacity:0; transition:opacity 0.2s; }
        .chart-bar-group:hover .chart-bar-value { opacity:1; }

        .occupancy-grid { display:grid; grid-template-columns:1fr 1fr; gap:16px; margin-top:20px; }
        .occupancy-item { padding:12px 0; }
        .occupancy-header { display:flex; justify-content:space-between; align-items:end; margin-bottom:8px; }
        .occupancy-name { font-size:14px; font-weight:600; color:var(--on-surface); }
        .occupancy-rate { font-size:14px; font-weight:800; color:var(--on-surface); }
        .occupancy-rate-sub { font-size:11px; font-weight:400; color:var(--on-surface-variant); margin-left:4px; }
        .occupancy-bar { width:100%; height:10px; background:rgba(255,255,255,0.4); border-radius:5px; overflow:hidden; }
        .occupancy-fill { height:100%; border-radius:5px; transition:width 1s ease; }

        .dash-grid { display:grid; grid-template-columns:1fr 380px; gap:20px; align-items:start; }

        .quick-actions {
            background:rgba(255,255,255,0.6); backdrop-filter:blur(8px); border-radius:16px; padding:20px;
            border:1px solid rgba(255,255,255,0.5); position:sticky; top:88px;
        }
        .quick-actions-title { font-size:18px; font-weight:700; color:var(--on-surface); margin-bottom:16px; }
        .quick-action-item {
            display:flex; align-items:center; justify-content:space-between; padding:16px; border-radius:14px;
            cursor:pointer; transition:all 0.2s; margin-bottom:10px; text-decoration:none; color:inherit;
        }
        .quick-action-item.primary { background:linear-gradient(135deg, var(--primary), var(--primary-dark)); color:var(--on-primary); box-shadow:0 4px 16px rgba(73,234,206,0.3); }
        .quick-action-item.outline { border:2px solid rgba(73,234,206,0.3); background:transparent; }
        .quick-action-item.plain { background:rgba(255,255,255,0.4); border:1px solid rgba(255,255,255,0.3); }
        .quick-action-left { display:flex; align-items:center; gap:12px; }
        .quick-action-icon { width:36px; height:36px; border-radius:10px; display:flex; align-items:center; justify-content:center; }
        .quick-action-item.primary .quick-action-icon { background:rgba(255,255,255,0.2); color:var(--on-primary); }
        .quick-action-item.outline .quick-action-icon { background:rgba(73,234,206,0.1); color:var(--primary); }
        .quick-action-item.plain .quick-action-icon { background:rgba(0,0,0,0.04); color:var(--on-surface-variant); }
        .quick-action-title { font-size:14px; font-weight:700; }
        .quick-action-sub { font-size:11px; opacity:0.8; margin-top:2px; }
        .quick-action-item.plain .quick-action-sub { color:var(--on-surface-variant); opacity:1; }
        .quick-action-arrow .material-symbols-outlined { font-size:20px; }

        @media (max-width:1200px) { .stat-cards { grid-template-columns:repeat(2,1fr); } .dash-grid { grid-template-columns:1fr; } }
        @media (max-width:768px) { .stat-cards { grid-template-columns:1fr; } .occupancy-grid { grid-template-columns:1fr; } }
    </style>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="dash-welcome">
        <div>
            <h1>控制台概览</h1>
            <p>欢迎回来，这是今日的宿舍运行数据摘要。</p>
        </div>
        <div class="dash-actions">
            <div class="dash-date-btn">
                <span class="material-symbols-outlined" style="font-size:18px; color:var(--primary);">calendar_today</span>
                <asp:Literal ID="litCurrentDate" runat="server" />
            </div>

        </div>
    </div>

    <div class="stat-cards">
        <div class="stat-card">
            <div class="stat-card-icon" style="background:rgba(73,234,206,0.1);"><span class="material-symbols-outlined" style="color:var(--primary);">apartment</span></div>
            <div class="stat-card-label">总房间数</div>
            <div class="stat-card-value"><asp:Literal ID="litTotalRooms" runat="server" /></div>
            <div class="stat-card-sub" style="color:var(--primary);"><span style="width:6px; height:6px; border-radius:50%; background:var(--primary); display:inline-block;"></span> 运行正常</div>
        </div>
        <div class="stat-card">
            <div class="stat-card-icon" style="background:rgba(73,234,206,0.1);"><span class="material-symbols-outlined" style="color:var(--primary);">group</span></div>
            <div class="stat-card-label">当前在宿学生</div>
            <div class="stat-card-value"><asp:Literal ID="litTotalStudents" runat="server" /></div>
            <div class="stat-card-sub" style="color:var(--primary);"><span class="material-symbols-outlined" style="font-size:14px;">trending_up</span> <asp:Literal ID="litOccupancyRate" runat="server" /> 入住率</div>
        </div>
        <div class="stat-card">
            <div class="stat-card-icon" style="background:rgba(73,234,206,0.1);"><span class="material-symbols-outlined" style="color:var(--primary);">bed</span></div>
            <div class="stat-card-label">空余床位</div>
            <div class="stat-card-value"><asp:Literal ID="litAvailableBeds" runat="server" /></div>
            <div class="stat-card-sub" style="color:var(--on-surface-variant);">可供即时分配</div>
        </div>
        <div class="stat-card error">
            <div class="stat-card-icon" style="background:rgba(186,26,26,0.08);"><span class="material-symbols-outlined" style="color:var(--error);">build</span></div>
            <div class="stat-card-label">今日报修请求</div>
            <div class="stat-card-value"><asp:Literal ID="litTodayRepair" runat="server" /></div>
            <div class="stat-card-sub" style="color:var(--error);">待处理: <asp:Literal ID="litPendingRepair" runat="server" /></div>
        </div>
    </div>

    <div class="dash-grid">
        <div>
            <!-- 报修趋势图 -->
            <div class="chart-card">
                <div class="chart-header">
                    <div>
                        <div class="chart-title">7日故障报修趋势</div>
                        <div class="chart-subtitle"><asp:Literal ID="litTrendSummary" runat="server" /></div>
                    </div>
                </div>
                <div class="chart-bars">
                    <asp:Repeater ID="rptTrendChart" runat="server">
                        <ItemTemplate>
                            <div class="chart-bar-group">
                                <div class="chart-bar-value"><%# Eval("Count") %></div>
                                <div class="chart-bar" style="height:<%# GetBarHeight(Eval("Count")) %>%; background:<%# GetBarColor(Eval("Count")) %>;"></div>
                                <div class="chart-bar-label"><%# Eval("DayLabel") %></div>
                            </div>
                        </ItemTemplate>
                    </asp:Repeater>
                </div>
            </div>

            <!-- 楼宇入住率 -->
            <div class="chart-card">
                <div style="display:flex; justify-content:space-between; align-items:center;">
                    <div class="chart-title">楼宇入住率分布</div>
                    <a href="/admin/allocation.aspx" style="font-size:14px; font-weight:600; color:var(--primary);">查看楼层详情</a>
                </div>
                <div class="occupancy-grid">
                    <asp:Repeater ID="rptOccupancy" runat="server">
                        <ItemTemplate>
                            <div class="occupancy-item">
                                <div class="occupancy-header">
                                    <span class="occupancy-name"><%# Eval("BuildingName") %> (<%# Eval("Campus") %>)</span>
                                    <span class="occupancy-rate"><%# Eval("OccupancyRate") %>%<span class="occupancy-rate-sub">/ <%# Eval("TotalBeds") %> 床位</span></span>
                                </div>
                                <div class="occupancy-bar"><div class="occupancy-fill" style="width:<%# Eval("OccupancyRate") %>%; <%# GetOccupancyColor(Eval("OccupancyRate")) %>"></div></div>
                            </div>
                        </ItemTemplate>
                    </asp:Repeater>
                </div>
            </div>
        </div>

        <div>
            <!-- 快捷操作 -->
            <div class="quick-actions">
                <div class="quick-actions-title">快捷操作</div>
                <a href="/admin/repair.aspx" class="quick-action-item primary">
                    <div class="quick-action-left">
                        <div class="quick-action-icon"><span class="material-symbols-outlined">assignment</span></div>
                        <div>
                            <div class="quick-action-title">处理报修订单</div>
                            <div class="quick-action-sub">待处理 <asp:Literal ID="litPendingCount" runat="server" /> 个工单</div>
                        </div>
                    </div>
                    <span class="quick-action-arrow"><span class="material-symbols-outlined">chevron_right</span></span>
                </a>
                <a href="/admin/allocation.aspx" class="quick-action-item outline">
                    <div class="quick-action-left">
                        <div class="quick-action-icon"><span class="material-symbols-outlined">bed</span></div>
                        <div>
                            <div class="quick-action-title">宿舍分配管理</div>
                            <div class="quick-action-sub">空余床位 <asp:Literal ID="litQuickBeds" runat="server" /> 个</div>
                        </div>
                    </div>
                    <span class="quick-action-arrow" style="color:var(--primary);"><span class="material-symbols-outlined">chevron_right</span></span>
                </a>
                <a href="/admin/notice.aspx" class="quick-action-item plain">
                    <div class="quick-action-left">
                        <div class="quick-action-icon"><span class="material-symbols-outlined">campaign</span></div>
                        <div>
                            <div class="quick-action-title">发布宿舍公告</div>
                            <div class="quick-action-sub">通知全体在校学生</div>
                        </div>
                    </div>
                    <span class="quick-action-arrow" style="color:var(--on-surface-variant);"><span class="material-symbols-outlined">chevron_right</span></span>
                </a>
            </div>
        </div>
    </div>
</asp:Content>
