using System;
using System.Data;
using System.Web;
using System.Web.UI;

public partial class student_home : System.Web.UI.Page
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
            LoadDormInfo();
            LoadRoommates();
            LoadRepairs();
            LoadNotices();
        }
    }

    private void LoadDormInfo()
    {
        int studentId = Convert.ToInt32(Session["UserId"]);
        DataTable dt = DormBLL.GetStudentDormInfo(studentId);
        if (dt != null && dt.Rows.Count > 0)
        {
            DataRow row = dt.Rows[0];
            string campus = row["Campus"] != DBNull.Value ? row["Campus"].ToString() : "";
            string building = row["BuildingName"] != DBNull.Value ? row["BuildingName"].ToString() : "";
            string roomNo = row["RoomNo"] != DBNull.Value ? row["RoomNo"].ToString() : "";
            string bedNo = row["BedNo"] != DBNull.Value ? row["BedNo"].ToString() : "";

            if (!string.IsNullOrEmpty(building))
            {
                litBuilding.Text = campus + " " + building;
                litRoom.Text = roomNo + " 室";
                litBed.Text = bedNo + "号床位";
            }
            else
            {
                litBuilding.Text = "未分配宿舍";
                litRoom.Text = "—";
                litBed.Text = "—";
            }

            string name = row["StudentName"].ToString();
            string major = row["MajorName"] != DBNull.Value ? row["MajorName"].ToString() : "";
            string grade = row["Grade"] != DBNull.Value ? row["Grade"].ToString() : "";
            litMyAvatar.Text = name.Length > 0 ? name.Substring(name.Length - 1) : "同";
            litMyName.Text = name;
            litMyMajor.Text = major + (string.IsNullOrEmpty(grade) ? "" : " · " + grade + "级");
        }
        else
        {
            litBuilding.Text = "未分配宿舍";
            litRoom.Text = "—";
            litBed.Text = "—";
        }
    }

    private void LoadRoommates()
    {
        int studentId = Convert.ToInt32(Session["UserId"]);
        DataTable dt = DormBLL.GetRoommates(studentId);
        if (dt != null && dt.Rows.Count > 0)
        {
            litRoommateCount.Text = (dt.Rows.Count + 1).ToString();
            rptRoommates.DataSource = dt;
            rptRoommates.DataBind();
            pnlRoommates.Visible = true;
            pnlNoRoommates.Visible = false;
        }
        else
        {
            DataTable dormDt = DormBLL.GetStudentDormInfo(studentId);
            bool hasDorm = dormDt != null && dormDt.Rows.Count > 0 && dormDt.Rows[0]["BuildingName"] != DBNull.Value;
            if (hasDorm)
            {
                litRoommateCount.Text = "1";
                pnlRoommates.Visible = true;
                pnlNoRoommates.Visible = false;
            }
            else
            {
                litRoommateCount.Text = "0";
                pnlRoommates.Visible = false;
                pnlNoRoommates.Visible = true;
            }
        }
    }

    private void LoadRepairs()
    {
        int studentId = Convert.ToInt32(Session["UserId"]);
        DataTable dt = RepairBLL.GetStudentRepairOrders(studentId);
        if (dt != null && dt.Rows.Count > 0)
        {
            rptRepairs.DataSource = dt;
            rptRepairs.DataBind();
        }
        else
        {
            litNoRepair.Visible = true;
        }
    }

    private void LoadNotices()
    {
        DataTable dt = NoticeBLL.GetNoticeList("", 1, 1, 5);
        if (dt != null && dt.Rows.Count > 0)
        {
            rptNotices.DataSource = dt;
            rptNotices.DataBind();
        }
        else
        {
            litNoNotice.Visible = true;
        }
    }

    protected string GetRepairIcon(object repairType)
    {
        int type = Convert.ToInt32(repairType);
        switch (type)
        {
            case 1: return "plumbing";
            case 2: return "chair";
            case 3: return "wifi";
            default: return "handyman";
        }
    }

    protected string GetStatusClass(int status)
    {
        switch (status)
        {
            case 1: return "pending";
            case 2: return "processing";
            case 3: return "completed";
            case 4: return "rejected";
            default: return "pending";
        }
    }
}
