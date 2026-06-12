<%@ Page Language="C#" MasterPageFile="~/admin/MasterPage.master" AutoEventWireup="true" CodeFile="building.aspx.cs" Inherits="admin_building" ResponseEncoding="utf-8" %>

<asp:Content ID="Content1" ContentPlaceHolderID="title" runat="server">楼宇管理 - SmartDorm</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="head" runat="server" />

<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <div class="page-header">
        <div>
            <h1 class="page-title">楼宇房间管理</h1>
            <p class="page-subtitle">管理楼宇信息和房间配置</p>
        </div>
        <div class="flex gap-3">
            <button type="button" class="btn btn-primary">
                <span class="material-symbols-outlined" style="font-size: 20px;">add</span>
                新增楼宇
            </button>
            <button type="button" class="btn btn-outline">
                <span class="material-symbols-outlined" style="font-size: 20px;">auto_fix_high</span>
                批量生成房间
            </button>
        </div>
    </div>

    <div class="filter-bar">
        <input type="text" class="filter-search" placeholder="搜索楼宇名称...">
        <button type="button" class="btn btn-primary">
            <span class="material-symbols-outlined" style="font-size: 20px;">search</span>
            搜索
        </button>
    </div>

    <div class="card" style="padding: 48px; text-align: center;">
        <span class="material-symbols-outlined" style="font-size: 64px; color: var(--outline-variant);">meeting_room</span>
        <h3 style="font-size: 18px; font-weight: 700; color: var(--on-surface); margin-top: 16px;">楼宇房间管理</h3>
        <p style="font-size: 14px; color: var(--on-surface-variant); margin-top: 8px;">功能开发中，敬请期待</p>
        <a href="/admin/dashboard.aspx" class="btn btn-outline" style="margin-top: 20px;">
            <span class="material-symbols-outlined" style="font-size: 20px;">arrow_back</span>
            返回仪表盘
        </a>
    </div>

</asp:Content>