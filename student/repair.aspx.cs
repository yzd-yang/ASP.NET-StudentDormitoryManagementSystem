using System;
using System.Data;
using System.IO;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class student_repair : System.Web.UI.Page
{
    private int studentId;

    protected void Page_Load(object sender, EventArgs e)
    {
        if (Session["UserId"] == null)
        {
            Response.Redirect("/login.aspx");
            return;
        }

        studentId = Convert.ToInt32(Session["UserId"]);

        if (!IsPostBack)
        {
            LoadStudentInfo();
            LoadRepairOrders();

            // 支持 ?tab=list 参数直接打开"我的报修"标签
            if (Request.QueryString["tab"] == "list")
            {
                ScriptManager.RegisterStartupScript(this, GetType(), "switchToList", "switchTab('list');", true);
            }
        }
    }

    private void LoadStudentInfo()
    {
        // 获取学生宿舍信息
        DataTable dt = DormBLL.GetStudentDormInfo(studentId);
        if (dt != null && dt.Rows.Count > 0)
        {
            DataRow row = dt.Rows[0];
            string building = row["BuildingName"] != DBNull.Value ? row["BuildingName"].ToString() : "";
            string roomNo = row["RoomNo"] != DBNull.Value ? row["RoomNo"].ToString() : "";

            if (!string.IsNullOrEmpty(building))
            {
                litDormInfo.Text = building + " " + roomNo;
                hfRoomId.Value = GetStudentRoomId().ToString();
            }
            else
            {
                litDormInfo.Text = "未分配宿舍";
                hfRoomId.Value = "0";
            }

            // 默认填入手机号
            string phone = Session["UserNo"] != DBNull.Value ? Session["UserNo"].ToString() : "";
            DataTable studentDt = UserBLL.GetStudentById(studentId);
            if (studentDt != null && studentDt.Rows.Count > 0)
            {
                string p = studentDt.Rows[0]["Phone"] != DBNull.Value ? studentDt.Rows[0]["Phone"].ToString() : "";
                if (!string.IsNullOrEmpty(p)) txtContactPhone.Text = p;
            }
        }
    }

    private int GetStudentRoomId()
    {
        string sql = "SELECT r.Id FROM Beds bed JOIN Rooms r ON bed.RoomId = r.Id WHERE bed.StudentId = @StudentId AND bed.Status = 1";
        object result = DBHelper.ExecuteScalar(sql, new MySql.Data.MySqlClient.MySqlParameter[] {
            new MySql.Data.MySqlClient.MySqlParameter("@StudentId", studentId)
        });
        return result != null ? Convert.ToInt32(result) : 0;
    }

    private void LoadRepairOrders()
    {
        DataTable dt = RepairBLL.GetStudentRepairOrders(studentId);
        if (dt != null && dt.Rows.Count > 0)
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
    }

    protected void rptRepairs_ItemCommand(object source, RepeaterCommandEventArgs e)
    {
        if (e.CommandName == "CancelRepair")
        {
            int orderId = Convert.ToInt32(e.CommandArgument);
            if (RepairBLL.DeleteRepairOrder(orderId, studentId))
            {
                ShowToast("已取消报修申请", "success");
                LoadRepairOrders();
                ScriptManager.RegisterStartupScript(this, GetType(), "switchToList", "switchTab('list');", true);
            }
            else
            {
                ShowToast("取消失败，只有待处理的申请可取消", "error");
            }
        }
    }

    protected void btnSubmit_Click(object sender, EventArgs e)
    {
        int repairType = Convert.ToInt32(ddlRepairType.SelectedValue);
        string description = txtDescription.Text.Trim();
        string expectTime = txtExpectTime.Text;
        string contactPhone = txtContactPhone.Text.Trim();

        // 校验
        if (string.IsNullOrEmpty(description))
        {
            ShowToast("请填写故障描述", "error");
            return;
        }
        if (string.IsNullOrEmpty(contactPhone))
        {
            ShowToast("请填写联系电话", "error");
            return;
        }

        int roomId = 0;
        int.TryParse(hfRoomId.Value, out roomId);
        if (roomId <= 0)
        {
            ShowToast("您尚未分配宿舍，无法报修", "error");
            return;
        }

        // 处理图片上传
        string photoPaths = "";
        if (fuPhotos.HasFiles)
        {
            string uploadDir = Server.MapPath("~/Uploads/repair/images/");
            if (!Directory.Exists(uploadDir))
                Directory.CreateDirectory(uploadDir);

            var paths = new System.Collections.Generic.List<string>();
            foreach (HttpPostedFile file in fuPhotos.PostedFiles)
            {
                if (file.ContentLength > 5 * 1024 * 1024)
                {
                    ShowToast("单张图片不能超过5MB", "error");
                    return;
                }
                string ext = Path.GetExtension(file.FileName).ToLower();
                if (ext != ".jpg" && ext != ".jpeg" && ext != ".png")
                {
                    ShowToast("仅支持 JPG/PNG 格式", "error");
                    return;
                }

                string fileName = studentId + "_" + DateTime.Now.ToString("yyyyMMddHHmmss") + "_" + Guid.NewGuid().ToString("N").Substring(0, 6) + ext;
                string savePath = Path.Combine(uploadDir, fileName);
                file.SaveAs(savePath);
                paths.Add("/Uploads/repair/images/" + fileName);
            }
            photoPaths = string.Join(",", paths);
        }

        // 创建报修单
        bool ok = RepairBLL.CreateRepairOrderWithPhotos(studentId, roomId, repairType, description, expectTime, contactPhone, photoPaths);
        if (ok)
        {
            ShowToast("报修申请提交成功！", "success");
            ClearForm();
            LoadRepairOrders();
            // 切换到"我的报修"标签
            ScriptManager.RegisterStartupScript(this, GetType(), "switchTab", "switchTab('list');", true);
        }
        else
        {
            ShowToast("提交失败，请重试", "error");
        }
    }

    private void ClearForm()
    {
        ddlRepairType.SelectedIndex = 0;
        txtDescription.Text = "";
        txtExpectTime.Text = "";
    }

    protected string GetStatusCssClass(object status)
    {
        int s = Convert.ToInt32(status);
        switch (s)
        {
            case 1: return "status-pending";
            case 2: return "status-processing";
            case 3: return "status-completed";
            case 4: return "status-pending";
            default: return "";
        }
    }

    protected string GetStatusBorderClass(object status)
    {
        int s = Convert.ToInt32(status);
        switch (s)
        {
            case 1: return "border-left:4px solid #fbc02d;";
            case 2: return "border-left:4px solid #3b82f6;";
            case 3: return "border-left:4px solid #49EACE;";
            case 4: return "border-left:4px solid #fbc02d;";
            default: return "";
        }
    }

    protected string GetRepairIcon(object repairType)
    {
        int t = Convert.ToInt32(repairType);
        switch (t)
        {
            case 1: return "water_drop";
            case 2: return "chair";
            case 3: return "router";
            default: return "handyman";
        }
    }

    protected string GetRepairIconColor(object repairType)
        {
        int t = Convert.ToInt32(repairType);
        switch (t)
        {
            case 1: return "color:var(--primary);";
            case 2: return "color:#3b82f6;";
            case 3: return "color:#b58900;";
            default: return "color:var(--on-surface-variant);";
        }
    }

    protected string GetPhotosHtml(object photosObj)
    {
        if (photosObj == null || photosObj == DBNull.Value) return "";
        string photos = photosObj.ToString();
        if (string.IsNullOrEmpty(photos)) return "";

        string[] paths = photos.Split(',');
        string html = "<div style='display:flex;gap:8px;margin-top:8px;flex-wrap:wrap;'>";
        foreach (string path in paths)
        {
            if (!string.IsNullOrEmpty(path.Trim()))
                html += "<img src='" + path.Trim() + "' style='width:60px;height:60px;object-fit:cover;border-radius:8px;cursor:pointer;' onclick='window.open(this.src)' />";
        }
        html += "</div>";
        return html;
    }

    private void ShowToast(string msg, string type)
    {
        ScriptManager.RegisterStartupScript(this, GetType(), "toast" + Guid.NewGuid(),
            "showToast('" + msg + "','" + type + "');", true);
    }
}
