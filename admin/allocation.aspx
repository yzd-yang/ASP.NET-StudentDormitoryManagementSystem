<%@ Page Language="C#" MasterPageFile="~/admin/MasterPage.master" AutoEventWireup="true" CodeFile="allocation.aspx.cs" Inherits="admin_allocation" ResponseEncoding="utf-8" %>

<asp:Content ID="Content1" ContentPlaceHolderID="title" runat="server">宿舍分配管理 - SmartDorm</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="head" runat="server">
    <style>
        .alloc-header { display:flex; justify-content:space-between; align-items:end; margin-bottom:20px; flex-wrap:wrap; gap:12px; }
        .alloc-header h1 { font-size:28px; font-weight:800; color:var(--on-surface); }
        .alloc-header p { font-size:15px; color:var(--on-surface-variant); margin-top:4px; }
        .alloc-actions { display:flex; gap:8px; }
        .alloc-btn { display:flex; align-items:center; gap:6px; padding:10px 18px; border-radius:12px; font-size:14px; font-weight:700; cursor:pointer; font-family:inherit; }
        .alloc-btn.upload { background:rgba(73,234,206,0.12); border:1px solid rgba(73,234,206,0.3); color:var(--primary); }
        .alloc-btn.export { background:rgba(73,234,206,0.12); border:1px solid rgba(73,234,206,0.3); color:var(--primary); }
        .alloc-btn.exit { background:var(--error); border:none; color:#fff; }

        .alloc-filter {
            background:rgba(255,255,255,0.5); backdrop-filter:blur(8px); border-radius:16px; padding:16px 18px;
            border:1px solid rgba(255,255,255,0.4); display:flex; flex-wrap:wrap; gap:14px; align-items:center; margin-bottom:20px;
        }
        .alloc-filter-field { display:flex; align-items:center; gap:8px; background:rgba(255,255,255,0.4); padding:8px 14px; border-radius:12px; border:1px solid rgba(73,234,206,0.08); }
        .alloc-filter-label { font-size:13px; font-weight:700; color:var(--on-surface-variant); }
        .alloc-filter-select, .alloc-filter-input { border:none; background:transparent; font-family:inherit; font-size:14px; color:var(--on-surface); outline:none; }
        .alloc-filter-btn {
            padding:10px 20px; background:var(--primary); color:var(--on-primary); border:none;
            border-radius:12px; font-size:14px; font-weight:700; cursor:pointer; display:flex; align-items:center; gap:6px; font-family:inherit; margin-left:auto;
        }
        .alloc-stats { font-size:14px; font-weight:700; color:var(--primary); margin-left:12px; white-space:nowrap; }

        .room-grid { display:grid; grid-template-columns:repeat(auto-fill, minmax(340px, 1fr)); gap:20px; }
        .room-card {
            background:rgba(255,255,255,0.7); backdrop-filter:blur(12px); border-radius:18px; padding:20px;
            border:1px solid rgba(73,234,206,0.12); position:relative; overflow:hidden; transition:all 0.3s;
        }
        .room-card:hover { transform:translateY(-3px); box-shadow:0 8px 24px rgba(73,234,206,0.15); }
        .room-card::before { content:''; position:absolute; left:0; top:0; bottom:0; width:4px; background:var(--primary); border-radius:2px 0 0 2px; }
        .room-card-header { display:flex; justify-content:space-between; align-items:start; margin-bottom:16px; }
        .room-card-title { font-size:20px; font-weight:700; color:var(--on-surface); }
        .room-card-sub { font-size:13px; color:var(--on-surface-variant); margin-top:2px; }
        .room-status { padding:4px 12px; border-radius:20px; font-size:12px; font-weight:700; }
        .room-status.full { background:rgba(73,234,206,0.12); color:#006b5c; border:1px solid rgba(73,234,206,0.2); }
        .room-status.partial { background:rgba(251,192,45,0.1); color:#b58900; border:1px solid rgba(251,192,45,0.2); }
        .room-status.empty { background:rgba(73,234,206,0.08); color:var(--primary); border:1px solid rgba(73,234,206,0.15); }

        .bed-item {
            display:flex; align-items:center; justify-content:space-between; padding:12px 14px;
            background:rgba(255,255,255,0.4); border-radius:12px; margin-bottom:8px; transition:all 0.2s;
        }
        .bed-item:hover { border-color:rgba(73,234,206,0.3); background:rgba(255,255,255,0.6); }
        .bed-left { display:flex; align-items:center; gap:10px; }
        .bed-avatar { width:36px; height:36px; border-radius:50%; background:rgba(73,234,206,0.12); display:flex; align-items:center; justify-content:center; }
        .bed-avatar .material-symbols-outlined { font-size:18px; color:var(--primary); }
        .bed-name { font-size:14px; font-weight:700; color:var(--on-surface); }
        .bed-info { font-size:12px; color:var(--on-surface-variant); }
        .bed-status { font-size:12px; font-weight:700; color:var(--primary); }
        .bed-empty {
            display:flex; align-items:center; justify-content:center; gap:8px; padding:14px;
            border:2px dashed rgba(73,234,206,0.3); border-radius:14px; color:var(--on-surface-variant);
            cursor:pointer; transition:all 0.2s; margin-bottom:8px;
        }
        .bed-empty:hover { border-color:var(--primary); color:var(--primary); background:rgba(73,234,206,0.04); }
        .bed-empty .material-symbols-outlined { color:var(--primary); }

        .pagination-bar { display:flex; justify-content:space-between; align-items:center; margin-top:24px; padding-top:20px; border-top:1px solid rgba(73,234,206,0.12); }
        .pagination-info { font-size:13px; color:var(--on-surface-variant); }
        .pagination-btns { display:flex; gap:6px; }
        .page-btn { width:36px; height:36px; display:flex; align-items:center; justify-content:center; border:none; border-radius:10px; cursor:pointer; font-size:13px; font-weight:700; background:transparent; color:var(--on-surface-variant); transition:all 0.2s; }
        .page-btn.active { background:var(--primary); color:var(--on-primary); }
        .page-btn:hover:not(.active) { background:rgba(73,234,206,0.1); }
    </style>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="alloc-header">
        <div>
            <h1>宿舍分配管理</h1>
            <p>实时监控与管理全校 12 栋公寓、共 1,248 个房间的床位资源</p>
        </div>
        <div class="alloc-actions">
            <button class="alloc-btn upload"><span class="material-symbols-outlined" style="font-size:18px;">upload</span> 批量导入</button>
            <button class="alloc-btn export"><span class="material-symbols-outlined" style="font-size:18px;">download</span> 导出表格</button>
            <button class="alloc-btn exit"><span class="material-symbols-outlined" style="font-size:18px;">logout</span> 集中退宿</button>
        </div>
    </div>

    <div class="alloc-filter">
        <div class="alloc-filter-field">
            <span class="alloc-filter-label">宿舍楼号:</span>
            <select class="alloc-filter-select"><option>全部楼栋</option><option>松园 1 号楼</option><option>松园 2 号楼</option><option>松园 3 号楼</option></select>
        </div>
        <div class="alloc-filter-field">
            <span class="alloc-filter-label">房间号:</span>
            <input class="alloc-filter-input" type="text" placeholder="输入房间号..." style="width:120px;" />
        </div>
        <button class="alloc-filter-btn"><span class="material-symbols-outlined" style="font-size:18px;">filter_list</span> 筛选</button>
        <span class="alloc-stats">1,248 房间 / 4,992 床位</span>
    </div>

    <div class="room-grid">
        <!-- 101室 满员 -->
        <div class="room-card">
            <div class="room-card-header">
                <div><div class="room-card-title">101 室</div><div class="room-card-sub">四人间 · 男生宿舍</div></div>
                <span class="room-status full">已满员</span>
            </div>
            <div class="bed-item"><div class="bed-left"><div class="bed-avatar"><span class="material-symbols-outlined">person</span></div><div><div class="bed-name">张三</div><div class="bed-info">20240901 · 计算机</div></div></div><span class="bed-status">已入宿</span></div>
            <div class="bed-item"><div class="bed-left"><div class="bed-avatar"><span class="material-symbols-outlined">person</span></div><div><div class="bed-name">李四</div><div class="bed-info">20240902 · 计算机</div></div></div><span class="bed-status">已入宿</span></div>
            <div class="bed-item"><div class="bed-left"><div class="bed-avatar"><span class="material-symbols-outlined">person</span></div><div><div class="bed-name">王五</div><div class="bed-info">20240903 · 计算机</div></div></div><span class="bed-status">已入宿</span></div>
            <div class="bed-item"><div class="bed-left"><div class="bed-avatar"><span class="material-symbols-outlined">person</span></div><div><div class="bed-name">赵六</div><div class="bed-info">20240904 · 软件</div></div></div><span class="bed-status">已入宿</span></div>
        </div>

        <!-- 102室 部分入住 -->
        <div class="room-card">
            <div class="room-card-header">
                <div><div class="room-card-title">102 室</div><div class="room-card-sub">四人间 · 男生宿舍</div></div>
                <span class="room-status partial">空余 2</span>
            </div>
            <div class="bed-item"><div class="bed-left"><div class="bed-avatar"><span class="material-symbols-outlined">person</span></div><div><div class="bed-name">陈小明</div><div class="bed-info">20241011 · 艺术</div></div></div><span class="bed-status">已入宿</span></div>
            <div class="bed-item"><div class="bed-left"><div class="bed-avatar"><span class="material-symbols-outlined">person</span></div><div><div class="bed-name">孙悟空</div><div class="bed-info">20241122 · 体育</div></div></div><span class="bed-status">已入宿</span></div>
            <div class="bed-empty"><span class="material-symbols-outlined">add_circle</span> 分配床位 3</div>
            <div class="bed-empty"><span class="material-symbols-outlined">add_circle</span> 分配床位 4</div>
        </div>

        <!-- 103室 全空置 -->
        <div class="room-card">
            <div class="room-card-header">
                <div><div class="room-card-title">103 室</div><div class="room-card-sub">四人间 · 男生宿舍</div></div>
                <span class="room-status empty">全空置</span>
            </div>
            <div class="bed-empty"><span class="material-symbols-outlined">add_circle</span> 分配床位 1</div>
            <div class="bed-empty"><span class="material-symbols-outlined">add_circle</span> 分配床位 2</div>
            <div class="bed-empty"><span class="material-symbols-outlined">add_circle</span> 分配床位 3</div>
            <div class="bed-empty"><span class="material-symbols-outlined">add_circle</span> 分配床位 4</div>
        </div>
    </div>

    <div class="pagination-bar">
        <span class="pagination-info">显示 1 到 12 / 共 1,248 个房间</span>
        <div class="pagination-btns">
            <button class="page-btn"><span class="material-symbols-outlined" style="font-size:18px;">chevron_left</span></button>
            <button class="page-btn active">1</button>
            <button class="page-btn">2</button>
            <button class="page-btn">3</button>
            <span style="padding:0 4px; color:var(--on-surface-variant);">...</span>
            <button class="page-btn">42</button>
            <button class="page-btn"><span class="material-symbols-outlined" style="font-size:18px;">chevron_right</span></button>
        </div>
    </div>
</asp:Content>
