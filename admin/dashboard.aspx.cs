using System;
using System.Web;
using System.Web.UI;

public partial class admin_dashboard : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        currentDate.InnerText = DateTime.Now.ToString("yyyy\u5E74M\u6708d\u65E5");
    }
}