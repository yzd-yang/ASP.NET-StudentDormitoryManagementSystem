using System;
using System.Data;
using System.Web;
using System.Web.UI;

public partial class student_batch : System.Web.UI.Page
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
            LoadBatches();
        }
    }

    private void LoadBatches()
    {
        int studentId = Convert.ToInt32(Session["UserId"]);
        DataTable studentDt = UserBLL.GetStudentById(studentId);
        string grade = "", college = "", major = "";
        if (studentDt != null && studentDt.Rows.Count > 0)
        {
            DataRow row = studentDt.Rows[0];
            grade = row["Grade"] != DBNull.Value ? row["Grade"].ToString() : "";
            college = row["College"] != DBNull.Value ? row["College"].ToString() : "";
            major = row["Major"] != DBNull.Value ? row["Major"].ToString() : "";
        }

        string keyword = txtKeyword.Text.Trim();
        int status = -1;
        int.TryParse(ddlStatus.SelectedValue, out status);

        DataTable dt = BatchBLL.GetBatchesForStudent(grade, college, major, keyword, status);
        if (dt != null && dt.Rows.Count > 0)
        {
            rptBatches.DataSource = dt;
            rptBatches.DataBind();
            pnlEmpty.Visible = false;
        }
        else
        {
            rptBatches.DataSource = null;
            rptBatches.DataBind();
            pnlEmpty.Visible = true;
        }
    }

    protected void btnFilter_Click(object sender, EventArgs e)
    {
        LoadBatches();
    }

    protected string GetStatusText(int status)
    {
        switch (status)
        {
            case 0: return "待开始";
            case 1: return "进行中";
            case 2: return "已结束";
            case 3: return "已暂停";
            default: return "未知";
        }
    }

    protected string GetStatusClass(int status)
    {
        switch (status)
        {
            case 0: return "upcoming";
            case 1: return "active";
            case 2: return "ended";
            case 3: return "paused";
            default: return "";
        }
    }

    protected bool IsInfoComplete()
    {
        int studentId = Convert.ToInt32(Session["UserId"]);
        DataTable dt = UserBLL.GetStudentById(studentId);
        if (dt == null || dt.Rows.Count == 0) return false;

        DataRow row = dt.Rows[0];
        string college = row["College"] != DBNull.Value ? row["College"].ToString().Trim() : "";
        string major = row["Major"] != DBNull.Value ? row["Major"].ToString().Trim() : "";
        string grade = row["Grade"] != DBNull.Value ? row["Grade"].ToString().Trim() : "";

        return !string.IsNullOrEmpty(college) && !string.IsNullOrEmpty(major) && !string.IsNullOrEmpty(grade);
    }
}
