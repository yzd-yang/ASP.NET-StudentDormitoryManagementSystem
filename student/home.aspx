<%@ Page Language="C#" MasterPageFile="~/student/MasterPage.master" AutoEventWireup="true" CodeFile="home.aspx.cs" Inherits="student_home" ResponseEncoding="utf-8" %>

<asp:Content ID="Content1" ContentPlaceHolderID="title" runat="server">我的宿舍 - 智慧宿舍</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="head" runat="server">
    <link href="/css/student.css" rel="stylesheet" />
    <style>
        .dorm-hero {
            position: relative;
            border-radius: 24px;
            overflow: hidden;
            height: 220px;
            margin-bottom: 24px;
            display: flex;
            flex-direction: column;
            justify-content: flex-end;
            padding: 24px;
            background: linear-gradient(135deg, #006b5c 0%, #49EACE 100%);
            color: #fff;
        }
        .dorm-hero::before {
            content: '';
            position: absolute;
            inset: 0;
            background: linear-gradient(to top, rgba(0,0,0,0.6) 0%, transparent 60%);
        }
        .dorm-hero-content { position: relative; z-index: 1; }
        .dorm-hero h1 { font-size: 24px; font-weight: 800; margin-bottom: 8px; }
        .dorm-hero-meta { display: flex; gap: 20px; opacity: 0.9; font-size: 15px; }
        .dorm-hero-meta span { display: flex; align-items: center; gap: 6px; }

        .score-card {
            background: rgba(255,255,255,0.6);
            backdrop-filter: blur(8px);
            border: 1px solid rgba(255,255,255,0.5);
            border-radius: 20px;
            padding: 20px;
        }
        .score-card-header { display: flex; justify-content: space-between; align-items: start; margin-bottom: 12px; }
        .score-card-title { font-size: 16px; font-weight: 700; color: var(--on-surface); }
        .score-card-sub { font-size: 13px; color: var(--on-surface-variant); margin-top: 2px; }
        .score-value { font-size: 48px; font-weight: 800; color: var(--on-surface); line-height: 1; }
        .score-tag { display: inline-block; padding: 4px 12px; border-radius: 20px; font-size: 12px; font-weight: 700; background: rgba(73,234,206,0.15); color: #006b5c; }

        .roommate-section { margin-top: 24px; }
        .roommate-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 12px; }
        .roommate-item {
            display: flex; align-items: center; gap: 12px; padding: 14px;
            background: rgba(255,255,255,0.5); border-radius: 16px;
            border: 1px solid rgba(255,255,255,0.4); transition: all 0.2s;
        }
        .roommate-item:hover { border-color: var(--primary); background: rgba(255,255,255,0.7); }
        .roommate-item.self { border: 2px solid var(--primary); background: rgba(73,234,206,0.05); }
        .roommate-avatar { width: 48px; height: 48px; border-radius: 50%; background: linear-gradient(135deg, var(--primary), var(--primary-dark)); display: flex; align-items: center; justify-content: center; color: var(--on-primary); font-weight: 700; font-size: 18px; flex-shrink: 0; }
        .roommate-name { font-size: 15px; font-weight: 700; color: var(--on-surface); }
        .roommate-detail { font-size: 13px; color: var(--on-surface-variant); }
        .roommate-badge { font-size: 10px; padding: 2px 8px; border-radius: 10px; background: var(--primary); color: var(--on-primary); font-weight: 700; }

        .facility-section { margin-top: 24px; }
        .facility-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 10px; }
        .facility-item {
            display: flex; align-items: center; justify-content: space-between;
            padding: 14px 16px; background: rgba(255,255,255,0.5); border-radius: 14px;
            border: 1px solid rgba(255,255,255,0.4);
        }
        .facility-item.error { border-color: rgba(186,26,26,0.15); background: rgba(186,26,26,0.03); }
        .facility-left { display: flex; align-items: center; gap: 10px; }
        .facility-icon { width: 36px; height: 36px; border-radius: 10px; display: flex; align-items: center; justify-content: center; }
        .facility-icon.green { background: rgba(73,234,206,0.12); color: var(--primary); }
        .facility-icon.red { background: rgba(186,26,26,0.08); color: var(--error); }
        .facility-name { font-size: 14px; font-weight: 600; color: var(--on-surface); }
        .facility-status { font-size: 12px; font-weight: 600; padding: 3px 10px; border-radius: 10px; }
        .facility-status.ok { background: rgba(73,234,206,0.12); color: #006b5c; }
        .facility-status.error { background: rgba(186,26,26,0.08); color: var(--error); }

        .quick-tools { display: grid; grid-template-columns: 1fr 1fr; gap: 10px; margin-top: 24px; }
        .quick-tool {
            display: flex; flex-direction: column; align-items: center; gap: 8px;
            padding: 16px; background: rgba(255,255,255,0.5); border-radius: 14px;
            border: 1px solid rgba(255,255,255,0.4); cursor: pointer; transition: all 0.2s; text-decoration: none;
        }
        .quick-tool:hover { background: rgba(73,234,206,0.08); border-color: var(--primary); }
        .quick-tool-icon { font-size: 28px; color: var(--primary); }
        .quick-tool-label { font-size: 13px; font-weight: 600; color: var(--on-surface-variant); }

        .report-btn {
            width: 100%; padding: 14px; background: var(--primary); color: var(--on-primary);
            border: none; border-radius: 16px; font-size: 15px; font-weight: 700; cursor: pointer;
            display: flex; align-items: center; justify-content: center; gap: 8px;
            margin-top: 16px; box-shadow: 0 4px 16px rgba(73,234,206,0.3); transition: all 0.2s;
        }
        .report-btn:hover { box-shadow: 0 6px 24px rgba(73,234,206,0.5); }
    </style>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <!-- 宿舍信息 Hero -->
    <div class="dorm-hero">
        <div class="dorm-hero-content">
            <h1>北校区 3号楼</h1>
            <div class="dorm-hero-meta">
                <span><span class="material-symbols-outlined" style="font-size:20px">meeting_room</span> 502-A 室</span>
                <span><span class="material-symbols-outlined" style="font-size:20px">bed</span> 02号床位</span>
            </div>
        </div>
    </div>

    <!-- 宿舍评分 -->
    <div style="margin-bottom:24px;">
        <div class="score-card">
            <div class="score-card-header">
                <div>
                    <div class="score-card-title">宿舍评分</div>
                    <div class="score-card-sub">基于本月卫生与安全周检</div>
                </div>
                <span class="material-symbols-outlined" style="color:var(--primary); font-size:36px" data-icon="stars">stars</span>
            </div>
            <div style="display:flex; align-items:end; gap:10px; margin-bottom:14px;">
                <span class="score-value">94</span>
                <div style="margin-bottom:4px;">
                    <span class="score-tag">优秀</span>
                    <div style="font-size:12px; color:var(--on-surface-variant); margin-top:4px;">超过 85% 的宿舍</div>
                </div>
            </div>
            <button class="btn btn-primary w-full" style="width:100%; border-radius:14px;">查看详细自查报告</button>
        </div>
    </div>

    <!-- 我的室友 -->
    <div class="roommate-section">
        <div class="section-title">
            <span class="material-symbols-outlined" style="color:var(--primary);">group</span>
            我的室友 (4)
        </div>
        <div class="roommate-grid">
            <div class="roommate-item self">
                <div class="roommate-avatar">张</div>
                <div>
                    <div style="display:flex; align-items:center; gap:6px;">
                        <span class="roommate-name">张伟</span>
                        <span class="roommate-badge">我</span>
                    </div>
                    <div class="roommate-detail">计算机科学与技术 · 2022级</div>
                </div>
            </div>
            <div class="roommate-item">
                <div class="roommate-avatar">李</div>
                <div>
                    <div class="roommate-name">李明</div>
                    <div class="roommate-detail">自动化 · 2022级</div>
                </div>
            </div>
            <div class="roommate-item">
                <div class="roommate-avatar">王</div>
                <div>
                    <div class="roommate-name">王小红</div>
                    <div class="roommate-detail">数字媒体艺术 · 2022级</div>
                </div>
            </div>
            <div class="roommate-item">
                <div class="roommate-avatar">赵</div>
                <div>
                    <div class="roommate-name">赵强</div>
                    <div class="roommate-detail">电子信息工程 · 2022级</div>
                </div>
            </div>
        </div>
    </div>

    <!-- 设施状态 -->
    <div class="facility-section">
        <div class="section-title">
            <span class="material-symbols-outlined" style="color:var(--primary);">construction</span>
            设施状态
        </div>
        <div class="facility-grid">
            <div class="facility-item">
                <div class="facility-left">
                    <div class="facility-icon green"><span class="material-symbols-outlined">ac_unit</span></div>
                    <span class="facility-name">空调系统</span>
                </div>
                <span class="facility-status ok">运行正常</span>
            </div>
            <div class="facility-item">
                <div class="facility-left">
                    <div class="facility-icon green"><span class="material-symbols-outlined">water_drop</span></div>
                    <span class="facility-name">热水器</span>
                </div>
                <span class="facility-status ok">运行正常</span>
            </div>
            <div class="facility-item error">
                <div class="facility-left">
                    <div class="facility-icon red"><span class="material-symbols-outlined">lightbulb</span></div>
                    <span class="facility-name">照明设施</span>
                </div>
                <span class="facility-status error">等待维修</span>
            </div>
            <div class="facility-item">
                <div class="facility-left">
                    <div class="facility-icon green"><span class="material-symbols-outlined">wifi</span></div>
                    <span class="facility-name">校园网</span>
                </div>
                <span class="facility-status ok">连接稳定</span>
            </div>
        </div>
        <a href="repair.aspx" class="report-btn">
            <span class="material-symbols-outlined">add_circle</span>
            提交报修申请
        </a>
    </div>

    <!-- 快捷工具 -->
    <div class="quick-tools">
        <a href="#" class="quick-tool">
            <span class="material-symbols-outlined quick-tool-icon">event_available</span>
            <span class="quick-tool-label">宿舍预约</span>
        </a>
        <a href="#" class="quick-tool">
            <span class="material-symbols-outlined quick-tool-icon">policy</span>
            <span class="quick-tool-label">管理规章</span>
        </a>
    </div>
</asp:Content>
