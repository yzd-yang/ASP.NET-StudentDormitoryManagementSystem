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

    public static int GetTodayRepairCount()
    {
        string sql = "SELECT COUNT(*) FROM RepairOrders WHERE DATE(CreateTime) = CURDATE()";
        object result = DBHelper.ExecuteScalar(sql);
        return result != null ? Convert.ToInt32(result) : 0;
    }

    public static int GetUrgentRepairCount()
    {
        string sql = "SELECT COUNT(*) FROM RepairOrders WHERE Status IN (1, 3)";
        object result = DBHelper.ExecuteScalar(sql);
        return result != null ? Convert.ToInt32(result) : 0;
    }

    public static DataTable GetRepairTrendByDay(int days)
    {
        string sql = @"SELECT DATE(CreateTime) as RepairDate, COUNT(*) as Count 
                       FROM RepairOrders 
                       WHERE CreateTime >= DATE_SUB(CURDATE(), INTERVAL @Days DAY)
                       GROUP BY DATE(CreateTime)
                       ORDER BY RepairDate";
        MySqlParameter[] parameters = new MySqlParameter[] { new MySqlParameter("@Days", days) };
        return DBHelper.GetDataTable(sql, parameters);
    }

    public static DataTable GetRepairList(int status = 0, int buildingId = 0, int repairType = 0, int pageIndex = 1, int pageSize = 15)
    {
        string sql = @"SELECT ro.*, s.Name as StudentName, s.StudentNo, s.College, r.RoomNo, r.Floor, bd.Name as BuildingName,
                       CASE ro.RepairType WHEN 1 THEN '水电报修' WHEN 2 THEN '家具家电' WHEN 3 THEN '网络连接' WHEN 4 THEN '其他' END as TypeName,
                       CASE ro.Status WHEN 1 THEN '待分配' WHEN 2 THEN '维修中' WHEN 3 THEN '已完成' WHEN 4 THEN '已驳回' END as StatusName,
                       a.Name as AssignAdminName
                       FROM RepairOrders ro
                       LEFT JOIN Students s ON ro.StudentId = s.Id
                       LEFT JOIN Rooms r ON ro.RoomId = r.Id
                       LEFT JOIN Buildings bd ON r.BuildingId = bd.Id
                       LEFT JOIN Admins a ON ro.AssignAdminId = a.Id
                       WHERE 1=1";

        var paramList = new System.Collections.Generic.List<MySqlParameter>();

        if (status > 0)
        {
            sql += " AND ro.Status=@Status";
            paramList.Add(new MySqlParameter("@Status", status));
        }
        if (buildingId > 0)
        {
            sql += " AND r.BuildingId=@BuildingId";
            paramList.Add(new MySqlParameter("@BuildingId", buildingId));
        }
        if (repairType > 0)
        {
            sql += " AND ro.RepairType=@RepairType";
            paramList.Add(new MySqlParameter("@RepairType", repairType));
        }

        sql += " ORDER BY ro.CreateTime DESC LIMIT @Offset, @PageSize";
        paramList.Add(new MySqlParameter("@Offset", (pageIndex - 1) * pageSize));
        paramList.Add(new MySqlParameter("@PageSize", pageSize));

        return DBHelper.GetDataTable(sql, paramList.ToArray());
    }

    public static int GetRepairListCount(int status = 0, int buildingId = 0, int repairType = 0)
    {
        string sql = @"SELECT COUNT(*) FROM RepairOrders ro
                       LEFT JOIN Rooms r ON ro.RoomId = r.Id
                       WHERE 1=1";

        var paramList = new System.Collections.Generic.List<MySqlParameter>();

        if (status > 0)
        {
            sql += " AND ro.Status=@Status";
            paramList.Add(new MySqlParameter("@Status", status));
        }
        if (buildingId > 0)
        {
            sql += " AND r.BuildingId=@BuildingId";
            paramList.Add(new MySqlParameter("@BuildingId", buildingId));
        }
        if (repairType > 0)
        {
            sql += " AND ro.RepairType=@RepairType";
            paramList.Add(new MySqlParameter("@RepairType", repairType));
        }

        object result = DBHelper.ExecuteScalar(sql, paramList.ToArray());
        return result != null ? Convert.ToInt32(result) : 0;
    }

    public static DataTable GetRepairById(int id)
    {
        string sql = @"SELECT ro.*, s.Name as StudentName, s.StudentNo, s.College, s.Major, s.Phone as StudentPhone,
                       r.RoomNo, r.Floor, bd.Name as BuildingName,
                       CASE ro.RepairType WHEN 1 THEN '水电报修' WHEN 2 THEN '家具家电' WHEN 3 THEN '网络连接' WHEN 4 THEN '其他' END as TypeName,
                       CASE ro.Status WHEN 1 THEN '待分配' WHEN 2 THEN '维修中' WHEN 3 THEN '已完成' WHEN 4 THEN '已驳回' END as StatusName,
                       a.Name as AssignAdminName
                       FROM RepairOrders ro
                       LEFT JOIN Students s ON ro.StudentId = s.Id
                       LEFT JOIN Rooms r ON ro.RoomId = r.Id
                       LEFT JOIN Buildings bd ON r.BuildingId = bd.Id
                       LEFT JOIN Admins a ON ro.AssignAdminId = a.Id
                       WHERE ro.Id=@Id";
        MySqlParameter[] parameters = new MySqlParameter[] { new MySqlParameter("@Id", id) };
        return DBHelper.GetDataTable(sql, parameters);
    }

    public static bool UpdateInternalNote(int orderId, string note)
    {
        string sql = "UPDATE RepairOrders SET InternalNote=@Note WHERE Id=@Id";
        MySqlParameter[] parameters = new MySqlParameter[]
        {
            new MySqlParameter("@Note", note),
            new MySqlParameter("@Id", orderId)
        };
        return DBHelper.ExecuteNonQuery(sql, parameters) > 0;
    }

    public static DataTable GetRepairStats()
    {
        string sql = @"SELECT 
                       SUM(CASE WHEN Status=1 THEN 1 ELSE 0 END) as Pending,
                       SUM(CASE WHEN Status=2 THEN 1 ELSE 0 END) as Processing,
                       SUM(CASE WHEN Status=1 THEN 1 ELSE 0 END) as Urgent,
                       SUM(CASE WHEN Status=3 AND DATE(CompleteTime)=CURDATE() THEN 1 ELSE 0 END) as TodayCompleted
                       FROM RepairOrders";
        return DBHelper.GetDataTable(sql);
    }

    public static DataTable GetAdminListForAssign()
    {
        string sql = "SELECT Id, Name, Role, CASE Role WHEN 1 THEN '超级管理员' WHEN 2 THEN '宿管' WHEN 3 THEN '后勤' END as RoleName FROM Admins WHERE Status=1 ORDER BY Role, Name";
        return DBHelper.GetDataTable(sql);
    }
}