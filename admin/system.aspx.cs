using System;
using System.Data;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class admin_system : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (Session["AdminId"] == null)
        {
            Response.Redirect("/admin/login.aspx");
            return;
        }

        // 只有超级管理员(Role=1)才能访问系统管理
        if (Session["AdminRole"] == null || Session["AdminRole"].ToString() != "1")
        {
            Response.Redirect("/admin/dashboard.aspx");
            return;
        }

        if (!IsPostBack)
        {
            LoadAdmins();
            LoadBuildings();
            LoadGenBuildings();
            LoadDepts();
        }
    }

    #region 管理员管理

    private void LoadAdmins()
    {
        string keyword = txtAdminSearch.Text.Trim();
        int role = Convert.ToInt32(ddlAdminRole.SelectedValue);
        int status = Convert.ToInt32(ddlAdminStatus.SelectedValue);

        DataTable dt = AdminBLL.GetAdminList(keyword, role, status);
        rptAdmins.DataSource = dt;
        rptAdmins.DataBind();
    }

    protected void btnAdminSearch_Click(object sender, EventArgs e)
    {
        LoadAdmins();
    }

    protected void rptAdmins_ItemCommand(object source, RepeaterCommandEventArgs e)
    {
        int id = Convert.ToInt32(e.CommandArgument);

        if (e.CommandName == "EditAdmin")
        {
            hfAdminId.Value = id.ToString();
            DataTable dt = AdminBLL.GetAdminList("", 0, -1);
            foreach (DataRow row in dt.Rows)
            {
                if (Convert.ToInt32(row["Id"]) == id)
                {
                    txtAdminNo.Text = row["AdminNo"].ToString();
                    txtAdminNo.Enabled = false;
                    txtAdminName.Text = row["Name"].ToString();
                    txtAdminPhone.Text = row["Phone"].ToString();
                    ddlAdminRoleModal.SelectedValue = row["Role"].ToString();
                    ddlAdminStatusModal.SelectedValue = row["Status"].ToString();
                    break;
                }
            }
            litAdminModalTitle.Text = "编辑管理员";
            pnlAdminModal.Style["display"] = "flex";
        }
        else if (e.CommandName == "ResetPwd")
        {
            if (AdminBLL.ResetPassword(id, "123456"))
            {
                Page.ClientScript.RegisterStartupScript(this.GetType(), "toast", "showToast('密码已重置为123456','success');", true);
            }
        }
        else if (e.CommandName == "DeleteAdmin")
        {
            if (AdminBLL.DeleteAdmin(id))
            {
                LoadAdmins();
                Page.ClientScript.RegisterStartupScript(this.GetType(), "toast", "showToast('管理员已删除','success');", true);
            }
            else
            {
                Page.ClientScript.RegisterStartupScript(this.GetType(), "toast", "showToast('删除失败','error');", true);
            }
        }
    }

    protected void btnSaveAdmin_Click(object sender, EventArgs e)
    {
        string adminNo = txtAdminNo.Text.Trim();
        string name = txtAdminName.Text.Trim();
        string phone = txtAdminPhone.Text.Trim();
        int role = Convert.ToInt32(ddlAdminRoleModal.SelectedValue);
        int status = Convert.ToInt32(ddlAdminStatusModal.SelectedValue);

        if (string.IsNullOrEmpty(adminNo) || string.IsNullOrEmpty(name) || string.IsNullOrEmpty(phone))
        {
            Page.ClientScript.RegisterStartupScript(this.GetType(), "toast", "showToast('请填写完整信息','error');", true);
            pnlAdminModal.Style["display"] = "flex";
            return;
        }

        if (!string.IsNullOrEmpty(hfAdminId.Value))
        {
            int id = Convert.ToInt32(hfAdminId.Value);
            if (AdminBLL.UpdateAdmin(id, name, phone, role, status))
            {
                pnlAdminModal.Style["display"] = "none";
                LoadAdmins();
                Page.ClientScript.RegisterStartupScript(this.GetType(), "toast", "showToast('修改成功','success');", true);
            }
        }
        else
        {
            if (AdminBLL.AddAdmin(adminNo, name, phone, "123456", role))
            {
                pnlAdminModal.Style["display"] = "none";
                LoadAdmins();
                Page.ClientScript.RegisterStartupScript(this.GetType(), "toast", "showToast('添加成功，初始密码为123456','success');", true);
            }
            else
            {
                Page.ClientScript.RegisterStartupScript(this.GetType(), "toast", "showToast('工号已存在','error');", true);
                pnlAdminModal.Style["display"] = "flex";
            }
        }
    }

    protected void btnCloseAdminModal_Click(object sender, EventArgs e)
    {
        pnlAdminModal.Style["display"] = "none";
        hfAdminId.Value = "";
        txtAdminNo.Text = "";
        txtAdminNo.Enabled = true;
        txtAdminName.Text = "";
        txtAdminPhone.Text = "";
    }

    protected string GetRoleBadgeClass(object role)
    {
        int r = Convert.ToInt32(role);
        switch (r)
        {
            case 1: return "admin";
            case 2: return "manager";
            case 3: return "worker";
            default: return "";
        }
    }

    #endregion

    #region 楼宇管理

    private void LoadBuildings()
    {
        DataTable dt = DormBLL.GetBuildingList();
        rptBuildings.DataSource = dt;
        rptBuildings.DataBind();
    }

    protected void rptBuildings_ItemCommand(object source, RepeaterCommandEventArgs e)
    {
        int id = Convert.ToInt32(e.CommandArgument);

        if (e.CommandName == "ViewRooms")
        {
            hfSelectedBuildingId.Value = id.ToString();
            LoadRooms(id);
        }
        else if (e.CommandName == "EditBuilding")
        {
            hfBuildingId.Value = id.ToString();
            DataTable dt = DormBLL.GetBuildingList();
            foreach (DataRow row in dt.Rows)
            {
                if (Convert.ToInt32(row["Id"]) == id)
                {
                    txtBuildingName.Text = row["Name"].ToString();
                    txtBuildingCampus.Text = row["Campus"].ToString();
                    txtBuildingFloors.Text = row["FloorCount"].ToString();
                    txtBuildingRooms.Text = row["RoomsPerFloor"].ToString();
                    break;
                }
            }
            litBuildingModalTitle.Text = "编辑楼宇";
            pnlBuildingModal.Style["display"] = "flex";
        }
        else if (e.CommandName == "DeleteBuilding")
        {
            if (DormBLL.DeleteBuilding(id))
            {
                LoadBuildings();
                Page.ClientScript.RegisterStartupScript(this.GetType(), "toast", "showToast('楼宇已删除','success');", true);
            }
            else
            {
                Page.ClientScript.RegisterStartupScript(this.GetType(), "toast", "showToast('该楼宇下有房间，无法删除','error');", true);
            }
        }
    }

    private void LoadRooms(int buildingId)
    {
        DataTable dt = DormBLL.GetRoomsByBuildingForManage(buildingId);
        if (dt.Rows.Count > 0)
        {
            litRoomTitle.Text = dt.Rows[0]["RoomNo"].ToString().Split('-')[0] + "座 房间管理";
        }
        else
        {
            // 获取楼宇名称
            DataTable buildings = DormBLL.GetBuildingList();
            foreach (DataRow row in buildings.Rows)
            {
                if (Convert.ToInt32(row["Id"]) == buildingId)
                {
                    litRoomTitle.Text = row["Name"].ToString() + " 房间管理";
                    break;
                }
            }
        }
        rptRooms.DataSource = dt;
        rptRooms.DataBind();
        pnlRoomList.Visible = true;
        pnlNoBuilding.Visible = false;
        btnAddRoom.Visible = true;
    }

    protected void rptRooms_ItemCommand(object source, RepeaterCommandEventArgs e)
    {
        if (e.CommandName == "ToggleStatus")
        {
            string[] args = e.CommandArgument.ToString().Split(',');
            int roomId = Convert.ToInt32(args[0]);
            int currentStatus = Convert.ToInt32(args[1]);
            int newStatus = currentStatus == 1 ? 0 : 1;

            if (DormBLL.UpdateRoomStatus(roomId, newStatus))
            {
                int buildingId = Convert.ToInt32(hfSelectedBuildingId.Value);
                LoadRooms(buildingId);
                Page.ClientScript.RegisterStartupScript(this.GetType(), "toast", "showToast('状态已更新','success');", true);
            }
        }
        else if (e.CommandName == "DeleteRoom")
        {
            int roomId = Convert.ToInt32(e.CommandArgument);
            if (DormBLL.DeleteRoom(roomId))
            {
                int buildingId = Convert.ToInt32(hfSelectedBuildingId.Value);
                LoadRooms(buildingId);
                LoadBuildings();
                Page.ClientScript.RegisterStartupScript(this.GetType(), "toast", "showToast('房间已删除','success');", true);
            }
        }
    }

    protected void btnAddRoom_Click(object sender, EventArgs e)
    {
        int buildingId = Convert.ToInt32(hfSelectedBuildingId.Value);
        DataTable buildings = DormBLL.GetBuildingList();
        foreach (DataRow row in buildings.Rows)
        {
            if (Convert.ToInt32(row["Id"]) == buildingId)
            {
                lblRoomBuilding.Text = row["Name"].ToString() + " (" + row["Campus"] + ")";
                break;
            }
        }
        txtRoomFloor.Text = "";
        txtRoomNo.Text = "";
        pnlRoomModal.Style["display"] = "flex";
    }

    protected void btnSaveRoom_Click(object sender, EventArgs e)
    {
        int buildingId = Convert.ToInt32(hfSelectedBuildingId.Value);
        int floor = Convert.ToInt32(txtRoomFloor.Text);
        string roomNo = txtRoomNo.Text.Trim();
        int roomType = Convert.ToInt32(ddlRoomType.SelectedValue);

        int bedCount = 2;
        if (roomType == 2) bedCount = 4;
        else if (roomType == 3) bedCount = 6;

        if (string.IsNullOrEmpty(roomNo))
        {
            Page.ClientScript.RegisterStartupScript(this.GetType(), "toast", "showToast('请输入房间号','error');", true);
            pnlRoomModal.Style["display"] = "flex";
            return;
        }

        if (DormBLL.AddRoom(buildingId, floor, roomNo, roomType, bedCount))
        {
            pnlRoomModal.Style["display"] = "none";
            LoadRooms(buildingId);
            LoadBuildings();
            Page.ClientScript.RegisterStartupScript(this.GetType(), "toast", "showToast('房间添加成功','success');", true);
        }
        else
        {
            Page.ClientScript.RegisterStartupScript(this.GetType(), "toast", "showToast('添加失败','error');", true);
        }
    }

    protected void btnCloseRoomModal_Click(object sender, EventArgs e)
    {
        pnlRoomModal.Style["display"] = "none";
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

    protected void btnSaveBuilding_Click(object sender, EventArgs e)
    {
        string name = txtBuildingName.Text.Trim();
        string campus = txtBuildingCampus.Text.Trim();
        int floors = Convert.ToInt32(txtBuildingFloors.Text);
        int rooms = Convert.ToInt32(txtBuildingRooms.Text);

        if (string.IsNullOrEmpty(name) || string.IsNullOrEmpty(campus))
        {
            Page.ClientScript.RegisterStartupScript(this.GetType(), "toast", "showToast('请填写完整信息','error');", true);
            pnlBuildingModal.Style["display"] = "flex";
            return;
        }

        if (!string.IsNullOrEmpty(hfBuildingId.Value))
        {
            int id = Convert.ToInt32(hfBuildingId.Value);
            if (DormBLL.UpdateBuilding(id, name, floors, rooms, campus))
            {
                pnlBuildingModal.Style["display"] = "none";
                LoadBuildings();
                LoadGenBuildings();
                Page.ClientScript.RegisterStartupScript(this.GetType(), "toast", "showToast('修改成功','success');", true);
            }
        }
        else
        {
            if (DormBLL.AddBuilding(name, floors, rooms, campus))
            {
                pnlBuildingModal.Style["display"] = "none";
                LoadBuildings();
                LoadGenBuildings();
                Page.ClientScript.RegisterStartupScript(this.GetType(), "toast", "showToast('添加成功','success');", true);
            }
        }
    }

    protected void btnCloseBuildingModal_Click(object sender, EventArgs e)
    {
        pnlBuildingModal.Style["display"] = "none";
        hfBuildingId.Value = "";
        txtBuildingName.Text = "";
        txtBuildingCampus.Text = "";
        txtBuildingFloors.Text = "6";
        txtBuildingRooms.Text = "20";
    }

    #endregion

    #region 批量生成房间

    private void LoadGenBuildings()
    {
        DataTable dt = DormBLL.GetBuildings();
        ddlGenBuilding.Items.Clear();
        foreach (DataRow row in dt.Rows)
        {
            ddlGenBuilding.Items.Add(new ListItem(row["Name"].ToString() + " (" + row["Campus"] + ")", row["Id"].ToString()));
        }
    }

    protected void btnBatchGen_Click(object sender, EventArgs e)
    {
        int buildingId = Convert.ToInt32(ddlGenBuilding.SelectedValue);
        int startFloor = Convert.ToInt32(txtStartFloor.Text);
        int endFloor = Convert.ToInt32(txtEndFloor.Text);
        int roomsPerFloor = Convert.ToInt32(txtRoomsPerFloor.Text);
        int roomType = Convert.ToInt32(ddlGenRoomType.SelectedValue);

        int bedCount = 2;
        if (roomType == 2) bedCount = 4;
        else if (roomType == 3) bedCount = 6;

        int totalCreated = DormBLL.BatchCreateRooms(buildingId, startFloor, endFloor, roomsPerFloor, roomType, bedCount);
        if (totalCreated > 0)
        {
            LoadBuildings();
            Page.ClientScript.RegisterStartupScript(this.GetType(), "toast", "showToast('成功生成 " + totalCreated + " 个房间','success');", true);
        }
        else
        {
            Page.ClientScript.RegisterStartupScript(this.GetType(), "toast", "showToast('生成失败','error');", true);
        }
    }

    #endregion

    #region 院系管理

    private void LoadDepts()
    {
        DataTable dt = DeptBLL.GetDepartmentTree();

        // 按学院分组
        DataTable dtGrouped = dt.DefaultView.ToTable(true, "CollegeName");
        DataTable dtResult = new DataTable();
        dtResult.Columns.Add("CollegeName", typeof(string));

        foreach (DataRow row in dtGrouped.Rows)
        {
            dtResult.Rows.Add(row["CollegeName"]);
        }

        rptDepts.DataSource = dtResult;
        rptDepts.DataBind();
    }

    protected void rptDepts_ItemDataBound(object sender, RepeaterItemEventArgs e)
    {
        if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
        {
            DataRowView row = (DataRowView)e.Item.DataItem;
            string college = row["CollegeName"].ToString();

            Repeater rptMajors = (Repeater)e.Item.FindControl("rptMajors");
            DataTable dt = DeptBLL.GetDepartmentTree();
            DataView dv = new DataView(dt);
            dv.RowFilter = "CollegeName='" + college.Replace("'", "''") + "'";
            rptMajors.DataSource = dv;
            rptMajors.DataBind();
        }
    }

    protected void rptMajors_ItemCommand(object source, RepeaterCommandEventArgs e)
    {
        int id = Convert.ToInt32(e.CommandArgument);

        if (e.CommandName == "EditMajor")
        {
            hfEditMajorId.Value = id.ToString();
            DataTable dt = DeptBLL.GetDepartmentTree();
            foreach (DataRow row in dt.Rows)
            {
                if (Convert.ToInt32(row["Id"]) == id)
                {
                    txtEditMajorName.Text = row["MajorName"].ToString();
                    break;
                }
            }
            pnlEditMajorModal.Style["display"] = "flex";
        }
        else if (e.CommandName == "DeleteMajor")
        {
            if (DeptBLL.DeleteDepartment(id))
            {
                LoadDepts();
                Page.ClientScript.RegisterStartupScript(this.GetType(), "toast", "showToast('专业已删除','success');", true);
            }
        }
    }

    protected void btnSaveDept_Click(object sender, EventArgs e)
    {
        string college = txtCollegeName.Text.Trim();
        string major = txtMajorName.Text.Trim();

        if (string.IsNullOrEmpty(college) || string.IsNullOrEmpty(major))
        {
            Page.ClientScript.RegisterStartupScript(this.GetType(), "toast", "showToast('请填写完整信息','error');", true);
            pnlDeptModal.Style["display"] = "flex";
            return;
        }

        if (DeptBLL.AddDepartment(college, major))
        {
            pnlDeptModal.Style["display"] = "none";
            txtCollegeName.Text = "";
            txtMajorName.Text = "";
            LoadDepts();
            Page.ClientScript.RegisterStartupScript(this.GetType(), "toast", "showToast('添加成功','success');", true);
        }
    }

    protected void btnCloseDeptModal_Click(object sender, EventArgs e)
    {
        pnlDeptModal.Style["display"] = "none";
        txtCollegeName.Text = "";
        txtMajorName.Text = "";
    }

    protected void btnSaveEditMajor_Click(object sender, EventArgs e)
    {
        int id = Convert.ToInt32(hfEditMajorId.Value);
        string majorName = txtEditMajorName.Text.Trim();

        if (string.IsNullOrEmpty(majorName))
        {
            Page.ClientScript.RegisterStartupScript(this.GetType(), "toast", "showToast('请输入专业名称','error');", true);
            pnlEditMajorModal.Style["display"] = "flex";
            return;
        }

        if (DeptBLL.UpdateDepartment(id, majorName))
        {
            pnlEditMajorModal.Style["display"] = "none";
            LoadDepts();
            Page.ClientScript.RegisterStartupScript(this.GetType(), "toast", "showToast('修改成功','success');", true);
        }
    }

    protected void btnCloseEditMajorModal_Click(object sender, EventArgs e)
    {
        pnlEditMajorModal.Style["display"] = "none";
        hfEditMajorId.Value = "";
        txtEditMajorName.Text = "";
    }

    #endregion
}
