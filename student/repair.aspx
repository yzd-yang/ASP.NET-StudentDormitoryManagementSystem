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
        .form-select, .form-textarea {
            width:100%; padding:14px 16px; border:1px solid var(--outline-variant); border-radius:14px;
            background:#fff; font-family:inherit; font-size:15px; color:var(--on-surface); outline:none; transition:all 0.2s;
        }
        .form-select:focus, .form-textarea:focus { border-color:var(--primary); box-shadow:0 0 0 3px rgba(73,234,206,0.12); }
        .form-textarea { min-height:120px; resize:none; }

        .upload-area {
            border:2px dashed var(--outline-variant); border-radius:16px; padding:32px; text-align:center;
            cursor:pointer; transition:all 0.2s; background:rgba(255,255,255,0.3);
        }
        .upload-area:hover { border-color:var(--primary); background:rgba(73,234,206,0.04); }
        .upload-icon { font-size:40px; color:var(--outline-variant); margin-bottom:8px; }
        .upload-text { font-size:14px; font-weight:600; color:var(--on-surface); }
        .upload-hint { font-size:12px; color:var(--on-surface-variant); margin-top:4px; }

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
        .repair-card-action { font-size:13px; font-weight:700; color:var(--primary); cursor:pointer; text-decoration:none; display:flex; align-items:center; gap:4px; }
        .repair-card-action:hover { text-decoration:underline; }
        .repair-card-action.cancel { color:var(--error); }
        .repair-card-note { background:rgba(73,234,206,0.05); border:1px solid rgba(73,234,206,0.1); border-radius:12px; padding:12px; margin-bottom:12px; }
        .repair-card-note p { font-size:14px; color:var(--on-surface-variant); font-style:italic; }
        .repair-card-notice { display:flex; align-items:center; gap:8px; padding:10px 14px; border-radius:12px; background:rgba(59,130,246,0.05); border:1px solid rgba(59,130,246,0.1); margin-bottom:12px; font-size:14px; color:#3b82f6; }
        .section-empty { text-align:center; padding:40px; color:var(--on-surface-variant); }
        .section-empty .material-symbols-outlined { font-size:48px; opacity:0.3; display:block; margin-bottom:8px; }
    </style>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <!-- 标签切换 -->
    <div class="tab-bar">
        <div class="tab-group">
            <button class="tab-btn active" onclick="switchTab('new')">提交申请</button>
            <button class="tab-btn" onclick="switchTab('list')">我的报修</button>
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

            <div class="form-row">
                <div class="form-full">
                    <label class="form-label">报修类型 <span class="required">*</span></label>
                    <select class="form-select">
                        <option>水电报修</option>
                        <option>家具家电</option>
                        <option>网络连接</option>
                        <option>其他问题</option>
                    </select>
                </div>
                <div class="form-full">
                    <label class="form-label">详细描述 <span class="required">*</span></label>
                    <textarea class="form-textarea" placeholder="请详细描述故障现象、具体位置以及出现时间..."></textarea>
                </div>
                <div>
                    <label class="form-label">期望上门时间</label>
                    <input type="datetime-local" class="form-select" />
                </div>
                <div>
                    <label class="form-label">联系电话 <span class="required">*</span></label>
                    <input type="tel" class="form-select" placeholder="请输入您的手机号" />
                </div>
                <div class="form-full">
                    <label class="form-label">上传现场照片</label>
                    <div class="upload-area">
                        <span class="material-symbols-outlined upload-icon">add_a_photo</span>
                        <div class="upload-text">点击或将图片拖拽至此上传</div>
                        <div class="upload-hint">支持 JPG, PNG 格式，每张不超过 5MB</div>
                    </div>
                </div>
            </div>
            <button class="submit-btn" type="button">
                <span class="material-symbols-outlined" style="font-size:20px;">send</span>
                提交报修申请
            </button>
            <p style="text-align:center; font-size:12px; color:var(--on-surface-variant); margin-top:12px; font-style:italic;">提交后可在"我的报修"中实时查看处理进度</p>
        </div>
    </div>

    <!-- 我的报修 -->
    <div id="tab-list" style="display:none;">
        <!-- 已完成 -->
        <div class="repair-card" style="border-left:4px solid #49EACE;">
            <div class="repair-card-header">
                <div class="repair-card-left">
                    <div class="repair-card-icon"><span class="material-symbols-outlined" style="color:var(--primary);">water_drop</span></div>
                    <div>
                        <div class="repair-card-title">洗手间龙头漏水</div>
                        <div class="repair-card-no">订单编号: RE-2023091001</div>
                    </div>
                </div>
                <span class="repair-status status-completed">已完成</span>
            </div>
            <div class="repair-card-note">
                <p>" 维修师傅已于 09-11 14:30 修复水龙头并更换密封圈。 "</p>
            </div>
            <div class="repair-card-footer">
                <span class="repair-card-time"><span class="material-symbols-outlined" style="font-size:14px;">calendar_today</span> 2023-09-10 10:20</span>
                <button class="btn btn-primary" style="padding:8px 20px; font-size:13px; border-radius:10px;">立即评价</button>
            </div>
        </div>

        <!-- 处理中 -->
        <div class="repair-card" style="border-left:4px solid #3b82f6;">
            <div class="repair-card-header">
                <div class="repair-card-left">
                    <div class="repair-card-icon"><span class="material-symbols-outlined" style="color:#3b82f6;">router</span></div>
                    <div>
                        <div class="repair-card-title">寝室WiFi无法连接</div>
                        <div class="repair-card-no">订单编号: RE-2023091244</div>
                    </div>
                </div>
                <span class="repair-status status-processing">处理中</span>
            </div>
            <div class="repair-card-notice">
                <span class="material-symbols-outlined" style="font-size:20px;">engineering</span>
                维修人员 张师傅 (139-0000-0000) 正在赶往现场
            </div>
            <div class="repair-card-footer">
                <span class="repair-card-time"><span class="material-symbols-outlined" style="font-size:14px;">calendar_today</span> 2023-09-12 16:45</span>
                <a href="#" class="repair-card-action">查看进度详情 <span class="material-symbols-outlined" style="font-size:16px;">arrow_forward</span></a>
            </div>
        </div>

        <!-- 待处理 -->
        <div class="repair-card" style="border-left:4px solid #fbc02d;">
            <div class="repair-card-header">
                <div class="repair-card-left">
                    <div class="repair-card-icon"><span class="material-symbols-outlined" style="color:#b58900;">chair</span></div>
                    <div>
                        <div class="repair-card-title">书桌抽屉滑轨损坏</div>
                        <div class="repair-card-no">订单编号: RE-2023091302</div>
                    </div>
                </div>
                <span class="repair-status status-pending">待处理</span>
            </div>
            <div class="repair-card-footer">
                <span class="repair-card-time"><span class="material-symbols-outlined" style="font-size:14px;">calendar_today</span> 2023-09-13 09:12</span>
                <a href="#" class="repair-card-action cancel"><span class="material-symbols-outlined" style="font-size:16px;">cancel</span> 取消申请</a>
            </div>
        </div>
    </div>

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
    </script>
</asp:Content>
