<%@ Page Language="C#" AutoEventWireup="true" CodeFile="login.aspx.cs" Inherits="login" ResponseEncoding="utf-8" %>

<!DOCTYPE html>
<html lang="zh-CN">
<head runat="server">
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>智慧宿舍 - 登录</title>
    <link href="https://fonts.googleapis.com/css2?family=Manrope:wght@400;500;600;700;800&display=swap" rel="stylesheet" />
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&display=swap" rel="stylesheet" />
    <link href="css/style.css" rel="stylesheet" />
    <style>
        .login-bg {
            min-height: 100vh;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            padding: 20px;
            position: relative;
            overflow: hidden;
        }
        .login-bg::before {
            content: '';
            position: absolute;
            top: -10%;
            left: -10%;
            width: 50%;
            height: 50%;
            background: rgba(73, 234, 206, 0.15);
            border-radius: 50%;
            filter: blur(80px);
            pointer-events: none;
        }
        .login-bg::after {
            content: '';
            position: absolute;
            bottom: -10%;
            right: -10%;
            width: 50%;
            height: 50%;
            background: rgba(186, 202, 197, 0.15);
            border-radius: 50%;
            filter: blur(80px);
            pointer-events: none;
        }
        .login-brand {
            text-align: center;
            margin-bottom: 40px;
            position: relative;
            z-index: 1;
        }
        .login-brand-icon {
            width: 64px;
            height: 64px;
            margin: 0 auto 16px;
            background: rgba(255, 255, 255, 0.8);
            border-radius: 20px;
            display: flex;
            align-items: center;
            justify-content: center;
            box-shadow: 0 4px 16px rgba(0,0,0,0.06);
            border: 1px solid rgba(255,255,255,0.5);
        }
        .login-brand-icon .material-symbols-outlined {
            font-size: 32px;
            color: var(--primary);
        }
        .login-brand-title {
            font-size: 28px;
            font-weight: 800;
            color: var(--on-surface);
        }
        .login-brand-subtitle {
            font-size: 14px;
            font-weight: 600;
            color: var(--on-surface-variant);
            letter-spacing: 0.2em;
            margin-top: 4px;
        }
        .login-card {
            width: 100%;
            max-width: 420px;
            background: rgba(255, 255, 255, 0.7);
            backdrop-filter: blur(12px);
            border: 1px solid rgba(255, 255, 255, 0.4);
            border-radius: 28px;
            padding: 36px 32px;
            box-shadow: 0 20px 50px rgba(73, 234, 206, 0.1);
            position: relative;
            z-index: 1;
        }
        .login-card-title {
            font-size: 22px;
            font-weight: 700;
            color: var(--on-surface);
            margin-bottom: 4px;
        }
        .login-card-desc {
            font-size: 14px;
            color: var(--on-surface-variant);
            margin-bottom: 28px;
        }
        .input-group {
            position: relative;
            display: flex;
            align-items: center;
            border: 1px solid var(--outline-variant);
            border-radius: 16px;
            background: rgba(255, 255, 255, 0.5);
            padding: 0 16px;
            transition: all 0.2s;
        }
        .input-group:focus-within {
            border-color: var(--primary);
            box-shadow: 0 0 0 4px rgba(73, 234, 206, 0.15);
            background: #fff;
        }
        .input-group .material-symbols-outlined {
            color: var(--outline);
            font-size: 22px;
            margin-right: 12px;
        }
        .input-group input {
            flex: 1;
            border: none;
            background: transparent;
            padding: 16px 0;
            font-family: inherit;
            font-size: 15px;
            color: var(--on-surface);
            outline: none;
        }
        .input-group input::placeholder {
            color: var(--outline-variant);
        }
        .vcode-row {
            display: grid;
            grid-template-columns: 1fr auto;
            gap: 12px;
        }
        .vcode-img {
            height: 54px;
            border-radius: 16px;
            border: 1px solid var(--outline-variant);
            cursor: pointer;
            display: flex;
            align-items: center;
            justify-content: center;
            background: rgba(255, 255, 255, 0.5);
            padding: 0 12px;
            font-size: 20px;
            font-weight: 700;
            letter-spacing: 0.1em;
            color: var(--on-surface);
            user-select: none;
            transition: all 0.2s;
            overflow: hidden;
            flex-shrink: 0;
        }
        .vcode-img img { max-width: 100%; max-height: 100%; object-fit: contain; }
        .vcode-img:hover {
            background: rgba(255, 255, 255, 0.8);
        }
        .login-btn {
            width: 100%;
            padding: 16px;
            border: none;
            border-radius: 16px;
            background: var(--primary);
            color: var(--on-primary);
            font-family: inherit;
            font-size: 16px;
            font-weight: 700;
            cursor: pointer;
            transition: all 0.2s;
            box-shadow: 0 4px 16px rgba(73, 234, 206, 0.3);
        }
        .login-btn:hover {
            box-shadow: 0 6px 24px rgba(73, 234, 206, 0.5);
            transform: translateY(-1px);
        }
        .login-btn:active {
            transform: scale(0.98);
        }
        .login-links {
            display: flex;
            justify-content: space-between;
            margin-top: 24px;
            padding-top: 20px;
            border-top: 1px solid rgba(0,0,0,0.05);
        }
        .login-links a {
            font-size: 14px;
            font-weight: 600;
            color: var(--on-surface-variant);
            display: flex;
            align-items: center;
            gap: 4px;
            transition: color 0.2s;
        }
        .login-links a:hover {
            color: var(--primary);
        }
        .login-links a .material-symbols-outlined {
            font-size: 18px;
        }
        .login-footer {
            margin-top: 32px;
            text-align: center;
            position: relative;
            z-index: 1;
        }
        .login-footer p {
            font-size: 12px;
            color: var(--on-surface-variant);
            opacity: 0.7;
        }
        .login-footer-badges {
            display: flex;
            justify-content: center;
            gap: 12px;
            margin-top: 12px;
        }
        .login-footer-badges span {
            font-size: 12px;
            font-weight: 500;
            padding: 6px 14px;
            border-radius: 9999px;
            background: rgba(255, 255, 255, 0.4);
            backdrop-filter: blur(8px);
            border: 1px solid rgba(186, 202, 197, 0.3);
            color: var(--on-surface-variant);
        }
        .error-msg {
            color: var(--error);
            font-size: 13px;
            font-weight: 500;
            margin-top: 8px;
            display: none;
        }
        .error-msg.show {
            display: block;
        }
        .login-tabs { display:flex; border-bottom:2px solid rgba(0,0,0,0.05); margin-bottom:24px; }
        .login-tab { flex:1; padding:12px; text-align:center; font-size:14px; font-weight:700; cursor:pointer; border:none; background:transparent; font-family:inherit; color:var(--on-surface-variant); border-bottom:2px solid transparent; margin-bottom:-2px; transition:all 0.2s; }
        .login-tab.active { color:var(--primary); border-bottom-color:var(--primary); }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="login-bg">
            <div class="login-brand">
                <div class="login-brand-icon">
                    <span class="material-symbols-outlined">apartment</span>
                </div>
                <div class="login-brand-title">智慧宿舍</div>
                <div class="login-brand-subtitle">智慧宿舍管理系统</div>
            </div>

            <div class="login-card">
                <div class="login-card-title">账号登录</div>
                <div class="login-card-desc">欢迎回来，请输入您的信息以继续访问系统</div>

                <div class="login-tabs">
                    <button type="button" class="login-tab active" onclick="switchLoginTab('student')">学生登录</button>
                    <button type="button" class="login-tab" onclick="switchLoginTab('admin')">管理员登录</button>
                </div>
                <asp:HiddenField ID="hfRole" runat="server" Value="student" />

                <div style="display: flex; flex-direction: column; gap: 20px;">
                    <div>
                        <label class="form-label" id="loginIdLabel">学号</label>
                        <div class="input-group">
                            <span class="material-symbols-outlined">person</span>
                            <asp:TextBox ID="txtUserNo" runat="server" />
                        </div>
                    </div>

                    <div>
                        <label class="form-label">密码</label>
                        <div class="input-group">
                            <span class="material-symbols-outlined">lock</span>
                            <asp:TextBox ID="txtPassword" runat="server" TextMode="Password" />
                        </div>
                    </div>

                    <div>
                        <label class="form-label">验证码</label>
                        <div class="vcode-row">
                            <div class="input-group">
                                <span class="material-symbols-outlined">verified_user</span>
                                <asp:TextBox ID="txtVerifyCode" runat="server" MaxLength="4" />
                            </div>
                            <div class="vcode-img" onclick="refreshCode()">
                                <asp:Image ID="imgCode" runat="server" ImageUrl="~/checkcode.aspx" Width="100" Height="40" />
                            </div>
                        </div>
                    </div>

                    <asp:Label ID="lblError" runat="server" CssClass="error-msg" />

                    <asp:Button ID="btnLogin" runat="server" Text="立即登录" CssClass="login-btn" OnClick="btnLogin_Click" />
                </div>

                <div class="login-links">
                    <a href="/reset-password.aspx">
                        <span class="material-symbols-outlined">help_outline</span>
                        忘记密码？
                    </a>
                    <a href="register.aspx">
                        立即注册
                        <span class="material-symbols-outlined">arrow_forward</span>
                    </a>
                </div>
            </div>

            <div class="login-footer">
                <p>&copy; 2024 智慧宿舍管理系统 版权所有</p>
            </div>
        </div>
    </form>

    <script type="text/javascript">
        function refreshCode() {
            var img = document.getElementById('<%= imgCode.ClientID %>');
            img.src = '/checkcode.aspx?t=' + new Date().getTime();
        }

        function switchLoginTab(type) {
            var tabs = document.querySelectorAll('.login-tab');
            tabs.forEach(function(t) { t.classList.remove('active'); });
            var label = document.getElementById('loginIdLabel');
            var hf = document.getElementById('<%= hfRole.ClientID %>');
            if (type === 'student') {
                tabs[0].classList.add('active');
                label.innerText = '学号';
                hf.value = 'student';
            } else {
                tabs[1].classList.add('active');
                label.innerText = '工号';
                hf.value = 'admin';
            }
        }
    </script>
</body>
</html>