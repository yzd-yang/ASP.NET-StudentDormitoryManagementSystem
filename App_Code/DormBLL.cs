using System;
using System.Data;
using MySql.Data.MySqlClient;

public class DormBLL
{
    public static DataTable GetStudentDormInfo(int studentId)
    {
        string sql = @"SELECT s.Name as StudentName, s.StudentNo, s.College, s.Major, s.Grade,
                       bd.Campus, bd.Name as BuildingName, r.RoomNo, r.RoomType, bed.BedNo
                       FROM Students s
                       LEFT JOIN Beds bed ON s.Id = bed.StudentId
                       LEFT JOIN Rooms r ON bed.RoomId = r.Id
                       LEFT JOIN Buildings bd ON r.BuildingId = bd.Id
                       WHERE s.Id = @StudentId";

        MySqlParameter[] parameters = new MySqlParameter[] { new MySqlParameter("@StudentId", studentId) };
        return DBHelper.GetDataTable(sql, parameters);
    }

    public static DataTable GetRoommates(int studentId)
    {
        string sql = @"SELECT s2.Name, s2.College, s2.Major, s2.Grade
                       FROM Beds bed1
                       JOIN Beds bed2 ON bed1.RoomId = bed2.RoomId AND bed2.StudentId IS NOT NULL
                       JOIN Students s2 ON bed2.StudentId = s2.Id
                       WHERE bed1.StudentId = @StudentId AND bed2.StudentId != @StudentId";

        MySqlParameter[] parameters = new MySqlParameter[] { new MySqlParameter("@StudentId", studentId) };
        return DBHelper.GetDataTable(sql, parameters);
    }

    public static DataTable GetBuildings()
    {
        string sql = "SELECT * FROM Buildings WHERE Status=1 ORDER BY Name";
        return DBHelper.GetDataTable(sql);
    }

    public static DataTable GetRoomsByBuilding(int buildingId)
    {
        string sql = @"SELECT r.*, 
                       (SELECT COUNT(*) FROM Beds WHERE RoomId=r.Id AND Status=1) as OccupiedBeds,
                       (SELECT COUNT(*) FROM Beds WHERE RoomId=r.Id) as TotalBeds
                       FROM Rooms r WHERE r.BuildingId=@BuildingId ORDER BY r.RoomNo";
        MySqlParameter[] parameters = new MySqlParameter[] { new MySqlParameter("@BuildingId", buildingId) };
        return DBHelper.GetDataTable(sql, parameters);
    }

    public static DataTable GetRoomBeds(int roomId)
    {
        string sql = @"SELECT bed.*, s.Name as StudentName, s.StudentNo
                       FROM Beds bed
                       LEFT JOIN Students s ON bed.StudentId = s.Id
                       WHERE bed.RoomId = @RoomId
                       ORDER BY bed.BedNo";
        MySqlParameter[] parameters = new MySqlParameter[] { new MySqlParameter("@RoomId", roomId) };
        return DBHelper.GetDataTable(sql, parameters);
    }

    public static bool AllocateBed(int bedId, int studentId)
    {
        // 检查学生是否已有床位
        string checkSql = "SELECT COUNT(*) FROM Beds WHERE StudentId=@StudentId AND Status=1";
        MySqlParameter[] checkParams = new MySqlParameter[] { new MySqlParameter("@StudentId", studentId) };
        object count = DBHelper.ExecuteScalar(checkSql, checkParams);
        if (count != null && Convert.ToInt32(count) > 0)
        {
            return false; // 学生已有床位
        }

        string sql = "UPDATE Beds SET StudentId=@StudentId, Status=1, AllocateTime=NOW() WHERE Id=@Id AND Status=0";
        MySqlParameter[] parameters = new MySqlParameter[]
        {
            new MySqlParameter("@StudentId", studentId),
            new MySqlParameter("@Id", bedId)
        };
        return DBHelper.ExecuteNonQuery(sql, parameters) > 0;
    }

