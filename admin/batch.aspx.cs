using System;
using System.Data;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class admin_batch : System.Web.UI.Page
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
            LoadStats();
            LoadBatches();
            LoadColleges();
        }
    }

    private void LoadStats()
    {
        DataTable dt = BatchBLL.GetBatchStats();
        if (dt.Rows.Count > 0)
        {
            litTotalBatches.Text = (Convert.ToInt32(dt.Rows[0]["Total"]) + Convert.ToInt32(dt.Rows[0]["Active"]) + Convert.ToInt32(dt.Rows[0]["Upcoming"]) + Convert.ToInt32(dt.Rows[0]["Ended"])).ToString();
            litActiveBatches.Text = Convert.ToInt32(dt.Rows[0]["Active"]).ToString();
            litUpcomingBatches.Text = Convert.ToInt32(dt.Rows[0]["Upcoming"]).ToString();
            litEndedBatches.Text = Convert.ToInt32(dt.Rows[0]["Ended"]).ToString();
        }
    }

    private void LoadBatches()
    {
        string keyword = txtBatchSearch.Text.Trim();
        int status = Convert.ToInt32(ddlBatchStatus.SelectedValue);

        DataTable dt = BatchBLL.GetBatchList(keyword, status);
        if (dt.Rows.Count > 0)
        {
            rptBatches.DataSource = dt;
            rptBatches.DataBind();
            rptBatches.Visible = true;
            pnlEmpty.Visible = false;
        }
        else
        {
            rptBatches.Visible = false;
            pnlEmpty.Visible = true;
        }
    }

    private void LoadColleges()
    {
        DataTable dt = DeptBLL.GetDepartmentTree();
        DataTable colleges = dt.DefaultView.ToTable(true, "CollegeName");
        foreach (DataRow row in colleges.Rows)
        {
            ddlCollegeLimit.Items.Add(new ListItem(row["CollegeName"].ToString(), row["CollegeName"].ToString()));
        }
    }

    protected void btnBatchSearch_Click(object sender, EventArgs e)
    {
        LoadBatches();
    }

    protected void rptBatches_ItemCommand(object source, RepeaterCommandEventArgs e)
    {
        int id = Convert.ToInt32(e.CommandArgument);

        if (e.CommandName == "EditBatch")
        {
            hfBatchId.Value = id.ToString();
            DataTable dt = BatchBLL.GetBatchList("", -1);
            foreach (DataRow row in dt.Rows)
            {
                if (Convert.ToInt32(row["Id"]) == id)
                {
                    txtBatchName.Text = row["BatchName"].ToString();
                    txtStartTime.Text = Convert.ToDateTime(row["StartTime"]).ToString("yyyy-MM-ddTHH:mm");
                    txtEndTime.Text = Convert.ToDateTime(row["EndTime"]).ToString("yyyy-MM-ddTHH:mm");
                    
                    string gradeLimit = row["GradeLimit"] != DBNull.Value ? row["GradeLimit"].ToString() : "";
                    string collegeLimit = row["CollegeLimit"] != DBNull.Value ? row["CollegeLimit"].ToString() : "";
                    string majorLimit = row["MajorLimit"] != DBNull.Value ? row["MajorLimit"].ToString() : "";
                    int status = Convert.ToInt32(row["Status"]);

                    SetDropDownValue(ddlGradeLimit, gradeLimit);
                    SetDropDownValue(ddlCollegeLimit, collegeLimit);
                    SetDropDownValue(ddlMajorLimit, majorLimit);
                    ddlBatchStatusEdit.SelectedValue = status.ToString();
                    break;
                }
            }
            litModalTitle.Text = "编辑批次";
            pnlBatchModal.Style["display"] = "flex";
        }
        else if (e.CommandName == "DeleteBatch")
        {
            if (BatchBLL.DeleteBatch(id))
            {
                LoadBatches();
                LoadStats();
                Page.ClientScript.RegisterStartupScript(this.GetType(), "toast", "showToast('批次已删除','success');", true);
            }
        }
    }

    private void SetDropDownValue(DropDownList ddl, string value)
    {
        foreach (ListItem item in ddl.Items)
        {
            if (item.Value == value)
            {
                ddl.SelectedValue = value;
                return;
            }
        }
    }

    protected void ddlModalBuilding_SelectedIndexChanged(object sender, EventArgs e)
    {
        int buildingId = Convert.ToInt32(ddlModalBuilding.SelectedValue);
        if (buildingId > 0)
        {
            DataTable floors = DormBLL.GetFloorsByBuilding(buildingId);
            ddlModalFloor.Items.Clear();
            ddlModalFloor.Items.Add(new ListItem("全部楼层", "0"));
            foreach (DataRow row in floors.Rows)
            {
                ddlModalFloor.Items.Add(new ListItem(row["Floor"].ToString() + "层", row["Floor"].ToString()));
            }
            LoadModalRooms(buildingId, 0);
            LoadSelectedRooms();
        }
        else
        {
            rptModalRooms.DataSource = null;
            rptModalRooms.DataBind();
            rptSelectedRooms.DataSource = null;
            rptSelectedRooms.DataBind();
        }
        pnlBatchModal.Style["display"] = "flex";
    }

    protected void ddlModalFloor_SelectedIndexChanged(object sender, EventArgs e)
    {
        int buildingId = Convert.ToInt32(ddlModalBuilding.SelectedValue);
        int floor = Convert.ToInt32(ddlModalFloor.SelectedValue);
        LoadModalRooms(buildingId, floor);
        pnlBatchModal.Style["display"] = "flex";
    }

    private void LoadModalRooms(int buildingId, int floor)
    {
        DataTable dt = BatchBLL.GetRoomsForBatch(buildingId, floor);
        rptModalRooms.DataSource = dt;
        rptModalRooms.DataBind();
    }

    private void LoadSelectedRooms()
    {
        string selectedIds = ViewState["SelectedRoomIds"] as string ?? "";
        if (string.IsNullOrEmpty(selectedIds))
        {
            rptSelectedRooms.DataSource = null;
            rptSelectedRooms.DataBind();
            return;
        }

        DataTable dt = new DataTable();
        dt.Columns.Add("BuildingName", typeof(string));
        dt.Columns.Add("RoomNo", typeof(string));

        string[] ids = selectedIds.Split(',');
        foreach (string id in ids)
        {
            int roomId;
            if (int.TryParse(id.Trim(), out roomId))
            {
                DataTable roomInfo = DBHelper.GetDataTable(
                    "SELECT r.RoomNo, b.Name as BuildingName FROM Rooms r JOIN Buildings b ON r.BuildingId=b.Id WHERE r.Id=@Id",
                    new MySql.Data.MySqlClient.MySqlParameter("@Id", roomId));
                if (roomInfo.Rows.Count > 0)
                {
                    dt.Rows.Add(roomInfo.Rows[0]["BuildingName"], roomInfo.Rows[0]["RoomNo"]);
                }
            }
        }
        rptSelectedRooms.DataSource = dt;
        rptSelectedRooms.DataBind();
    }

    protected void rptModalRooms_ItemCommand(object source, RepeaterCommandEventArgs e)
    {
        if (e.CommandName == "ToggleRoom")
        {
            int roomId = Convert.ToInt32(e.CommandArgument);
            string selectedIds = ViewState["SelectedRoomIds"] as string ?? "";
            string[] ids = string.IsNullOrEmpty(selectedIds) ? new string[0] : selectedIds.Split(',');

            System.Collections.Generic.List<string> list = new System.Collections.Generic.List<string>(ids);
            string roomIdStr = roomId.ToString();

            if (list.Contains(roomIdStr))
            {
                list.Remove(roomIdStr);
            }
            else
            {
                list.Add(roomIdStr);
            }

            ViewState["SelectedRoomIds"] = string.Join(",", list);

            // 重新加载房间列表和已选房间
            int buildingId = Convert.ToInt32(ddlModalBuilding.SelectedValue);
            int floor = Convert.ToInt32(ddlModalFloor.SelectedValue);
            if (buildingId > 0)
            {
                LoadModalRooms(buildingId, floor);
            }
            LoadSelectedRooms();
            pnlBatchModal.Style["display"] = "flex";
        }
    }

    protected bool IsRoomSelected(object roomId)
    {
        string selectedIds = ViewState["SelectedRoomIds"] as string ?? "";
        if (string.IsNullOrEmpty(selectedIds)) return false;
        return selectedIds.Split(',').Contains(roomId.ToString());
    }

    protected void btnSaveBatch_Click(object sender, EventArgs e)
    {
        string batchName = txtBatchName.Text.Trim();
        DateTime startTime = Convert.ToDateTime(txtStartTime.Text);
        DateTime endTime = Convert.ToDateTime(txtEndTime.Text);
        string gradeLimit = ddlGradeLimit.SelectedValue;
        string collegeLimit = ddlCollegeLimit.SelectedValue;
        string majorLimit = ddlMajorLimit.SelectedValue;
        int status = Convert.ToInt32(ddlBatchStatusEdit.SelectedValue);
        int adminId = Convert.ToInt32(Session["AdminId"]);

        if (string.IsNullOrEmpty(batchName))
        {
            Page.ClientScript.RegisterStartupScript(this.GetType(), "toast", "showToast('请输入批次名称','error');", true);
            pnlBatchModal.Style["display"] = "flex";
            return;
        }

        if (startTime >= endTime)
        {
            Page.ClientScript.RegisterStartupScript(this.GetType(), "toast", "showToast('开始时间必须早于结束时间','error');", true);
            pnlBatchModal.Style["display"] = "flex";
            return;
        }

        // 获取选中的房间
        string selectedIds = ViewState["SelectedRoomIds"] as string ?? "";
        int[] roomIds = new int[0];
        if (!string.IsNullOrEmpty(selectedIds))
        {
            var list = new System.Collections.Generic.List<int>();
            foreach (string id in selectedIds.Split(','))
            {
                int roomId;
                if (int.TryParse(id.Trim(), out roomId))
                    list.Add(roomId);
            }
            roomIds = list.ToArray();
        }

        if (!string.IsNullOrEmpty(hfBatchId.Value))
        {
            int id = Convert.ToInt32(hfBatchId.Value);
            if (BatchBLL.UpdateBatch(id, batchName, startTime, endTime, gradeLimit, collegeLimit, majorLimit, status))
            {
                pnlBatchModal.Style["display"] = "none";
                LoadBatches();
                LoadStats();
                Page.ClientScript.RegisterStartupScript(this.GetType(), "toast", "showToast('修改成功','success');", true);
            }
        }
        else
        {
            if (BatchBLL.AddBatch(batchName, startTime, endTime, gradeLimit, collegeLimit, majorLimit, adminId, roomIds))
            {
                pnlBatchModal.Style["display"] = "none";
                LoadBatches();
                LoadStats();
                Page.ClientScript.RegisterStartupScript(this.GetType(), "toast", "showToast('创建成功','success');", true);
            }
            else
            {
                Page.ClientScript.RegisterStartupScript(this.GetType(), "toast", "showToast('创建失败','error');", true);
                pnlBatchModal.Style["display"] = "flex";
            }
        }
    }

    protected void btnCloseModal_Click(object sender, EventArgs e)
    {
        pnlBatchModal.Style["display"] = "none";
        hfBatchId.Value = "";
        txtBatchName.Text = "";
        txtStartTime.Text = "";
        txtEndTime.Text = "";
        ddlGradeLimit.SelectedIndex = 0;
        ddlCollegeLimit.SelectedIndex = 0;
        ddlMajorLimit.SelectedIndex = 0;
        ddlBatchStatusEdit.SelectedIndex = 0;
        ViewState["SelectedRoomIds"] = "";
        ddlModalBuilding.SelectedIndex = 0;
    }

    protected string GetStatusClass(object status)
    {
        int s = Convert.ToInt32(status);
        switch (s)
        {
            case 0: return "upcoming";
            case 1: return "active";
            case 2: return "ended";
            default: return "";
        }
    }

    protected string GetStatusText(object status)
    {
        int s = Convert.ToInt32(status);
        switch (s)
        {
            case 0: return "待开始";
            case 1: return "进行中";
            case 2: return "已结束";
            default: return "未知";
        }
    }

    protected string GetGradeLimit(object gradeLimit)
    {
        if (gradeLimit == null || gradeLimit == DBNull.Value || string.IsNullOrEmpty(gradeLimit.ToString()))
            return "";
        return "<span class='batch-tag green'>" + gradeLimit + "</span>";
    }

    protected string GetCollegeLimit(object collegeLimit)
    {
        if (collegeLimit == null || collegeLimit == DBNull.Value || string.IsNullOrEmpty(collegeLimit.ToString()))
            return "";
        return "<span class='batch-tag purple'>" + collegeLimit + "</span>";
    }

    protected string GetMajorLimit(object majorLimit)
    {
        if (majorLimit == null || majorLimit == DBNull.Value || string.IsNullOrEmpty(majorLimit.ToString()))
            return "";
        return "<span class='batch-tag green'>" + majorLimit + "</span>";
    }
}
