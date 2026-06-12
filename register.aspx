<%@ Page Language="C#" AutoEventWireup="true" CodeFile="register.aspx.cs" Inherits="register" ResponseEncoding="utf-8" %>

<!DOCTYPE html>
<html lang="zh-CN">
<head runat="server">
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>注册 - 智慧宿舍</title>
    <link href="https://fonts.googleapis.com/css2?family=Manrope:wght@400;500;600;700;800&display=swap" rel="stylesheet" />
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&display=swap" rel="stylesheet" />
    <link href="/css/style.css" rel="stylesheet" />
    <style>
        .reg-bg {
            min-height:100vh; display:flex; flex-direction:column; align-items:center; justify-content:center;
            padding:20px; position:relative; overflow:hidden;
        }
        .reg-bg::before { content:''; position:absolute; top:-10%; left:-10%; width:50%; height:50%; background:rgba(73,234,206,0.15); border-radius:50%; filter:blur(80px); pointer-events:none; }
        .reg-bg::after { content:''; position:absolute; bottom:-10%; right:-10%; width:50%; height:50%; background:rgba(186,202,197,0.15); border-radius:50%; filter:blur(80px); pointer-events:none; }
        .reg-brand { text-align:center; margin-bottom:40px; position:relative; z-index:1; }
        .reg-brand-icon { width:64px; height:64px; margin:0 auto 16px; background:rgba(255,255,255,0.8); border-radius:20px; display:flex; align-items:center; justify-content:center; box-shadow:0 4px 16px rgba(0,0,0,0.06); border:1px solid rgba(255,255,255,0.5); }
        .reg-brand-icon .material-symbols-outlined { font-size:32px; color:var(--primary); }
        .reg-brand-title { font-size:28px; font-weight:800; color:var(--on-surface); }
        .reg-brand-subtitle { font-size:14px; font-weight:600; color:var(--on-surface-variant); letter-spacing:0.2em; margin-top:4px; }
        .reg-card {
            width:100%; max-width:420px; background:rgba(255,255,255,0.7); backdrop-filter:blur(12px);
            border:1px solid rgba(255,255,255,0.4); border-radius:28px; padding:36px 32px;
            box-shadow:0 20px 50px rgba(73,234,206,0.1); position:relative; z-index:1;
        }
        .reg-card-title { font-size:22px; font-weight:700; color:var(--on-surface); margin-bottom:4px; }
        .reg-card-desc { font-size:14px; color:var(--on-surface-variant); margin-bottom:24px; }
        .reg-tabs { display:flex; border-bottom:2px solid rgba(0,0,0,0.05); margin-bottom:24px; }
        .reg-tab { flex:1; padding:12px; text-align:center; font-size:14px; font-weight:700; cursor:pointer; border:none; background:transparent; font-family:inherit; color:var(--on-surface-variant); border-bottom:2px solid transparent; margin-bottom:-2px; transition:all 0.2s; }
        .reg-tab.active { color:var(--primary); border-bottom-color:var(--primary); }
        .input-group {
            position:relative; display:flex; align-items:center; border:1px solid var(--outline-variant);
            border-radius:16px; background:rgba(255,255,255,0.5); padding:0 16px; transition:all 0.2s; margin-bottom:16px;
        }
        .input-group:focus-within { border-color:var(--primary); box-shadow:0 0 0 4px rgba(73,234,206,0.15); background:#fff; }
        .input-group .material-symbols-outlined { color:var(--outline); font-size:22px; margin-right:12px; }
        .input-group input { flex:1; border:none; background:transparent; padding:16px 0; font-family:inherit; font-size:15px; color:var(--on-surface); outline:none; }
        .input-group input::placeholder { color:var(--outline-variant); }
        .reg-agreement { display:flex; align-items:start; gap:8px; padding:8px 0; margin-bottom:16px; }
        .reg-agreement input { margin-top:4px; accent-color:var(--primary); }
        .reg-agreement label { font-size:13px; color:var(--on-surface-variant); cursor:pointer; line-height:1.5; }
        .reg-agreement a { color:var(--primary); text-decoration:none; }
        .reg-btn {
            width:100%; padding:16px; border:none; border-radius:16px; background:var(--primary);
            color:var(--on-primary); font-family:inherit; font-size:16px; font-weight:700; cursor:pointer;
            box-shadow:0 4px 16px rgba(73,234,206,0.3); transition:all 0.2s;
        }
        .reg-btn:hover { box-shadow:0 6px 24px rgba(73,234,206,0.5); transform:translateY(-1px); }
        .reg-btn:active { transform:scale(0.98); }
        .reg-links { display:flex; justify-content:flex-start; margin-top:24px; padding-top:20px; border-top:1px solid rgba(0,0,0,0.05); }
        .reg-links a { font-size:14px; font-weight:600; color:var(--on-surface-variant); display:flex; align-items:center; gap:4px; transition:color 0.2s; text-decoration:none; }
        .reg-links a:hover { color:var(--primary); }
        .reg-links a .material-symbols-outlined { font-size:18px; }
        .reg-footer { margin-top:32px; text-align:center; position:relative; z-index:1; }
        .reg-footer p { font-size:12px; color:var(--on-surface-variant); opacity:0.7; }
        .reg-badges { display:flex; justify-content:center; gap:12px; margin-top:12px; }
        .reg-badge { font-size:12px; font-weight:500; padding:6px 14px; border-radius:9999px; background:rgba(255,255,255,0.4); backdrop-filter:blur(8px); border:1px solid rgba(186,202,197,0.3); color:var(--on-surface-variant); display:flex; align-items:center; gap:4px; }
        .reg-badge .material-symbols-outlined { font-size:14px; color:var(--primary); }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="reg-bg">
            <div class="reg-brand">
                <div class="reg-brand-icon"><span class="material-symbols-outlined">apartment</span></div>
                <div class="reg-brand-title">智慧宿舍</div>
                <div class="reg-brand-subtitle">SMART DORMITORY SYSTEM</div>
            </div>

            <div class="reg-card">
                <div class="reg-card-title">账号注册</div>
                <div class="reg-card-desc">加入智慧宿舍，开启便捷校园生活</div>

                <div class="reg-tabs">
                    <button type="button" class="reg-tab active" onclick="switchRegTab('student')">学生注册</button>
                    <button type="button" class="reg-tab" onclick="switchRegTab('teacher')">老师注册</button>
                </div>

                <div>
                    <label class="form-label" id="regIdLabel">学号</label>
                    <div class="input-group">
                        <span class="material-symbols-outlined">badge</span>
                        <input type="text" placeholder="请输入您的学号或工号" />
                    </div>
                </div>
                <div>
                    <label class="form-label">手机号</label>
                    <div class="input-group">
                        <span class="material-symbols-outlined">smartphone</span>
                        <input type="tel" placeholder="请输入手机号" />
                    </div>
                </div>
                <div>
                    <label class="form-label">密码</label>
                    <div class="input-group">
                        <span class="material-symbols-outlined">lock</span>
                        <input type="password" placeholder="请输入密码" />
                    </div>
                </div>
                <div>
                    <label class="form-label">确认密码</label>
                    <div class="input-group">
                        <span class="material-symbols-outlined">lock_reset</span>
                        <input type="password" placeholder="请再次输入密码" />
                    </div>
                </div>

                <div class="reg-agreement">
                    <input type="checkbox" id="agreement" />
                    <label for="agreement">我已阅读并同意 <a href="#">用户服务协议</a> 与 <a href="#">隐私政策</a></label>
                </div>

                <asp:Button ID="btnRegister" runat="server" Text="立即注册" CssClass="reg-btn" OnClick="btnRegister_Click" />

                <div class="reg-links">
                    <a href="login.aspx"><span class="material-symbols-outlined">arrow_back</span> 已有账号？返回登录</a>
                </div>
            </div>

            <div class="reg-footer">
                <p>&copy; 2024 智慧宿舍管理系统 版权所有</p>
                <div class="reg-badges">
                    <span class="reg-badge"><span class="material-symbols-outlined">verified_user</span> 安全门户</span>
                    <span class="reg-badge"><span class="material-symbols-outlined">monitoring</span> 实时系统</span>
                    <span class="reg-badge"><span class="material-symbols-outlined">support_agent</span> 24/7 支持</span>
                </div>
            </div>
        </div>
    </form>

    <script type="text/javascript">
        function switchRegTab(type) {
            var tabs = document.querySelectorAll('.reg-tab');
            tabs.forEach(function(t) { t.classList.remove('active'); });
            var label = document.getElementById('regIdLabel');
            if (type === 'student') {
                tabs[0].classList.add('active');
                label.innerText = '学号';
            } else {
                tabs[1].classList.add('active');
                label.innerText = '工号';
            }
        }
    </script>
</body>
</html>
