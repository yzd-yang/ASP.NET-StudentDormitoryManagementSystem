using System;
using System.Data;
using System.Web;
using System.Web.UI;

public partial class admin_MasterPage : System.Web.UI.MasterPage
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (Session["AdminId"] == null)
        {
            Response.Redirect("/admin/login.aspx");
            return;
        }
        string role = Session["Role"] != null ? Session["Role"].ToString() : "";
        if (role != "admin")
        {
            Response.Redirect("/admin/login.aspx");
        }

        if (!IsPostBack)
        {
            LoadNotifications();
        }
    }

    private void LoadNotifications()
    {
        DataTable dt = new DataTable();
        dt.Columns.Add("Icon", typeof(string));
        dt.Columns.Add("IconClass", typeof(string));
        dt.Columns.Add("Title", typeof(string));
        dt.Columns.Add("Time", typeof(string));
        dt.Columns.Add("Link", typeof(string));

        // 获取待处理报修
        DataTable repairs = DBHelper.GetDataTable(
            "SELECT ro.OrderNo, ro.Description, ro.CreateTime, s.Name as StudentName FROM RepairOrders ro JOIN Students s ON ro.StudentId=s.Id WHERE ro.Status=1 ORDER BY ro.CreateTime DESC LIMIT 5");

        foreach (DataRow row in repairs.Rows)
        {
            string desc = row["Description"].ToString();
            if (desc.Length > 20) desc = desc.Substring(0, 20) + "...";
            string time = Convert.ToDateTime(row["CreateTime"]).ToString("MM-dd HH:mm");
            dt.Rows.Add("build", "repair", "新报修: " + row["StudentName"] + " - " + desc, time, "/admin/repair.aspx");
        }

        // 获取最近公告
        DataTable notices = DBHelper.GetDataTable(
            "SELECT Title, PublishTime FROM Notices WHERE Status=1 ORDER BY PublishTime DESC LIMIT 3");

        foreach (DataRow row in notices.Rows)
        {
            string time = row["PublishTime"] != DBNull.Value ? Convert.ToDateTime(row["PublishTime"]).ToString("MM-dd HH:mm") : "";
            dt.Rows.Add("campaign", "notice", "公告: " + row["Title"].ToString(), time, "/admin/notice.aspx");
        }

        int totalCount = dt.Rows.Count;

        if (totalCount > 0)
        {
            notifBadge.InnerHtml = totalCount.ToString();
            notifBadge.Attributes["class"] = "admin-header-badge";
            rptNotifications.DataSource = dt;
            rptNotifications.DataBind();
        }
        else
        {
            notifBadge.Attributes["class"] = "admin-header-badge hide";
            rptNotifications.DataSource = null;
            rptNotifications.DataBind();
        }
    }

    protected void btnLogout_Click(object sender, EventArgs e)
    {
        Session.Clear();
        Session.Abandon();
        Response.Redirect("/admin/login.aspx");
    }

    protected string IsActive(string page)
    {
        string currentPage = Request.Url.Segments[Request.Url.Segments.Length - 1].Replace(".aspx", "");
        return currentPage.Equals(page, StringComparison.OrdinalIgnoreCase) ? "active" : "";
    }

    protected string GetAdminName()
    {
        if (Session["AdminName"] != null) return Session["AdminName"].ToString();
        return "管理员";
    }

    protected string GetAdminRoleName()
    {
        if (Session["AdminRoleName"] != null) return Session["AdminRoleName"].ToString();
        return "系统管理员";
    }

    protected string GetAdminInitial()
    {
        string name = GetAdminName();
        if (!string.IsNullOrEmpty(name) && name.Length > 0)
        {
            return name.Substring(name.Length - 1);
        }
        return "管";
    }
}