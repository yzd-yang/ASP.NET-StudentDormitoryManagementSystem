<%@ Page Language="C#" MasterPageFile="~/student/MasterPage.master" AutoEventWireup="true" CodeFile="grab-dorm.aspx.cs" Inherits="student_grab_dorm" ResponseEncoding="utf-8" %>

<asp:Content ID="Content1" ContentPlaceHolderID="title" runat="server">选宿舍 - 智慧宿舍</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="head" runat="server">
    <style>
        .grab-header { display:flex; justify-content:space-between; align-items:end; gap:16px; margin-bottom:24px; flex-wrap:wrap; }
        .grab-header h1 { font-size:28px; font-weight:800; color:var(--on-surface); }
        .grab-header p { font-size:16px; color:var(--on-surface-variant); margin-top:4px; }
        .countdown-card {
            background:rgba(255,255,255,0.6); backdrop-filter:blur(8px); border-radius:18px;
            padding:16px 24px; border:1px solid rgba(255,255,255,0.4); text-align:center; min-width:220px;
        }
        .countdown-label { font-size:12px; color:var(--on-surface-variant); margin-bottom:10px; }
        .countdown-digits { display:flex; gap:10px; justify-content:center; }
        .countdown-num {
            width:48px; height:48px; display:flex; align-items:center; justify-content:center;
            background:#fff; border-radius:10px; font-size:22px; font-weight:700; color:var(--primary);
            border:1px solid rgba(0,0,0,0.06); box-shadow:0 2px 4px rgba(0,0,0,0.04);
        }
        .countdown-num.pulse { animation:pulse 1s infinite; }
        .countdown-unit { font-size:11px; color:var(--on-surface-variant); margin-top:4px; text-align:center; }
        @keyframes pulse { 0%,100%{opacity:1} 50%{opacity:0.5} }

        .filter-section {
            background:rgba(255,255,255,0.5); backdrop-filter:blur(8px); border-radius:16px;
            padding:14px 18px; border:1px solid rgba(255,255,255,0.4); display:flex; gap:14px;
            align-items:end; margin-bottom:24px; flex-wrap:wrap;
        }
        .filter-field { display:flex; flex-direction:column; gap:4px; flex:1; min-width:140px; }
        .filter-field label { font-size:12px; font-weight:600; color:var(--on-surface-variant); }
        .filter-field select, .filter-field input {
            padding:10px 14px; border:none; border-radius:12px; background:#FFF9E6;
            font-family:inherit; font-size:14px; color:var(--on-surface); outline:none;
        }

        .room-grid { display:grid; grid-template-columns:repeat(auto-fill, minmax(260px, 1fr)); gap:20px; }

        .room-card {
            background:rgba(255,255,255,0.6); backdrop-filter:blur(12px); border-radius:20px;
            padding:20px; border:2px solid transparent; transition:all 0.2s; display:flex; flex-direction:column;
        }
        .room-card:hover { border-color:rgba(73,234,206,0.3); }
        .room-card.full { opacity:0.5; }
        .room-card-header { display:flex; justify-content:space-between; align-items:start; margin-bottom:14px; }
        .room-card-title { font-size:20px; font-weight:700; color:var(--on-surface); }
        .room-card-sub { font-size:12px; color:var(--on-surface-variant); margin-top:2px; }
        .room-card-type { padding:4px 12px; border-radius:20px; font-size:12px; font-weight:700; background:rgba(219,206,221,0.5); color:var(--on-surface); }
        .room-card-type.full-type { background:rgba(232,233,236,0.6); }

        .bed-label { font-size:12px; font-weight:600; color:var(--on-surface-variant); margin-bottom:8px; }
        .bed-grid { display:grid; grid-template-columns:1fr 1fr; gap:8px; margin-bottom:16px; flex:1; }
        .bed-btn {
            display:flex; align-items:center; justify-content:space-between; padding:10px 14px;
            border:1px solid var(--outline-variant); border-radius:12px; background:rgba(255,255,255,0.5);
            font-size:14px; font-weight:600; color:var(--on-surface); cursor:pointer; transition:all 0.2s; font-family:inherit;
        }
        .bed-btn:hover { background:rgba(73,234,206,0.08); border-color:var(--primary); }
        .bed-btn.selected { border-color:var(--primary); background:rgba(73,234,206,0.1); }
        .bed-btn.occupied { border-color:transparent; background:rgba(232,233,236,0.5); color:var(--on-surface-variant); cursor:not-allowed; opacity:0.6; }
        .bed-btn .material-symbols-outlined { font-size:18px; }

        .grab-btn {
            width:100%; padding:14px; border:none; border-radius:16px; font-size:15px; font-weight:700;
            cursor:pointer; transition:all 0.2s; font-family:inherit;
        }
        .grab-btn.active { background:var(--primary); color:var(--on-primary); box-shadow:0 4px 14px rgba(73,234,206,0.35); }
        .grab-btn.disabled { background:rgba(232,233,236,0.6); color:var(--on-surface-variant); cursor:not-allowed; }
        .grab-btn.full-btn { background:rgba(232,233,236,0.6); color:var(--on-surface-variant); cursor:not-allowed; }
    </style>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="grab-header">
        <div>
            <h1>选宿舍 - 2024级新生第一批</h1>
            <p>名额有限，请在倒计时结束前锁定您的意向寝室。</p>
        </div>
        <div class="countdown-card">
            <div class="countdown-label">距离本轮抢订结束还剩</div>
            <div class="countdown-digits">
                <div>
                    <div class="countdown-num" id="hours">01</div>
                    <div class="countdown-unit">时</div>
                </div>
                <div>
                    <div class="countdown-num" id="minutes">57</div>
                    <div class="countdown-unit">分</div>
                </div>
                <div>
                    <div class="countdown-num pulse" id="seconds">16</div>
                    <div class="countdown-unit">秒</div>
                </div>
            </div>
        </div>
    </div>

    <div class="filter-section">
        <div class="filter-field">
            <label>空床位</label>
            <select><option>1个</option><option>2个</option><option>3个</option><option>4个以上</option></select>
        </div>
        <button class="filter-btn" style="padding:10px 24px; background:var(--primary); color:var(--on-primary); border:none; border-radius:12px; font-size:14px; font-weight:700; cursor:pointer; display:flex; align-items:center; gap:6px; font-family:inherit;">
            <span class="material-symbols-outlined" style="font-size:18px;">filter_list</span> 应用筛选
        </button>
    </div>

    <div class="room-grid">
        <!-- 501室 -->
        <div class="room-card">
            <div class="room-card-header">
                <div><div class="room-card-title">501 室</div><div class="room-card-sub">Building A · 北侧景观</div></div>
                <span class="room-card-type">四人间</span>
            </div>
            <div class="bed-label">选择床位：</div>
            <div class="bed-grid">
                <button class="bed-btn" onclick="selectBed(this)"><span>A号床</span><span class="material-symbols-outlined">bed</span></button>
                <button class="bed-btn occupied" disabled><span>B号床</span><span style="font-size:12px;">已占</span></button>
                <button class="bed-btn" onclick="selectBed(this)"><span>C号床</span><span class="material-symbols-outlined">bed</span></button>
                <button class="bed-btn occupied" disabled><span>D号床</span><span style="font-size:12px;">已占</span></button>
            </div>
            <button class="grab-btn disabled" disabled>立即抢订</button>
        </div>

        <!-- 612室 -->
        <div class="room-card">
            <div class="room-card-header">
                <div><div class="room-card-title">612 室</div><div class="room-card-sub">Building A · 南侧景观</div></div>
                <span class="room-card-type">四人间</span>
            </div>
            <div class="bed-label">选择床位：</div>
            <div class="bed-grid">
                <button class="bed-btn occupied" disabled><span>A号床</span><span style="font-size:12px;">已占</span></button>
                <button class="bed-btn occupied" disabled><span>B号床</span><span style="font-size:12px;">已占</span></button>
                <button class="bed-btn" onclick="selectBed(this)"><span>C号床</span><span class="material-symbols-outlined">bed</span></button>
                <button class="bed-btn occupied" disabled><span>D号床</span><span style="font-size:12px;">已占</span></button>
            </div>
            <button class="grab-btn disabled" disabled>立即抢订</button>
        </div>

        <!-- 808室 -->
        <div class="room-card">
            <div class="room-card-header">
                <div><div class="room-card-title">808 室</div><div class="room-card-sub">Building B · 高层</div></div>
                <span class="room-card-type">双人间</span>
            </div>
            <div class="bed-label">选择床位：</div>
            <div class="bed-grid">
                <button class="bed-btn" onclick="selectBed(this)"><span>A号床</span><span class="material-symbols-outlined">bed</span></button>
                <button class="bed-btn" onclick="selectBed(this)"><span>B号床</span><span class="material-symbols-outlined">bed</span></button>
            </div>
            <button class="grab-btn disabled" disabled>立即抢订</button>
        </div>

        <!-- 403室（满员） -->
        <div class="room-card full">
            <div class="room-card-header">
                <div><div class="room-card-title">403 室</div><div class="room-card-sub">Building C · 低层</div></div>
                <span class="room-card-type full-type">四人间</span>
            </div>
            <div class="bed-label">选择床位：</div>
            <div class="bed-grid">
                <div class="bed-btn occupied" style="opacity:0.5;"><span>A号床</span><span style="font-size:12px;">已占</span></div>
                <div class="bed-btn occupied" style="opacity:0.5;"><span>B号床</span><span style="font-size:12px;">已占</span></div>
                <div class="bed-btn occupied" style="opacity:0.5;"><span>C号床</span><span style="font-size:12px;">已占</span></div>
                <div class="bed-btn occupied" style="opacity:0.5;"><span>D号床</span><span style="font-size:12px;">已占</span></div>
            </div>
            <button class="grab-btn full-btn" disabled>已满额</button>
        </div>

        <!-- 1205室 -->
        <div class="room-card">
            <div class="room-card-header">
                <div><div class="room-card-title">1205 室</div><div class="room-card-sub">Building B · 空中花园</div></div>
                <span class="room-card-type">六人间</span>
            </div>
            <div class="bed-label">选择床位：</div>
            <div class="bed-grid">
                <button class="bed-btn occupied" disabled><span>A号床</span><span style="font-size:12px;">已占</span></button>
                <button class="bed-btn" onclick="selectBed(this)"><span>B号床</span><span class="material-symbols-outlined">bed</span></button>
                <button class="bed-btn" onclick="selectBed(this)"><span>C号床</span><span class="material-symbols-outlined">bed</span></button>
                <button class="bed-btn occupied" disabled><span>D号床</span><span style="font-size:12px;">已占</span></button>
                <button class="bed-btn" onclick="selectBed(this)"><span>E号床</span><span class="material-symbols-outlined">bed</span></button>
                <button class="bed-btn occupied" disabled><span>F号床</span><span style="font-size:12px;">已占</span></button>
            </div>
            <button class="grab-btn disabled" disabled>立即抢订</button>
        </div>
    </div>

    <script type="text/javascript">
        function selectBed(btn) {
            var card = btn.closest('.room-card');
            var beds = card.querySelectorAll('.bed-btn:not(.occupied)');
            beds.forEach(function(b) { b.classList.remove('selected'); });
            btn.classList.add('selected');
            var grabBtn = card.querySelector('.grab-btn');
            grabBtn.disabled = false;
            grabBtn.classList.remove('disabled');
            grabBtn.classList.add('active');
            grabBtn.onclick = function() {
                var room = card.querySelector('.room-card-title').innerText;
                var bed = btn.querySelector('span').innerText;
                alert('成功预约 ' + room + ' ' + bed + '！请在30分钟内完成选定确认。');
            };
        }
        // Countdown
        setInterval(function() {
            var s = document.getElementById('seconds');
            var m = document.getElementById('minutes');
            var h = document.getElementById('hours');
            var sec = parseInt(s.innerText) - 1;
            if (sec < 0) { sec = 59; var min = parseInt(m.innerText) - 1; if (min < 0) { min = 59; var hr = parseInt(h.innerText) - 1; h.innerText = (hr < 10 ? '0' : '') + hr; } m.innerText = (min < 10 ? '0' : '') + min; }
            s.innerText = (sec < 10 ? '0' : '') + sec;
        }, 1000);
    </script>
</asp:Content>
