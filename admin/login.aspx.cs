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

        // 从数据库查询管理员信息
        DataTable dt = DBHelper.GetDataTable("SELECT Id, AdminNo, Name, Phone, Role FROM Admins WHERE AdminNo=@AdminNo AND Password=@Password AND Status=1",
            new MySql.Data.MySqlClient.MySqlParameter("@AdminNo", adminNo),
            new MySql.Data.MySqlClient.MySqlParameter("@Password", UserBLL.GetMD5(password)));

        if (dt.Rows.Count > 0)
        {
            DataRow row = dt.Rows[0];
            int role = Convert.ToInt32(row["Role"]);
            string roleName = role == 1 ? "超级管理员" : (role == 2 ? "宿管" : "后勤");

            Session["AdminId"] = row["Id"];
            Session["AdminNo"] = row["AdminNo"].ToString();
            Session["AdminName"] = row["Name"].ToString();
            Session["AdminRoleName"] = roleName;
            Session["AdminRole"] = role.ToString();
            Session["Role"] = "admin";
            Response.Redirect("/admin/dashboard.aspx");
        }
        else
        {
            ShowError("工号或密码错误");
        }
    }

    private void ShowError(string msg)
    {
        lblError.Text = msg;
        lblError.CssClass = "error-msg show";
    }
}