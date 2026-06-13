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
            litTotalBatches.Text = Convert.ToInt32(dt.Rows[0]["Total"]).ToString();
            litActiveBatches.Text = Convert.ToInt32(dt.Rows[0]["Active"]).ToString();
            litUpcomingBatches.Text = Convert.ToInt32(dt.Rows[0]["Upcoming"]).ToString();
            litEndedBatches.Text = Convert.ToInt32(dt.Rows[0]["Ended"]).ToString();
        }
    }

    private void LoadBatches()
    {
        string keyword = txtBatchSearch.Text.Trim();
        int status = Convert.ToInt32(ddlBatchStatus.SelectedValue);
        string grade = ddlFilterGrade.SelectedValue;
        string college = ddlFilterCollege.SelectedValue;

        DataTable dt = BatchBLL.GetBatchList(keyword, status, grade, college);
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
        DataTable dt = DormBLL.GetColleges();
        foreach (DataRow row in dt.Rows)
        {
            ddlCollegeLimit.Items.Add(new ListItem(row["CollegeName"].ToString(), row["CollegeName"].ToString()));
            ddlFilterCollege.Items.Add(new ListItem(row["CollegeName"].ToString(), row["CollegeName"].ToString()));
        }

        // 加载楼宇列表到弹窗HTML select
        ddlModalBuilding.Items.Clear();
        ddlModalBuilding.Items.Add(new ListItem("选择楼栋", "0"));
        DataTable buildings = BatchBLL.GetBuildingsForBatch();
        foreach (DataRow row in buildings.Rows)
        {
            ddlModalBuilding.Items.Add(new ListItem(row["Name"].ToString() + " (" + row["Campus"].ToString() + ")", row["Id"].ToString()));
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
                    int batchStatus = Convert.ToInt32(row["Status"]);

                    SetDropDownValue(ddlGradeLimit, gradeLimit);
                    ddlBatchStatusEdit.SelectedValue = batchStatus.ToString();
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
        int buildingId = Convert.ToInt32(ddlModalBuilding.Value);
        ddlModalFloor.Items.Clear();
        ddlModalFloor.Items.Add(new ListItem("全部楼层", "0"));

        if (buildingId > 0)
        {
            DataTable floors = DormBLL.GetFloorsByBuilding(buildingId);
            foreach (DataRow row in floors.Rows)
            {
                ddlModalFloor.Items.Add(new ListItem(row["Floor"].ToString() + "层", row["Floor"].ToString()));
            }
            LoadRoomsForJS(buildingId, 0);
        }
        else
        {
            Page.ClientScript.RegisterStartupScript(this.GetType(), "clearGrid", "document.getElementById('roomGrid').innerHTML='';", true);
        }
        pnlBatchModal.Style["display"] = "flex";
    }

    protected void ddlModalFloor_SelectedIndexChanged(object sender, EventArgs e)
    {
        int buildingId = Convert.ToInt32(ddlModalBuilding.Value);
        int floor = Convert.ToInt32(ddlModalFloor.Value);
        LoadRoomsForJS(buildingId, floor);
        pnlBatchModal.Style["display"] = "flex";
    }

    private void LoadRoomsForJS(int buildingId, int floor)
    {
        DataTable dt = BatchBLL.GetRoomsForBatch(buildingId, floor);
        string buildingName = "";
        DataTable buildings = BatchBLL.GetBuildingsForBatch();
        foreach (DataRow row in buildings.Rows)
        {
            if (Convert.ToInt32(row["Id"]) == buildingId)
            {
                buildingName = row["Name"].ToString();
                break;
            }
        }

        string json = "[";
        for (int i = 0; i < dt.Rows.Count; i++)
        {
            if (i > 0) json += ",";
            json += "{\"Id\":" + dt.Rows[i]["Id"] + ",\"RoomNo\":\"" + dt.Rows[i]["RoomNo"] + "\",\"BuildingName\":\"" + buildingName + "\"}";
        }
        json += "]";

        Page.ClientScript.RegisterStartupScript(this.GetType(), "renderRooms" + Guid.NewGuid(), "renderRoomGrid('" + json.Replace("'", "\\'") + "');", true);
    }

    protected void ddlCollegeLimit_SelectedIndexChanged(object sender, EventArgs e)
    {
        ddlMajorLimit.Items.Clear();
        ddlMajorLimit.Items.Add(new ListItem("不限", ""));
        string college = ddlCollegeLimit.SelectedValue;
        if (!string.IsNullOrEmpty(college))
        {
            DataTable dt = DormBLL.GetMajorsByCollege(college);
            foreach (DataRow row in dt.Rows)
            {
                ddlMajorLimit.Items.Add(new ListItem(row["MajorName"].ToString(), row["MajorName"].ToString()));
            }
        }
        pnlBatchModal.Style["display"] = "flex";
    }

    protected void btnSaveBatch_Click(object sender, EventArgs e)
    {
        string batchName = txtBatchName.Text.Trim();
        DateTime startTime = Convert.ToDateTime(txtStartTime.Text);
        DateTime endTime = Convert.ToDateTime(txtEndTime.Text);
        string gradeLimit = ddlGradeLimit.SelectedValue;
        string collegeLimit = ddlCollegeLimit.SelectedValue;
        string majorLimit = ddlMajorLimit.SelectedValue;
        string[] collegeLimits = !string.IsNullOrEmpty(collegeLimit) ? new string[] { collegeLimit } : null;
        string[] majorLimits = !string.IsNullOrEmpty(majorLimit) ? new string[] { majorLimit } : null;
        int batchStatus = Convert.ToInt32(ddlBatchStatusEdit.SelectedValue);
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
        string selectedIds = hfSelectedRoomIds.Value;
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
            if (BatchBLL.UpdateBatch(id, batchName, startTime, endTime, gradeLimit, collegeLimits, majorLimits, batchStatus))
            {
                pnlBatchModal.Style["display"] = "none";
                LoadBatches();
                LoadStats();
                Page.ClientScript.RegisterStartupScript(this.GetType(), "toast", "showToast('修改成功','success');", true);
            }
        }
        else
        {
            if (BatchBLL.AddBatch(batchName, startTime, endTime, gradeLimit, collegeLimits, majorLimits, adminId, roomIds))
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
        hfSelectedRoomIds.Value = "";
        ddlModalBuilding.SelectedIndex = 0;
        ddlModalFloor.Items.Clear();
        ddlModalFloor.Items.Add(new ListItem("全部楼层", "0"));
        Page.ClientScript.RegisterStartupScript(this.GetType(), "clearGrid", "selectedRooms=[]; document.getElementById('roomGrid').innerHTML=''; document.getElementById('selectedRoomTags').innerHTML='';", true);
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

    protected string GetCollegeLimit(object batchIdObj)
    {
        int batchId = Convert.ToInt32(batchIdObj);
        DataTable dt = DBHelper.GetDataTable("SELECT CollegeName FROM BatchCollegeLimit WHERE BatchId=@Id", new MySql.Data.MySqlClient.MySqlParameter[] { new MySql.Data.MySqlClient.MySqlParameter("@Id", batchId) });
        if (dt.Rows.Count == 0) return "";
        var names = new System.Collections.Generic.List<string>();
        foreach (DataRow row in dt.Rows) names.Add(row["CollegeName"].ToString());
        return "<span class='batch-tag purple'>" + string.Join("、", names) + "</span>";
    }

    protected string GetMajorLimit(object batchIdObj)
    {
        int batchId = Convert.ToInt32(batchIdObj);
        DataTable dt = DBHelper.GetDataTable("SELECT MajorName FROM BatchMajorLimit WHERE BatchId=@Id", new MySql.Data.MySqlClient.MySqlParameter[] { new MySql.Data.MySqlClient.MySqlParameter("@Id", batchId) });
        if (dt.Rows.Count == 0) return "";
        var names = new System.Collections.Generic.List<string>();
        foreach (DataRow row in dt.Rows) names.Add(row["MajorName"].ToString());
        return "<span class='batch-tag green'>" + string.Join("、", names) + "</span>";
    }
}
