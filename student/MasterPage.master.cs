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
        return currentPage.Equals(page, StringComparison.OrdinalIgnoreCase) ? "active" : "";
    }
}