    public static bool HasBed(int studentId)
    {
        string sql = "SELECT COUNT(*) FROM Beds WHERE StudentId=@StudentId AND Status=1";
        MySqlParameter[] parameters = new MySqlParameter[] { new MySqlParameter("@StudentId", studentId) };
        object count = DBHelper.ExecuteScalar(sql, parameters);
        return count != null && Convert.ToInt32(count) > 0;
    }

    public static bool ReleaseBed(int bedId)
    {
        string sql = "UPDATE Beds SET StudentId=NULL, Status=0, AllocateTime=NULL WHERE Id=@Id";
        MySqlParameter[] parameters = new MySqlParameter[] { new MySqlParameter("@Id", bedId) };
        return DBHelper.ExecuteNonQuery(sql, parameters) > 0;
    }

    public static DataTable SearchStudents(string keyword)
    {
        string sql = @"SELECT Id, StudentNo, Name, College, Major, Grade, ClassName
                       FROM Students 
                       WHERE (StudentNo LIKE @Keyword OR Name LIKE @Keyword) AND Status=1
                       LIMIT 20";
        MySqlParameter[] parameters = new MySqlParameter[] { new MySqlParameter("@Keyword", "%" + keyword + "%") };
        return DBHelper.GetDataTable(sql, parameters);
    }

    public static DataTable SearchStudents(string keyword, string college, string major, string grade, string className)
    {
        string sql = @"SELECT s.Id, s.StudentNo, s.Name, s.College, s.Major, s.Grade, s.ClassName
                       FROM Students s
                       LEFT JOIN Beds b ON s.Id = b.StudentId AND b.Status = 1
                       WHERE s.Status=1 AND b.Id IS NULL";

        if (!string.IsNullOrEmpty(keyword))
        {
            sql += " AND (s.StudentNo LIKE @Keyword OR s.Name LIKE @Keyword)";
        }
        if (!string.IsNullOrEmpty(college))
        {
            sql += " AND s.College=@College";
        }
        if (!string.IsNullOrEmpty(major))
        {
            sql += " AND s.Major=@Major";
        }
        if (!string.IsNullOrEmpty(grade))
        {
            sql += " AND s.Grade=@Grade";
        }
        if (!string.IsNullOrEmpty(className))
        {
            sql += " AND s.ClassName=@ClassName";
        }

        sql += " ORDER BY s.StudentNo LIMIT 30";

        var paramList = new System.Collections.Generic.List<MySqlParameter>();
        if (!string.IsNullOrEmpty(keyword))
            paramList.Add(new MySqlParameter("@Keyword", "%" + keyword + "%"));
        if (!string.IsNullOrEmpty(college))
            paramList.Add(new MySqlParameter("@College", college));
        if (!string.IsNullOrEmpty(major))
            paramList.Add(new MySqlParameter("@Major", major));
        if (!string.IsNullOrEmpty(grade))
            paramList.Add(new MySqlParameter("@Grade", grade));
        if (!string.IsNullOrEmpty(className))
            paramList.Add(new MySqlParameter("@ClassName", className));

        return DBHelper.GetDataTable(sql, paramList.ToArray());
    }

    public static DataTable GetColleges()
    {
        string sql = "SELECT DISTINCT CollegeName FROM Departments ORDER BY CollegeName";
        return DBHelper.GetDataTable(sql);
    }

    public static DataTable GetMajorsByCollege(string college)
    {
        string sql = "SELECT DISTINCT MajorName FROM Departments WHERE CollegeName=@College ORDER BY MajorName";
        MySqlParameter[] parameters = new MySqlParameter[] { new MySqlParameter("@College", college) };
        return DBHelper.GetDataTable(sql, parameters);
    }

    public static DataTable GetGrades()
    {
        string sql = "SELECT DISTINCT Grade FROM Students WHERE Grade IS NOT NULL ORDER BY Grade DESC";
        return DBHelper.GetDataTable(sql);
    }

