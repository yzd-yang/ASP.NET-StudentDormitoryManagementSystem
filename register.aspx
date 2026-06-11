<%@ Page Language="C#" AutoEventWireup="true" CodeFile="register.aspx.cs" Inherits="register" %>

<!DOCTYPE html>
<html lang="zh-CN">
<head runat="server">
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>注册 - 智慧宿舍</title>
    <link href="https://fonts.googleapis.com/css2?family=Manrope:wght@400;500;600;700;800&display=swap" rel="stylesheet" />
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&display=swap" rel="stylesheet" />
    <link href="css/style.css" rel="stylesheet" />
    <style>
        body {
            display: flex;
            align-items: center;
            justify-content: center;
            min-height: 100vh;
            padding: 20px;
        }
        .register-card {
            width: 100%;
            max-width: 420px;
            background: rgba(255, 255, 255, 0.7);
            backdrop-filter: blur(12px);
            border: 1px solid rgba(255, 255, 255, 0.4);
            border-radius: 28px;
            padding: 36px 32px;
            box-shadow: 0 20px 50px rgba(73, 234, 206, 0.1);
        }
        .register-title {
            font-size: 24px;
            font-weight: 800;
            color: var(--on-surface);
            text-align: center;
            margin-bottom: 8px;
        }
        .register-desc {
            font-size: 14px;
            color: var(--on-surface-variant);
            text-align: center;
            margin-bottom: 28px;
        }
        .tab-group {
            display: flex;
            background: rgba(0, 0, 0, 0.05);
            border-radius: 12px;
            padding: 4px;
            margin-bottom: 24px;
        }
        .tab-item {
            flex: 1;
            padding: 10px;
            text-align: center;
            font-size: 14px;
            font-weight: 600;
            color: var(--on-surface-variant);
            border-radius: 10px;
            cursor: pointer;
            transition: all 0.2s;
            border: none;
            background: transparent;
            font-family: inherit;
        }
        .tab-item.active {
            background: #fff;
            color: var(--on-surface);
            box-shadow: var(--shadow-sm);
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
        .register-btn {
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
        .register-btn:hover {
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
        <div class="register-card">
            <div class="register-title">注册账号</div>
            <div class="register-desc">创建您的智慧宿舍账号</div>

            <div class="tab-group">
                <button type="button" class="tab-item active" onclick="switchRole('student', this)">学生注册</button>
                <button type="button" class="tab-item" onclick="switchRole('teacher', this)">老师注册</button>
            </div>

            <div style="display: flex; flex-direction: column; gap: 18px;">
                <div>
                    <label class="form-label" id="lblUserNo">学号</label>
                    <div class="input-group">
                        <span class="material-symbols-outlined">badge</span>
                        <asp:TextBox ID="txtUserNo" runat="server" />
                    </div>
                </div>

                <div>
                    <label class="form-label">手机号</label>
                    <div class="input-group">
                        <span class="material-symbols-outlined">phone</span>
                        <asp:TextBox ID="txtPhone" runat="server" MaxLength="11" />
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
                    <label class="form-label">确认密码</label>
                    <div class="input-group">
                        <span class="material-symbols-outlined">lock</span>
                        <asp:TextBox ID="txtConfirmPassword" runat="server" TextMode="Password" />
                    </div>
                </div>

                <asp:Label ID="lblError" runat="server" CssClass="error-msg" />

                <asp:Button ID="btnRegister" runat="server" Text="立即注册" CssClass="register-btn" OnClick="btnRegister_Click" />
            </div>

            <div style="text-align: center; margin-top: 24px;">
                <a href="login.aspx" style="font-size: 14px; font-weight: 600; color: var(--on-surface-variant);">
                    已有账号？立即登录
                </a>
            </div>
        </div>

        <asp:HiddenField ID="hfRole" runat="server" Value="student" />
    </form>

    <script type="text/javascript">
        function switchRole(role, btn) {
            document.getElementById('<%= hfRole.ClientID %>').value = role;
            document.querySelectorAll('.tab-item').forEach(function (t) { t.classList.remove('active'); });
            btn.classList.add('active');
            document.getElementById('lblUserNo').textContent = role === 'student' ? '学号' : '工号';
            document.getElementById('<%= txtUserNo.ClientID %>').placeholder = role === 'student' ? '请输入学号' : '请输入工号';
        }
    </script>
</body>
</html>