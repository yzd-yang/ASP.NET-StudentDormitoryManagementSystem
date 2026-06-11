using System;
using System.Web;
using System.Web.UI;

public partial class register : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            txtUserNo.Attributes["placeholder"] = "\u8BF7\u8F93\u5165\u5B66\u53F7";
            txtPhone.Attributes["placeholder"] = "\u8BF7\u8F93\u516511\u4F4D\u624B\u673A\u53F7";
            txtPassword.Attributes["placeholder"] = "8-20\u4F4D\u5B57\u6BCD\u6570\u5B57\u7EC4\u5408";
            txtConfirmPassword.Attributes["placeholder"] = "\u8BF7\u518D\u6B21\u8F93\u5165\u5BC6\u7801";
        }
    }

    protected void btnRegister_Click(object sender, EventArgs e)
    {
        string userNo = txtUserNo.Text.Trim();
        string phone = txtPhone.Text.Trim();
        string password = txtPassword.Text.Trim();
        string confirmPassword = txtConfirmPassword.Text.Trim();
        string role = hfRole.Value;

        if (string.IsNullOrEmpty(userNo) || string.IsNullOrEmpty(phone) || string.IsNullOrEmpty(password))
        {
            ShowError("\u8BF7\u586B\u5199\u5B8C\u6574\u4FE1\u606F");
            return;
        }

        if (password.Length < 8 || password.Length > 20)
        {
            ShowError("\u5BC6\u7801\u957F\u5EA6\u5E94\u4E3A8-20\u4F4D");
            return;
        }

        if (password != confirmPassword)
        {
            ShowError("\u4E24\u6B21\u8F93\u5165\u7684\u5BC6\u7801\u4E0D\u4E00\u81F4");
            return;
        }

        if (phone.Length != 11)
        {
            ShowError("\u8BF7\u8F93\u5165\u6B63\u786E\u768411\u4F4D\u624B\u673A\u53F7");
            return;
        }

        Response.Redirect("login.aspx");
    }

    private void ShowError(string msg)
    {
        lblError.Text = msg;
        lblError.CssClass = "error-msg show";
    }
}