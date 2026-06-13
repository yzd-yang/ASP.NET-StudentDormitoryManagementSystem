using System;
using System.Web;
using System.Web.UI;

public partial class register : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            txtUserNo.Attributes["placeholder"] = "请输入学号";
            txtPhone.Attributes["placeholder"] = "请输入11位手机号";
            txtPassword.Attributes["placeholder"] = "6位及以上字母数字组合";
            txtConfirmPassword.Attributes["placeholder"] = "再次输入密码";
        }
    }

    protected void btnRegister_Click(object sender, EventArgs e)
    {
        string userNo = txtUserNo.Value.Trim();
        string phone = txtPhone.Value.Trim();
        string password = txtPassword.Value.Trim();
        string confirmPassword = txtConfirmPassword.Value.Trim();

        if (string.IsNullOrEmpty(userNo) || string.IsNullOrEmpty(phone) || string.IsNullOrEmpty(password))
        {
            ShowError("请填写完整信息");
            return;
        }

        if (password.Length < 6)
        {
            ShowError("密码长度至少6位");
            return;
        }

        if (password != confirmPassword)
        {
            ShowError("两次输入的密码不一致");
            return;
        }

        if (phone.Length != 11)
        {
            ShowError("请输入正确的11位手机号");
            return;
        }

        bool success = UserBLL.RegisterStudent(userNo, userNo, phone, password);
        if (success)
        {
            Response.Redirect("login.aspx");
        }
        else
        {
            ShowError("学号已存在");
        }
    }

    private void ShowError(string msg)
    {
        lblError.Text = msg;
        lblError.CssClass = "error-msg show";
    }
}