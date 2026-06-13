using System;
using System.Data;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class admin_repair : System.Web.UI.Page
{
    private int CurrentPage
    {
        get { return ViewState["CurrentPage"] != null ? (int)ViewState["CurrentPage"] : 1; }
        set { ViewState["CurrentPage"] = value; }
    }

    private const int PageSize = 15;

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
            LoadStats();
            LoadRepairs();
            LoadAssignAdmins();
        }

        // 处理点击行查看详情
        string eventTarget = Request.Form["__EVENTTARGET"];
        string eventArg = Request.Form["__EVENTARGUMENT"];
        if (eventTarget == "ShowDetail" && !string.IsNullOrEmpty(eventArg))
        {
            int id = Convert.ToInt32(eventArg);
            LoadDetail(id);
        }
    }

    private void LoadBuildings()
    {
        DataTable dt = DormBLL.GetBuildings();
        foreach (DataRow row in dt.Rows)
        {
            ddlBuilding.Items.Add(new ListItem(row["Name"].ToString(), row["Id"].ToString()));
        }
    }

    private void LoadStats()
    {
        DataTable dt = RepairBLL.GetRepairStats();
        if (dt.Rows.Count > 0)
        {
            litPending.Text = Convert.ToInt32(dt.Rows[0]["Pending"]).ToString();
            litProcessing.Text = Convert.ToInt32(dt.Rows[0]["Processing"]).ToString();
            litTodayCompleted.Text = Convert.ToInt32(dt.Rows[0]["TodayCompleted"]).ToString();
        }
    }

    private void LoadRepairs()
    {
        int status = Convert.ToInt32(ddlStatus.SelectedValue);
        int buildingId = Convert.ToInt32(ddlBuilding.SelectedValue);
        int repairType = Convert.ToInt32(ddlRepairType.SelectedValue);

        DataTable dt = RepairBLL.GetRepairList(status, buildingId, repairType, CurrentPage, PageSize);
        int totalCount = RepairBLL.GetRepairListCount(status, buildingId, repairType);

        if (dt.Rows.Count > 0)
        {
            rptRepairs.DataSource = dt;
            rptRepairs.DataBind();
            pnlEmpty.Visible = false;
        }
        else
        {
            rptRepairs.DataSource = null;
            rptRepairs.DataBind();
            pnlEmpty.Visible = true;
        }

        // 分页
        int totalPages = (int)Math.Ceiling((double)totalCount / PageSize);
        int start = (CurrentPage - 1) * PageSize + 1;
        int end = Math.Min(CurrentPage * PageSize, totalCount);
        litPageInfo.Text = "显示 " + start + "-" + end + " 条，共 " + totalCount + " 条工单";

        btnPrev.Enabled = CurrentPage > 1;
        btnPrev.Style["opacity"] = CurrentPage > 1 ? "1" : "0.4";

        litPageBtns.Text = "";
        for (int i = 1; i <= totalPages && i <= 5; i++)
        {
            string activeClass = i == CurrentPage ? " active" : "";
            litPageBtns.Text += "<button class='repair-page-btn" + activeClass + "' type='submit' name='PageBtn' value='" + i + "'>" + i + "</button>";
        }

        btnNext.Enabled = CurrentPage < totalPages;
        btnNext.Style["opacity"] = CurrentPage < totalPages ? "1" : "0.4";
    }

    private void LoadAssignAdmins()
    {
        DataTable dt = RepairBLL.GetAdminListForAssign();
        ddlAssignAdmin.Items.Add(new ListItem("点击选择维修技工...", ""));
        foreach (DataRow row in dt.Rows)
        {
            ddlAssignAdmin.Items.Add(new ListItem(row["Name"].ToString() + " (" + row["RoleName"] + ")", row["Id"].ToString()));
        }
    }

    private void LoadDetail(int id)
    {
        DataTable dt = RepairBLL.GetRepairById(id);
        if (dt.Rows.Count == 0) return;

        DataRow row = dt.Rows[0];
        hfDetailId.Value = id.ToString();
        litDetailOrderNo.Text = row["OrderNo"].ToString();
        litDetailStudent.Text = row["StudentName"].ToString();
        litDetailName.Text = row["StudentName"].ToString();
        litDetailStudentNo.Text = row["StudentNo"].ToString();
        litDetailPhone.Text = row["StudentPhone"].ToString();
        litDetailType.Text = row["TypeName"].ToString();
        litDetailDesc.Text = row["Description"].ToString();

        // 照片
        string photos = row["Photos"] != DBNull.Value ? row["Photos"].ToString() : "";
        if (!string.IsNullOrEmpty(photos))
        {
            string[] paths = photos.Split(',');
            string html = "<div style='display:flex;gap:10px;flex-wrap:wrap;margin-bottom:20px;'>";
            foreach (string path in paths)
            {
                if (!string.IsNullOrEmpty(path.Trim()))
                    html += "<img src='" + path.Trim() + "' style='width:120px;height:120px;object-fit:cover;border-radius:12px;cursor:pointer;border:1px solid rgba(0,0,0,0.06);' onclick='window.open(this.src)' />";
            }
            html += "</div>";
            litPhotos.Text = html;
        }
        else
        {
            litPhotos.Text = "<div style='color:var(--on-surface-variant);font-size:14px;padding:16px 0;'>未上传照片</div>";
        }

        txtNote.Text = row["InternalNote"] != DBNull.Value ? row["InternalNote"].ToString() : "";

        // 根据状态显示/隐藏按钮
        int status = Convert.ToInt32(row["Status"]);
        btnReject.Visible = (status == 1); // 只有待分配才能驳回
        btnComplete.Visible = (status == 2); // 只有维修中才能完成
        btnAssign.Visible = (status == 1); // 只有待分配才能指派

        if (status != 1)
        {
            ddlAssignAdmin.Enabled = false;
            if (row["AssignAdminName"] != DBNull.Value)
            {
                ddlAssignAdmin.Items.FindByText(row["AssignAdminName"].ToString());
            }
        }
        else
        {
            ddlAssignAdmin.Enabled = true;
        }

        Page.ClientScript.RegisterStartupScript(this.GetType(), "openDetail", "openDetail();", true);
    }

    protected void btnSearch_Click(object sender, EventArgs e)
    {
        CurrentPage = 1;
        LoadRepairs();
    }

    protected void btnReset_Click(object sender, EventArgs e)
    {
        ddlStatus.SelectedIndex = 0;
        ddlBuilding.SelectedIndex = 0;
        ddlRepairType.SelectedIndex = 0;
        CurrentPage = 1;
        LoadRepairs();
    }

    protected void btnPrev_Click(object sender, EventArgs e)
    {
        if (CurrentPage > 1)
        {
            CurrentPage--;
            LoadRepairs();
        }
    }

    protected void btnNext_Click(object sender, EventArgs e)
    {
        CurrentPage++;
        LoadRepairs();
    }

    protected void rptRepairs_ItemCommand(object source, RepeaterCommandEventArgs e)
    {
        // 不使用，改为JS触发PostBack
    }

    protected void btnAssign_Click(object sender, EventArgs e)
    {
        int orderId = Convert.ToInt32(hfDetailId.Value);
        string adminIdStr = ddlAssignAdmin.SelectedValue;
        if (string.IsNullOrEmpty(adminIdStr))
        {
            Page.ClientScript.RegisterStartupScript(this.GetType(), "toast", "showToast('请选择维修技工','error');", true);
            Page.ClientScript.RegisterStartupScript(this.GetType(), "openDetail", "openDetail();", true);
            return;
        }

        int adminId = Convert.ToInt32(adminIdStr);
        if (RepairBLL.AssignRepairOrder(orderId, adminId))
        {
            LoadStats();
            LoadRepairs();
            LoadDetail(orderId);
            Page.ClientScript.RegisterStartupScript(this.GetType(), "toast", "showToast('指派成功','success');", true);
        }
    }

    protected void btnComplete_Click(object sender, EventArgs e)
    {
        int orderId = Convert.ToInt32(hfDetailId.Value);
        if (RepairBLL.CompleteRepairOrder(orderId))
        {
            LoadStats();
            LoadRepairs();
            LoadDetail(orderId);
            Page.ClientScript.RegisterStartupScript(this.GetType(), "toast", "showToast('工单已完成','success');", true);
        }
    }

    protected void btnReject_Click(object sender, EventArgs e)
    {
        int orderId = Convert.ToInt32(hfDetailId.Value);
        if (RepairBLL.RejectRepairOrder(orderId, "管理员驳回"))
        {
            LoadStats();
            LoadRepairs();
            Page.ClientScript.RegisterStartupScript(this.GetType(), "toast", "showToast('已驳回','success');", true);
        }
    }

    protected void btnSaveNote_Click(object sender, EventArgs e)
    {
        int orderId = Convert.ToInt32(hfDetailId.Value);
        string note = txtNote.Text.Trim();
        if (RepairBLL.UpdateInternalNote(orderId, note))
        {
            Page.ClientScript.RegisterStartupScript(this.GetType(), "toast", "showToast('备注已保存','success');", true);
            Page.ClientScript.RegisterStartupScript(this.GetType(), "openDetail", "openDetail();", true);
        }
    }

    protected string GetRepairTypeColor(object type)
    {
        int t = Convert.ToInt32(type);
        switch (t)
        {
            case 1: return "var(--error)";
            case 2: return "var(--primary)";
            case 3: return "#3b82f6";
            default: return "var(--on-surface-variant)";
        }
    }

    protected string GetRepairTypeIcon(object type)
    {
        int t = Convert.ToInt32(type);
        switch (t)
        {
            case 1: return "bolt";
            case 2: return "home_repair_service";
            case 3: return "router";
            default: return "build";
        }
    }

    protected override void RaisePostBackEvent(IPostBackEventHandler sourceControl, string eventArgument)
    {
        if (!string.IsNullOrEmpty(Request.Form["PageBtn"]))
        {
            CurrentPage = Convert.ToInt32(Request.Form["PageBtn"]);
            LoadRepairs();
            return;
        }

        base.RaisePostBackEvent(sourceControl, eventArgument);
    }
}
