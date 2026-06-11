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
            <div class="stat-card-value">--</div>
        </div>
        <div class="stat-card">
            <div class="stat-card-icon blue">
                <span class="material-symbols-outlined">group</span>
            </div>
            <div class="stat-card-label">在宿学生</div>
            <div class="stat-card-value">--</div>
        </div>
        <div class="stat-card">
            <div class="stat-card-icon green">
                <span class="material-symbols-outlined">bed</span>
            </div>
            <div class="stat-card-label">空余床位</div>
            <div class="stat-card-value">--</div>
        </div>
        <div class="stat-card">
            <div class="stat-card-icon orange">
                <span class="material-symbols-outlined">build</span>
            </div>
            <div class="stat-card-label">待处理报修</div>
            <div class="stat-card-value">--</div>
        </div>
    </div>

    <div class="card" style="padding: 48px; text-align: center;">
        <span class="material-symbols-outlined" style="font-size: 64px; color: var(--outline-variant);">construction</span>
        <h3 style="font-size: 18px; font-weight: 700; color: var(--on-surface); margin-top: 16px;">功能开发中</h3>
        <p style="font-size: 14px; color: var(--on-surface-variant); margin-top: 8px;">仪表盘数据统计功能即将上线，敬请期待</p>
    </div>

</asp:Content>