using System;
using System.Data;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class admin_notice : System.Web.UI.Page
{
    private int CurrentPage
    {
        get { return ViewState["CurrentPage"] != null ? (int)ViewState["CurrentPage"] : 1; }
        set { ViewState["CurrentPage"] = value; }
    }

    private int CurrentFilter
    {
        get { return ViewState["CurrentFilter"] != null ? (int)ViewState["CurrentFilter"] : -1; }
        set { ViewState["CurrentFilter"] = value; }
    }

    private const int PageSize = 10;

    protected void Page_Load(object sender, EventArgs e)
    {
        if (Session["AdminId"] == null)
        {
            Response.Redirect("/admin/login.aspx");
            return;
        }

        if (!IsPostBack)
        {
            LoadScopeOptions();
            LoadNotices();
        }

        UpdateFormButton();
    }

    private void LoadScopeOptions()
    {
        DataTable dt = DormBLL.GetBuildings();
        foreach (DataRow row in dt.Rows)
        {
            ddlScope.Items.Add(new ListItem(row["Name"].ToString() + "宿舍楼", row["Id"].ToString()));
        }
    }

    private void LoadNotices()
    {
        DataTable dt = NoticeBLL.GetNoticeList("", CurrentFilter, CurrentPage, PageSize);
        int totalCount = NoticeBLL.GetNoticeCount("", CurrentFilter);

        if (dt.Rows.Count > 0)
        {
            rptNotices.DataSource = dt;
            rptNotices.DataBind();
            pnlEmpty.Visible = false;
        }
        else
        {
            rptNotices.DataSource = null;
            rptNotices.DataBind();
            pnlEmpty.Visible = true;
        }

        int totalPages = (int)Math.Ceiling((double)totalCount / PageSize);
        int start = (CurrentPage - 1) * PageSize + 1;
        int end = Math.Min(CurrentPage * PageSize, totalCount);
        litPageInfo.Text = "Page " + CurrentPage + " of " + Math.Max(totalPages, 1) + " · " + totalCount + " TOTAL RECORDS";

        btnPrev.Enabled = CurrentPage > 1;
        btnPrev.Style["opacity"] = CurrentPage > 1 ? "1" : "0.4";

        litPageBtns.Text = "";
        for (int i = 1; i <= totalPages && i <= 5; i++)
        {
            string activeClass = i == CurrentPage ? " active" : "";
            litPageBtns.Text += "<button class='pagination-btn" + activeClass + "' type='submit' name='NoticePageBtn' value='" + i + "'>" + i + "</button>";
        }

        btnNext.Enabled = CurrentPage < totalPages;
        btnNext.Style["opacity"] = CurrentPage < totalPages ? "1" : "0.4";
    }

    private void UpdateFormButton()
    {
        if (!string.IsNullOrEmpty(hfNoticeId.Value))
        {
            btnPublish.Text = "保存修改";
            btnCancelEdit.Style["display"] = "flex";
            formTitle.InnerText = "编辑公告";
        }
        else
        {
            btnPublish.Text = "立即发布公告";
            btnCancelEdit.Style["display"] = "none";
            formTitle.InnerText = "发布新公告";
        }
    }

    protected void btnPublish_Click(object sender, EventArgs e)
    {
        string title = txtTitle.Text.Trim();
        string content = txtContent.Text.Trim();
        int category = Convert.ToInt32(ddlCategory.SelectedValue);
        int isTop = chkIsTop.Checked ? 1 : 0;
        int status = chkSendNow.Checked ? 1 : 0;
        int adminId = Convert.ToInt32(Session["AdminId"]);

        // 获取选中的楼宇
        int[] buildingIds = null;
        string scopeVal = ddlScope.SelectedValue;
        if (scopeVal != "0")
        {
            buildingIds = new int[] { Convert.ToInt32(scopeVal) };
        }

        if (string.IsNullOrEmpty(title) || string.IsNullOrEmpty(content))
        {
            Page.ClientScript.RegisterStartupScript(this.GetType(), "toast", "showToast('请填写标题和内容','error');", true);
            return;
        }

        if (!string.IsNullOrEmpty(hfNoticeId.Value))
        {
            int id = Convert.ToInt32(hfNoticeId.Value);
            if (NoticeBLL.UpdateNotice(id, title, content, category, isTop, buildingIds))
            {
                ClearForm();
                LoadNotices();
                Page.ClientScript.RegisterStartupScript(this.GetType(), "toast", "showToast('修改成功','success');", true);
            }
        }
        else
        {
            if (NoticeBLL.AddNotice(title, content, category, isTop, status, adminId, buildingIds))
            {
                ClearForm();
                LoadNotices();
                string msg = status == 1 ? "发布成功" : "已保存为草稿";
                Page.ClientScript.RegisterStartupScript(this.GetType(), "toast", "showToast('" + msg + "','success');", true);
            }
        }
    }

    protected void btnCancelEdit_Click(object sender, EventArgs e)
    {
        ClearForm();
    }

    private void ClearForm()
    {
        hfNoticeId.Value = "";
        txtTitle.Text = "";
        txtContent.Text = "";
        ddlScope.SelectedIndex = 0;
        ddlCategory.SelectedIndex = 0;
        chkIsTop.Checked = false;
        chkSendNow.Checked = true;
    }

    protected void rptNotices_ItemCommand(object source, RepeaterCommandEventArgs e)
    {
        int id = Convert.ToInt32(e.CommandArgument);

        if (e.CommandName == "EditNotice")
        {
            DataTable dt = NoticeBLL.GetNoticeById(id);
            if (dt.Rows.Count > 0)
            {
                DataRow row = dt.Rows[0];
                hfNoticeId.Value = id.ToString();
                txtTitle.Text = row["Title"].ToString();
                txtContent.Text = row["Content"].ToString();
                // 加载通知范围
                DataTable scopeDt = NoticeBLL.GetNoticeScope(id);
                if (scopeDt.Rows.Count > 0)
                    ddlScope.SelectedValue = scopeDt.Rows[0]["BuildingId"].ToString();
                else
                    ddlScope.SelectedIndex = 0;
                ddlCategory.SelectedValue = row["Category"].ToString();
                chkIsTop.Checked = Convert.ToInt32(row["IsTop"]) == 1;
                chkSendNow.Checked = Convert.ToInt32(row["Status"]) == 1;
            }
        }
        else if (e.CommandName == "WithdrawNotice")
        {
            if (NoticeBLL.WithdrawNotice(id))
            {
                LoadNotices();
                Page.ClientScript.RegisterStartupScript(this.GetType(), "toast", "showToast('已撤回','success');", true);
            }
        }
        else if (e.CommandName == "PublishNotice")
        {
            if (NoticeBLL.PublishNotice(id))
            {
                LoadNotices();
                Page.ClientScript.RegisterStartupScript(this.GetType(), "toast", "showToast('已发布','success');", true);
            }
        }
        else if (e.CommandName == "DeleteNotice")
        {
            if (NoticeBLL.DeleteNotice(id))
            {
                LoadNotices();
                Page.ClientScript.RegisterStartupScript(this.GetType(), "toast", "showToast('已删除','success');", true);
            }
        }
    }

    protected void btnTabAll_Click(object sender, EventArgs e)
    {
        CurrentFilter = -1;
        CurrentPage = 1;
        SetActiveTab(0);
        LoadNotices();
    }

    protected void btnTabPublished_Click(object sender, EventArgs e)
    {
        CurrentFilter = 1;
        CurrentPage = 1;
        SetActiveTab(1);
        LoadNotices();
    }

    protected void btnTabDraft_Click(object sender, EventArgs e)
    {
        CurrentFilter = 0;
        CurrentPage = 1;
        SetActiveTab(2);
        LoadNotices();
    }

    private void SetActiveTab(int index)
    {
        btnTabAll.CssClass = "tab-btn-sm" + (index == 0 ? " active" : "");
        btnTabPublished.CssClass = "tab-btn-sm" + (index == 1 ? " active" : "");
        btnTabDraft.CssClass = "tab-btn-sm" + (index == 2 ? " active" : "");
    }

    protected void btnPrev_Click(object sender, EventArgs e)
    {
        if (CurrentPage > 1)
        {
            CurrentPage--;
            LoadNotices();
        }
    }

    protected void btnNext_Click(object sender, EventArgs e)
    {
        CurrentPage++;
        LoadNotices();
    }

    protected string GetScopeText(object noticeIdObj)
    {
        int noticeId = Convert.ToInt32(noticeIdObj);
        return NoticeBLL.GetNoticeScopeText(noticeId);
    }

    protected string GetCategoryText(object category)
    {
        int c = Convert.ToInt32(category);
        switch (c)
        {
            case 1: return "行政通知";
            case 2: return "安全警示";
            case 3: return "生活服务";
            case 4: return "活动资讯";
            default: return "";
        }
    }

    protected string GetStatusClass(object status)
    {
        int s = Convert.ToInt32(status);
        switch (s)
        {
            case 0: return "draft";
            case 1: return "published";
            case 2: return "withdrawn";
            default: return "";
        }
    }

    protected string GetStatusText(object status)
    {
        int s = Convert.ToInt32(status);
        switch (s)
        {
            case 0: return "草稿";
            case 1: return "已发布";
            case 2: return "已撤回";
            default: return "";
        }
    }

    protected override void RaisePostBackEvent(IPostBackEventHandler sourceControl, string eventArgument)
    {
        if (!string.IsNullOrEmpty(Request.Form["NoticePageBtn"]))
        {
            CurrentPage = Convert.ToInt32(Request.Form["NoticePageBtn"]);
            LoadNotices();
            return;
        }

        base.RaisePostBackEvent(sourceControl, eventArgument);
    }
}