    public static DataTable GetClasses(string college, string major, string grade)
    {
        string sql = "SELECT DISTINCT ClassName FROM Students WHERE ClassName IS NOT NULL";
        if (!string.IsNullOrEmpty(college)) sql += " AND College=@College";
        if (!string.IsNullOrEmpty(major)) sql += " AND Major=@Major";
        if (!string.IsNullOrEmpty(grade)) sql += " AND Grade=@Grade";
        sql += " ORDER BY ClassName";

        var paramList = new System.Collections.Generic.List<MySqlParameter>();
        if (!string.IsNullOrEmpty(college)) paramList.Add(new MySqlParameter("@College", college));
        if (!string.IsNullOrEmpty(major)) paramList.Add(new MySqlParameter("@Major", major));
        if (!string.IsNullOrEmpty(grade)) paramList.Add(new MySqlParameter("@Grade", grade));

        return DBHelper.GetDataTable(sql, paramList.ToArray());
    }

    public static int GetTotalRooms()
    {
        string sql = "SELECT COUNT(*) FROM Rooms WHERE Status=1";
        object result = DBHelper.ExecuteScalar(sql);
        return result != null ? Convert.ToInt32(result) : 0;
    }

    public static int GetTotalStudents()
    {
        string sql = "SELECT COUNT(*) FROM Students WHERE Status=1";
        object result = DBHelper.ExecuteScalar(sql);
        return result != null ? Convert.ToInt32(result) : 0;
    }

    public static int GetAvailableBeds()
    {
        string sql = "SELECT COUNT(*) FROM Beds WHERE Status=0";
        object result = DBHelper.ExecuteScalar(sql);
        return result != null ? Convert.ToInt32(result) : 0;
    }

    public static DataTable GetBuildingOccupancy()
    {
        string sql = @"SELECT b.Id, b.Name as BuildingName, b.Campus,
                       (SELECT COUNT(*) FROM Beds bed JOIN Rooms r ON bed.RoomId = r.Id WHERE r.BuildingId = b.Id) as TotalBeds,
                       (SELECT COUNT(*) FROM Beds bed JOIN Rooms r ON bed.RoomId = r.Id WHERE r.BuildingId = b.Id AND bed.Status = 1) as OccupiedBeds
                       FROM Buildings b
                       WHERE b.Status = 1
                       ORDER BY b.Name";
        return DBHelper.GetDataTable(sql);
    }

    public static int GetTotalBeds()
    {
        string sql = "SELECT COUNT(*) FROM Beds";
        object result = DBHelper.ExecuteScalar(sql);
        return result != null ? Convert.ToInt32(result) : 0;
    }

    public static DataTable GetAllRooms(int buildingId = 0, string roomNo = "", int floor = 0, int roomType = 0, string status = "", int pageIndex = 1, int pageSize = 12)
    {
        string sql = @"SELECT r.*, b.Name as BuildingName, b.Campus,
                       (SELECT COUNT(*) FROM Beds WHERE RoomId=r.Id AND Status=1) as OccupiedBeds,
                       (SELECT COUNT(*) FROM Beds WHERE RoomId=r.Id) as TotalBeds
                       FROM Rooms r
                       JOIN Buildings b ON r.BuildingId = b.Id
                       WHERE r.Status=1";

        var paramList = new System.Collections.Generic.List<MySqlParameter>();

        if (buildingId > 0)
        {
            sql += " AND r.BuildingId=@BuildingId";
            paramList.Add(new MySqlParameter("@BuildingId", buildingId));
        }
        if (!string.IsNullOrEmpty(roomNo))
        {
            sql += " AND r.RoomNo LIKE @RoomNo";
            paramList.Add(new MySqlParameter("@RoomNo", "%" + roomNo + "%"));
        }
        if (floor > 0)
        {
            sql += " AND r.Floor=@Floor";
            paramList.Add(new MySqlParameter("@Floor", floor));
        }
        if (roomType > 0)
        {
            sql += " AND r.RoomType=@RoomType";
            paramList.Add(new MySqlParameter("@RoomType", roomType));
        }

        // 先查出所有符合条件的房间，再用HAVING筛选满员状态
        if (status == "full")
        {
            sql += " HAVING OccupiedBeds = TotalBeds";
        }
        else if (status == "empty")
        {
            sql += " HAVING OccupiedBeds = 0";
        }
        else if (status == "partial")
        {
            sql += " HAVING OccupiedBeds > 0 AND OccupiedBeds < TotalBeds";
        }

        sql += " ORDER BY b.Name, r.RoomNo LIMIT @Offset, @PageSize";

        int offset = (pageIndex - 1) * pageSize;
        paramList.Add(new MySqlParameter("@Offset", offset));
        paramList.Add(new MySqlParameter("@PageSize", pageSize));

        return DBHelper.GetDataTable(sql, paramList.ToArray());
    }

