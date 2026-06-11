<%@ Page Language="C#" MasterPageFile="~/student/MasterPage.master" AutoEventWireup="true" CodeFile="home.aspx.cs" Inherits="student_home" %>

<asp:Content ID="Content1" ContentPlaceHolderID="title" runat="server">我的宿舍 - 智慧宿舍</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="head" runat="server">
    <link href="/css/student.css" rel="stylesheet" />
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <div class="hero-card">
        <div class="hero-card-title">我的宿舍</div>
        <div class="hero-card-value"><asp:Literal ID="litDormInfo" runat="server" Text="暂未分配宿舍" /></div>
        <div class="hero-card-subtitle"><asp:Literal ID="litBedInfo" runat="server" Text="请等待管理员分配" /></div>
    </div>

    <div class="feature-grid">
        <div class="feature-card" onclick="location.href='/student/repair.aspx'">
            <div class="feature-card-icon green">
                <span class="material-symbols-outlined">build</span>
            </div>
            <div>
                <div class="feature-card-title">故障报修</div>
                <div class="feature-card-desc">提交报修申请</div>
            </div>
        </div>
        <div class="feature-card">
            <div class="feature-card-icon blue">
                <span class="material-symbols-outlined">star</span>
            </div>
            <div>
                <div class="feature-card-title">宿舍评分</div>
                <div class="feature-card-desc">94分 · 优秀</div>
            </div>
        </div>
        <div class="feature-card">
            <div class="feature-card-icon orange">
                <span class="material-symbols-outlined">payments</span>
            </div>
            <div>
                <div class="feature-card-title">住宿费</div>
                <div class="feature-card-desc">已缴纳 ¥1,200</div>
            </div>
        </div>
        <div class="feature-card">
            <div class="feature-card-icon purple">
                <span class="material-symbols-outlined">event</span>
            </div>
            <div>
                <div class="feature-card-title">宿舍预约</div>
                <div class="feature-card-desc">预约维修时间</div>
            </div>
        </div>
    </div>

    <div class="section-title">
        <span class="material-symbols-outlined" style="color: var(--primary);">group</span>
        我的室友
    </div>

    <div style="margin-bottom: 24px;">
        <asp:Repeater ID="rptRoommates" runat="server">
            <ItemTemplate>
                <div class="roommate-card">
                    <div class="roommate-avatar"><%# GetAvatarText(Eval("Name").ToString()) %></div>
                    <div class="roommate-info">
                        <div class="roommate-name"><%# Eval("Name") %></div>
                        <div class="roommate-detail"><%# Eval("College") %> · <%# Eval("Major") %> · <%# Eval("Grade") %></div>
                    </div>
                </div>
            </ItemTemplate>
        </asp:Repeater>
        <asp:Panel ID="pnlNoRoommate" runat="server" Visible="false">
            <div style="text-align: center; padding: 24px; color: var(--on-surface-variant);">
                <span class="material-symbols-outlined" style="font-size: 48px; opacity: 0.5;">group_off</span>
                <p style="margin-top: 8px;">暂无室友信息</p>
            </div>
        </asp:Panel>
    </div>

    <div class="section-title">
        <span class="material-symbols-outlined" style="color: var(--primary);">home_repair_service</span>
        设施状态
    </div>

    <div class="facility-list">
        <div class="facility-item">
            <div class="facility-dot ok"></div>
            <div class="facility-name">空调</div>
            <div class="facility-status">正常</div>
        </div>
        <div class="facility-item">
            <div class="facility-dot ok"></div>
            <div class="facility-name">热水器</div>
            <div class="facility-status">正常</div>
        </div>
        <div class="facility-item">
            <div class="facility-dot warning"></div>
            <div class="facility-name">照明</div>
            <div class="facility-status">等待维修</div>
        </div>
        <div class="facility-item">
            <div class="facility-dot ok"></div>
            <div class="facility-name">校园网</div>
            <div class="facility-status">正常</div>
        </div>
    </div>

</asp:Content>