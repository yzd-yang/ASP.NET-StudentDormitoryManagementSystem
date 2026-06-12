using System;
using System.Data;
using System.Security.Cryptography;
using System.Text;
using MySql.Data.MySqlClient;

public class AdminBLL
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

    public static DataTable GetAdminList(string keyword = "", int role = 0, int status = -1)
    {
        string sql = @"SELECT Id, AdminNo, Name, Phone, Role, Status, CreateTime,
                       CASE Role WHEN 1 THEN '超级管理员' WHEN 2 THEN '宿管' WHEN 3 THEN '后勤' END as RoleName
                       FROM Admins WHERE 1=1";

        var paramList = new System.Collections.Generic.List<MySqlParameter>();

        if (!string.IsNullOrEmpty(keyword))
        {
            sql += " AND (AdminNo LIKE @Keyword OR Name LIKE @Keyword OR Phone LIKE @Keyword)";
            paramList.Add(new MySqlParameter("@Keyword", "%" + keyword + "%"));
        }
        if (role > 0)
        {
            sql += " AND Role=@Role";
            paramList.Add(new MySqlParameter("@Role", role));
        }
        if (status >= 0)
        {
            sql += " AND Status=@Status";
            paramList.Add(new MySqlParameter("@Status", status));
        }

        sql += " ORDER BY AdminNo";
        return DBHelper.GetDataTable(sql, paramList.ToArray());
    }

    public static bool AddAdmin(string adminNo, string name, string phone, string password, int role)
    {
        string checkSql = "SELECT COUNT(*) FROM Admins WHERE AdminNo=@AdminNo";
        object count = DBHelper.ExecuteScalar(checkSql, new MySqlParameter[] { new MySqlParameter("@AdminNo", adminNo) });
        if (count != null && Convert.ToInt32(count) > 0) return false;

        string sql = "INSERT INTO Admins (AdminNo, Name, Phone, Password, Role) VALUES (@AdminNo, @Name, @Phone, @Password, @Role)";
        MySqlParameter[] parameters = new MySqlParameter[]
        {
            new MySqlParameter("@AdminNo", adminNo),
            new MySqlParameter("@Name", name),
            new MySqlParameter("@Phone", phone),
            new MySqlParameter("@Password", GetMD5(password)),
            new MySqlParameter("@Role", role)
        };
        return DBHelper.ExecuteNonQuery(sql, parameters) > 0;
    }

    public static bool UpdateAdmin(int id, string name, string phone, int role, int status)
    {
        string sql = "UPDATE Admins SET Name=@Name, Phone=@Phone, Role=@Role, Status=@Status WHERE Id=@Id";
        MySqlParameter[] parameters = new MySqlParameter[]
        {
            new MySqlParameter("@Name", name),
            new MySqlParameter("@Phone", phone),
            new MySqlParameter("@Role", role),
            new MySqlParameter("@Status", status),
            new MySqlParameter("@Id", id)
        };
        return DBHelper.ExecuteNonQuery(sql, parameters) > 0;
    }

    public static bool ResetPassword(int id, string newPassword)
    {
        string sql = "UPDATE Admins SET Password=@Password WHERE Id=@Id";
        MySqlParameter[] parameters = new MySqlParameter[]
        {
            new MySqlParameter("@Password", GetMD5(newPassword)),
            new MySqlParameter("@Id", id)
        };
        return DBHelper.ExecuteNonQuery(sql, parameters) > 0;
    }

    public static bool DeleteAdmin(int id)
    {
        string sql = "DELETE FROM Admins WHERE Id=@Id";
        MySqlParameter[] parameters = new MySqlParameter[] { new MySqlParameter("@Id", id) };
        return DBHelper.ExecuteNonQuery(sql, parameters) > 0;
    }
}
