<%@ Page Language="C#" MasterPageFile="~/student/MasterPage.master" AutoEventWireup="true" CodeFile="repair.aspx.cs" Inherits="student_repair" ResponseEncoding="utf-8" %>

<asp:Content ID="Content1" ContentPlaceHolderID="title" runat="server">故障报修 - 智慧宿舍</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="head" runat="server">
    <style>
        .tab-bar { display:flex; justify-content:center; margin-bottom:24px; }
        .tab-group { display:inline-flex; background:rgba(255,255,255,0.6); backdrop-filter:blur(8px); border-radius:14px; padding:4px; border:1px solid rgba(255,255,255,0.4); }
        .tab-btn { padding:10px 32px; border:none; border-radius:10px; font-size:14px; font-weight:700; cursor:pointer; transition:all 0.2s; background:transparent; color:var(--on-surface-variant); font-family:inherit; }
        .tab-btn.active { background:var(--primary); color:var(--on-primary); box-shadow:0 2px 8px rgba(73,234,206,0.3); }

        .repair-form { background:rgba(255,255,255,0.65); backdrop-filter:blur(12px); border-radius:20px; padding:24px; border:1px solid rgba(255,255,255,0.5); }
        .form-row { display:grid; grid-template-columns:1fr 1fr; gap:16px; }
        .form-full { grid-column:1/-1; }
        .form-label { display:block; font-size:14px; font-weight:700; color:var(--on-surface); margin-bottom:8px; }
        .form-label .required { color:var(--error); }
        .form-select, .form-textarea, .form-input {
            width:100%; padding:14px 16px; border:1px solid var(--outline-variant); border-radius:14px;
            background:#fff; font-family:inherit; font-size:15px; color:var(--on-surface); outline:none; transition:all 0.2s; box-sizing:border-box;
        }
        .form-select:focus, .form-textarea:focus, .form-input:focus { border-color:var(--primary); box-shadow:0 0 0 3px rgba(73,234,206,0.12); }
        .form-textarea { min-height:120px; resize:none; }

        .upload-area {
            border:2px dashed var(--outline-variant); border-radius:16px; padding:24px; text-align:center;
            cursor:pointer; transition:all 0.2s; background:rgba(255,255,255,0.3); position:relative;
        }
        .upload-area:hover { border-color:var(--primary); background:rgba(73,234,206,0.04); }
        .upload-icon { font-size:36px; color:var(--outline-variant); margin-bottom:8px; }
        .upload-text { font-size:14px; font-weight:600; color:var(--on-surface); }
        .upload-hint { font-size:12px; color:var(--on-surface-variant); margin-top:4px; }
        .upload-preview { display:flex; gap:8px; flex-wrap:wrap; margin-top:12px; }
        .upload-preview img { width:60px; height:60px; object-fit:cover; border-radius:8px; border:1px solid var(--outline-variant); }

        .submit-btn {
            width:100%; padding:16px; background:var(--primary); color:var(--on-primary); border:none;
            border-radius:14px; font-size:16px; font-weight:700; cursor:pointer; display:flex; align-items:center;
            justify-content:center; gap:8px; margin-top:20px; box-shadow:0 4px 16px rgba(73,234,206,0.3); transition:all 0.2s; font-family:inherit;
        }
        .submit-btn:hover { box-shadow:0 6px 24px rgba(73,234,206,0.5); }

        .repair-card {
            background:rgba(255,255,255,0.65); backdrop-filter:blur(12px); border-radius:18px; padding:20px;
            border:1px solid rgba(255,255,255,0.5); margin-bottom:14px; transition:all 0.2s;
        }
        .repair-card:hover { box-shadow:0 4px 16px rgba(0,0,0,0.06); }
        .repair-card-header { display:flex; justify-content:space-between; align-items:start; margin-bottom:12px; }
        .repair-card-left { display:flex; align-items:center; gap:12px; }
        .repair-card-icon { width:42px; height:42px; border-radius:12px; display:flex; align-items:center; justify-content:center; background:rgba(255,255,255,0.6); border:1px solid rgba(255,255,255,0.4); }
        .repair-card-title { font-size:15px; font-weight:700; color:var(--on-surface); }
        .repair-card-no { font-size:12px; color:var(--on-surface-variant); margin-top:2px; }
        .repair-status { padding:4px 12px; border-radius:20px; font-size:12px; font-weight:700; }
        .status-completed { background:rgba(73,234,206,0.12); color:#006b5c; }
        .status-processing { background:rgba(59,130,246,0.1); color:#3b82f6; }
        .status-pending { background:rgba(251,192,45,0.12); color:#b58900; }
        .repair-card-footer { display:flex; justify-content:space-between; align-items:center; padding-top:12px; border-top:1px solid rgba(0,0,0,0.05); margin-top:12px; }
        .repair-card-time { font-size:12px; color:var(--on-surface-variant); display:flex; align-items:center; gap:4px; }
        .section-empty { text-align:center; padding:40px; color:var(--on-surface-variant); }
        .section-empty .material-symbols-outlined { font-size:48px; opacity:0.3; display:block; margin-bottom:8px; }
        .dorm-info { display:flex; align-items:center; gap:8px; padding:10px 14px; background:rgba(73,234,206,0.06); border-radius:12px; margin-bottom:16px; font-size:14px; color:var(--on-surface); font-weight:600; }
    </style>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <asp:ScriptManager ID="ScriptManager1" runat="server" />
    <asp:HiddenField ID="hfRoomId" runat="server" Value="0" />

    <div class="tab-bar">
        <div class="tab-group">
            <button type="button" class="tab-btn active" onclick="switchTab('new')">提交申请</button>
            <button type="button" class="tab-btn" onclick="switchTab('list')">我的报修</button>
        </div>
    </div>

    <!-- 提交申请 -->
    <div id="tab-new">
        <div class="repair-form">
            <div style="display:flex; align-items:center; gap:12px; margin-bottom:24px;">
                <div style="padding:10px; background:var(--primary); border-radius:12px; box-shadow:0 4px 12px rgba(73,234,206,0.3);">
                    <span class="material-symbols-outlined" style="color:#fff; font-size:24px;">handyman</span>
                </div>
                <div>
                    <h2 style="font-size:18px; font-weight:700; color:var(--on-surface); margin:0;">新建报修单</h2>
                    <p style="font-size:13px; color:var(--on-surface-variant); margin:0;">请填写详细信息以便我们更高效地为您服务</p>
                </div>
            </div>

            <div class="dorm-info">
                <span class="material-symbols-outlined" style="font-size:18px;">home</span>
                报修宿舍：<asp:Literal ID="litDormInfo" runat="server" />
            </div>

            <div class="form-row">
                <div class="form-full">
                    <label class="form-label">报修类型 <span class="required">*</span></label>
                    <asp:DropDownList ID="ddlRepairType" runat="server" CssClass="form-select">
                        <asp:ListItem Value="1" Text="水电报修" />
                        <asp:ListItem Value="2" Text="家具家电" />
                        <asp:ListItem Value="3" Text="网络连接" />
                        <asp:ListItem Value="4" Text="其他问题" />
                    </asp:DropDownList>
                </div>
                <div class="form-full">
                    <label class="form-label">详细描述 <span class="required">*</span></label>
                    <asp:TextBox ID="txtDescription" runat="server" CssClass="form-textarea" TextMode="MultiLine" placeholder="请详细描述故障现象、具体位置以及出现时间..." />
                </div>
                <div>
                    <label class="form-label">期望上门时间</label>
                    <asp:TextBox ID="txtExpectTime" runat="server" CssClass="form-input" TextMode="DateTimeLocal" />
                </div>
                <div>
                    <label class="form-label">联系电话 <span class="required">*</span></label>
                    <asp:TextBox ID="txtContactPhone" runat="server" CssClass="form-input" placeholder="请输入您的手机号" />
                </div>
                <div class="form-full">
                    <label class="form-label">上传现场照片（可选，最多3张）</label>
                    <div class="upload-area" onclick="document.getElementById('<%= fuPhotos.ClientID %>').click();">
                        <span class="material-symbols-outlined upload-icon">add_a_photo</span>
                        <div class="upload-text">点击上传照片</div>
                        <div class="upload-hint">支持 JPG/PNG 格式，每张不超过 5MB</div>
                        <div id="previewArea" class="upload-preview"></div>
                    </div>
                    <asp:FileUpload ID="fuPhotos" runat="server" style="display:none;" accept="image/*" AllowMultiple="true" onchange="previewImages(this);" />
                </div>
            </div>

            <asp:Button ID="btnSubmit" runat="server" CssClass="submit-btn" Text="提交报修申请" OnClick="btnSubmit_Click" />
            <p style="text-align:center; font-size:12px; color:var(--on-surface-variant); margin-top:12px; font-style:italic;">提交后可在"我的报修"中实时查看处理进度</p>
        </div>
    </div>

    <!-- 我的报修 -->
    <div id="tab-list" style="display:none;">
        <asp:Repeater ID="rptRepairs" runat="server">
            <ItemTemplate>
                <div class="repair-card" style='<%# GetStatusBorderClass(Eval("Status")) %>'>
                    <div class="repair-card-header">
                        <div class="repair-card-left">
                            <div class="repair-card-icon">
                                <span class="material-symbols-outlined" style='<%# GetRepairIconColor(Eval("RepairType")) %>'><%# GetRepairIcon(Eval("RepairType")) %></span>
                            </div>
                            <div>
                                <div class="repair-card-title"><%# Eval("TypeName") %></div>
                                <div class="repair-card-no">订单编号: <%# Eval("OrderNo") %></div>
                            </div>
                        </div>
                        <span class="repair-status <%# GetStatusCssClass(Eval("Status")) %>"><%# Eval("StatusName") %></span>
                    </div>
                    <div style="font-size:14px; color:var(--on-surface); margin-bottom:8px;"><%# Eval("Description") %></div>
                    <%# GetPhotosHtml(Eval("Photos")) %>
                    <%# Eval("InternalNote") != DBNull.Value && !string.IsNullOrEmpty(Eval("InternalNote").ToString()) ? "<div style='background:rgba(73,234,206,0.05);border:1px solid rgba(73,234,206,0.1);border-radius:12px;padding:10px;margin-top:8px;'><p style='font-size:13px;color:var(--on-surface-variant);margin:0;font-style:italic;'>维修备注：" + Eval("InternalNote") + "</p></div>" : "" %>
                    <div class="repair-card-footer">
                        <span class="repair-card-time">
                            <span class="material-symbols-outlined" style="font-size:14px;">calendar_today</span>
                            <%# Convert.ToDateTime(Eval("CreateTime")).ToString("yyyy-MM-dd HH:mm") %>
                        </span>
                        <span style="font-size:12px; color:var(--on-surface-variant);"><%# Eval("BuildingName") %> <%# Eval("RoomNo") %></span>
                    </div>
                </div>
            </ItemTemplate>
        </asp:Repeater>

        <asp:Panel ID="pnlEmpty" runat="server" Visible="false" CssClass="section-empty">
            <span class="material-symbols-outlined">build</span>
            <span>暂无报修记录</span>
        </asp:Panel>
    </div>

    <div id="toast" class="toast"></div>

    <script type="text/javascript">
        function switchTab(tab) {
            var newSection = document.getElementById('tab-new');
            var listSection = document.getElementById('tab-list');
            var btns = document.querySelectorAll('.tab-btn');
            btns.forEach(function(b) { b.classList.remove('active'); });
            if (tab === 'new') {
                newSection.style.display = 'block';
                listSection.style.display = 'none';
                btns[0].classList.add('active');
            } else {
                newSection.style.display = 'none';
                listSection.style.display = 'block';
                btns[1].classList.add('active');
            }
        }

        function previewImages(input) {
            var preview = document.getElementById('previewArea');
            preview.innerHTML = '';
            if (input.files.length > 3) {
                showToast('最多上传3张照片', 'error');
                input.value = '';
                return;
            }
            for (var i = 0; i < input.files.length; i++) {
                var file = input.files[i];
                if (file.size > 5 * 1024 * 1024) {
                    showToast('单张图片不能超过5MB', 'error');
                    input.value = '';
                    return;
                }
                var reader = new FileReader();
                reader.onload = function(e) {
                    var img = document.createElement('img');
                    img.src = e.target.result;
                    preview.appendChild(img);
                };
                reader.readAsDataURL(file);
            }
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
