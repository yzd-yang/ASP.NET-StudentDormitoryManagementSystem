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
        string sql = "UPDATE Beds SET StudentId=@StudentId, Status=1, AllocateTime=NOW() WHERE Id=@Id AND Status=0";
        MySqlParameter[] parameters = new MySqlParameter[]
        {
            new MySqlParameter("@StudentId", studentId),
            new MySqlParameter("@Id", bedId)
        };
        return DBHelper.ExecuteNonQuery(sql, parameters) > 0;
    }

    public static bool ReleaseBed(int bedId)
    {
        string sql = "UPDATE Beds SET StudentId=NULL, Status=0, AllocateTime=NULL WHERE Id=@Id";
        MySqlParameter[] parameters = new MySqlParameter[] { new MySqlParameter("@Id", bedId) };
        return DBHelper.ExecuteNonQuery(sql, parameters) > 0;
    }

    public static DataTable SearchStudents(string keyword)
    {
        string sql = @"SELECT Id, StudentNo, Name, College, Major, Grade 
                       FROM Students 
                       WHERE (StudentNo LIKE @Keyword OR Name LIKE @Keyword) AND Status=1
                       LIMIT 20";
        MySqlParameter[] parameters = new MySqlParameter[] { new MySqlParameter("@Keyword", "%" + keyword + "%") };
        return DBHelper.GetDataTable(sql, parameters);
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
}