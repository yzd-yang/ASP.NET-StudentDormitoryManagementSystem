using System;
using System.Data;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class student_grab_dorm : System.Web.UI.Page
{
    private int batchId;
    private int studentId;

    protected void Page_Load(object sender, EventArgs e)
    {
        if (Session["UserId"] == null)
        {
            Response.Redirect("/login.aspx");
            return;
        }

        studentId = Convert.ToInt32(Session["UserId"]);

        if (!int.TryParse(Request.QueryString["batchId"], out batchId) || batchId <= 0)
        {
            Response.Redirect("/student/batch.aspx");
            return;
        }

        if (!IsPostBack)
        {
            if (!LoadBatchInfo())
            {
                Response.Redirect("/student/batch.aspx");
                return;
            }
            LoadRooms();
        }
    }

    private bool LoadBatchInfo()
    {
        DataTable dt = BatchBLL.GetBatchById(batchId);
        if (dt == null || dt.Rows.Count == 0) return false;

        DataRow row = dt.Rows[0];
        int status = Convert.ToInt32(row["Status"]);

        if (status != 1)
        {
            // 批次不在进行中
            return false;
        }

        litBatchName.Text = row["BatchName"].ToString();
        DateTime endTime = Convert.ToDateTime(row["EndTime"]);

        // 倒计时
        TimeSpan remaining = endTime - DateTime.Now;
        if (remaining.TotalSeconds <= 0)
        {
            litBatchName.Text = row["BatchName"].ToString() + "（已结束）";
            litCountdown.Text = "00:00:00";
            hfEndTime.Value = "0";
        }
        else
        {
            hfEndTime.Value = ((long)(endTime - new DateTime(1970, 1, 1)).TotalMilliseconds).ToString();
            litCountdown.Text = string.Format("{0:D2}:{1:D2}:{2:D2}",
                (int)remaining.TotalHours, remaining.Minutes, remaining.Seconds);
        }

        // 检查学生是否已有床位
        if (DormBLL.HasBed(studentId))
        {
            litAlreadyAllocated.Visible = true;
            pnlRooms.Visible = false;
        }

        return true;
    }

    private void LoadRooms()
    {
        DataTable rooms = BatchBLL.GetBatchRooms(batchId);
        rptRooms.DataSource = rooms;
        rptRooms.DataBind();
    }

    protected DataTable GetBedsForRoom(int roomId)
    {
        return DormBLL.GetRoomBeds(roomId);
    }

    protected string GetRoomTypeText(object roomType)
    {
        int t = Convert.ToInt32(roomType);
        switch (t)
        {
            case 1: return "双人间";
            case 2: return "四人间";
            case 3: return "六人间";
            default: return "未知";
        }
    }

    protected int GetAvailableBeds(int roomId)
    {
        DataTable dt = DormBLL.GetRoomBeds(roomId);
        int count = 0;
        foreach (DataRow row in dt.Rows)
        {
            if (row["StudentId"] == DBNull.Value) count++;
        }
        return count;
    }

    protected void btnGrab_Click(object sender, EventArgs e)
    {
        int bedId;
        if (!int.TryParse(hfSelectedBedId.Value, out bedId) || bedId <= 0)
        {
            ShowToast("请选择床位", "error");
            return;
        }

        // 再次检查批次状态
        DataTable batchDt = BatchBLL.GetBatchById(batchId);
        if (batchDt == null || batchDt.Rows.Count == 0 || Convert.ToInt32(batchDt.Rows[0]["Status"]) != 1)
        {
            ShowToast("该批次已结束", "error");
            return;
        }

        // 检查学生是否已有床位
        if (DormBLL.HasBed(studentId))
        {
            ShowToast("您已有宿舍，不能重复选择", "error");
            return;
        }

        // 分配床位
        bool ok = DormBLL.AllocateBed(bedId, studentId);
        if (ok)
        {
            ShowToast("选宿成功！即将跳转到首页...", "success");
            ScriptManager.RegisterStartupScript(this, GetType(), "redirect",
                "setTimeout(function(){ window.location.href='/student/home.aspx'; }, 2000);", true);
            pnlRooms.Visible = false;
            litAlreadyAllocated.Visible = true;
            litAlreadyAllocated.Text = "<span class='material-symbols-outlined' style='font-size:48px;color:var(--primary);display:block;margin-bottom:12px;'>check_circle</span><strong style='color:var(--primary);'>选宿成功！</strong>正在跳转到首页...";
        }
        else
        {
            ShowToast("该床位已被他人选择，请换一个", "error");
            LoadRooms(); // 刷新房间列表
        }
    }

    private void ShowToast(string msg, string type)
    {
        ScriptManager.RegisterStartupScript(this, GetType(), "toast" + Guid.NewGuid(),
            "showToast('" + msg + "','" + type + "');", true);
    }
}
