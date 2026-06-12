using System;
using System.Data;
using MySql.Data.MySqlClient;

public class BatchBLL
{
    public static DataTable GetBatchList(string keyword = "", int status = -1, string grade = "", string college = "")
    {
        string sql = @"SELECT b.*, a.Name as AdminName,
                       (SELECT COUNT(*) FROM BatchRooms WHERE BatchId=b.Id) as RoomCount
                       FROM SelectionBatches b
                       LEFT JOIN Admins a ON b.AdminId = a.Id
                       WHERE 1=1";

        var paramList = new System.Collections.Generic.List<MySqlParameter>();

        if (!string.IsNullOrEmpty(keyword))
        {
            sql += " AND b.BatchName LIKE @Keyword";
            paramList.Add(new MySqlParameter("@Keyword", "%" + keyword + "%"));
        }
        if (status >= 0)
        {
            sql += " AND b.Status=@Status";
            paramList.Add(new MySqlParameter("@Status", status));
        }
        if (!string.IsNullOrEmpty(grade))
        {
            sql += " AND b.GradeLimit=@Grade";
            paramList.Add(new MySqlParameter("@Grade", grade));
        }
        if (!string.IsNullOrEmpty(college))
        {
            sql += " AND b.CollegeLimit LIKE @College";
            paramList.Add(new MySqlParameter("@College", "%" + college + "%"));
        }

        sql += " ORDER BY b.CreateTime DESC";
        return DBHelper.GetDataTable(sql, paramList.ToArray());
    }

    public static DataTable GetBatchStats()
    {
        string sql = @"SELECT 
                       COUNT(*) as Total,
                       SUM(CASE WHEN Status=1 THEN 1 ELSE 0 END) as Active,
                       SUM(CASE WHEN Status=0 THEN 1 ELSE 0 END) as Upcoming,
                       SUM(CASE WHEN Status=2 THEN 1 ELSE 0 END) as Ended
                       FROM SelectionBatches";
        return DBHelper.GetDataTable(sql);
    }

    public static bool AddBatch(string batchName, DateTime startTime, DateTime endTime, string gradeLimit, string collegeLimit, string majorLimit, int adminId, int[] roomIds)
    {
        string sql = @"INSERT INTO SelectionBatches (BatchName, StartTime, EndTime, GradeLimit, CollegeLimit, MajorLimit, Status, AdminId) 
                       VALUES (@BatchName, @StartTime, @EndTime, @GradeLimit, @CollegeLimit, @MajorLimit, 0, @AdminId)";

        MySqlParameter[] parameters = new MySqlParameter[]
        {
            new MySqlParameter("@BatchName", batchName),
            new MySqlParameter("@StartTime", startTime),
            new MySqlParameter("@EndTime", endTime),
            new MySqlParameter("@GradeLimit", string.IsNullOrEmpty(gradeLimit) ? (object)DBNull.Value : gradeLimit),
            new MySqlParameter("@CollegeLimit", string.IsNullOrEmpty(collegeLimit) ? (object)DBNull.Value : collegeLimit),
            new MySqlParameter("@MajorLimit", string.IsNullOrEmpty(majorLimit) ? (object)DBNull.Value : majorLimit),
            new MySqlParameter("@AdminId", adminId)
        };

        int batchId = 0;
        if (DBHelper.ExecuteNonQuery(sql, parameters) > 0)
        {
            DataTable dt = DBHelper.GetDataTable("SELECT LAST_INSERT_ID() as Id");
            if (dt.Rows.Count > 0) batchId = Convert.ToInt32(dt.Rows[0]["Id"]);

            // 添加房间关联
            if (roomIds != null && roomIds.Length > 0)
            {
                foreach (int roomId in roomIds)
                {
                    string roomSql = "INSERT INTO BatchRooms (BatchId, RoomId) VALUES (@BatchId, @RoomId)";
                    DBHelper.ExecuteNonQuery(roomSql, new MySqlParameter[] {
                        new MySqlParameter("@BatchId", batchId),
                        new MySqlParameter("@RoomId", roomId)
                    });
                }
            }
            return true;
        }
        return false;
    }

