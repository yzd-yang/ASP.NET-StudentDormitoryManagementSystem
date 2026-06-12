<%@ Page Language="C#" MasterPageFile="~/admin/MasterPage.master" AutoEventWireup="true" CodeFile="dashboard.aspx.cs" Inherits="admin_dashboard" %>

<asp:Content ID="Content1" ContentPlaceHolderID="title" runat="server">控制台 - SmartDorm</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="head" runat="server" />
<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <div class="page-header">
        <div>
            <h1 class="page-title">控制台概览</h1>
            <p class="page-subtitle">欢迎回来，这是今日的宿舍运行数据摘要。</p>
        </div>
        <div class="flex gap-3">
            <button type="button" class="btn btn-ghost">
                <span class="material-symbols-outlined" style="font-size: 20px; color: var(--primary);">calendar_today</span>
                <span id="currentDate" runat="server"></span>
            </button>
        </div>
    </div>

    <div class="stat-grid">
        <div class="stat-card">
            <div class="stat-card-icon green">
                <span class="material-symbols-outlined">apartment</span>
            </div>
            <div class="stat-card-label">总房间数</div>
            <div class="stat-card-value"><asp:Literal ID="litTotalRooms" runat="server" Text="0" /></div>
        </div>
        <div class="stat-card">
            <div class="stat-card-icon blue">
                <span class="material-symbols-outlined">group</span>
            </div>
            <div class="stat-card-label">在宿学生</div>
            <div class="stat-card-value"><asp:Literal ID="litTotalStudents" runat="server" Text="0" /></div>
        </div>
        <div class="stat-card">
            <div class="stat-card-icon green">
                <span class="material-symbols-outlined">bed</span>
            </div>
            <div class="stat-card-label">空余床位</div>
            <div class="stat-card-value"><asp:Literal ID="litAvailableBeds" runat="server" Text="0" /></div>
        </div>
        <div class="stat-card stat-card-warning">
            <div class="stat-card-icon orange">
                <span class="material-symbols-outlined">build</span>
            </div>
            <div class="stat-card-label">待处理报修</div>
            <div class="stat-card-value"><asp:Literal ID="litPendingRepair" runat="server" Text="0" /></div>
        </div>
    </div>

    <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 24px;">
        <div class="card" style="padding: 24px;">
            <h3 style="font-size: 18px; font-weight: 700; margin-bottom: 20px;">快捷操作</h3>
            <div style="display: flex; flex-direction: column; gap: 12px;">
                <a href="/admin/repair.aspx" class="btn btn-primary" style="justify-content: flex-start; padding: 16px 20px; border-radius: 16px;">
                    <span class="material-symbols-outlined">assignment</span>
                    <div style="text-align: left;">
                        <div style="font-weight: 700;">处理报修订单</div>
                        <div style="font-size: 11px; opacity: 0.8;">查看并处理报修工单</div>
                    </div>
                </a>
                <a href="/admin/allocation.aspx" class="btn btn-outline" style="justify-content: flex-start; padding: 16px 20px; border-radius: 16px;">
                    <span class="material-symbols-outlined" style="color: var(--primary);">bed</span>
                    <div style="text-align: left;">
                        <div style="font-weight: 700;">宿舍分配管理</div>
                        <div style="font-size: 11px; color: var(--on-surface-variant);">管理学生宿舍分配</div>
                    </div>
                </a>
                <a href="/admin/building.aspx" class="btn btn-ghost" style="justify-content: flex-start; padding: 16px 20px; border-radius: 16px;">
                    <span class="material-symbols-outlined">meeting_room</span>
                    <div style="text-align: left;">
                        <div style="font-weight: 700;">楼宇房间管理</div>
                        <div style="font-size: 11px; color: var(--on-surface-variant);">管理楼宇和房间信息</div>
                    </div>
                </a>
            </div>
        </div>

        <div class="card" style="padding: 24px;">
            <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px;">
                <h3 style="font-size: 18px; font-weight: 700;">系统信息</h3>
            </div>
            <div style="display: flex; flex-direction: column; gap: 16px;">
                <div style="display: flex; justify-content: space-between; padding: 12px 0; border-bottom: 1px solid rgba(0,0,0,0.05);">
                    <span style="color: var(--on-surface-variant); font-size: 14px;">系统版本</span>
                    <span style="font-weight: 600; font-size: 14px;">SmartDorm v1.0</span>
                </div>
                <div style="display: flex; justify-content: space-between; padding: 12px 0; border-bottom: 1px solid rgba(0,0,0,0.05);">
                    <span style="color: var(--on-surface-variant); font-size: 14px;">数据库状态</span>
                    <span style="font-weight: 600; font-size: 14px; color: var(--primary);">正常运行</span>
                </div>
                <div style="display: flex; justify-content: space-between; padding: 12px 0; border-bottom: 1px solid rgba(0,0,0,0.05);">
                    <span style="color: var(--on-surface-variant); font-size: 14px;">当前管理员</span>
                    <span style="font-weight: 600; font-size: 14px;"><%= Session["AdminName"] ?? "管理员" %></span>
                </div>
                <div style="display: flex; justify-content: space-between; padding: 12px 0;">
                    <span style="color: var(--on-surface-variant); font-size: 14px;">登录时间</span>
                    <span style="font-weight: 600; font-size: 14px;"><%= DateTime.Now.ToString("yyyy-MM-dd HH:mm") %></span>
                </div>
            </div>
        </div>
    </div>

</asp:Content>