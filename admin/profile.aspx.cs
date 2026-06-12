using System;
using System.Data;
using System.Web;
using System.Web.UI;

public partial class admin_profile : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (Session["AdminId"] == null)
        {
            Response.Redirect("/admin/login.aspx");
            return;
        }

        if (!IsPostBack)
        {
            LoadProfile();
        }
    }

    private void LoadProfile()
    {
        int adminId = Convert.ToInt32(Session["AdminId"]);
        DataTable dt = UserBLL.GetAdminById(adminId);

        if (dt.Rows.Count > 0)
        {
            DataRow row = dt.Rows[0];
            string name = row["Name"].ToString();
            string adminNo = row["AdminNo"].ToString();
            string phone = row["Phone"].ToString();
            int role = Convert.ToInt32(row["Role"]);
            string roleName = role == 1 ? "超级管理员" : (role == 2 ? "宿管" : "后勤");

            // 页面展示
            litAvatar.Text = name.Length > 0 ? name.Substring(name.Length - 1) : "管";
            litName.Text = name;
            litRole.Text = roleName;
            litAdminNo.Text = adminNo;
            litPhone.Text = phone.Substring(0, 3) + "****" + phone.Substring(phone.Length - 4);

            // 表单
            txtName.Text = name;
            txtAdminNo.Text = adminNo;
            txtPhone.Text = phone;
        }
    }

    protected void btnSaveInfo_Click(object sender, EventArgs e)
    {
        int adminId = Convert.ToInt32(Session["AdminId"]);
        string name = txtName.Text.Trim();
        string phone = txtPhone.Text.Trim();

        if (string.IsNullOrEmpty(name) || string.IsNullOrEmpty(phone))
        {
            Page.ClientScript.RegisterStartupScript(this.GetType(), "toast", "showToast('姓名和手机号不能为空','error');", true);
            return;
        }

        // 获取当前角色
        DataTable dt = UserBLL.GetAdminById(adminId);
        int role = Convert.ToInt32(dt.Rows[0]["Role"]);
        int status = Convert.ToInt32(dt.Rows[0]["Status"]);

        if (AdminBLL.UpdateAdmin(adminId, name, phone, role, status))
        {
            Session["AdminName"] = name;
            LoadProfile();
            Page.ClientScript.RegisterStartupScript(this.GetType(), "toast", "showToast('保存成功','success');", true);
        }
        else
        {
            Page.ClientScript.RegisterStartupScript(this.GetType(), "toast", "showToast('保存失败','error');", true);
        }
    }

    protected void btnChangePwd_Click(object sender, EventArgs e)
    {
        int adminId = Convert.ToInt32(Session["AdminId"]);
        string currentPwd = txtCurrentPwd.Text.Trim();
        string newPwd = txtNewPwd.Text.Trim();
        string confirmPwd = txtConfirmPwd.Text.Trim();

        if (string.IsNullOrEmpty(currentPwd) || string.IsNullOrEmpty(newPwd) || string.IsNullOrEmpty(confirmPwd))
        {
            Page.ClientScript.RegisterStartupScript(this.GetType(), "toast", "showToast('请填写完整密码信息','error');", true);
            return;
        }

        if (newPwd.Length < 6 || newPwd.Length > 20)
        {
            Page.ClientScript.RegisterStartupScript(this.GetType(), "toast", "showToast('新密码长度需为6-20位','error');", true);
            return;
        }

        if (newPwd != confirmPwd)
        {
            Page.ClientScript.RegisterStartupScript(this.GetType(), "toast", "showToast('两次输入的新密码不一致','error');", true);
            return;
        }

        // 验证当前密码
        DataTable dt = UserBLL.GetAdminById(adminId);
        string currentPwdMd5 = UserBLL.GetMD5(currentPwd);
        if (dt.Rows[0]["Password"].ToString() != currentPwdMd5)
        {
            Page.ClientScript.RegisterStartupScript(this.GetType(), "toast", "showToast('当前密码错误','error');", true);
            return;
        }

        if (AdminBLL.ResetPassword(adminId, newPwd))
        {
            txtCurrentPwd.Text = "";
            txtNewPwd.Text = "";
            txtConfirmPwd.Text = "";
            Page.ClientScript.RegisterStartupScript(this.GetType(), "toast", "showToast('密码修改成功','success');", true);
        }
        else
        {
            Page.ClientScript.RegisterStartupScript(this.GetType(), "toast", "showToast('密码修改失败','error');", true);
        }
    }
}