    public static int GetRoomCount(int buildingId = 0, string roomNo = "", int floor = 0, int roomType = 0, string status = "")
    {
        // 带HAVING的查询需要用子查询包装
        string sql = @"SELECT COUNT(*) FROM (
                       SELECT r.Id
                       FROM Rooms r
                       JOIN Buildings b ON r.BuildingId = b.Id
                       WHERE r.Status=1";

        var paramList = new System.Collections.Generic.List<MySqlParameter>();

        if (buildingId > 0)
        {
            sql += " AND r.BuildingId=@BuildingId";
            paramList.Add(new MySqlParameter("@BuildingId", buildingId));
        }
        if (!string.IsNullOrEmpty(roomNo))
        {
            sql += " AND r.RoomNo LIKE @RoomNo";
            paramList.Add(new MySqlParameter("@RoomNo", "%" + roomNo + "%"));
        }
        if (floor > 0)
        {
            sql += " AND r.Floor=@Floor";
            paramList.Add(new MySqlParameter("@Floor", floor));
        }
        if (roomType > 0)
        {
            sql += " AND r.RoomType=@RoomType";
            paramList.Add(new MySqlParameter("@RoomType", roomType));
        }

        if (status == "full")
        {
            sql += " HAVING (SELECT COUNT(*) FROM Beds WHERE RoomId=r.Id AND Status=1) = (SELECT COUNT(*) FROM Beds WHERE RoomId=r.Id)";
        }
        else if (status == "empty")
        {
            sql += " HAVING (SELECT COUNT(*) FROM Beds WHERE RoomId=r.Id AND Status=1) = 0";
        }
        else if (status == "partial")
        {
            sql += " HAVING (SELECT COUNT(*) FROM Beds WHERE RoomId=r.Id AND Status=1) > 0 AND (SELECT COUNT(*) FROM Beds WHERE RoomId=r.Id AND Status=1) < (SELECT COUNT(*) FROM Beds WHERE RoomId=r.Id)";
        }

        sql += ") t";

        object result = DBHelper.ExecuteScalar(sql, paramList.ToArray());
        return result != null ? Convert.ToInt32(result) : 0;
    }

    public static DataTable GetFloorsByBuilding(int buildingId)
    {
        string sql = "SELECT DISTINCT Floor FROM Rooms WHERE BuildingId=@BuildingId ORDER BY Floor";
        MySqlParameter[] parameters = new MySqlParameter[] { new MySqlParameter("@BuildingId", buildingId) };
        return DBHelper.GetDataTable(sql, parameters);
    }

    public static DataTable GetAllFloors()
    {
        string sql = "SELECT DISTINCT Floor FROM Rooms ORDER BY Floor";
        return DBHelper.GetDataTable(sql);
    }

    public static int GetTotalRoomCount()
    {
        string sql = "SELECT COUNT(*) FROM Rooms WHERE Status=1";
        object result = DBHelper.ExecuteScalar(sql);
        return result != null ? Convert.ToInt32(result) : 0;
    }

    // 楼宇管理
    public static DataTable GetBuildingList()
    {
        string sql = @"SELECT b.*, 
                       (SELECT COUNT(*) FROM Rooms WHERE BuildingId=b.Id) as RoomCount
                       FROM Buildings b ORDER BY b.Name";
        return DBHelper.GetDataTable(sql);
    }

    public static DataTable GetRoomsByBuildingForManage(int buildingId)
    {
        string sql = @"SELECT r.*, 
                       (SELECT COUNT(*) FROM Beds WHERE RoomId=r.Id AND Status=1) as OccupiedBeds,
                       (SELECT COUNT(*) FROM Beds WHERE RoomId=r.Id) as TotalBeds
                       FROM Rooms r WHERE r.BuildingId=@BuildingId ORDER BY r.Floor, r.RoomNo";
        MySqlParameter[] parameters = new MySqlParameter[] { new MySqlParameter("@BuildingId", buildingId) };
        return DBHelper.GetDataTable(sql, parameters);
    }