    public static bool UpdateBatch(int id, string batchName, DateTime startTime, DateTime endTime, string gradeLimit, string collegeLimit, string majorLimit, int status)
    {
        string sql = @"UPDATE SelectionBatches SET BatchName=@BatchName, StartTime=@StartTime, EndTime=@EndTime, 
                       GradeLimit=@GradeLimit, CollegeLimit=@CollegeLimit, MajorLimit=@MajorLimit, Status=@Status
                       WHERE Id=@Id";

        MySqlParameter[] parameters = new MySqlParameter[]
        {
            new MySqlParameter("@BatchName", batchName),
            new MySqlParameter("@StartTime", startTime),
            new MySqlParameter("@EndTime", endTime),
            new MySqlParameter("@GradeLimit", string.IsNullOrEmpty(gradeLimit) ? (object)DBNull.Value : gradeLimit),
            new MySqlParameter("@CollegeLimit", string.IsNullOrEmpty(collegeLimit) ? (object)DBNull.Value : collegeLimit),
            new MySqlParameter("@MajorLimit", string.IsNullOrEmpty(majorLimit) ? (object)DBNull.Value : majorLimit),
            new MySqlParameter("@Status", status),
            new MySqlParameter("@Id", id)
        };
        return DBHelper.ExecuteNonQuery(sql, parameters) > 0;
    }

    public static bool DeleteBatch(int id)
    {
        // 先删除房间关联
        string deleteRooms = "DELETE FROM BatchRooms WHERE BatchId=@BatchId";
        DBHelper.ExecuteNonQuery(deleteRooms, new MySqlParameter[] { new MySqlParameter("@BatchId", id) });

        string sql = "DELETE FROM SelectionBatches WHERE Id=@Id";
        return DBHelper.ExecuteNonQuery(sql, new MySqlParameter[] { new MySqlParameter("@Id", id) }) > 0;
    }

    public static DataTable GetBatchRooms(int batchId)
    {
        string sql = @"SELECT r.*, b.Name as BuildingName
                       FROM BatchRooms br
                       JOIN Rooms r ON br.RoomId = r.Id
                       JOIN Buildings b ON r.BuildingId = b.Id
                       WHERE br.BatchId=@BatchId
                       ORDER BY b.Name, r.RoomNo";
        return DBHelper.GetDataTable(sql, new MySqlParameter[] { new MySqlParameter("@BatchId", batchId) });
    }

    public static DataTable GetBuildingsForBatch()
    {
        string sql = "SELECT Id, Name, Campus FROM Buildings WHERE Status=1 ORDER BY Name";
        return DBHelper.GetDataTable(sql);
    }

    public static DataTable GetRoomsForBatch(int buildingId, int floor = 0)
    {
        string sql = @"SELECT r.Id, r.RoomNo, r.Floor, r.RoomType, r.BedCount,
                       (SELECT COUNT(*) FROM Beds WHERE RoomId=r.Id AND Status=0) as AvailableBeds
                       FROM Rooms r WHERE r.BuildingId=@BuildingId AND r.Status=1";
        if (floor > 0)
        {
            sql += " AND r.Floor=@Floor";
        }
        sql += " ORDER BY r.RoomNo";

        var paramList = new System.Collections.Generic.List<MySqlParameter>();
        paramList.Add(new MySqlParameter("@BuildingId", buildingId));
        if (floor > 0)
        {
            paramList.Add(new MySqlParameter("@Floor", floor));
        }
        return DBHelper.GetDataTable(sql, paramList.ToArray());
    }

    public static DataTable GetBatchStatusCounts()
    {
        string sql = @"SELECT 
                       SUM(CASE WHEN Status=1 THEN 1 ELSE 0 END) as Active,
                       SUM(CASE WHEN Status=2 THEN 1 ELSE 0 END) as Ended
                       FROM SelectionBatches";
        return DBHelper.GetDataTable(sql);
    }
}
