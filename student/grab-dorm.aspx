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
        .countdown-text { font-size:24px; font-weight:800; color:var(--primary); font-variant-numeric:tabular-nums; }

        .room-grid { display:grid; grid-template-columns:repeat(auto-fill, minmax(280px, 1fr)); gap:20px; }

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

        .empty-state { text-align:center; padding:60px 20px; color:var(--on-surface-variant); }
        .empty-state .material-symbols-outlined { font-size:48px; opacity:0.3; display:block; margin-bottom:12px; }
    </style>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <asp:ScriptManager ID="ScriptManager1" runat="server" />

    <div class="grab-header">
        <div>
            <h1>选宿舍 - <asp:Literal ID="litBatchName" runat="server" /></h1>
            <p>名额有限，请在倒计时结束前选定寝室。</p>
        </div>
        <div class="countdown-card">
            <div class="countdown-label">距离本轮选宿结束还剩</div>
            <div class="countdown-text" id="countdownDisplay"><asp:Literal ID="litCountdown" runat="server" /></div>
        </div>
    </div>

    <asp:HiddenField ID="hfEndTime" runat="server" Value="0" />
    <asp:HiddenField ID="hfSelectedBedId" runat="server" Value="" />

    <asp:Panel ID="pnlAlreadyAllocated" runat="server" Visible="false" CssClass="empty-state">
        <asp:Literal ID="litAlreadyAllocated" runat="server" Text="<span class='material-symbols-outlined'>bed</span>您已有宿舍，无需重复选择。<br/><a href='/student/home.aspx' style='color:var(--primary);font-weight:700;'>返回首页</a>" />
    </asp:Panel>

    <asp:Panel ID="pnlRooms" runat="server">
        <div class="room-grid">
            <asp:Repeater ID="rptRooms" runat="server">
                <ItemTemplate>
                    <div class='<%# GetAvailableBeds(Convert.ToInt32(Eval("Id"))) == 0 ? "room-card full" : "room-card" %>'>
                        <div class="room-card-header">
                            <div>
                                <div class="room-card-title"><%# Eval("RoomNo") %> 室</div>
                                <div class="room-card-sub"><%# Eval("BuildingName") %> · <%# Eval("Campus") %></div>
                            </div>
                            <span class='<%# GetAvailableBeds(Convert.ToInt32(Eval("Id"))) == 0 ? "room-card-type full-type" : "room-card-type" %>'>
                                <%# GetRoomTypeText(Eval("RoomType")) %>
                            </span>
                        </div>
                        <div class="bed-label">选择床位：</div>
                        <div class="bed-grid">
                            <asp:Repeater ID="rptBeds" runat="server" DataSource='<%# GetBedsForRoom(Convert.ToInt32(Eval("Id"))) %>'>
                                <ItemTemplate>
                                    <%# Convert.ToInt32(Eval("Status")) == 1 ? 
                                        "<div class='bed-btn occupied'><span>" + Eval("BedNo") + "号床</span><span style='font-size:12px;'>已占</span></div>" :
                                        "<button type='button' class='bed-btn' onclick=\"selectBed(this, " + Eval("Id") + ")\" data-bed-id='" + Eval("Id") + "'><span>" + Eval("BedNo") + "号床</span><span class='material-symbols-outlined'>bed</span></button>"
                                    %>
                                </ItemTemplate>
                            </asp:Repeater>
                        </div>
                        <%# GetAvailableBeds(Convert.ToInt32(Eval("Id"))) == 0 ? 
                            "<button type='button' class='grab-btn full-btn' disabled>已满额</button>" :
                            "<button type='button' class='grab-btn disabled' disabled onclick=\"grabBed(this)\">选定此床位</button>"
                        %>
                    </div>
                </ItemTemplate>
            </asp:Repeater>
        </div>

        <asp:Panel ID="pnlEmpty" runat="server" Visible="false" CssClass="empty-state">
            <span class="material-symbols-outlined">meeting_room</span>
            <span>该批次暂无可选宿舍</span>
        </asp:Panel>
    </asp:Panel>

    <asp:Button ID="btnGrab" runat="server" Style="display:none;" OnClick="btnGrab_Click" />

    <div id="toast" class="toast"></div>

    <script type="text/javascript">
        var selectedBedId = 0;

        function selectBed(btn, bedId) {
            var card = btn.closest('.room-card');
            var beds = card.querySelectorAll('.bed-btn:not(.occupied)');
            beds.forEach(function(b) { b.classList.remove('selected'); });
            btn.classList.add('selected');
            selectedBedId = bedId;
            document.getElementById('<%= hfSelectedBedId.ClientID %>').value = bedId;

            var grabBtn = card.querySelector('.grab-btn');
            if (grabBtn && !grabBtn.classList.contains('full-btn')) {
                grabBtn.disabled = false;
                grabBtn.classList.remove('disabled');
                grabBtn.classList.add('active');
            }
        }

        function grabBed(btn) {
            if (selectedBedId <= 0) {
                showToast('请先选择一个床位', 'error');
                return;
            }
            // 触发服务端按钮
            document.getElementById('<%= btnGrab.ClientID %>').click();
        }

        // 倒计时
        var endTimeMs = parseInt(document.getElementById('<%= hfEndTime.ClientID %>').value);
        if (endTimeMs > 0) {
            setInterval(function() {
                var now = new Date().getTime();
                var diff = endTimeMs - now;
                if (diff <= 0) {
                    document.getElementById('countdownDisplay').innerText = '00:00:00';
                    return;
                }
                var h = Math.floor(diff / 3600000);
                var m = Math.floor((diff % 3600000) / 60000);
                var s = Math.floor((diff % 60000) / 1000);
                document.getElementById('countdownDisplay').innerText =
                    (h < 10 ? '0' : '') + h + ':' + (m < 10 ? '0' : '') + m + ':' + (s < 10 ? '0' : '') + s;
            }, 1000);
        }

        function showToast(msg, type) {
            var toast = document.getElementById('toast');
            toast.className = 'toast toast-' + type;
            toast.innerHTML = '<span class="material-symbols-outlined">' + (type === 'success' ? 'check_circle' : 'error') + '</span>' + msg;
            toast.classList.add('show');
            setTimeout(function() { toast.classList.remove('show'); }, 3000);
        }
    </script>
</asp:Content>
