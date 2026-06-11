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
            <div class="stat-card-value">1,240</div>
        </div>
        <div class="stat-card">
            <div class="stat-card-icon blue">
                <span class="material-symbols-outlined">group</span>
            </div>
            <div class="stat-card-label">在宿学生</div>
            <div class="stat-card-value">4,812</div>
        </div>
        <div class="stat-card">
            <div class="stat-card-icon green">
                <span class="material-symbols-outlined">bed</span>
            </div>
            <div class="stat-card-label">空余床位</div>
            <div class="stat-card-value">148</div>
        </div>
        <div class="stat-card">
            <div class="stat-card-icon orange">
                <span class="material-symbols-outlined">build</span>
            </div>
            <div class="stat-card-label">今日报修</div>
            <div class="stat-card-value">14</div>
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
                        <div style="font-size: 11px; opacity: 0.8;">当前有 2 个紧急工单</div>
                    </div>
                </a>
                <a href="/admin/allocation.aspx" class="btn btn-outline" style="justify-content: flex-start; padding: 16px 20px; border-radius: 16px;">
                    <span class="material-symbols-outlined" style="color: var(--primary);">rule</span>
                    <div style="text-align: left;">
                        <div style="font-weight: 700;">审批入住变更</div>
                        <div style="font-size: 11px; color: var(--on-surface-variant);">待审批申请: 5 份</div>
                    </div>
                </a>
                <a href="/admin/notice.aspx" class="btn btn-ghost" style="justify-content: flex-start; padding: 16px 20px; border-radius: 16px;">
                    <span class="material-symbols-outlined">campaign</span>
                    <div style="text-align: left;">
                        <div style="font-weight: 700;">发布宿舍公告</div>
                        <div style="font-size: 11px; color: var(--on-surface-variant);">通知全体在校学生</div>
                    </div>
                </a>
            </div>
        </div>

        <div class="card" style="padding: 24px;">
            <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px;">
                <h3 style="font-size: 18px; font-weight: 700;">实时动态</h3>
                <div style="width: 8px; height: 8px; background: var(--primary); border-radius: 50%; animation: pulse 2s infinite;"></div>
            </div>
            <div style="display: flex; flex-direction: column; gap: 4px;">
                <div style="display: flex; gap: 12px; padding: 12px; border-radius: 12px;">
                    <div style="width: 40px; height: 40px; border-radius: 50%; background: rgba(73,234,206,0.15); display: flex; align-items: center; justify-content: center; flex-shrink: 0;">
                        <span class="material-symbols-outlined" style="font-size: 20px; color: var(--primary);">check_circle</span>
                    </div>
                    <div style="flex: 1;">
                        <div style="font-size: 14px; font-weight: 600;">报修已完成: A-302 空调</div>
                        <div style="font-size: 12px; color: var(--on-surface-variant); margin-top: 2px;">维修工 李师傅 · 15分钟前</div>
                    </div>
                </div>
                <div style="display: flex; gap: 12px; padding: 12px; border-radius: 12px;">
                    <div style="width: 40px; height: 40px; border-radius: 50%; background: rgba(186,26,26,0.1); display: flex; align-items: center; justify-content: center; flex-shrink: 0;">
                        <span class="material-symbols-outlined" style="font-size: 20px; color: var(--error);">bolt</span>
                    </div>
                    <div style="flex: 1;">
                        <div style="font-size: 14px; font-weight: 600; color: var(--error);">预警：异常用电 C-115</div>
                        <div style="font-size: 12px; color: var(--on-surface-variant); margin-top: 2px;">瞬时功率超标 · 42分钟前</div>
                    </div>
                </div>
                <div style="display: flex; gap: 12px; padding: 12px; border-radius: 12px;">
                    <div style="width: 40px; height: 40px; border-radius: 50%; background: rgba(73,234,206,0.15); display: flex; align-items: center; justify-content: center; flex-shrink: 0;">
                        <span class="material-symbols-outlined" style="font-size: 20px; color: var(--primary);">person_add</span>
                    </div>
                    <div style="flex: 1;">
                        <div style="font-size: 14px; font-weight: 600;">新申请：留学生入住</div>
                        <div style="font-size: 12px; color: var(--on-surface-variant); margin-top: 2px;">待管理员审核 · 1小时前</div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <style>
        @@keyframes pulse {
            0%, 100% { opacity: 1; }
            50% { opacity: 0.5; }
        }
    </style>

</asp:Content>