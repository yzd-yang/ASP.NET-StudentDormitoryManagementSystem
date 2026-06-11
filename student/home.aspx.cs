using System;
using System.Data;
using System.Web;
using System.Web.UI;

public partial class student_home : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            LoadDormInfo();
            LoadRoommates();
        }
    }

    private void LoadDormInfo()
    {
        int studentId = Convert.ToInt32(Session["UserId"]);
        DataTable dt = DormBLL.GetStudentDormInfo(studentId);

        if (dt.Rows.Count > 0)
        {
            DataRow row = dt.Rows[0];
            string campus = row["Campus"] != DBNull.Value ? row["Campus"].ToString() : "";
            string building = row["BuildingName"] != DBNull.Value ? row["BuildingName"].ToString() : "";
            string roomNo = row["RoomNo"] != DBNull.Value ? row["RoomNo"].ToString() : "";
            string bedNo = row["BedNo"] != DBNull.Value ? row["BedNo"].ToString() : "";

            if (!string.IsNullOrEmpty(building))
            {
                litDormInfo.Text = campus + " " + building + " " + roomNo;
                litBedInfo.Text = bedNo + "\u53F7\u5E8A\u4F4D";
            }
        }
    }

    private void LoadRoommates()
    {
        int studentId = Convert.ToInt32(Session["UserId"]);
        DataTable dt = DormBLL.GetRoommates(studentId);

        if (dt.Rows.Count > 0)
        {
            rptRoommates.DataSource = dt;
            rptRoommates.DataBind();
            pnlNoRoommate.Visible = false;
        }
        else
        {
            rptRoommates.Visible = false;
            pnlNoRoommate.Visible = true;
        }
    }

    protected string GetAvatarText(string name)
    {
        if (!string.IsNullOrEmpty(name))
        {
            return name.Substring(name.Length - 1);
        }
        return "?";
    }
}