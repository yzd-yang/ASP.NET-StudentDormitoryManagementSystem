<%@ Page Language="C#" MasterPageFile="~/admin/MasterPage.master" AutoEventWireup="true" CodeFile="system.aspx.cs" Inherits="admin_system" ResponseEncoding="utf-8" %>

<asp:Content ID="Content1" ContentPlaceHolderID="title" runat="server">系统管理 - SmartDorm</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="head" runat="server">
    <style>
        .sys-section { background:rgba(255,255,255,0.6); backdrop-filter:blur(12px); border-radius:16px; padding:24px; border:1px solid rgba(255,255,255,0.5); margin-bottom:20px; }
        .sys-section-title { font-size:18px; font-weight:700; color:var(--primary); margin-bottom:20px; }

        .sys-filter { display:flex; flex-wrap:wrap; gap:12px; align-items:center; margin-bottom:20px; }
        .sys-filter-field { position:relative; }
        .sys-filter-field .material-symbols-outlined { position:absolute; left:12px; top:50%; transform:translateY(-50%); font-size:20px; color:var(--outline); }
        .sys-filter-input { padding:10px 14px 10px 40px; border:none; border-radius:10px; background:#FFF9E6; font-family:inherit; font-size:14px; width:220px; outline:none; }
        .sys-filter-input:focus { box-shadow:0 0 0 2px rgba(73,234,206,0.3); }
        .sys-filter-select { padding:10px 14px; border:none; border-radius:10px; background:#FFF9E6; font-family:inherit; font-size:14px; outline:none; min-width:130px; }
        .sys-add-btn {
            display:flex; align-items:center; gap:6px; padding:10px 20px; background:var(--primary); color:var(--on-primary);
            border:none; border-radius:10px; font-size:14px; font-weight:700; cursor:pointer; margin-left:auto; font-family:inherit;
        }

        .sys-table { width:100%; border-collapse:collapse; }
        .sys-table th { padding:12px 16px; text-align:left; font-size:13px; font-weight:700; color:var(--on-surface-variant); border-bottom:1px solid rgba(0,0,0,0.05); }
        .sys-table td { padding:14px 16px; font-size:14px; color:var(--on-surface); border-bottom:1px solid rgba(0,0,0,0.03); }
        .sys-table tr:hover td { background:rgba(73,234,206,0.04); }
        .sys-role-badge { display:inline-block; padding:3px 10px; border-radius:20px; font-size:12px; font-weight:700; }
        .sys-role-badge.admin { background:rgba(219,206,221,0.5); color:var(--on-surface); }
        .sys-role-badge.manager { background:rgba(221,231,197,0.5); color:var(--on-surface); }
        .sys-role-badge.worker { background:rgba(73,234,206,0.12); color:var(--primary); }
        .sys-status { display:flex; align-items:center; gap:6px; font-size:14px; font-weight:600; color:var(--primary); }
        .sys-status-dot { width:8px; height:8px; border-radius:50%; background:var(--primary); }
        .sys-action-link { font-size:13px; font-weight:700; cursor:pointer; background:none; border:none; font-family:inherit; padding:0 4px; }
        .sys-action-link.edit { color:var(--primary); }
        .sys-action-link.reset { color:var(--on-surface-variant); }
        .sys-action-link.delete { color:var(--error); }

        .sys-grid { display:grid; grid-template-columns:1fr 1.5fr 0.8fr; gap:20px; }
        .sys-card { background:rgba(255,255,255,0.6); backdrop-filter:blur(12px); border-radius:16px; padding:20px; border:1px solid rgba(255,255,255,0.5); }
        .sys-card-title { font-size:15px; font-weight:700; color:var(--on-surface); margin-bottom:16px; display:flex; justify-content:space-between; align-items:center; }
        .sys-add-icon { width:28px; height:28px; display:flex; align-items:center; justify-content:center; border:none; background:transparent; border-radius:50%; cursor:pointer; color:var(--primary); }
        .sys-add-icon:hover { background:rgba(73,234,206,0.1); }

        .building-item {
            display:flex; align-items:center; justify-content:space-between; padding:14px;
            background:rgba(255,255,255,0.6); border-radius:12px; margin-bottom:10px; border:1px solid rgba(255,255,255,0.4); transition:all 0.2s;
        }
        .building-item:hover { background:rgba(255,255,255,0.8); }
        .building-left { display:flex; align-items:center; gap:12px; }
        .building-icon { width:44px; height:44px; border-radius:10px; background:rgba(73,234,206,0.12); display:flex; align-items:center; justify-content:center; }
        .building-icon .material-symbols-outlined { color:var(--primary); font-size:24px; }
        .building-name { font-size:14px; font-weight:700; color:var(--on-surface); }
        .building-sub { font-size:12px; color:var(--on-surface-variant); }
        .building-actions { display:flex; gap:4px; opacity:0; transition:opacity 0.2s; }
        .building-item:hover .building-actions { opacity:1; }
        .building-action-btn { padding:6px; border:none; background:transparent; border-radius:6px; cursor:pointer; color:var(--on-surface-variant); }
        .building-action-btn:hover { background:rgba(0,0,0,0.04); }
        .building-action-btn.delete:hover { color:var(--error); background:rgba(186,26,26,0.06); }
        .building-action-btn .material-symbols-outlined { font-size:18px; }

        .building-add {
            padding:14px; border:2px dashed rgba(107,122,118,0.3); border-radius:12px; display:flex;
            align-items:center; justify-content:center; gap:6px; color:var(--outline); font-size:14px; font-weight:600; cursor:pointer;
        }
        .building-add:hover { border-color:var(--primary); color:var(--primary); }

        .batch-gen-form { display:flex; flex-direction:column; gap:14px; }
        .batch-gen-row { display:grid; grid-template-columns:1fr 1fr; gap:12px; }
        .batch-gen-row-3 { display:flex; gap:8px; }
        .batch-gen-row-3 span { display:flex; align-items:center; color:var(--on-surface-variant); }
        .batch-gen-input { width:100%; padding:10px 14px; border:none; border-radius:10px; background:#FFF9E6; font-family:inherit; font-size:14px; outline:none; }
        .batch-gen-input:focus { box-shadow:0 0 0 2px rgba(73,234,206,0.3); }
        .batch-gen-preview {
            padding:14px; background:rgba(232,233,236,0.4); border-radius:12px; border:1px solid rgba(0,0,0,0.04);
        }
        .batch-gen-preview-label { font-size:13px; font-weight:600; color:var(--on-surface-variant); margin-bottom:8px; }
        .batch-gen-tags { display:flex; flex-wrap:wrap; gap:6px; margin-bottom:8px; }
        .batch-gen-tag { padding:4px 10px; border-radius:6px; font-size:12px; background:rgba(255,255,255,0.7); border:1px solid rgba(0,0,0,0.04); }
        .batch-gen-summary { font-size:13px; color:var(--primary); font-weight:600; }
        .batch-gen-btn {
            width:100%; padding:12px; background:var(--primary); color:var(--on-primary); border:none;
            border-radius:10px; font-size:14px; font-weight:700; cursor:pointer; font-family:inherit;
        }

        .dept-tree { max-height:350px; overflow-y:auto; }
        .dept-group { margin-bottom:8px; }
        .dept-header { display:flex; align-items:center; gap:8px; padding:8px 4px; cursor:pointer; font-weight:700; color:var(--on-surface); font-size:14px; }
        .dept-header .material-symbols-outlined { font-size:20px; color:var(--primary); }
        .dept-children { padding-left:32px; }
        .dept-child { display:flex; align-items:center; justify-content:space-between; padding:6px 4px; font-size:14px; color:var(--on-surface); }
        .dept-child-edit { opacity:0; cursor:pointer; color:var(--outline); font-size:16px; transition:opacity 0.2s; }
        .dept-child:hover .dept-child-edit { opacity:1; }
        .dept-add-btn {
            width:100%; padding:10px; border:2px dashed rgba(73,234,206,0.4); border-radius:10px; background:transparent;
            color:var(--primary); font-size:14px; font-weight:600; cursor:pointer; display:flex; align-items:center; justify-content:center; gap:6px; margin-top:12px; font-family:inherit;
        }
        .dept-add-btn:hover { background:rgba(73,234,206,0.06); }

        @media (max-width:1024px) { .sys-grid { grid-template-columns:1fr; } }
    </style>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="page-header">
        <div>
            <h1 class="page-title">系统管理</h1>
            <p class="page-subtitle">管理系统管理员权限及全局基础数据设置</p>
        </div>
    </div>

    <!-- 管理员账号管理 -->
    <div class="sys-section">
        <h2 class="sys-section-title">管理员账号管理</h2>
        <div class="sys-filter">
            <div class="sys-filter-field">
                <span class="material-symbols-outlined">search</span>
                <input class="sys-filter-input" type="text" placeholder="搜索 ID/姓名/手机号" />
            </div>
            <select class="sys-filter-select"><option value="">所有角色</option><option>系统管理员</option><option>宿管主管</option><option>维修人员</option></select>
            <select class="sys-filter-select"><option value="">所有状态</option><option>启用</option><option>禁用</option></select>
            <button class="sys-add-btn"><span class="material-symbols-outlined" style="font-size:18px;">person_add</span> 新增管理员</button>
        </div>
        <table class="sys-table">
            <thead><tr><th>工号</th><th>姓名</th><th>手机号</th><th>角色</th><th>状态</th><th style="text-align:right;">操作</th></tr></thead>
            <tbody>
                <tr>
                    <td>admin001</td><td><strong>陈志强</strong></td><td>138****0001</td>
                    <td><span class="sys-role-badge admin">系统管理员</span></td>
                    <td><span class="sys-status"><span class="sys-status-dot"></span> 启用</span></td>
                    <td style="text-align:right;"><button class="sys-action-link edit">编辑</button> <button class="sys-action-link reset">重置密码</button> <button class="sys-action-link delete">删除</button></td>
                </tr>
                <tr>
                    <td>admin002</td><td><strong>李美玲</strong></td><td>135****4423</td>
                    <td><span class="sys-role-badge manager">宿管主管</span></td>
                    <td><span class="sys-status"><span class="sys-status-dot"></span> 启用</span></td>
                    <td style="text-align:right;"><button class="sys-action-link edit">编辑</button> <button class="sys-action-link reset">重置密码</button> <button class="sys-action-link delete">删除</button></td>
                </tr>
                <tr>
                    <td>admin004</td><td><strong>赵后勤</strong></td><td>138****0004</td>
                    <td><span class="sys-role-badge worker">后勤人员</span></td>
                    <td><span class="sys-status"><span class="sys-status-dot"></span> 启用</span></td>
                    <td style="text-align:right;"><button class="sys-action-link edit">编辑</button> <button class="sys-action-link reset">重置密码</button> <button class="sys-action-link delete">删除</button></td>
                </tr>
            </tbody>
        </table>
    </div>

    <!-- 基础数据管理 -->
    <h2 class="sys-section-title" style="margin-bottom:16px;">基础数据管理</h2>
    <div class="sys-grid">
        <!-- 楼宇管理 -->
        <div class="sys-card">
            <div class="sys-card-title">楼宇管理 <button class="sys-add-icon"><span class="material-symbols-outlined">add_circle</span></button></div>
            <div class="building-item">
                <div class="building-left">
                    <div class="building-icon"><span class="material-symbols-outlined">apartment</span></div>
                    <div><div class="building-name">A座 (男生宿舍)</div><div class="building-sub">12层 | 240房间</div></div>
                </div>
                <div class="building-actions">
                    <button class="building-action-btn"><span class="material-symbols-outlined">edit</span></button>
                    <button class="building-action-btn delete"><span class="material-symbols-outlined">delete</span></button>
                </div>
            </div>
            <div class="building-item">
                <div class="building-left">
                    <div class="building-icon"><span class="material-symbols-outlined">apartment</span></div>
                    <div><div class="building-name">B座 (女生宿舍)</div><div class="building-sub">12层 | 240房间</div></div>
                </div>
                <div class="building-actions">
                    <button class="building-action-btn"><span class="material-symbols-outlined">edit</span></button>
                    <button class="building-action-btn delete"><span class="material-symbols-outlined">delete</span></button>
                </div>
            </div>
            <div class="building-item">
                <div class="building-left">
                    <div class="building-icon"><span class="material-symbols-outlined">apartment</span></div>
                    <div><div class="building-name">C座 (研究生公寓)</div><div class="building-sub">8层 | 160房间</div></div>
                </div>
                <div class="building-actions">
                    <button class="building-action-btn"><span class="material-symbols-outlined">edit</span></button>
                    <button class="building-action-btn delete"><span class="material-symbols-outlined">delete</span></button>
                </div>
            </div>
            <div class="building-add"><span class="material-symbols-outlined">add</span> 添加新楼宇</div>
        </div>

        <!-- 批量生成房间 -->
        <div class="sys-card">
            <div class="sys-card-title">批量生成房间</div>
            <div class="batch-gen-form">
                <div class="batch-gen-row">
                    <div><label style="font-size:13px; font-weight:600; color:var(--on-surface-variant); display:block; margin-bottom:6px;">选择楼宇</label>
                    <select class="batch-gen-input"><option>A座</option><option>B座</option><option>C座</option></select></div>
                    <div><label style="font-size:13px; font-weight:600; color:var(--on-surface-variant); display:block; margin-bottom:6px;">房间类型</label>
                    <select class="batch-gen-input"><option>4人间</option><option>6人间</option></select></div>
                </div>
                <div class="batch-gen-row">
                    <div><label style="font-size:13px; font-weight:600; color:var(--on-surface-variant); display:block; margin-bottom:6px;">起始层数 - 结束层数</label>
                    <div class="batch-gen-row-3"><input class="batch-gen-input" type="number" value="1" /><span>-</span><input class="batch-gen-input" type="number" value="12" /></div></div>
                    <div><label style="font-size:13px; font-weight:600; color:var(--on-surface-variant); display:block; margin-bottom:6px;">每层房间数</label>
                    <input class="batch-gen-input" type="number" value="20" /></div>
                </div>
                <div class="batch-gen-preview">
                    <div class="batch-gen-preview-label">预览生成的编号:</div>
                    <div class="batch-gen-tags">
                        <span class="batch-gen-tag">A-101</span>
                        <span class="batch-gen-tag">A-102</span>
                        <span class="batch-gen-tag">...</span>
                        <span class="batch-gen-tag">A-1220</span>
                    </div>
                    <div class="batch-gen-summary">共计将生成 240 个房间，960 个床位</div>
                </div>
                <button class="batch-gen-btn">执行批量生成</button>
            </div>
        </div>

        <!-- 院系结构 -->
        <div class="sys-card">
            <div class="sys-card-title">院系结构</div>
            <div class="dept-tree">
                <div class="dept-group">
                    <div class="dept-header"><span class="material-symbols-outlined">keyboard_arrow_down</span><span class="material-symbols-outlined">account_balance</span> 信息工程学院</div>
                    <div class="dept-children">
                        <div class="dept-child"><span>计算机科学与技术</span><span class="material-symbols-outlined dept-child-edit">edit</span></div>
                        <div class="dept-child" style="border-left:2px solid var(--primary); padding-left:8px;"><span>软件工程</span><span class="material-symbols-outlined dept-child-edit">edit</span></div>
                        <div class="dept-child"><span>网络空间安全</span><span class="material-symbols-outlined dept-child-edit">edit</span></div>
                    </div>
                </div>
                <div class="dept-group">
                    <div class="dept-header" style="color:var(--on-surface-variant);"><span class="material-symbols-outlined">keyboard_arrow_right</span><span class="material-symbols-outlined">account_balance</span> 外国语学院</div>
                </div>
                <div class="dept-group">
                    <div class="dept-header" style="color:var(--on-surface-variant);"><span class="material-symbols-outlined">keyboard_arrow_right</span><span class="material-symbols-outlined">account_balance</span> 经济管理学院</div>
                </div>
            </div>
            <button class="dept-add-btn"><span class="material-symbols-outlined" style="font-size:18px;">add</span> 添加学院</button>
        </div>
    </div>
</asp:Content>
