<%@ Page Language="C#" MasterPageFile="~/admin/MasterPage.master" AutoEventWireup="true" CodeFile="repair.aspx.cs" Inherits="admin_repair" %>

<asp:Content ID="Content1" ContentPlaceHolderID="title" runat="server">报修管理 - SmartDorm</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="head" runat="server" />

<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <div class="page-header">
        <div>
            <h1 class="page-title">报修管理</h1>
            <p class="page-subtitle">处理学生报修工单</p>
        </div>
    </div>

    <div class="stat-grid">
        <div class="stat-card">
            <div class="stat-card-icon orange">
                <span class="material-symbols-outlined">pending</span>
            </div>
            <div class="stat-card-label">待处理</div>
            <div class="stat-card-value">--</div>
        </div>
        <div class="stat-card">
            <div class="stat-card-icon blue">
                <span class="material-symbols-outlined">engineering</span>
            </div>
            <div class="stat-card-label">处理中</div>
            <div class="stat-card-value">--</div>
        </div>
        <div class="stat-card">
            <div class="stat-card-icon green">
                <span class="material-symbols-outlined">check_circle</span>
            </div>
            <div class="stat-card-label">已完成</div>
            <div class="stat-card-value">--</div>
        </div>
        <div class="stat-card">
            <div class="stat-card-icon red">
                <span class="material-symbols-outlined">cancel</span>
            </div>
            <div class="stat-card-label">已驳回</div>
            <div class="stat-card-value">--</div>
        </div>
    </div>

    <div class="filter-bar">
        <select class="filter-select">
            <option value="">全部状态</option>
            <option value="1">待分配</option>
            <option value="2">维修中</option>
            <option value="3">已完成</option>
            <option value="4">已驳回</option>
        </select>
        <select class="filter-select">
            <option value="">全部楼栋</option>
            <option>A座</option>
            <option>B座</option>
            <option>C座</option>
            <option>D座</option>
        </select>
        <select class="filter-select">
            <option value="">全部类型</option>
            <option value="1">水电报修</option>
            <option value="2">家具家电</option>
            <option value="3">网络连接</option>
            <option value="4">其他</option>
        </select>
        <input type="text" class="filter-search" placeholder="搜索工单号或描述...">
    </div>

    <div class="card" style="padding: 48px; text-align: center;">
        <span class="material-symbols-outlined" style="font-size: 64px; color: var(--outline-variant);">build</span>
        <h3 style="font-size: 18px; font-weight: 700; color: var(--on-surface); margin-top: 16px;">报修管理</h3>
        <p style="font-size: 14px; color: var(--on-surface-variant); margin-top: 8px;">功能开发中，敬请期待</p>
        <a href="/admin/dashboard.aspx" class="btn btn-outline" style="margin-top: 20px;">
            <span class="material-symbols-outlined" style="font-size: 20px;">arrow_back</span>
            返回仪表盘
        </a>
    </div>

</asp:Content>