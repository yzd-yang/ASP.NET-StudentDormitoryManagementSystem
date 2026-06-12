<%@ Page Language="C#" MasterPageFile="~/admin/MasterPage.master" AutoEventWireup="true" CodeFile="repair.aspx.cs" Inherits="admin_repair" ResponseEncoding="utf-8" MaintainScrollPositionOnPostBack="true" %>

<asp:Content ID="Content1" ContentPlaceHolderID="title" runat="server">报修管理 - SmartDorm</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="head" runat="server">
    <style>
        .repair-header { display:flex; justify-content:space-between; align-items:center; margin-bottom:20px; flex-wrap:wrap; gap:12px; }
        .repair-header h1 { font-size:28px; font-weight:800; color:var(--on-surface); }
        .repair-header p { font-size:15px; color:var(--on-surface-variant); margin-top:4px; }
        .repair-actions { display:flex; gap:8px; }
        .repair-btn { display:flex; align-items:center; gap:6px; padding:10px 18px; border-radius:12px; font-size:14px; font-weight:700; cursor:pointer; font-family:inherit; }
        .repair-btn.ghost { background:rgba(255,255,255,0.6); border:1px solid rgba(0,0,0,0.06); color:var(--on-surface); }
        .repair-btn.primary { background:var(--primary); border:none; color:var(--on-primary); box-shadow:0 4px 12px rgba(73,234,206,0.3); }

        .repair-filter {
            background:rgba(255,255,255,0.5); backdrop-filter:blur(8px); border-radius:16px; padding:16px 18px;
            border:1px solid rgba(255,255,255,0.4); display:flex; flex-wrap:wrap; gap:14px; align-items:end; margin-bottom:20px;
        }
        .repair-filter-group { display:flex; flex-direction:column; gap:4px; }
        .repair-filter-label { font-size:12px; font-weight:700; color:var(--on-surface-variant); text-transform:uppercase; letter-spacing:0.05em; }
        .repair-filter-select { padding:10px 14px; border:none; border-radius:10px; background:#FFF9E6; font-family:inherit; font-size:14px; outline:none; min-width:140px; }
        .repair-filter-reset { padding:10px 16px; background:rgba(73,234,206,0.1); color:var(--primary); border:1px solid rgba(73,234,206,0.3); border-radius:10px; font-size:14px; font-weight:700; cursor:pointer; margin-left:auto; font-family:inherit; display:flex; align-items:center; gap:6px; }

        .repair-stats { display:grid; grid-template-columns:repeat(4,1fr); gap:16px; margin-bottom:24px; }
        .repair-stat {
            background:rgba(255,255,255,0.6); backdrop-filter:blur(8px); border-radius:16px; padding:18px;
            border:1px solid rgba(255,255,255,0.5); position:relative; overflow:hidden;
        }
        .repair-stat::before { content:''; position:absolute; inset:0; background:linear-gradient(135deg, rgba(73,234,206,0.06), rgba(245,255,220,0.08)); opacity:0; transition:opacity 0.3s; }
        .repair-stat:hover::before { opacity:1; }
        .repair-stat-header { display:flex; justify-content:space-between; align-items:center; margin-bottom:8px; }
        .repair-stat-label { font-size:13px; font-weight:700; color:var(--on-surface-variant); text-transform:uppercase; letter-spacing:0.05em; }
        .repair-stat-icon { width:36px; height:36px; border-radius:10px; display:flex; align-items:center; justify-content:center; }
        .repair-stat-icon .material-symbols-outlined { font-size:20px; }
        .repair-stat-value { font-size:32px; font-weight:800; color:var(--on-surface); }
        .repair-stat-sub { font-size:12px; font-weight:600; margin-top:6px; }

        .repair-table-card {
            background:rgba(255,255,255,0.6); backdrop-filter:blur(12px); border-radius:16px;
            border:1px solid rgba(255,255,255,0.5); overflow:hidden; display:flex; flex-direction:column;
        }
        .repair-table { width:100%; border-collapse:collapse; }
        .repair-table th {
            padding:14px 20px; text-align:left; font-size:13px; font-weight:700; color:var(--on-surface-variant);
            text-transform:uppercase; letter-spacing:0.05em; background:rgba(255,255,255,0.4); backdrop-filter:blur(8px);
            border-bottom:1px solid rgba(0,0,0,0.05); position:sticky; top:0; z-index:1;
        }
        .repair-table td { padding:16px 20px; font-size:14px; color:var(--on-surface); border-bottom:1px solid rgba(0,0,0,0.03); }
        .repair-table tr:hover td { background:rgba(73,234,206,0.06); }
        .repair-table tr.completed td { opacity:0.5; }
        .repair-type { display:flex; align-items:center; gap:8px; font-weight:600; }
        .repair-type .material-symbols-outlined { font-size:18px; }
        .repair-desc { color:var(--on-surface-variant); max-width:240px; overflow:hidden; text-overflow:ellipsis; white-space:nowrap; }
        .repair-time { color:var(--on-surface-variant); }
        .repair-status-pill { padding:4px 12px; border-radius:20px; font-size:11px; font-weight:700; text-transform:uppercase; letter-spacing:0.05em; }
        .repair-status-pill.urgent { background:rgba(186,26,26,0.08); color:var(--error); }
        .repair-status-pill.pending { background:rgba(221,231,197,0.5); color:var(--on-surface); }
        .repair-status-pill.processing { background:rgba(73,234,206,0.12); color:var(--primary); }
        .repair-status-pill.done { background:rgba(232,233,236,0.6); color:var(--on-surface-variant); }
        .repair-table-footer { display:flex; justify-content:space-between; align-items:center; padding:14px 20px; background:rgba(255,255,255,0.4); border-top:1px solid rgba(0,0,0,0.05); }
        .repair-table-info { font-size:13px; color:var(--on-surface-variant); font-weight:500; }
        .repair-pagination { display:flex; gap:6px; }
        .repair-page-btn { width:32px; height:32px; display:flex; align-items:center; justify-content:center; border:1px solid rgba(0,0,0,0.08); border-radius:8px; background:rgba(255,255,255,0.6); cursor:pointer; font-size:13px; font-weight:600; color:var(--on-surface-variant); }
        .repair-page-btn.active { background:var(--primary); color:var(--on-primary); border-color:var(--primary); }

        .detail-overlay { display:none; position:fixed; inset:0; background:rgba(0,0,0,0.2); z-index:60; backdrop-filter:blur(4px); }
        .detail-overlay.show { display:block; }
        .detail-panel {
            position:fixed; top:0; right:0; height:100%; width:480px; max-width:100%; background:rgba(255,255,255,0.92);
            backdrop-filter:blur(16px); z-index:70; box-shadow:-8px 0 32px rgba(0,0,0,0.1); border-left:1px solid rgba(255,255,255,0.4);
            transform:translateX(100%); transition:transform 0.3s ease; display:flex; flex-direction:column; overflow-y:auto;
        }
        .detail-panel.show { transform:translateX(0); }
        .detail-header { padding:20px; border-bottom:1px solid rgba(0,0,0,0.05); display:flex; justify-content:space-between; align-items:start; position:sticky; top:0; background:rgba(255,255,255,0.8); backdrop-filter:blur(8px); z-index:1; }
        .detail-title { font-size:18px; font-weight:700; color:var(--on-surface); }
        .detail-sub { font-size:13px; color:var(--on-surface-variant); margin-top:4px; display:flex; align-items:center; gap:6px; }
        .detail-close { padding:8px; border:none; background:transparent; border-radius:50%; cursor:pointer; color:var(--on-surface-variant); }
        .detail-close:hover { background:rgba(0,0,0,0.05); }
        .detail-body { flex:1; padding:20px; }
        .detail-section-title { font-size:14px; font-weight:700; color:var(--on-surface); margin-bottom:12px; }
        .detail-photo { width:100%; aspect-ratio:16/9; background:var(--surface-container); border-radius:14px; overflow:hidden; margin-bottom:20px; display:flex; align-items:center; justify-content:center; color:var(--outline-variant); }
        .detail-info-grid { display:grid; grid-template-columns:1fr 1fr; gap:10px; margin-bottom:20px; }
        .detail-info-item { background:rgba(255,255,255,0.5); border:1px solid rgba(255,255,255,0.4); padding:12px; border-radius:12px; }
        .detail-info-label { font-size:11px; font-weight:700; color:var(--on-surface-variant); text-transform:uppercase; letter-spacing:0.08em; margin-bottom:4px; }
        .detail-info-value { font-size:14px; font-weight:700; color:var(--on-surface); }
        .detail-desc { background:rgba(255,255,255,0.4); border:1px solid rgba(0,0,0,0.04); border-radius:12px; padding:14px; font-size:14px; color:var(--on-surface-variant); line-height:1.7; margin-bottom:20px; }
        .detail-assign { background:rgba(73,234,206,0.05); border:1px solid rgba(73,234,206,0.15); border-radius:14px; padding:16px; margin-bottom:20px; }
        .detail-assign select { width:100%; padding:12px 14px; border:1px solid rgba(0,0,0,0.08); border-radius:12px; background:rgba(255,255,255,0.8); font-family:inherit; font-size:14px; outline:none; margin-bottom:10px; }
        .detail-assign-btn { width:100%; padding:12px; background:var(--primary); color:var(--on-primary); border:none; border-radius:12px; font-size:14px; font-weight:700; cursor:pointer; font-family:inherit; }
        .detail-note { width:100%; min-height:80px; border:1px solid rgba(0,0,0,0.08); border-radius:12px; padding:12px; background:rgba(255,255,255,0.8); font-family:inherit; font-size:14px; resize:none; outline:none; }
        .detail-footer { padding:16px 20px; border-top:1px solid rgba(0,0,0,0.05); display:grid; grid-template-columns:1fr 1fr; gap:12px; background:rgba(255,255,255,0.4); }
        .detail-footer-btn { padding:12px; border-radius:12px; font-size:14px; font-weight:700; cursor:pointer; display:flex; align-items:center; justify-content:center; gap:6px; font-family:inherit; }
        .detail-footer-btn.reject { background:transparent; border:1px solid var(--error); color:var(--error); }
        .detail-footer-btn.complete { background:var(--primary); border:none; color:var(--on-primary); }

        @media (max-width:1024px) { .repair-stats { grid-template-columns:repeat(2,1fr); } }
        @media (max-width:768px) { .repair-stats { grid-template-columns:1fr; } .detail-panel { width:100%; } }
    </style>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="repair-header">
        <div>
            <h1>报修请求管理</h1>
            <p>实时监控和处理校园宿舍的维修服务申请。</p>
        </div>
        <div class="repair-actions">
            <button class="repair-btn ghost"><span class="material-symbols-outlined" style="font-size:18px;">filter_list</span> 筛选条件</button>
            <button class="repair-btn ghost"><span class="material-symbols-outlined" style="font-size:18px;">download</span> 导出报表</button>
            <button class="repair-btn primary"><span class="material-symbols-outlined" style="font-size:18px;">add</span> 新建报修单</button>
        </div>
    </div>

    <div class="repair-filter">
        <div class="repair-filter-group"><label class="repair-filter-label">状态</label><select class="repair-filter-select"><option>全部</option><option>待处理</option><option>处理中</option><option>已完成</option><option>紧急</option></select></div>
        <div class="repair-filter-group"><label class="repair-filter-label">宿舍楼</label><select class="repair-filter-select"><option>全部</option><option>A楼</option><option>B楼</option><option>C楼</option><option>D楼</option></select></div>
        <div class="repair-filter-group"><label class="repair-filter-label">报修类型</label><select class="repair-filter-select"><option>全部</option><option>电力故障</option><option>供水维修</option><option>家具维修</option><option>空调清洗</option></select></div>
        <button class="repair-filter-reset"><span class="material-symbols-outlined" style="font-size:16px;">refresh</span> 重置筛选</button>
    </div>

    <div class="repair-stats">
        <div class="repair-stat">
            <div class="repair-stat-header"><span class="repair-stat-label">待处理工单</span><div class="repair-stat-icon" style="background:rgba(255,183,77,0.1);"><span class="material-symbols-outlined" style="color:#b58900;">pending_actions</span></div></div>
            <div class="repair-stat-value">12</div>
            <div class="repair-stat-sub" style="color:var(--error);">较昨日增加 25%</div>
        </div>
        <div class="repair-stat">
            <div class="repair-stat-header"><span class="repair-stat-label">处理中工单</span><div class="repair-stat-icon" style="background:rgba(73,234,206,0.1);"><span class="material-symbols-outlined" style="color:var(--primary);">engineering</span></div></div>
            <div class="repair-stat-value">08</div>
            <div class="repair-stat-sub" style="color:var(--primary);">平均用时 4.2h</div>
        </div>
        <div class="repair-stat">
            <div class="repair-stat-header"><span class="repair-stat-label">紧急报修项目</span><div class="repair-stat-icon" style="background:rgba(186,26,26,0.06);"><span class="material-symbols-outlined" style="color:var(--error);">priority_high</span></div></div>
            <div class="repair-stat-value">03</div>
            <div class="repair-stat-sub" style="color:var(--on-surface-variant);">需要立即分配技工</div>
        </div>
        <div class="repair-stat">
            <div class="repair-stat-header"><span class="repair-stat-label">今日已完成</span><div class="repair-stat-icon" style="background:rgba(73,234,206,0.1);"><span class="material-symbols-outlined" style="color:var(--primary);">task_alt</span></div></div>
            <div class="repair-stat-value">24</div>
            <div class="repair-stat-sub" style="color:var(--primary);">达标率 98%</div>
        </div>
    </div>

    <div class="repair-table-card">
        <div style="overflow-x:auto; flex:1;">
            <table class="repair-table">
                <thead>
                    <tr><th style="width:110px;">工单ID</th><th style="width:140px;">报修类型</th><th style="width:180px;">宿舍位置</th><th>描述简述</th><th style="width:140px;">报修时间</th><th style="width:120px;">状态</th><th style="width:50px;"></th></tr>
                </thead>
                <tbody>
                    <tr onclick="openDetail()" style="cursor:pointer;">
                        <td>#2023-001</td>
                        <td><div class="repair-type"><span class="material-symbols-outlined" style="color:var(--error);">bolt</span> 电力故障</div></td>
                        <td>B楼 402室 (床位 A)</td>
                        <td class="repair-desc">插座冒火花，无法通电。塑料外壳有轻微熔化迹象。</td>
                        <td class="repair-time">今日 09:12</td>
                        <td><span class="repair-status-pill urgent">紧急处理</span></td>
                        <td><span class="material-symbols-outlined" style="color:var(--on-surface-variant);">chevron_right</span></td>
                    </tr>
                    <tr onclick="openDetail()" style="cursor:pointer;">
                        <td>#2023-002</td>
                        <td><div class="repair-type"><span class="material-symbols-outlined" style="color:var(--primary);">water_drop</span> 供水维修</div></td>
                        <td>C楼 105室</td>
                        <td class="repair-desc">洗手池水龙头漏水，关不严实，持续滴水。</td>
                        <td class="repair-time">昨日 16:45</td>
                        <td><span class="repair-status-pill pending">待分配</span></td>
                        <td><span class="material-symbols-outlined" style="color:var(--on-surface-variant);">chevron_right</span></td>
                    </tr>
                    <tr onclick="openDetail()" style="cursor:pointer;">
                        <td>#2023-003</td>
                        <td><div class="repair-type"><span class="material-symbols-outlined" style="color:var(--primary);">home_repair_service</span> 家具维修</div></td>
                        <td>A楼 612室 (床位 B)</td>
                        <td class="repair-desc">书桌中间抽屉滑道变形损坏，无法正常拉出。</td>
                        <td class="repair-time">2023/10/24</td>
                        <td><span class="repair-status-pill processing">维修中</span></td>
                        <td><span class="material-symbols-outlined" style="color:var(--on-surface-variant);">chevron_right</span></td>
                    </tr>
                    <tr class="completed">
                        <td>#2022-894</td>
                        <td><div class="repair-type"><span class="material-symbols-outlined">event</span> 空调清洗</div></td>
                        <td>D楼 201室</td>
                        <td class="repair-desc">空调制冷时有异味，申请深度清洗滤网及散热片。</td>
                        <td class="repair-time">2023/10/20</td>
                        <td><span class="repair-status-pill done">已完成</span></td>
                        <td><span class="material-symbols-outlined" style="color:var(--primary);">check_circle</span></td>
                    </tr>
                </tbody>
            </table>
        </div>
        <div class="repair-table-footer">
            <span class="repair-table-info">显示 1-4 条，共 142 条工单数据</span>
            <div class="repair-pagination">
                <button class="repair-page-btn"><span class="material-symbols-outlined" style="font-size:16px;">chevron_left</span></button>
                <button class="repair-page-btn active">1</button>
                <button class="repair-page-btn">2</button>
                <button class="repair-page-btn">3</button>
                <button class="repair-page-btn"><span class="material-symbols-outlined" style="font-size:16px;">chevron_right</span></button>
            </div>
        </div>
    </div>

    <!-- 详情面板 -->
    <div class="detail-overlay" id="detailOverlay" onclick="closeDetail()"></div>
    <div class="detail-panel" id="detailPanel">
        <div class="detail-header">
            <div>
                <div class="detail-title">工单详情</div>
                <div class="detail-sub"><span style="color:var(--primary); font-weight:700;">REQ-2023-001</span><span style="color:var(--outline-variant);">·</span>由 张伟 提交</div>
            </div>
            <button class="detail-close" onclick="closeDetail()"><span class="material-symbols-outlined">close</span></button>
        </div>
        <div class="detail-body">
            <div class="detail-section-title">现场照片</div>
            <div class="detail-photo"><span class="material-symbols-outlined" style="font-size:48px;">image</span></div>

            <div class="detail-info-grid">
                <div class="detail-info-item"><div class="detail-info-label">学生姓名</div><div class="detail-info-value">张伟</div></div>
                <div class="detail-info-item"><div class="detail-info-label">学号</div><div class="detail-info-value">20210934</div></div>
                <div class="detail-info-item"><div class="detail-info-label">联系电话</div><div class="detail-info-value" style="color:var(--primary);">138-xxxx-5678</div></div>
                <div class="detail-info-item"><div class="detail-info-label">报修分类</div><div class="detail-info-value"><span class="repair-status-pill urgent" style="font-size:10px;">电力设备类</span></div></div>
            </div>

            <div class="detail-section-title">报修描述</div>
            <div class="detail-desc">今天早上在使用电脑充电器时，插座突然发出滋滋声并伴随明显火花。现在该插座已完全断电，且塑料外壳有明显的烧焦熔化痕迹，散发异味。考虑到整个寝室的用电安全，请务必尽快派专业电工师傅到场处理，以免发生次生灾害。</div>

            <div class="detail-section-title">派工处理</div>
            <div class="detail-assign">
                <select><option value="">点击选择维修技工...</option><option>老王 (电工组 - 5工单进行中)</option><option>陈师傅 (后勤保障 - 目前空闲)</option><option>刘师傅 (电工组 - 1工单进行中)</option></select>
                <button class="detail-assign-btn">立即确认指派</button>
            </div>

            <div class="detail-section-title">内部管理备注</div>
            <textarea class="detail-note" placeholder="此处输入仅管理员可见的工单跟踪记录或特别注意事项..."></textarea>
        </div>
        <div class="detail-footer">
            <button class="detail-footer-btn reject"><span class="material-symbols-outlined" style="font-size:18px;">cancel</span> 驳回申请</button>
            <button class="detail-footer-btn complete"><span class="material-symbols-outlined" style="font-size:18px;">check_circle</span> 确认完成</button>
        </div>
    </div>

    <script type="text/javascript">
        function openDetail() {
            document.getElementById('detailOverlay').classList.add('show');
            document.getElementById('detailPanel').classList.add('show');
            document.body.style.overflow = 'hidden';
        }
        function closeDetail() {
            document.getElementById('detailOverlay').classList.remove('show');
            document.getElementById('detailPanel').classList.remove('show');
            document.body.style.overflow = '';
        }
    </script>
</asp:Content>
