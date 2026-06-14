using System;
using System.Data;
using System.Security.Cryptography;
using System.Text;
using MySql.Data.MySqlClient;

public class UserBLL
{
    public static string GetMD5(string input)
    {
        using (MD5 md5 = MD5.Create())
        {
            byte[] inputBytes = Encoding.UTF8.GetBytes(input);
            byte[] hashBytes = md5.ComputeHash(inputBytes);
            StringBuilder sb = new StringBuilder();
            for (int i = 0; i < hashBytes.Length; i++)
            {
                sb.Append(hashBytes[i].ToString("x2"));
            }
            return sb.ToString();
        }
    }

    public static DataTable Login(string userNo, string password)
    {
        string md5Pwd = GetMD5(password);

        string sql = "SELECT Id, StudentNo as UserNo, Name, 'student' as Role FROM Students WHERE StudentNo=@UserNo AND Password=@Password AND Status=1 "
                   + "UNION ALL "
                   + "SELECT Id, AdminNo as UserNo, Name, 'admin' as Role FROM Admins WHERE AdminNo=@UserNo AND Password=@Password AND Status=1";

        MySqlParameter[] parameters = new MySqlParameter[]
        {
            new MySqlParameter("@UserNo", userNo),
            new MySqlParameter("@Password", md5Pwd)
        };

        return DBHelper.GetDataTable(sql, parameters);
    }

    public static DataTable LoginStudent(string userNo, string password)
    {
        string md5Pwd = GetMD5(password);
        string sql = "SELECT Id, StudentNo as UserNo, Name, 'student' as Role FROM Students WHERE StudentNo=@UserNo AND Password=@Password AND Status=1";
        MySqlParameter[] parameters = new MySqlParameter[]
        {
            new MySqlParameter("@UserNo", userNo),
            new MySqlParameter("@Password", md5Pwd)
        };
        return DBHelper.GetDataTable(sql, parameters);
    }

    public static DataTable LoginAdmin(string userNo, string password)
    {
        string md5Pwd = GetMD5(password);
        string sql = "SELECT Id, AdminNo as UserNo, Name, Role, 'admin' as RoleType FROM Admins WHERE AdminNo=@UserNo AND Password=@Password AND Status=1";
        MySqlParameter[] parameters = new MySqlParameter[]
        {
            new MySqlParameter("@UserNo", userNo),
            new MySqlParameter("@Password", md5Pwd)
        };
        return DBHelper.GetDataTable(sql, parameters);
    }

    public static bool RegisterStudent(string studentNo, string name, string phone, string password)
    {
        string checkSql = "SELECT COUNT(*) FROM Students WHERE StudentNo=@StudentNo";
        MySqlParameter[] checkParams = new MySqlParameter[] { new MySqlParameter("@StudentNo", studentNo) };
        object count = DBHelper.ExecuteScalar(checkSql, checkParams);
        if (count != null && Convert.ToInt32(count) > 0)
        {
            return false;
        }

        string sql = "INSERT INTO Students (StudentNo, Name, Phone, Password) VALUES (@StudentNo, @Name, @Phone, @Password)";
        MySqlParameter[] parameters = new MySqlParameter[]
        {
            new MySqlParameter("@StudentNo", studentNo),
            new MySqlParameter("@Name", name),
            new MySqlParameter("@Phone", phone),
            new MySqlParameter("@Password", GetMD5(password))
        };

        return DBHelper.ExecuteNonQuery(sql, parameters) > 0;
    }

    public static DataTable GetStudentById(int studentId)
    {
        string sql = "SELECT s.*, c.CollegeName, d.MajorName FROM Students s LEFT JOIN Departments d ON s.DepartmentId=d.Id LEFT JOIN Colleges c ON d.CollegeId=c.Id WHERE s.Id=@Id";
        MySqlParameter[] parameters = new MySqlParameter[] { new MySqlParameter("@Id", studentId) };
        return DBHelper.GetDataTable(sql, parameters);
    }

    public static bool UpdateStudentInfo(int studentId, string email, string emergencyContact, string emergencyRelation, string emergencyPhone, int departmentId, string grade, string className)
    {
        string sql = "UPDATE Students SET Email=@Email, EmergencyContact=@EmergencyContact, EmergencyRelation=@EmergencyRelation, EmergencyPhone=@EmergencyPhone, DepartmentId=@DepartmentId, Grade=@Grade, ClassName=@ClassName WHERE Id=@Id";
        MySqlParameter[] parameters = new MySqlParameter[]
        {
            new MySqlParameter("@Email", email),
            new MySqlParameter("@EmergencyContact", emergencyContact),
            new MySqlParameter("@EmergencyRelation", emergencyRelation),
            new MySqlParameter("@EmergencyPhone", emergencyPhone),
            new MySqlParameter("@DepartmentId", departmentId > 0 ? (object)departmentId : DBNull.Value),
            new MySqlParameter("@Grade", grade),
            new MySqlParameter("@ClassName", className),
            new MySqlParameter("@Id", studentId)
        };

        return DBHelper.ExecuteNonQuery(sql, parameters) > 0;
    }

    public static DataTable GetAdminById(int adminId)
    {
        string sql = "SELECT a.*, CASE a.Role WHEN 1 THEN '\u8D85\u7EA7\u7BA1\u7406\u5458' WHEN 2 THEN '\u5BBF\u7BA1' WHEN 3 THEN '\u540E\u52E4' END as RoleName FROM Admins a WHERE a.Id=@Id";
        MySqlParameter[] parameters = new MySqlParameter[] { new MySqlParameter("@Id", adminId) };
        return DBHelper.GetDataTable(sql, parameters);
    }

    public static DataTable VerifyStudent(string studentNo, string phone)
    {
        string sql = "SELECT Id, StudentNo, Name FROM Students WHERE StudentNo=@StudentNo AND Phone=@Phone AND Status=1";
        MySqlParameter[] parameters = new MySqlParameter[]
        {
            new MySqlParameter("@StudentNo", studentNo),
            new MySqlParameter("@Phone", phone)
        };
        return DBHelper.GetDataTable(sql, parameters);
    }

    public static bool ResetStudentPassword(int studentId, string newPassword)
    {
        string sql = "UPDATE Students SET Password=@Password WHERE Id=@Id";
        MySqlParameter[] parameters = new MySqlParameter[]
        {
            new MySqlParameter("@Password", GetMD5(newPassword)),
            new MySqlParameter("@Id", studentId)
        };
        return DBHelper.ExecuteNonQuery(sql, parameters) > 0;
    }
}