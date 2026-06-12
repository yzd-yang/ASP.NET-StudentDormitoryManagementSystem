<%@ Page Language="C#" MasterPageFile="~/admin/MasterPage.master" AutoEventWireup="true" CodeFile="batch.aspx.cs" Inherits="admin_batch" ResponseEncoding="utf-8" %>

<asp:Content ID="Content1" ContentPlaceHolderID="title" runat="server">选宿批次管理 - SmartDorm</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="head" runat="server">
    <style>
        .batch-stats { display:grid; grid-template-columns:repeat(4,1fr); gap:16px; margin-bottom:24px; }
        .batch-stat { background:rgba(255,255,255,0.6); backdrop-filter:blur(8px); border-radius:16px; padding:18px; border:1px solid rgba(255,255,255,0.5); display:flex; align-items:center; gap:14px; }
        .batch-stat-icon { width:48px; height:48px; border-radius:12px; display:flex; align-items:center; justify-content:center; }
        .batch-stat-icon .material-symbols-outlined { font-size:24px; }
        .batch-stat-label { font-size:13px; color:var(--on-surface-variant); }
        .batch-stat-value { font-size:24px; font-weight:800; color:var(--on-surface); }

        .batch-filter { background:rgba(255,255,255,0.5); backdrop-filter:blur(8px); border-radius:16px; padding:18px; border:1px solid rgba(255,255,255,0.4); display:flex; flex-wrap:wrap; gap:14px; align-items:end; margin-bottom:20px; }
        .batch-filter-field { display:flex; flex-direction:column; gap:4px; flex:1; min-width:160px; }
        .batch-filter-field label { font-size:12px; font-weight:700; color:var(--on-surface-variant); text-transform:uppercase; letter-spacing:0.05em; }
        .batch-filter-field select, .batch-filter-field input {
            padding:10px 14px; border:none; border-radius:10px; background:#FFF9E6;
            font-family:inherit; font-size:14px; color:var(--on-surface); outline:none;
        }
        .batch-filter-btn {
            padding:10px 20px; background:rgba(73,234,206,0.12); color:var(--primary); border:1px solid rgba(73,234,206,0.3);
            border-radius:10px; font-size:14px; font-weight:700; cursor:pointer; display:flex; align-items:center; gap:6px; font-family:inherit;
        }
        .batch-filter-reset { padding:10px 16px; background:transparent; color:var(--on-surface-variant); border:none; border-radius:10px; font-size:14px; font-weight:600; cursor:pointer; font-family:inherit; }

        .batch-table-card { background:rgba(255,255,255,0.6); backdrop-filter:blur(12px); border-radius:16px; border:1px solid rgba(255,255,255,0.5); overflow:hidden; }
        .batch-table-header { display:flex; justify-content:space-between; align-items:center; padding:18px 24px; border-bottom:1px solid rgba(0,0,0,0.05); }
        .batch-table-header h3 { font-size:18px; font-weight:700; color:var(--on-surface); }
        .batch-table { width:100%; border-collapse:collapse; }
        .batch-table th { padding:14px 24px; text-align:left; font-size:13px; font-weight:700; color:var(--on-surface-variant); text-transform:uppercase; letter-spacing:0.05em; background:rgba(232,233,236,0.4); }
        .batch-table td { padding:18px 24px; font-size:14px; color:var(--on-surface); border-bottom:1px solid rgba(0,0,0,0.03); }
        .batch-table tr:hover td { background:rgba(73,234,206,0.04); }
        .batch-table-name { font-size:15px; font-weight:700; color:var(--on-surface); }
        .batch-table-id { font-size:12px; color:var(--on-surface-variant); opacity:0.6; margin-top:2px; }
        .batch-table-scope { font-size:14px; }
        .batch-table-sub { font-size:12px; color:var(--on-surface-variant); margin-top:2px; }
        .batch-time { font-size:13px; display:flex; align-items:center; gap:6px; }
        .batch-time .material-symbols-outlined { font-size:16px; }
        .batch-tags { display:flex; flex-wrap:wrap; gap:4px; }
        .batch-tag { padding:2px 8px; border-radius:4px; font-size:11px; font-weight:700; }
        .batch-tag.green { background:rgba(221,231,197,0.6); color:var(--on-surface); }
        .batch-tag.purple { background:rgba(219,206,221,0.6); color:var(--on-surface); }
        .batch-status-pill { padding:4px 12px; border-radius:20px; font-size:12px; font-weight:700; }
        .batch-status-pill.active { background:rgba(73,234,206,0.15); color:#006b5c; border:1px solid rgba(73,234,206,0.3); }
        .batch-status-pill.upcoming { background:rgba(255,183,77,0.12); color:#b58900; border:1px solid rgba(255,183,77,0.2); }
        .batch-status-pill.ended { background:rgba(232,233,236,0.6); color:var(--on-surface-variant); border:1px solid rgba(0,0,0,0.06); }
        .batch-action-btns { display:flex; gap:4px; justify-content:flex-end; }
        .batch-action-btn { padding:8px; border:none; background:transparent; border-radius:8px; cursor:pointer; color:var(--on-surface-variant); transition:all 0.2s; }
        .batch-action-btn:hover { background:rgba(73,234,206,0.12); color:var(--primary); }
        .batch-action-btn.delete:hover { background:rgba(186,26,26,0.08); color:var(--error); }
        .batch-action-btn .material-symbols-outlined { font-size:20px; }

        .create-btn {
            display:flex; align-items:center; gap:8px; padding:12px 24px; background:var(--primary); color:var(--on-primary);
            border:none; border-radius:14px; font-size:14px; font-weight:700; cursor:pointer; box-shadow:0 4px 12px rgba(73,234,206,0.3); font-family:inherit;
        }

        .modal-overlay { display:none; position:fixed; inset:0; background:rgba(0,0,0,0.4); z-index:1000; align-items:center; justify-content:center; backdrop-filter:blur(4px); }
        .modal-overlay.show { display:flex; }
        .modal-card { background:#fff; border-radius:24px; max-width:600px; width:90%; max-height:85vh; overflow-y:auto; box-shadow:0 20px 60px rgba(0,0,0,0.2); }
        .modal-header { background:var(--primary); padding:20px 24px; display:flex; justify-content:space-between; align-items:center; color:var(--on-primary); }
        .modal-header h3 { font-size:18px; font-weight:700; }
        .modal-close { width:32px; height:32px; display:flex; align-items:center; justify-content:center; border:none; background:rgba(255,255,255,0.2); border-radius:50%; cursor:pointer; color:var(--on-primary); }
        .modal-body { padding:24px; }
        .modal-footer { padding:16px 24px; border-top:1px solid rgba(0,0,0,0.05); display:flex; justify-content:flex-end; gap:12px; }

        @media (max-width:768px) { .batch-stats { grid-template-columns:repeat(2,1fr); } }
    </style>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="page-header">
        <div>
            <h1 class="page-title">选宿批次管理</h1>
            <p class="page-subtitle">创建并管理全校宿舍分配的各个阶段批次。</p>
        </div>
        <button class="create-btn" onclick="document.getElementById('createModal').classList.add('show')">
            <span class="material-symbols-outlined">add_circle</span> 创建新批次
        </button>
    </div>

    <div class="batch-stats">
        <div class="batch-stat">
            <div class="batch-stat-icon" style="background:rgba(73,234,206,0.1);"><span class="material-symbols-outlined" style="color:var(--primary);">analytics</span></div>
            <div><div class="batch-stat-label">总批次</div><div class="batch-stat-value">12</div></div>
        </div>
        <div class="batch-stat">
            <div class="batch-stat-icon" style="background:rgba(73,234,206,0.15);"><span class="material-symbols-outlined" style="color:#006b5c;">bolt</span></div>
            <div><div class="batch-stat-label">进行中</div><div class="batch-stat-value">2</div></div>
        </div>
        <div class="batch-stat">
            <div class="batch-stat-icon" style="background:rgba(255,183,77,0.1);"><span class="material-symbols-outlined" style="color:#b58900;">schedule</span></div>
            <div><div class="batch-stat-label">待开始</div><div class="batch-stat-value">3</div></div>
        </div>
        <div class="batch-stat">
            <div class="batch-stat-icon" style="background:rgba(232,233,236,0.6);"><span class="material-symbols-outlined" style="color:var(--on-surface-variant);">check_circle</span></div>
            <div><div class="batch-stat-label">已结束</div><div class="batch-stat-value">7</div></div>
        </div>
    </div>

    <div class="batch-filter">
        <div class="batch-filter-field">
            <label>批次名称搜索</label>
            <input type="text" placeholder="输入批次名称..." />
        </div>
        <div class="batch-filter-field">
            <label>状态筛选</label>
            <select><option>全部</option><option>进行中</option><option>待开始</option><option>已结束</option></select>
        </div>
        <div class="batch-filter-field">
            <label>适用年级/学院</label>
            <select><option>全部范围</option><option>2024级</option><option>信息工程学院</option></select>
        </div>
        <button class="batch-filter-btn"><span class="material-symbols-outlined" style="font-size:16px;">filter_list</span> 筛选</button>
        <button class="batch-filter-reset">重置</button>
    </div>

    <div class="batch-table-card">
        <div class="batch-table-header"><h3>活跃批次列表</h3></div>
        <table class="batch-table">
            <thead>
                <tr><th>批次名称</th><th>适用范围</th><th>时间范围</th><th>资格限定</th><th>状态</th><th style="text-align:right;">操作</th></tr>
            </thead>
            <tbody>
                <tr>
                    <td><div class="batch-table-name">2024级新生第一批 (男生)</div><div class="batch-table-id">ID: BATCH-0982</div></td>
                    <td><div class="batch-table-scope">南区 1-5号楼</div><div class="batch-table-sub">共 450 间房</div></td>
                    <td>
                        <div class="batch-time"><span class="material-symbols-outlined" style="color:var(--primary);">calendar_today</span> 2024-08-20 09:00</div>
                        <div class="batch-time" style="margin-top:4px;"><span class="material-symbols-outlined" style="color:var(--error);">event_busy</span> 2024-08-22 18:00</div>
                    </td>
                    <td><div class="batch-tags"><span class="batch-tag green">2024级</span><span class="batch-tag purple">信息工程学院</span></div></td>
                    <td><span class="batch-status-pill active">进行中</span></td>
                    <td><div class="batch-action-btns">
                        <button class="batch-action-btn" title="查看"><span class="material-symbols-outlined">visibility</span></button>
                        <button class="batch-action-btn" title="编辑"><span class="material-symbols-outlined">edit</span></button>
                        <button class="batch-action-btn delete" title="删除"><span class="material-symbols-outlined">delete</span></button>
                    </div></td>
                </tr>
                <tr>
                    <td><div class="batch-table-name">2024级新生第二批 (女生)</div><div class="batch-table-id">ID: BATCH-0983</div></td>
                    <td><div class="batch-table-scope">北区 A, B, C栋</div><div class="batch-table-sub">共 320 间房</div></td>
                    <td>
                        <div class="batch-time"><span class="material-symbols-outlined">calendar_today</span> 2024-08-25 10:00</div>
                        <div class="batch-time" style="margin-top:4px;"><span class="material-symbols-outlined">event_busy</span> 2024-08-27 18:00</div>
                    </td>
                    <td><div class="batch-tags"><span class="batch-tag green">2024级</span><span class="batch-tag purple">艺术学院</span></div></td>
                    <td><span class="batch-status-pill upcoming">待开始</span></td>
                    <td><div class="batch-action-btns">
                        <button class="batch-action-btn"><span class="material-symbols-outlined">visibility</span></button>
                        <button class="batch-action-btn"><span class="material-symbols-outlined">edit</span></button>
                        <button class="batch-action-btn delete"><span class="material-symbols-outlined">delete</span></button>
                    </div></td>
                </tr>
                <tr>
                    <td><div class="batch-table-name">2023级老生补选</div><div class="batch-table-id">ID: BATCH-0981</div></td>
                    <td><div class="batch-table-scope">A座、B座</div><div class="batch-table-sub">共 200 间房</div></td>
                    <td>
                        <div class="batch-time"><span class="material-symbols-outlined">calendar_today</span> 2024-03-01 08:00</div>
                        <div class="batch-time" style="margin-top:4px;"><span class="material-symbols-outlined">event_busy</span> 2024-03-15 23:59</div>
                    </td>
                    <td><div class="batch-tags"><span class="batch-tag green">2023级</span></div></td>
                    <td><span class="batch-status-pill ended">已结束</span></td>
                    <td><div class="batch-action-btns">
                        <button class="batch-action-btn"><span class="material-symbols-outlined">visibility</span></button>
                        <button class="batch-action-btn delete"><span class="material-symbols-outlined">delete</span></button>
                    </div></td>
                </tr>
            </tbody>
        </table>
    </div>

    <!-- 创建新批次弹窗 -->
    <div class="modal-overlay" id="createModal">
        <div class="modal-card">
            <div class="modal-header">
                <h3>创建新批次</h3>
                <button class="modal-close" onclick="document.getElementById('createModal').classList.remove('show')"><span class="material-symbols-outlined">close</span></button>
            </div>
            <div class="modal-body">
                <div class="form-group"><label>批次名称</label><input class="form-input" type="text" placeholder="例如: 2024级大一新生秋季批次" /></div>
                <div class="form-row">
                    <div class="form-group"><label>选择楼栋</label><select class="form-select"><option>南区1号楼</option><option>南区2号楼</option><option>北区A栋</option></select></div>
                    <div class="form-group"><label>选择楼层</label><select class="form-select"><option>全部楼层</option><option>1F</option><option>2F</option><option>3F</option></select></div>
                </div>
                <div class="form-row">
                    <div class="form-group"><label>开始时间</label><input class="form-input" type="datetime-local" /></div>
                    <div class="form-group"><label>结束时间</label><input class="form-input" type="datetime-local" /></div>
                </div>
                <div class="form-row">
                    <div class="form-group"><label>学院</label><select class="form-select"><option>全部学院</option><option>信息工程学院</option><option>艺术学院</option></select></div>
                    <div class="form-group"><label>专业限定</label><select class="form-select"><option>无限制</option><option>计算机科学与技术</option></select></div>
                </div>
            </div>
            <div class="modal-footer">
                <button class="batch-filter-reset" onclick="document.getElementById('createModal').classList.remove('show')">取消</button>
                <button class="create-btn" onclick="document.getElementById('createModal').classList.remove('show')">确认创建批次</button>
            </div>
        </div>
    </div>
</asp:Content>
