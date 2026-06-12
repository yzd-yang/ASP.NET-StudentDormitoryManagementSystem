using System;
using System.Data;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class admin_allocation : System.Web.UI.Page
{
    private int CurrentPage
    {
        get { return ViewState["CurrentPage"] != null ? (int)ViewState["CurrentPage"] : 1; }
        set { ViewState["CurrentPage"] = value; }
    }

    private const int PageSize = 12;

    protected void Page_Load(object sender, EventArgs e)
    {
        if (Session["AdminId"] == null)
        {
            Response.Redirect("/admin/login.aspx");
            return;
        }

        if (!IsPostBack)
        {
            LoadBuildings();
            LoadRooms();
        }
    }

    private void LoadBuildings()
    {
        DataTable dt = DormBLL.GetBuildings();
        foreach (DataRow row in dt.Rows)
        {
            ddlBuilding.Items.Add(new ListItem(row["Name"].ToString() + " (" + row["Campus"] + ")", row["Id"].ToString()));
        }
    }

    private void LoadRooms()
    {
        int buildingId = 0;
        string roomNo = txtRoomNo.Text.Trim();

        if (ddlBuilding.SelectedValue != "0")
        {
            buildingId = Convert.ToInt32(ddlBuilding.SelectedValue);
        }

        DataTable dt = DormBLL.GetAllRooms(buildingId, roomNo, CurrentPage, PageSize);
        int totalRooms = DormBLL.GetRoomCount(buildingId, roomNo);
        int totalBeds = DormBLL.GetTotalBeds();
        int availableBeds = DormBLL.GetAvailableBeds();

        if (dt.Rows.Count > 0)
        {
            rptRooms.DataSource = dt;
            rptRooms.DataBind();
            pnlEmpty.Visible = false;
        }
        else
        {
            rptRooms.Visible = false;
            pnlEmpty.Visible = true;
        }

        litStats.Text = totalRooms + " 房间 / " + totalBeds + " 床位";

        // 分页信息
        int totalPages = (int)Math.Ceiling((double)totalRooms / PageSize);
        int start = (CurrentPage - 1) * PageSize + 1;
        int end = Math.Min(CurrentPage * PageSize, totalRooms);
        litPageInfo.Text = "显示 " + start + " 到 " + end + " / 共 " + totalRooms + " 个房间";

        // 分页按钮
        btnPrev.Enabled = CurrentPage > 1;
        btnPrev.Style["opacity"] = CurrentPage > 1 ? "1" : "0.4";

        litPageBtns.Text = "";
        for (int i = 1; i <= totalPages; i++)
        {
            if (i <= 3 || i >= totalPages - 1 || Math.Abs(i - CurrentPage) <= 1)
            {
                string activeClass = i == CurrentPage ? " active" : "";
                litPageBtns.Text += "<button class='page-btn" + activeClass + "' type='submit' name='PageBtn' value='" + i + "'>" + i + "</button>";
            }
            else if (i == 4 || i == totalPages - 2)
            {
                litPageBtns.Text += "<span style='padding:0 4px; color:var(--on-surface-variant);'>...</span>";
            }
        }

        btnNext.Enabled = CurrentPage < totalPages;
        btnNext.Style["opacity"] = CurrentPage < totalPages ? "1" : "0.4";
    }

    protected void ddlBuilding_SelectedIndexChanged(object sender, EventArgs e)
    {
        CurrentPage = 1;
        LoadRooms();
    }

    protected void btnSearch_Click(object sender, EventArgs e)
    {
        CurrentPage = 1;
        LoadRooms();
    }

    protected void btnPrev_Click(object sender, EventArgs e)
    {
        if (CurrentPage > 1)
        {
            CurrentPage--;
            LoadRooms();
        }
    }

    protected void btnNext_Click(object sender, EventArgs e)
    {
        CurrentPage++;
        LoadRooms();
    }

    protected void rptRooms_ItemDataBound(object sender, RepeaterItemEventArgs e)
    {
        if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
        {
            DataRowView row = (DataRowView)e.Item.DataItem;
            int roomId = Convert.ToInt32(row["Id"]);

            Repeater rptBeds = (Repeater)e.Item.FindControl("rptBeds");
            DataTable beds = DormBLL.GetRoomBeds(roomId);
            rptBeds.DataSource = beds;
            rptBeds.DataBind();
        }
    }

    protected void rptBeds_ItemCommand(object source, RepeaterCommandEventArgs e)
    {
        if (e.CommandName == "Allocate")
        {
            int bedId = Convert.ToInt32(e.CommandArgument);
            hfBedId.Value = bedId.ToString();
            litModalTitle.Text = "床位 " + GetBedName(bedId);
            txtSearchStudent.Text = "";
            rptStudents.DataSource = null;
            rptStudents.DataBind();
            pnlNoStudent.Visible = true;
            allocateModal.Attributes["class"] = "modal-overlay show";
        }
        else if (e.CommandName == "Release")
        {
            int bedId = Convert.ToInt32(e.CommandArgument);
            hfReleaseBedId.Value = bedId.ToString();
            litReleaseInfo.Text = "床位: " + GetBedName(bedId);
            releaseModal.Attributes["class"] = "modal-overlay show";
        }
    }

    private string GetBedName(int bedId)
    {
        DataTable dt = DBHelper.GetDataTable("SELECT b.BedNo, r.RoomNo FROM Beds b JOIN Rooms r ON b.RoomId=r.Id WHERE b.Id=@Id",
            new MySql.Data.MySqlClient.MySqlParameter("@Id", bedId));
        if (dt.Rows.Count > 0)
        {
            return dt.Rows[0]["RoomNo"] + " - " + dt.Rows[0]["BedNo"] + "号床";
        }
        return bedId.ToString();
    }

    protected void txtSearchStudent_TextChanged(object sender, EventArgs e)
    {
        string keyword = txtSearchStudent.Text.Trim();
        if (!string.IsNullOrEmpty(keyword))
        {
            DataTable dt = DormBLL.SearchStudents(keyword);
            if (dt.Rows.Count > 0)
            {
                rptStudents.DataSource = dt;
                rptStudents.DataBind();
                pnlNoStudent.Visible = false;
            }
            else
            {
                rptStudents.DataSource = null;
                rptStudents.DataBind();
                pnlNoStudent.Visible = true;
            }
        }
        else
        {
            rptStudents.DataSource = null;
            rptStudents.DataBind();
            pnlNoStudent.Visible = true;
        }

        allocateModal.Attributes["class"] = "modal-overlay show";
    }

    protected void rptStudents_ItemCommand(object source, RepeaterCommandEventArgs e)
    {
        if (e.CommandName == "Select")
        {
            int studentId = Convert.ToInt32(e.CommandArgument);
            int bedId = Convert.ToInt32(hfBedId.Value);

            if (DormBLL.AllocateBed(bedId, studentId))
            {
                allocateModal.Attributes["class"] = "modal-overlay";
                LoadRooms();
            }
        }
    }

    protected void btnConfirmRelease_Click(object sender, EventArgs e)
    {
        int bedId = Convert.ToInt32(hfReleaseBedId.Value);

        if (DormBLL.ReleaseBed(bedId))
        {
            releaseModal.Attributes["class"] = "modal-overlay";
            LoadRooms();
        }
    }

    protected string GetRoomType(object roomType)
    {
        int type = Convert.ToInt32(roomType);
        switch (type)
        {
            case 1: return "双人间";
            case 2: return "四人间";
            case 3: return "六人间";
            default: return "未知";
        }
    }

    protected string GetStatusCss(object occupied, object total)
    {
        int o = Convert.ToInt32(occupied);
        int t = Convert.ToInt32(total);
        if (o == 0) return "room-status empty";
        if (o >= t) return "room-status full";
        return "room-status partial";
    }

    protected string GetStatusText(object occupied, object total)
    {
        int o = Convert.ToInt32(occupied);
        int t = Convert.ToInt32(total);
        if (o == 0) return "全空置";
        if (o >= t) return "已满员";
        return "空余 " + (t - o);
    }

    protected string GetOccupiedBedHtml(object name, object studentNo, object bedId)
    {
        string n = name != null ? name.ToString() : "";
        string s = studentNo != null ? studentNo.ToString() : "";
        string id = bedId.ToString();
        return "<div class='bed-item'><div class='bed-left'><div class='bed-avatar'><span class='material-symbols-outlined'>person</span></div><div><div class='bed-name'>" + n + "</div><div class='bed-info'>" + s + "</div></div></div><button class='release-btn' type='submit' name='ReleaseBtn' value='" + id + "' onclick=\"return confirm('确定要退宿吗？');\">退宿</button></div>";
    }

    protected string GetEmptyBedHtml(object bedNo, object bedId)
    {
        string bn = bedNo.ToString();
        string id = bedId.ToString();
        return "<button class='bed-empty' type='submit' name='AllocateBtn' value='" + id + "'><span class='material-symbols-outlined'>add_circle</span> 分配床位 " + bn + "</button>";
    }

    protected override void RaisePostBackEvent(IPostBackEventHandler sourceControl, string eventArgument)
    {
        // 处理分页按钮点击
        if (!string.IsNullOrEmpty(Request.Form["PageBtn"]))
        {
            CurrentPage = Convert.ToInt32(Request.Form["PageBtn"]);
            LoadRooms();
            return;
        }

        // 处理分配床位按钮点击
        if (!string.IsNullOrEmpty(Request.Form["AllocateBtn"]))
        {
            int bedId = Convert.ToInt32(Request.Form["AllocateBtn"]);
            hfBedId.Value = bedId.ToString();
            litModalTitle.Text = "床位 " + GetBedName(bedId);
            txtSearchStudent.Text = "";
            rptStudents.DataSource = null;
            rptStudents.DataBind();
            pnlNoStudent.Visible = true;
            allocateModal.Attributes["class"] = "modal-overlay show";
            return;
        }

        // 处理退宿按钮点击
        if (!string.IsNullOrEmpty(Request.Form["ReleaseBtn"]))
        {
            int bedId = Convert.ToInt32(Request.Form["ReleaseBtn"]);
            if (DormBLL.ReleaseBed(bedId))
            {
                LoadRooms();
            }
            return;
        }

        base.RaisePostBackEvent(sourceControl, eventArgument);
    }
}
