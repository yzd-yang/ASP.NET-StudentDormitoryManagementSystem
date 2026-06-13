<%@ Page Language="C#" MasterPageFile="~/student/MasterPage.master" AutoEventWireup="true" CodeFile="notice-detail.aspx.cs" Inherits="student_notice_detail" ResponseEncoding="utf-8" %>

<asp:Content ID="Content1" ContentPlaceHolderID="title" runat="server">公告详情 - 智慧宿舍</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="head" runat="server">
    <style>
        .notice-detail-page { max-width:720px; margin:0 auto; }
        .notice-back { display:inline-flex; align-items:center; gap:6px; font-size:14px; font-weight:600; color:var(--on-surface-variant); text-decoration:none; padding:8px 0; margin-bottom:16px; }
        .notice-back:hover { color:var(--primary); }
        .notice-detail-card {
            background:rgba(255,255,255,0.7); backdrop-filter:blur(12px); -webkit-backdrop-filter:blur(12px);
            border:1px solid rgba(255,255,255,0.42); border-radius:24px; box-shadow:0 1px 8px rgba(0,0,0,0.04);
            padding:32px;
        }
        .notice-detail-title { font-size:24px; font-weight:700; color:var(--on-surface); margin-bottom:12px; line-height:1.4; }
        .notice-detail-meta { display:flex; align-items:center; gap:16px; font-size:13px; color:var(--on-surface-variant); margin-bottom:24px; padding-bottom:20px; border-bottom:1px solid rgba(0,0,0,0.06); }
        .notice-detail-meta span { display:inline-flex; align-items:center; gap:4px; }
        .notice-detail-content { font-size:15px; line-height:1.8; color:var(--on-surface); word-break:break-word; }
        .notice-detail-content p { margin-bottom:12px; }
        .notice-empty { text-align:center; padding:60px 20px; color:var(--on-surface-variant); }
        .notice-empty .material-symbols-outlined { font-size:48px; opacity:0.3; display:block; margin-bottom:12px; }
        @media (max-width:767px) {
            .notice-detail-card { padding:20px; border-radius:20px; }
            .notice-detail-title { font-size:20px; }
        }
    </style>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="notice-detail-page">
        <a href="home.aspx" class="notice-back">
            <span class="material-symbols-outlined" style="font-size:20px;">arrow_back</span>
            返回首页
        </a>

        <asp:Panel ID="pnlNotice" runat="server" CssClass="notice-detail-card" Visible="false">
            <h1 class="notice-detail-title"><asp:Literal ID="litTitle" runat="server" /></h1>
            <div class="notice-detail-meta">
                <span><span class="material-symbols-outlined" style="font-size:16px;">person</span> <asp:Literal ID="litAdmin" runat="server" /></span>
                <span><span class="material-symbols-outlined" style="font-size:16px;">schedule</span> <asp:Literal ID="litTime" runat="server" /></span>
                <span><span class="material-symbols-outlined" style="font-size:16px;">label</span> <asp:Literal ID="litCategory" runat="server" /></span>
            </div>
            <div class="notice-detail-content"><asp:Literal ID="litContent" runat="server" /></div>
        </asp:Panel>

        <asp:Panel ID="pnlEmpty" runat="server" CssClass="notice-empty" Visible="false">
            <span class="material-symbols-outlined">error_outline</span>
            <span>公告不存在或已删除</span>
        </asp:Panel>
    </div>
</asp:Content>
