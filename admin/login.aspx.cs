using System;
using System.Web;
using System.Web.UI;

public partial class admin_login : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            txtAdminNo.Attributes["placeholder"] = "\u8BF7\u8F93\u5165\u5DE5\u53F7";
            txtPassword.Attributes["placeholder"] = "\u8BF7\u8F93\u5165\u5BC6\u7801";
            txtVerifyCode.Attributes["placeholder"] = "\u9A8C\u8BC1\u7801";

            if (Session["AdminId"] != null)
            {
                Response.Redirect("/admin/dashboard.aspx");
            }
        }
    }

    protected void btnLogin_Click(object sender, EventArgs e)
    {
        string adminNo = txtAdminNo.Text.Trim();
        string password = txtPassword.Text.Trim();
        string verifyCode = txtVerifyCode.Text.Trim().ToUpper();

        if (Session["CheckCode"] == null || verifyCode != Session["CheckCode"].ToString().ToUpper())
        {
            ShowError("\u9A8C\u8BC1\u7801\u9519\u8BEF");
            return;
        }

        if (string.IsNullOrEmpty(adminNo) || string.IsNullOrEmpty(password))
        {
            ShowError("\u8BF7\u8F93\u5165\u5DE5\u53F7\u548C\u5BC6\u7801");
            return;
        }

        Session["AdminId"] = 1;
        Session["AdminNo"] = adminNo;
        Session["AdminName"] = "\u7CFB\u7EDF\u7BA1\u7406\u5458";
        Session["AdminRoleName"] = "\u8D85\u7EA7\u7BA1\u7406\u5458";
        Session["Role"] = "admin";
        Response.Redirect("/admin/dashboard.aspx");
    }

    private void ShowError(string msg)
    {
        lblError.Text = msg;
        lblError.CssClass = "error-msg show";
    }
}