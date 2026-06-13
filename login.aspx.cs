using System;
using System.Data;
using System.Web;
using System.Web.UI;

public partial class login : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            txtUserNo.Attributes["placeholder"] = "请输入学号";
            txtPassword.Attributes["placeholder"] = "请输入密码";
            txtVerifyCode.Attributes["placeholder"] = "验证码";

            if (Session["UserId"] != null)
            {
                string role = Session["Role"] != null ? Session["Role"].ToString() : "";
                if (role == "student")
                {
                    int uid = Convert.ToInt32(Session["UserId"]);
                    if (DormBLL.HasBed(uid))
                        Response.Redirect("/student/home.aspx");
                    else
                        Response.Redirect("/student/batch.aspx");
                }
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
        string loginRole = hfRole.Value;

        if (Session["CheckCode"] == null || verifyCode != Session["CheckCode"].ToString().ToUpper())
        {
            ShowError("验证码错误");
            return;
        }

        if (string.IsNullOrEmpty(userNo) || string.IsNullOrEmpty(password))
        {
            ShowError("请输入账号和密码");
            return;
        }

        if (loginRole == "student")
        {
            DataTable dt = UserBLL.LoginStudent(userNo, password);
            if (dt.Rows.Count == 0)
            {
                ShowError("学号或密码错误");
                return;
            }

            DataRow row = dt.Rows[0];
            int userId = Convert.ToInt32(row["Id"]);
            string name = row["Name"].ToString();

            Session["UserId"] = userId;
            Session["UserNo"] = userNo;
            Session["UserName"] = name;
            Session["Role"] = "student";

            if (DormBLL.HasBed(userId))
                Response.Redirect("/student/home.aspx");
            else
                Response.Redirect("/student/batch.aspx");
        }
        else
        {
            DataTable dt = UserBLL.LoginAdmin(userNo, password);
            if (dt.Rows.Count == 0)
            {
                ShowError("工号或密码错误");
                return;
            }

            DataRow row = dt.Rows[0];
            int userId = Convert.ToInt32(row["Id"]);
            string name = row["Name"].ToString();
            string adminRole = row["Role"].ToString();
            string roleName = adminRole == "1" ? "超级管理员" : adminRole == "2" ? "宿管" : "后勤";

            Session["AdminId"] = userId;
            Session["AdminNo"] = userNo;
            Session["AdminName"] = name;
            Session["AdminRoleName"] = roleName;
            Session["AdminRole"] = adminRole;
            Session["Role"] = "admin";
            Response.Redirect("/admin/dashboard.aspx");
        }
    }

    private void ShowError(string msg)
    {
        lblError.Text = msg;
        lblError.CssClass = "error-msg show";
    }
}