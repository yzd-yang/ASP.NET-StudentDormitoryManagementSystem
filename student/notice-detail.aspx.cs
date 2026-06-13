using System;
using System.Data;
using System.Web;
using System.Web.UI;

public partial class student_notice_detail : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (Session["UserId"] == null)
        {
            Response.Redirect("/login.aspx");
            return;
        }

        if (!IsPostBack)
        {
            LoadNotice();
        }
    }

    private void LoadNotice()
    {
        int id;
        if (!int.TryParse(Request.QueryString["id"], out id))
        {
            pnlEmpty.Visible = true;
            return;
        }

        DataTable dt = NoticeBLL.GetNoticeById(id);
        if (dt == null || dt.Rows.Count == 0)
        {
            pnlEmpty.Visible = true;
            return;
        }

        DataRow row = dt.Rows[0];
        if (Convert.ToInt32(row["Status"]) != 1)
        {
            pnlEmpty.Visible = true;
            return;
        }

        pnlNotice.Visible = true;
        litTitle.Text = row["Title"].ToString();
        litTime.Text = Convert.ToDateTime(row["CreateTime"]).ToString("yyyy-MM-dd HH:mm");

        int category = Convert.ToInt32(row["Category"]);
        string[] categoryNames = { "", "行政通知", "安全警示", "生活服务", "活动资讯" };
        litCategory.Text = category >= 1 && category <= 4 ? categoryNames[category] : "通知";

        string adminName = "";
        if (row.Table.Columns.Contains("AdminName") && row["AdminName"] != DBNull.Value)
            adminName = row["AdminName"].ToString();
        litAdmin.Text = string.IsNullOrEmpty(adminName) ? "管理员" : adminName;

        litContent.Text = row["Content"].ToString();
    }
}
