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
