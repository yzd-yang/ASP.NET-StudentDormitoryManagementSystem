<%@ Page Language="C#" AutoEventWireup="true" CodeFile="reset-password.aspx.cs" Inherits="reset_password" ResponseEncoding="utf-8" %>

<!DOCTYPE html>
<html lang="zh-CN">
<head runat="server">
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>重置密码 - 智慧宿舍</title>
    <link href="https://fonts.googleapis.com/css2?family=Manrope:wght@400;500;600;700;800&display=swap" rel="stylesheet" />
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&display=swap" rel="stylesheet" />
    <link href="/css/style.css" rel="stylesheet" />
    <style>
        body { font-family:'Manrope',sans-serif; min-height:100vh; display:flex; align-items:center; justify-content:center; padding:20px; position:relative; overflow:hidden; }
        body::before { content:''; position:fixed; top:-20%; left:-20%; width:60%; height:60%; background:rgba(73,234,206,0.2); border-radius:50%; filter:blur(100px); pointer-events:none; animation:moveBlob 20s infinite alternate ease-in-out; }
        body::after { content:''; position:fixed; bottom:-15%; right:-15%; width:50%; height:50%; background:rgba(255,249,230,0.4); border-radius:50%; filter:blur(80px); pointer-events:none; animation:moveBlob2 15s infinite alternate ease-in-out; }
        @keyframes moveBlob { from{transform:translate(0,0) scale(1)} to{transform:translate(80px,60px) scale(1.1)} }
        @keyframes moveBlob2 { from{transform:translate(0,0) scale(1)} to{transform:translate(-60px,-40px) scale(1.15)} }

        .reset-brand { text-align:center; margin-bottom:32px; position:relative; z-index:1; }
        .reset-brand h1 { font-size:36px; font-weight:800; color:var(--primary); letter-spacing:-0.02em; }
        .reset-brand p { font-size:16px; color:var(--on-surface-variant); margin-top:4px; }

        .reset-card {
            width:100%; max-width:440px; background:rgba(255,255,255,0.7); backdrop-filter:blur(16px);
            border:1px solid rgba(73,234,206,0.1); border-radius:24px; padding:32px; position:relative; z-index:1;
            box-shadow:0 12px 40px rgba(73,234,206,0.08);
        }
        .reset-card h2 { font-size:20px; font-weight:700; color:var(--on-surface); margin-bottom:4px; }
        .reset-card-desc { font-size:14px; color:var(--on-surface-variant); margin-bottom:24px; }

        .reset-field { margin-bottom:16px; }
        .reset-field label { display:block; font-size:14px; font-weight:600; color:var(--on-surface-variant); margin-bottom:6px; padding-left:4px; }
        .reset-input-wrap { position:relative; }
        .reset-input-wrap .material-symbols-outlined { position:absolute; left:14px; top:50%; transform:translateY(-50%); font-size:20px; color:var(--outline); transition:color 0.2s; }
        .reset-input {
            width:100%; padding:14px 14px 14px 44px; border:1px solid var(--outline-variant); border-radius:14px;
            background:#FFF9E6; font-family:inherit; font-size:15px; color:var(--on-surface); outline:none; transition:all 0.2s;
        }
        .reset-input:focus { border-color:var(--primary); box-shadow:0 0 0 4px rgba(73,234,206,0.12); }
        .reset-input-pwd { padding-right:44px; }
        .reset-pwd-toggle { position:absolute; right:14px; top:50%; transform:translateY(-50%); background:none; border:none; cursor:pointer; color:var(--outline); padding:4px; }

        .reset-vcode-row { display:grid; grid-template-columns:1fr auto; gap:12px; }
        .reset-vcode-img {
            height:50px; width:110px; border-radius:14px; background:rgba(221,231,197,0.4); display:flex;
            align-items:center; justify-content:center; cursor:pointer; font-size:18px; font-weight:700;
            letter-spacing:0.1em; color:var(--on-surface); user-select:none; border:1px solid rgba(0,0,0,0.06);
        }

        .reset-btn {
            width:100%; padding:16px; border:none; border-radius:14px; background:var(--primary);
            color:var(--on-primary); font-family:inherit; font-size:16px; font-weight:700; cursor:pointer;
            box-shadow:0 4px 16px rgba(73,234,206,0.3); transition:all 0.2s; display:flex; align-items:center; justify-content:center; gap:8px;
        }
        .reset-btn:hover { box-shadow:0 6px 24px rgba(73,234,206,0.5); }
        .reset-btn:active { transform:scale(0.98); }

        .reset-back { text-align:center; margin-top:20px; }
        .reset-back a { font-size:14px; font-weight:600; color:var(--primary); text-decoration:none; display:inline-flex; align-items:center; gap:4px; }
        .reset-back a:hover { text-decoration:underline; }
        .reset-back a .material-symbols-outlined { font-size:18px; }

        .reset-footer { margin-top:24px; text-align:center; position:relative; z-index:1; }
        .reset-footer-items { display:flex; justify-content:center; gap:20px; opacity:0.6; }
        .reset-footer-item { font-size:12px; color:var(--on-surface-variant); display:flex; align-items:center; gap:4px; }
        .reset-footer-item .material-symbols-outlined { font-size:14px; }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div style="width:100%; max-width:440px; position:relative; z-index:1;">
            <div class="reset-brand">
                <h1>SmartDorm</h1>
                <p>智慧公寓 · 重置您的访问权限</p>
            </div>

            <div class="reset-card">
                <h2 id="resetTitle">验证身份</h2>
                <p class="reset-card-desc" id="resetDesc">请输入您的账号信息以验证身份</p>

                <!-- 步骤1：验证身份 -->
                <div id="step1">
                    <div class="reset-field">
                        <label>学号 / 工号</label>
                        <div class="reset-input-wrap">
                            <span class="material-symbols-outlined">badge</span>
                            <input class="reset-input" type="text" placeholder="请输入学号或教工号" />
                        </div>
                    </div>
                    <div class="reset-field">
                        <label>手机号</label>
                        <div class="reset-input-wrap">
                            <span class="material-symbols-outlined">smartphone</span>
                            <input class="reset-input" type="tel" placeholder="请输入绑定的手机号码" />
                        </div>
                    </div>
                    <div class="reset-field">
                        <label>图形验证码</label>
                        <div class="reset-vcode-row">
                            <div class="reset-input-wrap" style="flex:1;">
                                <span class="material-symbols-outlined">verified</span>
                                <input class="reset-input" type="text" placeholder="请输入图形验证码" />
                            </div>
                            <div class="reset-vcode-img" onclick="refreshVCode()">4 K 8 R</div>
                        </div>
                    </div>
                    <button type="button" class="reset-btn" onclick="goToStep2()">
                        <span>验证身份</span>
                        <span class="material-symbols-outlined">arrow_forward</span>
                    </button>
                </div>

                <!-- 步骤2：设置新密码 -->
                <div id="step2" style="display:none;">
                    <div class="reset-field">
                        <label>设置新密码</label>
                        <div class="reset-input-wrap">
                            <span class="material-symbols-outlined">lock</span>
                            <input class="reset-input reset-input-pwd" type="password" placeholder="8-20位字母及数字组合" />
                            <button type="button" class="reset-pwd-toggle" onclick="togglePwd(this)"><span class="material-symbols-outlined">visibility</span></button>
                        </div>
                    </div>
                    <div class="reset-field">
                        <label>确认新密码</label>
                        <div class="reset-input-wrap">
                            <span class="material-symbols-outlined">lock_reset</span>
                            <input class="reset-input reset-input-pwd" type="password" placeholder="请再次输入新密码" />
                        </div>
                    </div>
                    <button type="submit" class="reset-btn">
                        <span>重置密码</span>
                        <span class="material-symbols-outlined">lock_reset</span>
                    </button>
                </div>
            </div>

            <div class="reset-back">
                <a href="login.aspx"><span class="material-symbols-outlined">arrow_back</span> 返回登录</a>
            </div>

            <div class="reset-footer">
                <div class="reset-footer-items">
                    <span class="reset-footer-item"><span class="material-symbols-outlined">verified</span> 安全身份校验</span>
                    <span class="reset-footer-item"><span class="material-symbols-outlined">lock_clock</span> 加密传输保障</span>
                </div>
            </div>
        </div>
    </form>

    <script type="text/javascript">
        function goToStep2() {
            document.getElementById('step1').style.display = 'none';
            document.getElementById('step2').style.display = 'block';
            document.getElementById('resetTitle').innerText = '设置新密码';
            document.getElementById('resetDesc').innerText = '身份验证成功，请设置您的新登录密码';
        }
        function togglePwd(btn) {
            var input = btn.previousElementSibling;
            var icon = btn.querySelector('.material-symbols-outlined');
            if (input.type === 'password') {
                input.type = 'text';
                icon.innerText = 'visibility_off';
            } else {
                input.type = 'password';
                icon.innerText = 'visibility';
            }
        }
        function refreshVCode() {
            var chars = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789';
            var code = '';
            for (var i = 0; i < 4; i++) { code += chars.charAt(Math.floor(Math.random() * chars.length)) + (i < 3 ? ' ' : ''); }
            document.querySelector('.reset-vcode-img').innerText = code;
        }
    </script>
</body>
</html>