    public static bool AddRoom(int buildingId, int floor, string roomNo, int roomType, int bedCount)
    {
        string sql = "INSERT INTO Rooms (BuildingId, Floor, RoomNo, RoomType, BedCount) VALUES (@BuildingId, @Floor, @RoomNo, @RoomType, @BedCount)";
        MySqlParameter[] parameters = new MySqlParameter[]
        {
            new MySqlParameter("@BuildingId", buildingId),
            new MySqlParameter("@Floor", floor),
            new MySqlParameter("@RoomNo", roomNo),
            new MySqlParameter("@RoomType", roomType),
            new MySqlParameter("@BedCount", bedCount)
        };
        int roomId = 0;
        if (DBHelper.ExecuteNonQuery(sql, parameters) > 0)
        {
            DataTable dt = DBHelper.GetDataTable("SELECT LAST_INSERT_ID() as Id");
            if (dt.Rows.Count > 0)
            {
                roomId = Convert.ToInt32(dt.Rows[0]["Id"]);
                // 创建床位
                for (int bed = 0; bed < bedCount; bed++)
                {
                    string bedNo = ((char)('A' + bed)).ToString();
                    string bedSql = "INSERT INTO Beds (RoomId, BedNo) VALUES (@RoomId, @BedNo)";
                    DBHelper.ExecuteNonQuery(bedSql, new MySqlParameter[] {
                        new MySqlParameter("@RoomId", roomId),
                        new MySqlParameter("@BedNo", bedNo)
                    });
                }
                return true;
            }
        }
        return false;
    }

    public static bool UpdateRoomStatus(int roomId, int status)
    {
        string sql = "UPDATE Rooms SET Status=@Status WHERE Id=@Id";
        MySqlParameter[] parameters = new MySqlParameter[]
        {
            new MySqlParameter("@Status", status),
            new MySqlParameter("@Id", roomId)
        };
        return DBHelper.ExecuteNonQuery(sql, parameters) > 0;
    }

    public static bool DeleteRoom(int roomId)
    {
        // 先删除床位
        string deleteBeds = "DELETE FROM Beds WHERE RoomId=@RoomId";
        DBHelper.ExecuteNonQuery(deleteBeds, new MySqlParameter[] { new MySqlParameter("@RoomId", roomId) });
        
        // 删除房间
        string sql = "DELETE FROM Rooms WHERE Id=@Id";
        return DBHelper.ExecuteNonQuery(sql, new MySqlParameter[] { new MySqlParameter("@Id", roomId) }) > 0;
    }

    public static bool AddBuilding(string name, int floorCount, int roomsPerFloor, string campus)
    {
        string sql = "INSERT INTO Buildings (Name, FloorCount, RoomsPerFloor, Campus) VALUES (@Name, @FloorCount, @RoomsPerFloor, @Campus)";
        MySqlParameter[] parameters = new MySqlParameter[]
        {
            new MySqlParameter("@Name", name),
            new MySqlParameter("@FloorCount", floorCount),
            new MySqlParameter("@RoomsPerFloor", roomsPerFloor),
            new MySqlParameter("@Campus", campus)
        };
        return DBHelper.ExecuteNonQuery(sql, parameters) > 0;
    }

    public static bool UpdateBuilding(int id, string name, int floorCount, int roomsPerFloor, string campus)
    {
        string sql = "UPDATE Buildings SET Name=@Name, FloorCount=@FloorCount, RoomsPerFloor=@RoomsPerFloor, Campus=@Campus WHERE Id=@Id";
        MySqlParameter[] parameters = new MySqlParameter[]
        {
            new MySqlParameter("@Name", name),
            new MySqlParameter("@FloorCount", floorCount),
            new MySqlParameter("@RoomsPerFloor", roomsPerFloor),
            new MySqlParameter("@Campus", campus),
            new MySqlParameter("@Id", id)
        };
        return DBHelper.ExecuteNonQuery(sql, parameters) > 0;
    }

