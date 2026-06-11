using System;
using System.Web;
using System.Web.UI;

public partial class login : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            txtUserNo.Attributes["placeholder"] = "\u8BF7\u8F93\u5165\u5B66\u53F7\u6216\u5DE5\u53F7";
            txtPassword.Attributes["placeholder"] = "\u8BF7\u8F93\u5165\u60A8\u7684\u767B\u5F55\u5BC6\u7801";
            txtVerifyCode.Attributes["placeholder"] = "\u9A8C\u8BC1\u7801";

            if (Session["UserId"] != null)
            {
                string role = Session["Role"] != null ? Session["Role"].ToString() : "";
                if (role == "student")
                    Response.Redirect("/student/home.aspx");
                else
                    Response.Redirect("/admin/dashboard.aspx");
            }
        }
    }

    protected void btnLogin_Click(object sender, EventArgs e)
    {
        string userNo = txtUserNo.Text.Trim();
        string password = txtPassword.Text.Trim();
        string verifyCode = txtVerifyCode.Text.Trim().ToUpper();

        if (Session["CheckCode"] == null || verifyCode != Session["CheckCode"].ToString().ToUpper())
        {
            ShowError("\u9A8C\u8BC1\u7801\u9519\u8BEF");
            return;
        }

        if (string.IsNullOrEmpty(userNo) || string.IsNullOrEmpty(password))
        {
            ShowError("\u8BF7\u8F93\u5165\u5B66\u53F7/\u5DE5\u53F7\u548C\u5BC6\u7801");
            return;
        }

        Session["UserId"] = 1;
        Session["UserNo"] = userNo;
        Session["UserName"] = "\u6D4B\u8BD5\u540C\u5B66";
        Session["Role"] = "student";
        Response.Redirect("/student/home.aspx");
    }

    private void ShowError(string msg)
    {
        lblError.Text = msg;
        lblError.CssClass = "error-msg show";
    }
}