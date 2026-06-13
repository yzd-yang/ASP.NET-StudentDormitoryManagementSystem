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
            sql += " AND EXISTS (SELECT 1 FROM BatchCollegeLimit WHERE BatchId=b.Id AND CollegeName=@College)";
            paramList.Add(new MySqlParameter("@College", college));
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

    public static bool AddBatch(string batchName, DateTime startTime, DateTime endTime, string gradeLimit, string[] collegeLimits, string[] majorLimits, int adminId, int[] roomIds)
    {
        string sql = @"INSERT INTO SelectionBatches (BatchName, StartTime, EndTime, GradeLimit, Status, AdminId) 
                       VALUES (@BatchName, @StartTime, @EndTime, @GradeLimit, 0, @AdminId)";

        MySqlParameter[] parameters = new MySqlParameter[]
        {
            new MySqlParameter("@BatchName", batchName),
            new MySqlParameter("@StartTime", startTime),
            new MySqlParameter("@EndTime", endTime),
            new MySqlParameter("@GradeLimit", string.IsNullOrEmpty(gradeLimit) ? (object)DBNull.Value : gradeLimit),
            new MySqlParameter("@AdminId", adminId)
        };

        int batchId = 0;
        if (DBHelper.ExecuteNonQuery(sql, parameters) > 0)
        {
            DataTable dt = DBHelper.GetDataTable("SELECT LAST_INSERT_ID() as Id");
            if (dt.Rows.Count > 0) batchId = Convert.ToInt32(dt.Rows[0]["Id"]);

            // 添加学院限制
            if (collegeLimits != null)
            {
                foreach (string college in collegeLimits)
                {
                    if (!string.IsNullOrEmpty(college))
                    {
                        string limitSql = "INSERT INTO BatchCollegeLimit (BatchId, CollegeName) VALUES (@BatchId, @CollegeName)";
                        DBHelper.ExecuteNonQuery(limitSql, new MySqlParameter[] {
                            new MySqlParameter("@BatchId", batchId),
                            new MySqlParameter("@CollegeName", college)
                        });
                    }
                }
            }

            // 添加专业限制
            if (majorLimits != null)
            {
                foreach (string major in majorLimits)
                {
                    if (!string.IsNullOrEmpty(major))
                    {
                        string limitSql = "INSERT INTO BatchMajorLimit (BatchId, MajorName) VALUES (@BatchId, @MajorName)";
                        DBHelper.ExecuteNonQuery(limitSql, new MySqlParameter[] {
                            new MySqlParameter("@BatchId", batchId),
                            new MySqlParameter("@MajorName", major)
                        });
                    }
                }
            }

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

    public static bool UpdateBatch(int id, string batchName, DateTime startTime, DateTime endTime, string gradeLimit, string[] collegeLimits, string[] majorLimits, int status)
    {
        string sql = @"UPDATE SelectionBatches SET BatchName=@BatchName, StartTime=@StartTime, EndTime=@EndTime, 
                       GradeLimit=@GradeLimit, Status=@Status
                       WHERE Id=@Id";

        MySqlParameter[] parameters = new MySqlParameter[]
        {
            new MySqlParameter("@BatchName", batchName),
            new MySqlParameter("@StartTime", startTime),
            new MySqlParameter("@EndTime", endTime),
            new MySqlParameter("@GradeLimit", string.IsNullOrEmpty(gradeLimit) ? (object)DBNull.Value : gradeLimit),
            new MySqlParameter("@Status", status),
            new MySqlParameter("@Id", id)
        };

        if (DBHelper.ExecuteNonQuery(sql, parameters) > 0)
        {
            // 更新学院限制
            DBHelper.ExecuteNonQuery("DELETE FROM BatchCollegeLimit WHERE BatchId=@BatchId", new MySqlParameter[] { new MySqlParameter("@BatchId", id) });
            if (collegeLimits != null)
            {
                foreach (string college in collegeLimits)
                {
                    if (!string.IsNullOrEmpty(college))
                    {
                        DBHelper.ExecuteNonQuery("INSERT INTO BatchCollegeLimit (BatchId, CollegeName) VALUES (@BatchId, @CollegeName)", new MySqlParameter[] {
                            new MySqlParameter("@BatchId", id),
                            new MySqlParameter("@CollegeName", college)
                        });
                    }
                }
            }

            // 更新专业限制
            DBHelper.ExecuteNonQuery("DELETE FROM BatchMajorLimit WHERE BatchId=@BatchId", new MySqlParameter[] { new MySqlParameter("@BatchId", id) });
            if (majorLimits != null)
            {
                foreach (string major in majorLimits)
                {
                    if (!string.IsNullOrEmpty(major))
                    {
                        DBHelper.ExecuteNonQuery("INSERT INTO BatchMajorLimit (BatchId, MajorName) VALUES (@BatchId, @MajorName)", new MySqlParameter[] {
                            new MySqlParameter("@BatchId", id),
                            new MySqlParameter("@MajorName", major)
                        });
                    }
                }
            }

            return true;
        }
        return false;
    }

    public static bool DeleteBatch(int id)
    {
        // 先删除关联数据
        DBHelper.ExecuteNonQuery("DELETE FROM BatchCollegeLimit WHERE BatchId=@BatchId", new MySqlParameter[] { new MySqlParameter("@BatchId", id) });
        DBHelper.ExecuteNonQuery("DELETE FROM BatchMajorLimit WHERE BatchId=@BatchId", new MySqlParameter[] { new MySqlParameter("@BatchId", id) });
        DBHelper.ExecuteNonQuery("DELETE FROM BatchRooms WHERE BatchId=@BatchId", new MySqlParameter[] { new MySqlParameter("@BatchId", id) });

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

    public static DataTable GetBatchesForStudent(string studentGrade, string studentCollege, string studentMajor, string keyword = "", int status = -1)
    {
        string sql = @"SELECT b.*, 
                       (SELECT COUNT(*) FROM BatchRooms WHERE BatchId=b.Id) as RoomCount,
                       (SELECT GROUP_CONCAT(DISTINCT bd.Name SEPARATOR '、') FROM BatchRooms br JOIN Rooms r ON br.RoomId=r.Id JOIN Buildings bd ON r.BuildingId=bd.Id WHERE br.BatchId=b.Id) as BuildingNames
                       FROM SelectionBatches b
                       WHERE 1=1";

        var paramList = new System.Collections.Generic.List<MySqlParameter>();

        if (!string.IsNullOrEmpty(studentGrade))
        {
            sql += " AND (b.GradeLimit IS NULL OR b.GradeLimit=@Grade)";
            paramList.Add(new MySqlParameter("@Grade", studentGrade));
        }
        if (!string.IsNullOrEmpty(studentCollege))
        {
            sql += " AND (NOT EXISTS (SELECT 1 FROM BatchCollegeLimit WHERE BatchId=b.Id) OR EXISTS (SELECT 1 FROM BatchCollegeLimit WHERE BatchId=b.Id AND CollegeName=@College))";
            paramList.Add(new MySqlParameter("@College", studentCollege));
        }
        if (!string.IsNullOrEmpty(studentMajor))
        {
            sql += " AND (NOT EXISTS (SELECT 1 FROM BatchMajorLimit WHERE BatchId=b.Id) OR EXISTS (SELECT 1 FROM BatchMajorLimit WHERE BatchId=b.Id AND MajorName=@Major))";
            paramList.Add(new MySqlParameter("@Major", studentMajor));
        }

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

        sql += " ORDER BY b.Status ASC, b.CreateTime DESC";
        return DBHelper.GetDataTable(sql, paramList.ToArray());
    }
}
