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
        bool infoComplete = false;
        if (studentDt != null && studentDt.Rows.Count > 0)
        {
            DataRow row = studentDt.Rows[0];
            grade = row["Grade"] != DBNull.Value ? row["Grade"].ToString() : "";
            college = row["CollegeName"] != DBNull.Value ? row["CollegeName"].ToString() : "";
            major = row["MajorName"] != DBNull.Value ? row["MajorName"].ToString() : "";
            infoComplete = !string.IsNullOrEmpty(grade) && !string.IsNullOrEmpty(college) && !string.IsNullOrEmpty(major);
        }

        string keyword = txtKeyword.Text.Trim();
        int status = -1;
        int.TryParse(ddlStatus.SelectedValue, out status);

        // 信息不完整时不过滤年级/学院/专业，显示全部批次
        DataTable dt = BatchBLL.GetBatchesForStudent(
            infoComplete ? grade : null,
            infoComplete ? college : null,
            infoComplete ? major : null,
            keyword, status);
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
        string college = row["CollegeName"] != DBNull.Value ? row["CollegeName"].ToString().Trim() : "";
        string major = row["MajorName"] != DBNull.Value ? row["MajorName"].ToString().Trim() : "";
        string grade = row["Grade"] != DBNull.Value ? row["Grade"].ToString().Trim() : "";

        return !string.IsNullOrEmpty(college) && !string.IsNullOrEmpty(major) && !string.IsNullOrEmpty(grade);
    }
}
