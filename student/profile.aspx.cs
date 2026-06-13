using System;
using System.Data;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class student_profile : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (Session["UserId"] == null)
        {
            Response.Redirect("/login.aspx");
            return;
        }

        if (!IsPostBack)
        {
            LoadProfile();
            LoadDormInfo();
        }
    }

    private void LoadProfile()
    {
        int studentId = Convert.ToInt32(Session["UserId"]);
        DataTable dt = UserBLL.GetStudentById(studentId);
        if (dt == null || dt.Rows.Count == 0) return;

        DataRow row = dt.Rows[0];
        string name = row["Name"].ToString();
        litName.Text = name;
        litAvatar.Text = name.Length > 0 ? name.Substring(name.Length - 1) : "同";
        litStudentNo.Text = row["StudentNo"].ToString();
        litPhone.Text = MaskPhone(row["Phone"].ToString());

        txtEmail.Text = row["Email"] != DBNull.Value ? row["Email"].ToString() : "";
        txtEmergencyContact.Text = row["EmergencyContact"] != DBNull.Value ? row["EmergencyContact"].ToString() : "";
        if (row["EmergencyRelation"] != DBNull.Value && !string.IsNullOrEmpty(row["EmergencyRelation"].ToString()))
        {
            string contact = txtEmergencyContact.Text;
            string relation = row["EmergencyRelation"].ToString();
            if (!string.IsNullOrEmpty(contact))
                txtEmergencyContact.Text = contact + " (" + relation + ")";
        }
        txtEmergencyPhone.Text = row["EmergencyPhone"] != DBNull.Value ? MaskPhone(row["EmergencyPhone"].ToString()) : "";

        txtGrade.Text = row["Grade"] != DBNull.Value ? row["Grade"].ToString() : "";

        LoadCollegeList();
        string college = row["College"] != DBNull.Value ? row["College"].ToString() : "";
        if (!string.IsNullOrEmpty(college))
        {
            ddlCollege.SelectedValue = college;
            LoadMajorList(college);
            string major = row["Major"] != DBNull.Value ? row["Major"].ToString() : "";
            if (!string.IsNullOrEmpty(major) && ddlMajor.Items.FindByValue(major) != null)
                ddlMajor.SelectedValue = major;
        }
        else
        {
            LoadMajorList("");
        }
    }

    private void LoadDormInfo()
    {
        int studentId = Convert.ToInt32(Session["UserId"]);
        DataTable dt = DormBLL.GetStudentDormInfo(studentId);
        if (dt != null && dt.Rows.Count > 0)
        {
            DataRow row = dt.Rows[0];
            string campus = row["Campus"] != DBNull.Value ? row["Campus"].ToString() : "";
            string building = row["BuildingName"] != DBNull.Value ? row["BuildingName"].ToString() : "";
            string roomNo = row["RoomNo"] != DBNull.Value ? row["RoomNo"].ToString() : "";

            if (!string.IsNullOrEmpty(building))
            {
                string dormText = campus + " " + building + " " + roomNo;
                litDorm.Text = dormText;
                litStatus.Text = "已分配";
                spanStatus.Attributes["class"] = "status-badge allocated";
                litStatusDorm.Text = dormText;
            }
            else
            {
                litDorm.Text = "未分配";
                litStatus.Text = "未分配";
                spanStatus.Attributes["class"] = "status-badge unallocated";
                litStatusDorm.Text = "等待分配";
            }
        }
        else
        {
            litDorm.Text = "未分配";
            litStatus.Text = "未分配";
            spanStatus.Attributes["class"] = "status-badge unallocated";
            litStatusDorm.Text = "等待分配";
        }

        litSemester.Text = DateTime.Now.Year + " 学年";
    }

    private void LoadCollegeList()
    {
        DataTable dt = DormBLL.GetColleges();
        ddlCollege.Items.Clear();
        ddlCollege.Items.Add(new ListItem("-- 请选择学院 --", ""));
        if (dt != null)
        {
            foreach (DataRow row in dt.Rows)
                ddlCollege.Items.Add(new ListItem(row["CollegeName"].ToString(), row["CollegeName"].ToString()));
        }
    }

    private void LoadMajorList(string college)
    {
        ddlMajor.Items.Clear();
        ddlMajor.Items.Add(new ListItem("-- 请选择专业 --", ""));
        if (!string.IsNullOrEmpty(college))
        {
            DataTable dt = DormBLL.GetMajorsByCollege(college);
            if (dt != null)
            {
                foreach (DataRow row in dt.Rows)
                    ddlMajor.Items.Add(new ListItem(row["MajorName"].ToString(), row["MajorName"].ToString()));
            }
        }
    }

    protected void ddlCollege_Changed(object sender, EventArgs e)
    {
        LoadMajorList(ddlCollege.SelectedValue);
    }

    protected void btnSave_Click(object sender, EventArgs e)
    {
        int studentId = Convert.ToInt32(Session["UserId"]);

        string email = txtEmail.Text.Trim();
        string contactRaw = txtEmergencyContact.Text.Trim();
        string emergencyPhone = txtEmergencyPhone.Text.Trim();

        string emergencyContact = contactRaw;
        string emergencyRelation = "";
        int parenIdx = contactRaw.IndexOf('(');
        if (parenIdx > 0)
        {
            int parenEnd = contactRaw.IndexOf(')', parenIdx);
            if (parenEnd > parenIdx)
            {
                emergencyContact = contactRaw.Substring(0, parenIdx).Trim();
                emergencyRelation = contactRaw.Substring(parenIdx + 1, parenEnd - parenIdx - 1).Trim();
            }
        }

        string college = ddlCollege.SelectedValue;
        string major = ddlMajor.SelectedValue;
        string grade = txtGrade.Text.Trim();

        bool ok = UserBLL.UpdateStudentInfo(studentId, email, emergencyContact, emergencyRelation, emergencyPhone, college, major, grade);
        if (ok)
        {
            ScriptManager.RegisterStartupScript(this, GetType(), "toast", "showToast('保存成功','success'); exitEdit();", true);
            LoadProfile();
        }
        else
        {
            ScriptManager.RegisterStartupScript(this, GetType(), "toast", "showToast('保存失败','error');", true);
        }
    }

    protected void btnCancel_Click(object sender, EventArgs e)
    {
        LoadProfile();
        ScriptManager.RegisterStartupScript(this, GetType(), "exit", "exitEdit();", true);
    }

    private string MaskPhone(string phone)
    {
        if (string.IsNullOrEmpty(phone) || phone.Length < 7) return phone;
        return phone.Substring(0, 3) + "****" + phone.Substring(phone.Length - 4);
    }
}
