using System;
using System.Data;
using System.Web;
using System.Web.UI;

public partial class reset_password : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
    }

    protected void btnVerify_Click(object sender, EventArgs e)
    {
        string studentNo = txtStudentNo.Text.Trim();
        string phone = txtPhone.Text.Trim();

        if (string.IsNullOrEmpty(studentNo) || string.IsNullOrEmpty(phone))
        {
            ShowToast("请输入学号和手机号", "error");
            return;
        }

        DataTable dt = UserBLL.VerifyStudent(studentNo, phone);
        if (dt.Rows.Count == 0)
        {
            ShowToast("学号或手机号不正确", "error");
            return;
        }

        Session["ResetStudentId"] = Convert.ToInt32(dt.Rows[0]["Id"]);
        step1.Visible = false;
        step2.Visible = true;
        resetTitle.InnerText = "设置新密码";
        resetDesc.InnerText = "身份验证成功，请设置您的新登录密码";
    }

    protected void btnReset_Click(object sender, EventArgs e)
    {
        if (Session["ResetStudentId"] == null)
        {
            ShowToast("请先验证身份", "error");
            step1.Visible = true;
            step2.Visible = false;
            return;
        }

        string newPwd = txtNewPwd.Text.Trim();
        string confirmPwd = txtConfirmPwd.Text.Trim();

        if (string.IsNullOrEmpty(newPwd) || string.IsNullOrEmpty(confirmPwd))
        {
            ShowToast("请输入新密码", "error");
            return;
        }

        if (newPwd.Length < 6)
        {
            ShowToast("密码长度不能少于6位", "error");
            return;
        }

        if (newPwd != confirmPwd)
        {
            ShowToast("两次密码输入不一致", "error");
            return;
        }

        int studentId = Convert.ToInt32(Session["ResetStudentId"]);
        if (UserBLL.ResetStudentPassword(studentId, newPwd))
        {
            Session.Remove("ResetStudentId");
            ShowToast("密码重置成功，正在跳转登录...", "success");
            ClientScript.RegisterStartupScript(this.GetType(), "redirect",
                "setTimeout(function(){window.location.href='/login.aspx';},1500);", true);
        }
        else
        {
            ShowToast("密码重置失败，请重试", "error");
        }
    }

    private void ShowToast(string msg, string type)
    {
        string safeMsg = msg.Replace("'", "\\'");
        string script = "var t=document.getElementById('toast');t.className='toast " + type + "';t.innerHTML='" + safeMsg + "';t.classList.add('show');setTimeout(function(){t.classList.remove('show');},3000);";
        ClientScript.RegisterStartupScript(this.GetType(), "toast" + Guid.NewGuid(), script, true);
    }
}
