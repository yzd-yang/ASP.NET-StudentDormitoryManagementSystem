<%@ Page Language="C#" AutoEventWireup="true" CodeFile="login.aspx.cs" Inherits="admin_login" %>

<!DOCTYPE html>
<html lang="zh-CN">
<head runat="server">
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>管理后台 - 登录</title>
    <link href="https://fonts.googleapis.com/css2?family=Manrope:wght@400;500;600;700;800&display=swap" rel="stylesheet" />
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&display=swap" rel="stylesheet" />
    <link href="/css/style.css" rel="stylesheet" />
    <style>
        body {
            display: flex;
            align-items: center;
            justify-content: center;
            min-height: 100vh;
            padding: 20px;
        }
        .admin-login-card {
            width: 100%;
            max-width: 420px;
            background: rgba(255, 255, 255, 0.7);
            backdrop-filter: blur(12px);
            border: 1px solid rgba(255, 255, 255, 0.4);
            border-radius: 28px;
            padding: 36px 32px;
            box-shadow: 0 20px 50px rgba(73, 234, 206, 0.1);
        }
        .admin-login-brand {
            display: flex;
            align-items: center;
            gap: 12px;
            margin-bottom: 32px;
        }
        .admin-login-brand-icon {
            width: 52px;
            height: 52px;
            background: var(--primary);
            border-radius: 16px;
            display: flex;
            align-items: center;
            justify-content: center;
            color: var(--on-primary);
        }
        .admin-login-brand-text {
            font-size: 24px;
            font-weight: 800;
            color: var(--on-primary-container);
        }
        .admin-login-desc {
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
        .login-btn {
            width: 100%;
            padding: 16px;
            border: none;
            border-radius: 16px;
            background: linear-gradient(135deg, var(--primary) 0%, var(--primary-dark) 100%);
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
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="admin-login-card">
            <div class="admin-login-brand">
                <div class="admin-login-brand-icon">
                    <span class="material-symbols-outlined">apartment</span>
                </div>
                <div class="admin-login-brand-text">SmartDorm</div>
            </div>
            <div class="admin-login-desc">管理后台登录，请输入您的工号和密码</div>

            <div style="display: flex; flex-direction: column; gap: 20px;">
                <div>
                    <label class="form-label">工号</label>
                    <div class="input-group">
                        <span class="material-symbols-outlined">badge</span>
                        <asp:TextBox ID="txtAdminNo" runat="server" />
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
                    <div style="display: grid; grid-template-columns: 1fr auto; gap: 12px;">
                        <div class="input-group">
                            <span class="material-symbols-outlined">verified_user</span>
                            <asp:TextBox ID="txtVerifyCode" runat="server" MaxLength="4" />
                        </div>
                        <div style="height: 54px; border-radius: 16px; border: 1px solid var(--outline-variant); display: flex; align-items: center; justify-content: center; background: rgba(255,255,255,0.5); padding: 0 16px; cursor: pointer;" onclick="refreshCode()">
                            <asp:Image ID="imgCode" runat="server" ImageUrl="~/checkcode.aspx" Width="100" Height="40" />
                        </div>
                    </div>
                </div>

                <asp:Label ID="lblError" runat="server" CssClass="error-msg" />

                <asp:Button ID="btnLogin" runat="server" Text="登录管理后台" CssClass="login-btn" OnClick="btnLogin_Click" />
            </div>

            <div style="text-align: center; margin-top: 24px;">
                <a href="/login.aspx" style="font-size: 14px; font-weight: 600; color: var(--on-surface-variant); display: inline-flex; align-items: center; gap: 4px;">
                    <span class="material-symbols-outlined" style="font-size: 18px;">arrow_back</span>
                    返回学生登录
                </a>
            </div>
        </div>
    </form>

    <script type="text/javascript">
        function refreshCode() {
            var img = document.getElementById('<%= imgCode.ClientID %>');
            img.src = '/checkcode.aspx?t=' + new Date().getTime();
        }
    </script>
</body>
</html>