<%@ Page Language="C#" MasterPageFile="~/admin/MasterPage.master" AutoEventWireup="true" CodeFile="allocation.aspx.cs" Inherits="admin_allocation" %>

<asp:Content ID="Content1" ContentPlaceHolderID="title" runat="server">宿舍分配 - SmartDorm</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="head" runat="server" />

<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <div class="page-header">
        <div>
            <h1 class="page-title">宿舍分配管理</h1>
            <p class="page-subtitle">管理学生宿舍分配和退宿操作</p>
        </div>
        <div class="flex gap-3">
            <button type="button" class="btn btn-ghost">
                <span class="material-symbols-outlined" style="font-size: 20px;">upload</span>
                批量导入
            </button>
            <button type="button" class="btn btn-ghost">
                <span class="material-symbols-outlined" style="font-size: 20px;">download</span>
                导出表格
            </button>
        </div>
    </div>

    <div class="filter-bar">
        <select class="filter-select">
            <option value="">全部楼栋</option>
            <option>A座</option>
            <option>B座</option>
            <option>C座</option>
            <option>D座</option>
        </select>
        <input type="text" class="filter-search" placeholder="搜索房间号...">
        <button type="button" class="btn btn-primary">
            <span class="material-symbols-outlined" style="font-size: 20px;">search</span>
            搜索
        </button>
    </div>

    <div class="card" style="padding: 48px; text-align: center;">
        <span class="material-symbols-outlined" style="font-size: 64px; color: var(--outline-variant);">bed</span>
        <h3 style="font-size: 18px; font-weight: 700; color: var(--on-surface); margin-top: 16px;">宿舍分配管理</h3>
        <p style="font-size: 14px; color: var(--on-surface-variant); margin-top: 8px;">功能开发中，敬请期待</p>
        <a href="/admin/dashboard.aspx" class="btn btn-outline" style="margin-top: 20px;">
            <span class="material-symbols-outlined" style="font-size: 20px;">arrow_back</span>
            返回仪表盘
        </a>
    </div>

</asp:Content>