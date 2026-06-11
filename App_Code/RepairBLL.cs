using System;
using System.Data;
using MySql.Data.MySqlClient;

public class RepairBLL
{
    public static string GenerateOrderNo()
    {
        return "WX" + DateTime.Now.ToString("yyyyMMdd") + new Random().Next(1000, 9999).ToString();
    }

    public static bool CreateRepairOrder(int studentId, int roomId, int repairType, string description, string expectTime, string contactPhone)
    {
        string orderNo = GenerateOrderNo();
        string sql = @"INSERT INTO RepairOrders (OrderNo, StudentId, RoomId, RepairType, Description, ExpectTime, ContactPhone, Status) 
                       VALUES (@OrderNo, @StudentId, @RoomId, @RepairType, @Description, @ExpectTime, @ContactPhone, 1)";
        MySqlParameter[] parameters = new MySqlParameter[]
        {
            new MySqlParameter("@OrderNo", orderNo),
            new MySqlParameter("@StudentId", studentId),
            new MySqlParameter("@RoomId", roomId),
            new MySqlParameter("@RepairType", repairType),
            new MySqlParameter("@Description", description),
            new MySqlParameter("@ExpectTime", string.IsNullOrEmpty(expectTime) ? (object)DBNull.Value : expectTime),
            new MySqlParameter("@ContactPhone", contactPhone)
        };
        return DBHelper.ExecuteNonQuery(sql, parameters) > 0;
    }

    public static DataTable GetStudentRepairOrders(int studentId, int status = 0)
    {
        string sql = @"SELECT ro.*, r.RoomNo, bd.Name as BuildingName,
                       CASE ro.RepairType WHEN 1 THEN '\u6C34\u7535\u62A5\u4FEE' WHEN 2 THEN '\u5BB6\u5177\u5BB6\u7535' WHEN 3 THEN '\u7F51\u7EDC\u8FDE\u63A5' WHEN 4 THEN '\u5176\u4ED6' END as TypeName,
                       CASE ro.Status WHEN 1 THEN '\u5F85\u5206\u914D' WHEN 2 THEN '\u7EF4\u4FEE\u4E2D' WHEN 3 THEN '\u5DF2\u5B8C\u6210' WHEN 4 THEN '\u5DF2\u9A73\u56DE' END as StatusName
                       FROM RepairOrders ro
                       LEFT JOIN Rooms r ON ro.RoomId = r.Id
                       LEFT JOIN Buildings bd ON r.BuildingId = bd.Id
                       WHERE ro.StudentId = @StudentId";

        if (status > 0)
        {
            sql += " AND ro.Status = @Status";
        }
        sql += " ORDER BY ro.CreateTime DESC";

        MySqlParameter[] parameters;
        if (status > 0)
        {
            parameters = new MySqlParameter[]
            {
                new MySqlParameter("@StudentId", studentId),
                new MySqlParameter("@Status", status)
            };
        }
        else
        {
            parameters = new MySqlParameter[] { new MySqlParameter("@StudentId", studentId) };
        }

        return DBHelper.GetDataTable(sql, parameters);
    }

    public static DataTable GetAllRepairOrders(int status = 0)
    {
        string sql = @"SELECT ro.*, s.Name as StudentName, s.StudentNo, r.RoomNo, bd.Name as BuildingName,
                       CASE ro.RepairType WHEN 1 THEN '\u6C34\u7535\u62A5\u4FEE' WHEN 2 THEN '\u5BB6\u5177\u5BB6\u7535' WHEN 3 THEN '\u7F51\u7EDC\u8FDE\u63A5' WHEN 4 THEN '\u5176\u4ED6' END as TypeName,
                       CASE ro.Status WHEN 1 THEN '\u5F85\u5206\u914D' WHEN 2 THEN '\u7EF4\u4FEE\u4E2D' WHEN 3 THEN '\u5DF2\u5B8C\u6210' WHEN 4 THEN '\u5DF2\u9A73\u56DE' END as StatusName
                       FROM RepairOrders ro
                       LEFT JOIN Students s ON ro.StudentId = s.Id
                       LEFT JOIN Rooms r ON ro.RoomId = r.Id
                       LEFT JOIN Buildings bd ON r.BuildingId = bd.Id";

        if (status > 0)
        {
            sql += " WHERE ro.Status = @Status";
        }
        sql += " ORDER BY ro.CreateTime DESC";

        MySqlParameter[] parameters = status > 0 ? new MySqlParameter[] { new MySqlParameter("@Status", status) } : null;
        return DBHelper.GetDataTable(sql, parameters);
    }

    public static bool AssignRepairOrder(int orderId, int adminId)
    {
        string sql = "UPDATE RepairOrders SET AssignAdminId=@AdminId, Status=2 WHERE Id=@Id AND Status=1";
        MySqlParameter[] parameters = new MySqlParameter[]
        {
            new MySqlParameter("@AdminId", adminId),
            new MySqlParameter("@Id", orderId)
        };
        return DBHelper.ExecuteNonQuery(sql, parameters) > 0;
    }

    public static bool CompleteRepairOrder(int orderId)
    {
        string sql = "UPDATE RepairOrders SET Status=3, CompleteTime=NOW() WHERE Id=@Id AND Status=2";
        MySqlParameter[] parameters = new MySqlParameter[] { new MySqlParameter("@Id", orderId) };
        return DBHelper.ExecuteNonQuery(sql, parameters) > 0;
    }

    public static bool RejectRepairOrder(int orderId, string reason)
    {
        string sql = "UPDATE RepairOrders SET Status=4, RejectReason=@Reason WHERE Id=@Id AND Status=1";
        MySqlParameter[] parameters = new MySqlParameter[]
        {
            new MySqlParameter("@Reason", reason),
            new MySqlParameter("@Id", orderId)
        };
        return DBHelper.ExecuteNonQuery(sql, parameters) > 0;
    }

    public static int GetPendingRepairCount()
    {
        string sql = "SELECT COUNT(*) FROM RepairOrders WHERE Status=1";
        object result = DBHelper.ExecuteScalar(sql);
        return result != null ? Convert.ToInt32(result) : 0;
    }

    public static int GetProcessingRepairCount()
    {
        string sql = "SELECT COUNT(*) FROM RepairOrders WHERE Status=2";
        object result = DBHelper.ExecuteScalar(sql);
        return result != null ? Convert.ToInt32(result) : 0;
    }
}