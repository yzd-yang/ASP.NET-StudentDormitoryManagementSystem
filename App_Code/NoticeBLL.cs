using System;
using System.Data;
using MySql.Data.MySqlClient;

public class NoticeBLL
{
    public static DataTable GetNoticeList(string keyword = "", int status = -1, int pageIndex = 1, int pageSize = 10)
    {
        string sql = @"SELECT n.*, a.Name as AdminName
                       FROM Notices n
                       LEFT JOIN Admins a ON n.AdminId = a.Id
                       WHERE 1=1";

        var paramList = new System.Collections.Generic.List<MySqlParameter>();

        if (!string.IsNullOrEmpty(keyword))
        {
            sql += " AND n.Title LIKE @Keyword";
            paramList.Add(new MySqlParameter("@Keyword", "%" + keyword + "%"));
        }
        if (status >= 0)
        {
            sql += " AND n.Status=@Status";
            paramList.Add(new MySqlParameter("@Status", status));
        }

        sql += " ORDER BY n.IsTop DESC, n.CreateTime DESC LIMIT @Offset, @PageSize";
        paramList.Add(new MySqlParameter("@Offset", (pageIndex - 1) * pageSize));
        paramList.Add(new MySqlParameter("@PageSize", pageSize));

        return DBHelper.GetDataTable(sql, paramList.ToArray());
    }

    public static int GetNoticeCount(string keyword = "", int status = -1)
    {
        string sql = "SELECT COUNT(*) FROM Notices n WHERE 1=1";
        var paramList = new System.Collections.Generic.List<MySqlParameter>();

        if (!string.IsNullOrEmpty(keyword))
        {
            sql += " AND n.Title LIKE @Keyword";
            paramList.Add(new MySqlParameter("@Keyword", "%" + keyword + "%"));
        }
        if (status >= 0)
        {
            sql += " AND n.Status=@Status";
            paramList.Add(new MySqlParameter("@Status", status));
        }

        object result = DBHelper.ExecuteScalar(sql, paramList.ToArray());
        return result != null ? Convert.ToInt32(result) : 0;
    }

    public static bool AddNotice(string title, string content, int scope, int category, int isTop, int status, int adminId)
    {
        string sql = @"INSERT INTO Notices (Title, Content, Scope, Category, IsTop, Status, PublishTime, AdminId) 
                       VALUES (@Title, @Content, @Scope, @Category, @IsTop, @Status, @PublishTime, @AdminId)";

        MySqlParameter[] parameters = new MySqlParameter[]
        {
            new MySqlParameter("@Title", title),
            new MySqlParameter("@Content", content),
            new MySqlParameter("@Scope", scope),
            new MySqlParameter("@Category", category),
            new MySqlParameter("@IsTop", isTop),
            new MySqlParameter("@Status", status),
            new MySqlParameter("@PublishTime", status == 1 ? (object)DateTime.Now : DBNull.Value),
            new MySqlParameter("@AdminId", adminId)
        };
        return DBHelper.ExecuteNonQuery(sql, parameters) > 0;
    }

    public static bool UpdateNotice(int id, string title, string content, int scope, int category, int isTop)
    {
        string sql = @"UPDATE Notices SET Title=@Title, Content=@Content, Scope=@Scope, Category=@Category, IsTop=@IsTop 
                       WHERE Id=@Id";

        MySqlParameter[] parameters = new MySqlParameter[]
        {
            new MySqlParameter("@Title", title),
            new MySqlParameter("@Content", content),
            new MySqlParameter("@Scope", scope),
            new MySqlParameter("@Category", category),
            new MySqlParameter("@IsTop", isTop),
            new MySqlParameter("@Id", id)
        };
        return DBHelper.ExecuteNonQuery(sql, parameters) > 0;
    }

    public static bool PublishNotice(int id)
    {
        string sql = "UPDATE Notices SET Status=1, PublishTime=NOW() WHERE Id=@Id";
        return DBHelper.ExecuteNonQuery(sql, new MySqlParameter[] { new MySqlParameter("@Id", id) }) > 0;
    }

    public static bool WithdrawNotice(int id)
    {
        string sql = "UPDATE Notices SET Status=2 WHERE Id=@Id AND Status=1";
        return DBHelper.ExecuteNonQuery(sql, new MySqlParameter[] { new MySqlParameter("@Id", id) }) > 0;
    }

    public static bool DeleteNotice(int id)
    {
        string sql = "DELETE FROM Notices WHERE Id=@Id";
        return DBHelper.ExecuteNonQuery(sql, new MySqlParameter[] { new MySqlParameter("@Id", id) }) > 0;
    }

    public static DataTable GetNoticeById(int id)
    {
        string sql = "SELECT * FROM Notices WHERE Id=@Id";
        return DBHelper.GetDataTable(sql, new MySqlParameter[] { new MySqlParameter("@Id", id) });
    }
}
