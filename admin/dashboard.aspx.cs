using System;
using System.Data;
using System.Globalization;
using System.Web;
using System.Web.UI;

public partial class admin_dashboard : System.Web.UI.Page
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
            LoadStatistics();
            LoadTrendChart();
            LoadOccupancy();
            LoadQuickActions();
        }
    }

    private void LoadStatistics()
    {
        litCurrentDate.Text = DateTime.Now.ToString("yyyy年M月d日");

        int totalRooms = DormBLL.GetTotalRooms();
        int totalStudents = DormBLL.GetTotalStudents();
        int totalBeds = DormBLL.GetTotalBeds();
        int availableBeds = DormBLL.GetAvailableBeds();
        int todayRepair = RepairBLL.GetTodayRepairCount();
        int pendingRepair = RepairBLL.GetPendingRepairCount();

        litTotalRooms.Text = totalRooms.ToString("N0");
        litTotalStudents.Text = totalStudents.ToString("N0");
        litAvailableBeds.Text = availableBeds.ToString("N0");
        litTodayRepair.Text = todayRepair.ToString();
        litPendingRepair.Text = pendingRepair.ToString();

        if (totalBeds > 0)
        {
            double rate = Math.Round((double)(totalBeds - availableBeds) / totalBeds * 100, 1);
            litOccupancyRate.Text = rate + "%";
        }
        else
        {
            litOccupancyRate.Text = "0%";
        }
    }

    private void LoadTrendChart()
    {
        DataTable dt = RepairBLL.GetRepairTrendByDay(7);

        // 填充最近7天的数据（含0天）
        DataTable trendData = new DataTable();
        trendData.Columns.Add("RepairDate", typeof(DateTime));
        trendData.Columns.Add("Count", typeof(int));
        trendData.Columns.Add("DayLabel", typeof(string));

        DateTime today = DateTime.Today;
        for (int i = 6; i >= 0; i--)
        {
            DateTime date = today.AddDays(-i);
            string dayLabel = GetDayLabel(date);
            int count = 0;

            foreach (DataRow row in dt.Rows)
            {
                DateTime repairDate = Convert.ToDateTime(row["RepairDate"]);
                if (repairDate.Date == date.Date)
                {
                    count = Convert.ToInt32(row["Count"]);
                    break;
                }
            }

            trendData.Rows.Add(date, count, dayLabel);
        }

        rptTrendChart.DataSource = trendData;
        rptTrendChart.DataBind();

        // 计算趋势摘要
        int thisWeekTotal = 0;
        foreach (DataRow row in trendData.Rows)
        {
            thisWeekTotal += Convert.ToInt32(row["Count"]);
        }
        litTrendSummary.Text = "本周共 " + thisWeekTotal + " 条报修记录";
    }

    private string GetDayLabel(DateTime date)
    {
        if (date.Date == DateTime.Today) return "今天";
        if (date.Date == DateTime.Today.AddDays(-1)) return "昨天";

        string[] dayNames = { "周日", "周一", "周二", "周三", "周四", "周五", "周六" };
        return dayNames[(int)date.DayOfWeek];
    }

    protected string GetBarHeight(object countObj)
    {
        int count = Convert.ToInt32(countObj);
        if (count == 0) return "2";

        // 获取最大值来计算比例
        int maxCount = 1;
        DataTable dt = rptTrendChart.DataSource as DataTable;
        if (dt != null)
        {
            foreach (DataRow row in dt.Rows)
            {
                int c = Convert.ToInt32(row["Count"]);
                if (c > maxCount) maxCount = c;
            }
        }
        int height = (int)Math.Round((double)count / maxCount * 100);
        return Math.Max(height, 5).ToString();
    }

    protected string GetBarColor(object countObj)
    {
        int count = Convert.ToInt32(countObj);
        if (count == 0) return "background:rgba(73,234,206,0.1);";
        if (count >= 20) return "background:rgba(73,234,206,0.6);";
        if (count >= 10) return "background:rgba(73,234,206,0.4);";
        return "background:rgba(73,234,206,0.25);";
    }

    private void LoadOccupancy()
    {
        DataTable dt = DormBLL.GetBuildingOccupancy();

        // 添加入住率列
        dt.Columns.Add("OccupancyRate", typeof(double));
        foreach (DataRow row in dt.Rows)
        {
            int total = Convert.ToInt32(row["TotalBeds"]);
            int occupied = Convert.ToInt32(row["OccupiedBeds"]);
            row["OccupancyRate"] = total > 0 ? Math.Round((double)occupied / total * 100, 0) : 0;
        }

        rptOccupancy.DataSource = dt;
        rptOccupancy.DataBind();
    }

    protected string GetOccupancyColor(object rateObj)
    {
        double rate = Convert.ToDouble(rateObj);
        if (rate >= 90) return "background:var(--primary);";
        if (rate >= 70) return "background:var(--primary); opacity:0.7;";
        return "background:#b58900;";
    }

    private void LoadQuickActions()
    {
        int pendingRepair = RepairBLL.GetPendingRepairCount();
        int availableBeds = DormBLL.GetAvailableBeds();

        litPendingCount.Text = pendingRepair.ToString();
        litQuickBeds.Text = availableBeds.ToString();
    }
}
