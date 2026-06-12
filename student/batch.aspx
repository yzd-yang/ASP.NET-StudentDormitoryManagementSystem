<%@ Page Language="C#" MasterPageFile="~/student/MasterPage.master" AutoEventWireup="true" CodeFile="batch.aspx.cs" Inherits="student_batch" ResponseEncoding="utf-8" %>

<asp:Content ID="Content1" ContentPlaceHolderID="title" runat="server">选宿批次 - 智慧宿舍</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="head" runat="server">
    <style>
        .batch-header { margin-bottom:24px; }
        .batch-header h1 { font-size:32px; font-weight:800; color:var(--on-surface); }
        .batch-header p { font-size:16px; color:var(--on-surface-variant); margin-top:6px; }

        .filter-bar { background:rgba(255,255,255,0.5); backdrop-filter:blur(8px); border-radius:16px; padding:16px; border:1px solid rgba(255,255,255,0.4); margin-bottom:20px; display:grid; grid-template-columns:repeat(4,1fr) auto; gap:12px; align-items:end; }
        .filter-group { display:flex; flex-direction:column; gap:4px; }
        .filter-label { font-size:12px; font-weight:600; color:var(--on-surface-variant); }
        .filter-select, .filter-input {
            padding:10px 14px; border:none; border-radius:10px; background:#FFF9E6;
            font-family:inherit; font-size:14px; color:var(--on-surface); outline:none; transition:all 0.2s;
        }
        .filter-select:focus, .filter-input:focus { box-shadow:0 0 0 2px rgba(73,234,206,0.3); }
        .filter-btn {
            padding:10px 20px; background:var(--primary); color:var(--on-primary); border:none;
            border-radius:10px; font-size:14px; font-weight:700; cursor:pointer; display:flex;
            align-items:center; gap:6px; font-family:inherit;
        }

        .batch-table { background:rgba(255,255,255,0.5); backdrop-filter:blur(8px); border-radius:16px; border:1px solid rgba(255,255,255,0.4); overflow:hidden; }
        .batch-table table { width:100%; border-collapse:collapse; }
        .batch-table th {
            padding:14px 20px; text-align:left; font-size:13px; font-weight:700; color:var(--on-surface-variant);
            background:rgba(73,234,206,0.06); border-bottom:1px solid rgba(0,0,0,0.05);
        }
        .batch-table td { padding:14px 20px; font-size:14px; color:var(--on-surface); border-bottom:1px solid rgba(0,0,0,0.03); }
        .batch-table tr:hover td { background:rgba(73,234,206,0.04); }
        .batch-name { font-weight:700; }
        .batch-status { padding:4px 14px; border-radius:20px; font-size:13px; font-weight:700; }
        .batch-status.active { background:var(--primary); color:var(--on-primary); animation:pulse 2s infinite; }
        .batch-status.upcoming { background:rgba(232,233,236,0.8); color:var(--on-surface-variant); }
        @keyframes pulse { 0%,100%{opacity:1} 50%{opacity:0.7} }
        .batch-btn {
            padding:8px 18px; border:none; border-radius:10px; font-size:13px; font-weight:700;
            cursor:pointer; transition:all 0.2s; font-family:inherit;
        }
        .batch-btn.primary { background:var(--primary); color:var(--on-primary); }
        .batch-btn.ghost { background:rgba(232,233,236,0.6); color:var(--on-surface-variant); }

        .tip-card {
            background:rgba(255,255,255,0.5); backdrop-filter:blur(8px); border-radius:16px;
            padding:24px; border:1px solid rgba(255,255,255,0.4); display:flex; gap:20px;
            align-items:center; margin-top:32px;
        }
        .tip-icon { width:72px; height:72px; border-radius:50%; background:rgba(73,234,206,0.12); display:flex; align-items:center; justify-content:center; flex-shrink:0; }
        .tip-icon .material-symbols-outlined { font-size:36px; color:var(--primary); }
        .tip-title { font-size:18px; font-weight:700; color:var(--primary); margin-bottom:6px; }
        .tip-text { font-size:14px; color:var(--on-surface-variant); line-height:1.6; }
        .tip-link { color:var(--primary); font-size:14px; font-weight:600; text-decoration:underline; text-underline-offset:4px; margin-top:8px; display:inline-block; }
    </style>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="batch-header">
        <h1>选宿批次</h1>
        <p>当前没有已分配宿舍，请选择以下开放批次参与选宿。</p>
    </div>

    <div class="filter-bar">
        <div class="filter-group">
            <span class="filter-label">批次名称</span>
            <input class="filter-input" type="text" placeholder="搜索批次..." />
        </div>
        <div class="filter-group">
            <span class="filter-label">楼栋</span>
            <select class="filter-select">
                <option>全部楼栋</option><option>南区1号楼</option><option>南区2号楼</option><option>北区5号楼</option>
            </select>
        </div>
        <div class="filter-group">
            <span class="filter-label">适用学院</span>
            <select class="filter-select">
                <option>全部学院</option><option>信息工程学院</option><option>商学院</option><option>外国语学院</option>
            </select>
        </div>
        <div class="filter-group">
            <span class="filter-label">状态</span>
            <select class="filter-select">
                <option>全部状态</option><option>进行中</option><option>即将开始</option><option>已结束</option>
            </select>
        </div>
        <button class="filter-btn"><span class="material-symbols-outlined" style="font-size:18px;">filter_list</span> 筛选</button>
    </div>

    <div class="batch-table">
        <table>
            <thead>
                <tr>
                    <th>批次名称</th>
                    <th>楼栋</th>
                    <th>适用年级</th>
                    <th>专业限定</th>
                    <th>状态</th>
                    <th style="text-align:center;">操作</th>
                </tr>
            </thead>
            <tbody>
                <tr>
                    <td><span class="batch-name">2024级新生第一批 (男生)</span></td>
                    <td>南区 1-5号楼</td>
                    <td>2024级</td>
                    <td>不限专业</td>
                    <td><span class="batch-status active">进行中</span></td>
                    <td style="text-align:center;"><a href="grab-dorm.aspx" class="batch-btn primary">进入选宿</a></td>
                </tr>
                <tr>
                    <td><span class="batch-name">2024级新生第二批 (女生)</span></td>
                    <td>北区 1-3号楼</td>
                    <td>2024级</td>
                    <td>信息工程学院</td>
                    <td><span class="batch-status upcoming">即将开始</span></td>
                    <td style="text-align:center;"><button class="batch-btn ghost">查看详情</button></td>
                </tr>
                <tr>
                    <td><span class="batch-name">2023级老生补选</span></td>
                    <td>A座、B座</td>
                    <td>2023级</td>
                    <td>不限专业</td>
                    <td><span class="batch-status upcoming">已结束</span></td>
                    <td style="text-align:center;"><button class="batch-btn ghost">查看详情</button></td>
                </tr>
            </tbody>
        </table>
    </div>

    <div class="tip-card">
        <div class="tip-icon"><span class="material-symbols-outlined">info</span></div>
        <div>
            <div class="tip-title">选宿小贴士</div>
            <div class="tip-text">请确保您的网络环境稳定，提前了解心仪宿舍楼层及配置。若遇到问题，可点击右上角"帮助"或联系宿管中心。</div>
            <a href="#" class="tip-link">了解更多规则</a>
        </div>
    </div>
</asp:Content>
