using System;
using System.Web;
using System.Web.UI;

public partial class student_MasterPage : System.Web.UI.MasterPage
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (Session["UserId"] == null)
        {
            Response.Redirect("/login.aspx");
            return;
        }
        string role = Session["Role"] != null ? Session["Role"].ToString() : "";
        if (role != "student")
        {
            Response.Redirect("/login.aspx");
        }
    }

    protected void btnLogout_Click(object sender, EventArgs e)
    {
        Session.Clear();
        Session.Abandon();
        Response.Redirect("/login.aspx");
    }

    protected string IsActive(string page)
    {
        string currentPage = Request.Url.Segments[Request.Url.Segments.Length - 1].Replace(".aspx", "");
        if (page.Equals("batch", StringComparison.OrdinalIgnoreCase) && currentPage.Equals("grab-dorm", StringComparison.OrdinalIgnoreCase))
        {
            return "active";
        }
        return currentPage.Equals(page, StringComparison.OrdinalIgnoreCase) ? "active" : "";
    }

    protected string GetUserName()
    {
        if (Session["UserName"] != null) return Session["UserName"].ToString();
        return "同学";
    }

    protected string GetUserInitial()
    {
        string name = GetUserName();
        if (!string.IsNullOrEmpty(name) && name.Length > 0)
        {
            return name.Substring(name.Length - 1);
        }
        return "同";
    }
}