    public static bool DeleteBuilding(int id)
    {
        string checkSql = "SELECT COUNT(*) FROM Rooms WHERE BuildingId=@Id";
        object count = DBHelper.ExecuteScalar(checkSql, new MySqlParameter[] { new MySqlParameter("@Id", id) });
        if (count != null && Convert.ToInt32(count) > 0) return false;

        string sql = "DELETE FROM Buildings WHERE Id=@Id";
        return DBHelper.ExecuteNonQuery(sql, new MySqlParameter[] { new MySqlParameter("@Id", id) }) > 0;
    }

    // 批量生成房间
    public static int BatchCreateRooms(int buildingId, int startFloor, int endFloor, int roomsPerFloor, int roomType, int bedCount)
    {
        string prefixSql = "SELECT Name FROM Buildings WHERE Id=@Id";
        DataTable dt = DBHelper.GetDataTable(prefixSql, new MySqlParameter[] { new MySqlParameter("@Id", buildingId) });
        if (dt.Rows.Count == 0) return 0;
        string prefix = dt.Rows[0]["Name"].ToString();

        int totalCreated = 0;
        for (int floor = startFloor; floor <= endFloor; floor++)
        {
            for (int room = 1; room <= roomsPerFloor; room++)
            {
                string roomNo = prefix + "-" + floor + room.ToString("D2");
                string sql = "INSERT INTO Rooms (BuildingId, Floor, RoomNo, RoomType, BedCount) VALUES (@BuildingId, @Floor, @RoomNo, @RoomType, @BedCount)";
                MySqlParameter[] parameters = new MySqlParameter[]
                {
                    new MySqlParameter("@BuildingId", buildingId),
                    new MySqlParameter("@Floor", floor),
                    new MySqlParameter("@RoomNo", roomNo),
                    new MySqlParameter("@RoomType", roomType),
                    new MySqlParameter("@BedCount", bedCount)
                };
                if (DBHelper.ExecuteNonQuery(sql, parameters) > 0)
                {
                    // 创建床位
                    int roomId = Convert.ToInt32(DBHelper.ExecuteScalar("SELECT LAST_INSERT_ID()"));
                    for (int bed = 0; bed < bedCount; bed++)
                    {
                        string bedNo = ((char)('A' + bed)).ToString();
                        string bedSql = "INSERT INTO Beds (RoomId, BedNo) VALUES (@RoomId, @BedNo)";
                        DBHelper.ExecuteNonQuery(bedSql, new MySqlParameter[] {
                            new MySqlParameter("@RoomId", roomId),
                            new MySqlParameter("@BedNo", bedNo)
                        });
                    }
                    totalCreated++;
                }
            }
        }
        return totalCreated;
    }
}

// 院系管理
public class DeptBLL
{
    public static DataTable GetDepartmentTree()
    {
        string sql = "SELECT * FROM Departments ORDER BY CollegeName, SortOrder";
        return DBHelper.GetDataTable(sql);
    }

    public static bool AddDepartment(string collegeName, string majorName)
    {
        string sql = "INSERT INTO Departments (CollegeName, MajorName) VALUES (@CollegeName, @MajorName)";
        MySqlParameter[] parameters = new MySqlParameter[]
        {
            new MySqlParameter("@CollegeName", collegeName),
            new MySqlParameter("@MajorName", majorName)
        };
        return DBHelper.ExecuteNonQuery(sql, parameters) > 0;
    }

    public static bool UpdateDepartment(int id, string majorName)
    {
        string sql = "UPDATE Departments SET MajorName=@MajorName WHERE Id=@Id";
        MySqlParameter[] parameters = new MySqlParameter[]
        {
            new MySqlParameter("@MajorName", majorName),
            new MySqlParameter("@Id", id)
        };
        return DBHelper.ExecuteNonQuery(sql, parameters) > 0;
    }

    public static bool DeleteDepartment(int id)
    {
        string sql = "DELETE FROM Departments WHERE Id=@Id";
        return DBHelper.ExecuteNonQuery(sql, new MySqlParameter[] { new MySqlParameter("@Id", id) }) > 0;
    }
}