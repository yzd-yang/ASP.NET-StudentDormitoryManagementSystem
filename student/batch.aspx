<%@ Page Language="C#" MasterPageFile="~/student/MasterPage.master" AutoEventWireup="true" CodeFile="batch.aspx.cs" Inherits="student_batch" ResponseEncoding="utf-8" %>

<asp:Content ID="Content1" ContentPlaceHolderID="title" runat="server">选宿批次 - 智慧宿舍</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="head" runat="server">
    <style>
        .batch-header { margin-bottom:24px; }
        .batch-header h1 { font-size:32px; font-weight:800; color:var(--on-surface); }
        .batch-header p { font-size:16px; color:var(--on-surface-variant); margin-top:6px; }

        .filter-bar { background:rgba(255,255,255,0.5); backdrop-filter:blur(8px); border-radius:16px; padding:16px; border:1px solid rgba(255,255,255,0.4); margin-bottom:20px; display:grid; grid-template-columns:1fr 1fr auto; gap:12px; align-items:end; }
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
        .batch-status { padding:4px 14px; border-radius:20px; font-size:13px; font-weight:700; display:inline-block; }
        .batch-status.active { background:var(--primary); color:var(--on-primary); animation:pulse 2s infinite; }
        .batch-status.upcoming { background:rgba(232,233,236,0.8); color:var(--on-surface-variant); }
        .batch-status.ended { background:rgba(186,26,26,0.08); color:var(--on-surface-variant); }
        .batch-status.paused { background:rgba(251,192,45,0.15); color:#b58900; }
        @keyframes pulse { 0%,100%{opacity:1} 50%{opacity:0.7} }
        .batch-btn {
            padding:8px 18px; border:none; border-radius:10px; font-size:13px; font-weight:700;
            cursor:pointer; transition:all 0.2s; font-family:inherit; text-decoration:none; display:inline-block;
        }
        .batch-btn.primary { background:var(--primary); color:var(--on-primary); }
        .batch-btn.ghost { background:rgba(232,233,236,0.6); color:var(--on-surface-variant); cursor:default; }
        .batch-limit { font-size:12px; color:var(--on-surface-variant); margin-top:2px; }

        .batch-empty { text-align:center; padding:60px 20px; color:var(--on-surface-variant); }
        .batch-empty .material-symbols-outlined { font-size:48px; opacity:0.3; display:block; margin-bottom:12px; }

        .tip-card {
            background:rgba(255,255,255,0.5); backdrop-filter:blur(8px); border-radius:16px;
            padding:24px; border:1px solid rgba(255,255,255,0.4); display:flex; gap:20px;
            align-items:center; margin-top:32px;
        }
        .tip-icon { width:72px; height:72px; border-radius:50%; background:rgba(73,234,206,0.12); display:flex; align-items:center; justify-content:center; flex-shrink:0; }
        .tip-icon .material-symbols-outlined { font-size:36px; color:var(--primary); }
        .tip-title { font-size:18px; font-weight:700; color:var(--primary); margin-bottom:6px; }
        .tip-text { font-size:14px; color:var(--on-surface-variant); line-height:1.6; }

        .info-modal { display:none; position:fixed; inset:0; z-index:999; background:rgba(0,0,0,0.4); backdrop-filter:blur(4px); align-items:center; justify-content:center; }
        .info-modal.show { display:flex; }
        .info-modal-box { background:#fff; border-radius:20px; padding:32px; max-width:380px; width:90%; text-align:center; box-shadow:0 20px 50px rgba(0,0,0,0.2); }
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
            <asp:TextBox ID="txtKeyword" runat="server" CssClass="filter-input" placeholder="搜索批次..." />
        </div>
        <div class="filter-group">
            <span class="filter-label">状态</span>
            <asp:DropDownList ID="ddlStatus" runat="server" CssClass="filter-select">
                <asp:ListItem Text="全部状态" Value="-1" />
                <asp:ListItem Text="进行中" Value="1" />
                <asp:ListItem Text="待开始" Value="0" />
                <asp:ListItem Text="已结束" Value="2" />
            </asp:DropDownList>
        </div>
        <asp:Button ID="btnFilter" runat="server" CssClass="filter-btn" Text=" 筛选" OnClick="btnFilter_Click" />
    </div>

    <div class="batch-table">
        <asp:Repeater ID="rptBatches" runat="server">
            <HeaderTemplate>
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
            </HeaderTemplate>
            <ItemTemplate>
                <tr>
                    <td><span class="batch-name"><%# Eval("BatchName") %></span></td>
                    <td><%# Eval("BuildingNames") != DBNull.Value ? Eval("BuildingNames") : "全部楼栋" %></td>
                    <td><%# Eval("GradeLimit") != DBNull.Value ? Eval("GradeLimit") : "不限年级" %></td>
                    <td><%# Eval("MajorLimit") != DBNull.Value ? Eval("MajorLimit") : "不限专业" %></td>
                    <td><span class="batch-status <%# GetStatusClass(Convert.ToInt32(Eval("Status"))) %>"><%# GetStatusText(Convert.ToInt32(Eval("Status"))) %></span></td>
                    <td style="text-align:center;">
                        <%# Convert.ToInt32(Eval("Status")) == 1 ? "<a href='grab-dorm.aspx?batchId=" + Eval("Id") + "' class='batch-btn primary' onclick='return checkInfo();'>进入选宿</a>" : "<span class='batch-btn ghost'>" + (Convert.ToInt32(Eval("Status")) == 0 ? "未开始" : "已结束") + "</span>" %>
                    </td>
                </tr>
            </ItemTemplate>
            <FooterTemplate>
                    </tbody>
                </table>
            </FooterTemplate>
        </asp:Repeater>

        <asp:Panel ID="pnlEmpty" runat="server" Visible="false" CssClass="batch-empty">
            <span class="material-symbols-outlined">meeting_room</span>
            <span>暂无可参与的选宿批次</span>
        </asp:Panel>
    </div>

    <div class="tip-card">
        <div class="tip-icon"><span class="material-symbols-outlined">info</span></div>
        <div>
            <div class="tip-title">选宿小贴士</div>
            <div class="tip-text">请确保您的网络环境稳定，提前了解心仪宿舍楼层及配置。若遇到问题，可点击右上角"帮助"或联系宿管中心。</div>
        </div>
    </div>

    <div id="infoModal" class="info-modal">
        <div class="info-modal-box">
            <span class="material-symbols-outlined" style="font-size:48px; color:var(--primary); margin-bottom:12px;">info</span>
            <h3 style="font-size:18px; font-weight:700; color:var(--on-surface); margin-bottom:8px;">请先完善个人信息</h3>
            <p style="font-size:14px; color:var(--on-surface-variant); margin-bottom:24px; line-height:1.6;">选宿前需要填写所属学院、专业名称和年级信息，请先前往个人中心完善资料。</p>
            <div style="display:flex; gap:10px; justify-content:center;">
                <button type="button" onclick="closeModal()" style="padding:10px 24px; border:1px solid var(--outline-variant); border-radius:12px; background:transparent; font-size:14px; font-weight:700; cursor:pointer; font-family:inherit;">取消</button>
                <a href="profile.aspx" style="padding:10px 24px; background:var(--primary); color:var(--on-primary); border-radius:12px; font-size:14px; font-weight:700; text-decoration:none;">去填写</a>
            </div>
        </div>
    </div>

    <script type="text/javascript">
        var infoComplete = <%= IsInfoComplete() ? "true" : "false" %>;
        function checkInfo() {
            if (!infoComplete) {
                document.getElementById('infoModal').classList.add('show');
                return false;
            }
            return true;
        }
        function closeModal() {
            document.getElementById('infoModal').classList.remove('show');
        }
    </script>
</asp:Content>
