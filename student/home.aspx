<%@ Page Language="C#" MasterPageFile="~/student/MasterPage.master" AutoEventWireup="true" CodeFile="home.aspx.cs" Inherits="student_home" ResponseEncoding="utf-8" %>

<asp:Content ID="Content1" ContentPlaceHolderID="title" runat="server">我的宿舍 - 智慧宿舍</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="head" runat="server">
    <link href="/css/student.css" rel="stylesheet" />
    <style>
        .glass-card {
            background: rgba(255, 255, 255, 0.7);
            backdrop-filter: blur(12px);
            -webkit-backdrop-filter: blur(12px);
            border: 1px solid rgba(255, 255, 255, 0.4);
        }
        .mint-gradient {
            background: linear-gradient(135deg, rgba(73, 234, 206, 0.15) 0%, rgba(255, 255, 255, 0.4) 100%);
        }

        /* Hero */
        .hero-section { margin-bottom: 32px; }
        .hero-wrap {
            position: relative; overflow: hidden; border-radius: 24px;
            height: 320px; display: flex; flex-direction: column; justify-content: flex-end;
            padding: 48px; box-shadow: 0 2px 12px rgba(0,0,0,0.06); border: 1px solid rgba(255,255,255,0.4);
        }
        .hero-bg {
            position: absolute; inset: 0; width: 100%; height: 100%; object-fit: cover;
            background: linear-gradient(135deg, #006b5c 0%, #49EACE 50%, #A7F3E7 100%);
        }
        .hero-overlay {
            position: absolute; inset: 0;
            background: linear-gradient(to top, rgba(0,0,0,0.6) 0%, rgba(0,0,0,0.2) 50%, transparent 100%);
        }
        .hero-content {
            position: relative; z-index: 1; color: #fff;
            display: flex; flex-direction: column; gap: 16px;
        }
        @media (min-width: 768px) {
            .hero-content { flex-direction: row; align-items: flex-end; justify-content: space-between; }
        }
        .hero-title { font-size: 48px; font-weight: 800; letter-spacing: -0.02em; margin-bottom: 8px; line-height: 1.1; }
        @media (max-width: 767px) { .hero-title { font-size: 28px; } }
        .hero-meta { display: flex; align-items: center; gap: 24px; opacity: 0.9; font-size: 18px; }
        .hero-meta-item { display: flex; align-items: center; gap: 8px; }
        .hero-btn {
            background: rgba(255,255,255,0.15); backdrop-filter: blur(8px);
            color: #fff; padding: 10px 24px; border-radius: 12px; font-size: 14px; font-weight: 600;
            border: 1px solid rgba(255,255,255,0.2); cursor: pointer; display: flex;
            align-items: center; gap: 8px; font-family: inherit; transition: all 0.2s;
            text-decoration: none;
        }
        .hero-btn:hover { background: rgba(255,255,255,0.25); }

        /* 3列卡片网格 */
        .cards-grid { display: grid; grid-template-columns: 1fr 1fr 1fr; gap: 20px; margin-bottom: 32px; }
        @media (max-width: 1024px) { .cards-grid { grid-template-columns: 1fr 1fr; } }
        @media (max-width: 767px) { .cards-grid { grid-template-columns: 1fr; } }

        /* Score card */
        .score-card { padding: 24px; border-radius: 24px; display: flex; flex-direction: column; justify-content: space-between; }
        .score-header { display: flex; justify-content: space-between; align-items: flex-start; margin-bottom: 24px; }
        .score-title { font-size: 18px; font-weight: 700; color: var(--on-surface); }
        .score-sub { font-size: 14px; color: var(--on-surface-variant); margin-top: 4px; }
        .score-icon { font-size: 40px; color: var(--primary); transition: transform 0.2s; }
        .score-card:hover .score-icon { transform: scale(1.1); }
        .score-row { display: flex; align-items: flex-end; gap: 12px; margin-bottom: 24px; }
        .score-num { font-size: 56px; font-weight: 800; color: var(--on-surface); line-height: 1; letter-spacing: -0.02em; }
        .score-label { color: #00a08e; font-size: 14px; font-weight: 600; }
        .score-hint { font-size: 12px; color: var(--on-surface-variant); margin-top: 2px; }
        .score-btn {
            width: 100%; padding: 16px; background: #49EACE; color: #000;
            border: none; border-radius: 16px; font-size: 14px; font-weight: 600;
            cursor: pointer; font-family: inherit; box-shadow: 0 4px 12px rgba(73,234,206,0.2);
            transition: all 0.2s;
        }
        .score-btn:hover { opacity: 0.9; }

        /* Payment card */
        .pay-card { padding: 24px; border-radius: 24px; display: flex; flex-direction: column; justify-content: space-between; }
        .pay-badge { display: inline-block; padding: 6px 16px; border-radius: 20px; font-size: 14px; font-weight: 700; background: rgba(73,234,206,0.15); color: #006658; text-transform: uppercase; letter-spacing: 0.05em; }
        .pay-divider { border-top: 1px solid rgba(73,234,206,0.1); margin-top: 24px; padding-top: 24px; display: flex; justify-content: space-between; align-items: center; }
        .pay-label { font-size: 14px; color: var(--on-surface-variant); }
        .pay-amount { font-size: 24px; font-weight: 700; color: var(--on-surface); margin-top: 4px; }
        .pay-link { color: var(--primary); font-size: 14px; font-weight: 600; text-decoration: none; }
        .pay-link:hover { text-decoration: underline; }

        /* Facility card */
        .facility-card { padding: 24px; border-radius: 24px; display: flex; flex-direction: column; height: 100%; }
        .facility-header { display: flex; align-items: center; justify-content: space-between; margin-bottom: 24px; }
        .facility-title { font-size: 24px; font-weight: 600; color: var(--on-surface); display: flex; align-items: center; gap: 12px; }
        .facility-sync { font-size: 12px; color: var(--on-surface-variant); }
        .facility-list { display: flex; flex-direction: column; gap: 16px; flex-grow: 1; }
        .facility-row {
            display: flex; align-items: center; justify-content: space-between;
            padding: 16px; border-radius: 16px; background: rgba(255,255,255,0.5);
            border: 1px solid rgba(255,255,255,0.5); transition: all 0.2s;
        }
        .facility-row:hover { box-shadow: 0 2px 8px rgba(0,0,0,0.04); border-color: var(--primary); }
        .facility-row.error { background: rgba(186,26,26,0.04); border-color: rgba(186,26,26,0.1); }
        .facility-left { display: flex; align-items: center; gap: 16px; }
        .facility-icon-wrap { width: 40px; height: 40px; border-radius: 12px; display: flex; align-items: center; justify-content: center; background: rgba(73,234,206,0.1); }
        .facility-icon-wrap.error { background: rgba(186,26,26,0.1); }
        .facility-icon-wrap .material-symbols-outlined { font-size: 22px; color: var(--primary); }
        .facility-icon-wrap.error .material-symbols-outlined { color: var(--error); }
        .facility-name { font-size: 14px; font-weight: 600; color: var(--on-surface); }
        .facility-badge { padding: 4px 12px; border-radius: 20px; font-size: 12px; font-weight: 700; }
        .facility-badge.ok { background: rgba(73,234,206,0.12); color: #00a08e; }
        .facility-badge.error { background: rgba(186,26,26,0.08); color: var(--error); }
        .repair-btn {
            width: 100%; margin-top: 32px; padding: 16px; background: #49EACE; color: #000;
            border: none; border-radius: 16px; font-size: 14px; font-weight: 600;
            cursor: pointer; display: flex; align-items: center; justify-content: center; gap: 12px;
            font-family: inherit; box-shadow: 0 4px 12px rgba(73,234,206,0.2); transition: all 0.2s;
            text-decoration: none;
        }
        .repair-btn:hover { opacity: 0.9; }

        /* Roommates */
        .roommate-section { padding: 32px; border-radius: 24px; margin-bottom: 32px; }
        .roommate-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 32px; }
        .roommate-title { font-size: 24px; font-weight: 600; color: var(--on-surface); display: flex; align-items: center; gap: 12px; }
        .roommate-action { color: var(--primary); font-size: 14px; font-weight: 600; background: none; border: none; cursor: pointer; padding: 8px 16px; border-radius: 12px; font-family: inherit; }
        .roommate-action:hover { background: rgba(73,234,206,0.1); }
        .roommate-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 20px; }
        @media (max-width: 767px) { .roommate-grid { grid-template-columns: 1fr; } }
        .roommate-card {
            display: flex; align-items: center; gap: 20px; padding: 20px;
            border-radius: 16px; border: 1px solid rgba(255,255,255,0.4);
            cursor: pointer; transition: all 0.2s;
        }
        .roommate-card:hover { border-color: var(--primary); background: rgba(255,255,255,0.6); }
        .roommate-card.self { border: 2px solid var(--primary); background: rgba(73,234,206,0.05); }
        .roommate-img { width: 64px; height: 64px; border-radius: 50%; object-fit: cover; box-shadow: 0 2px 8px rgba(0,0,0,0.1); border: 2px solid #fff; }
        .roommate-img.self { border: 2px solid var(--primary); }
        .roommate-name { font-size: 18px; font-weight: 600; color: var(--on-surface); display: flex; align-items: center; gap: 8px; }
        .roommate-badge { font-size: 10px; padding: 2px 8px; border-radius: 10px; background: #49EACE; color: #000; font-weight: 700; text-transform: uppercase; }
        .roommate-info { font-size: 16px; color: var(--on-surface-variant); margin-top: 4px; overflow: hidden; text-overflow: ellipsis; white-space: nowrap; }
    </style>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <!-- Hero Section -->
    <section class="hero-section">
        <div class="hero-wrap">
            <div class="hero-bg"></div>
            <div class="hero-overlay"></div>
            <div class="hero-content">
                <div>
                    <h1 class="hero-title">北校区 3号楼</h1>
                    <div class="hero-meta">
                        <span class="hero-meta-item">
                            <span class="material-symbols-outlined" style="font-size:24px;">meeting_room</span> 502-A 室
                        </span>
                        <span class="hero-meta-item">
                            <span class="material-symbols-outlined" style="font-size:24px;">bed</span> 02号床位
                        </span>
                    </div>
                </div>
                <div>
                    <a href="profile.aspx" class="hero-btn">
                        <span class="material-symbols-outlined" style="font-size:20px;">edit</span>
                        修改个人资料
                    </a>
                </div>
            </div>
        </div>
    </section>

    <!-- 3栏卡片：评分 + 缴费 + 设施 -->
    <div class="cards-grid">
        <!-- 评分卡片 -->
        <div class="glass-card score-card mint-gradient">
            <div class="score-header">
                <div>
                    <div class="score-title">宿舍评分</div>
                    <div class="score-sub">基于本月卫生与安全周检</div>
                </div>
                <span class="material-symbols-outlined score-icon" style="font-variation-settings:'FILL' 1;">stars</span>
            </div>
            <div class="score-row">
                <span class="score-num">94</span>
                <div>
                    <span class="score-label">优秀</span>
                    <div class="score-hint">超过 85% 的宿舍</div>
                </div>
            </div>
            <button class="score-btn">查看详细自查报告</button>
        </div>

        <!-- 缴费卡片 -->
        <div class="glass-card pay-card">
            <div class="score-header">
                <div>
                    <div class="score-title">住宿费缴纳</div>
                    <div class="score-sub">2023-2024 秋季学期</div>
                </div>
                <span class="material-symbols-outlined score-icon">payments</span>
            </div>
            <div>
                <span class="pay-badge">已缴纳</span>
            </div>
            <div class="pay-divider">
                <div>
                    <div class="pay-label">应缴合计</div>
                    <div class="pay-amount">¥ 1,200.00</div>
                </div>
                <a href="#" class="pay-link">查看流水</a>
            </div>
        </div>

        <!-- 设施状态卡片 -->
        <div class="glass-card facility-card">
            <div class="facility-header">
                <div class="facility-title">
                    <span class="material-symbols-outlined" style="color:var(--primary); font-size:32px;">construction</span>
                    设施状态
                </div>
                <span class="facility-sync">最后同步: 10:30 AM</span>
            </div>
            <div class="facility-list">
                <div class="facility-row">
                    <div class="facility-left">
                        <div class="facility-icon-wrap"><span class="material-symbols-outlined">ac_unit</span></div>
                        <span class="facility-name">空调系统</span>
                    </div>
                    <span class="facility-badge ok">运行正常</span>
                </div>
                <div class="facility-row">
                    <div class="facility-left">
                        <div class="facility-icon-wrap"><span class="material-symbols-outlined">water_drop</span></div>
                        <span class="facility-name">热水器</span>
                    </div>
                    <span class="facility-badge ok">运行正常</span>
                </div>
                <div class="facility-row error">
                    <div class="facility-left">
                        <div class="facility-icon-wrap error"><span class="material-symbols-outlined">lightbulb</span></div>
                        <span class="facility-name">照明设施</span>
                    </div>
                    <span class="facility-badge error">等待维修</span>
                </div>
                <div class="facility-row">
                    <div class="facility-left">
                        <div class="facility-icon-wrap"><span class="material-symbols-outlined">wifi</span></div>
                        <span class="facility-name">校园网</span>
                    </div>
                    <span class="facility-badge ok">连接稳定</span>
                </div>
            </div>
            <a href="repair.aspx" class="repair-btn">
                <span class="material-symbols-outlined">add_circle</span>
                提交报修申请
            </a>
        </div>
    </div>

    <!-- 室友区域 -->
    <section class="glass-card roommate-section">
        <div class="roommate-header">
            <h3 class="roommate-title">
                <span class="material-symbols-outlined" style="color:var(--primary); font-size:32px;">group</span>
                我的室友 (4)
            </h3>
            <button class="roommate-action">管理室友群组</button>
        </div>
        <div class="roommate-grid">
            <div class="roommate-card self">
                <img alt="Avatar" class="roommate-img self" src="https://lh3.googleusercontent.com/aida-public/AB6AXuCbyslLsMRvdDQq_i-6PIvqW1xXfMmd7WxPIeGnabDMXGzCuA9-O7FAym9RljAs_2k5b6WrIOb6YqK6q64e1Sq1my-_59ereVLVvaTLgug_Q_Sj-q1-0AvRjjMr2gNzpBQg7EudsswENo54KVSZdf4o9Qx6Z_90fK3dmzSm4sTVqqoRJ-q0QRfi5G3j0_x4vhAeJ1qx4A75Iutb4JgfvoC8EYh6Op38ZaV78Hk-dHWzNnpYZPoOJL0QTeX-6zRhL__e8MHGtX7yvg">
                <div style="overflow:hidden;">
                    <div class="roommate-name">张伟 <span class="roommate-badge">我</span></div>
                    <div class="roommate-info">计算机科学与技术 · 2022级</div>
                </div>
            </div>
            <div class="roommate-card">
                <img alt="Avatar" class="roommate-img" src="https://lh3.googleusercontent.com/aida-public/AB6AXuAH5e4C8gYf40--3ApLuzKEZTf-p6wWWPHbSDCm4kbhj05nSXVNdtuFE5bjrdeXXGfrFED2EmEka4kZT0hBXRUnMS739u_eAtkbcJWegN_emYA2VEKAJD8an7yojLzc8FhO0-Q1jbIXr2rQQtOgr6PNeFoMaAbPoAvlqjExRWkVagCtmJUPxEXvnW_PEgjaotmqw5AtSmRhEbUsqX68Etq7dEIcuHHphT1iuQ5bUhd0UU0WEE60wIZ_cgo7vEZJSoifMB9GOp8b7Q">
                <div style="overflow:hidden;">
                    <div class="roommate-name">李明</div>
                    <div class="roommate-info">自动化 · 2022级</div>
                </div>
            </div>
            <div class="roommate-card">
                <img alt="Avatar" class="roommate-img" src="https://lh3.googleusercontent.com/aida-public/AB6AXuCTm5Sk9ARTpp5s0xHxQPSx4Bh0953x7nB8RwxsD9Q7k9OD1LOFGoS8BEVUulTAqOqn3_9a6gmClWfBNA8lz1b8hwlB9I2bSQlyURp8QRlRpBHk-1YN_DBX6SVw0_6BNudb2ZhrOcG49QtRkYKUz1hi7-BGGscfJshWrM2JAhu5CMkCLsdffVRZix02Wi5_baNxJ3bONvM9y-mUYL1c77MyeIekT1RxnmS82Nk1_KQSueQlpaSUCGBx0fvb2cKLPN4Ovae0SsOBDw">
                <div style="overflow:hidden;">
                    <div class="roommate-name">王小红</div>
                    <div class="roommate-info">数字媒体艺术 · 2022级</div>
                </div>
            </div>
            <div class="roommate-card">
                <img alt="Avatar" class="roommate-img" src="https://lh3.googleusercontent.com/aida-public/AB6AXuC0_EK9SsDFP_SWZobyMpWArxj7idMqA0F2_G2PB87sdGm35kJ0AKByXVogQ_nWQprhrK8cmTRf3mD2ISXN_kef-LYgk6wxqlcDxNh561QJ3KUuOfi7CMI2Fye-FvupL5sG61RSsGnbIXK6KfMVz-iFjaqJu6Hhv8ybQ4rO8pyTjyl_2LueGR-NWixc-GtW13glph9_IQeoeMdu0GjGWbEouSOg_7iGoQKNXHbp-sH-Tk1X4NpsnJZe-qjNCMMyA-n1hc35Z7Rbkw">
                <div style="overflow:hidden;">
                    <div class="roommate-name">赵强</div>
                    <div class="roommate-info">电子信息工程 · 2022级</div>
                </div>
            </div>
        </div>
    </section>
</asp:Content>
