using System;
using System.Data;
using System.Configuration;
using MySql.Data.MySqlClient;

public class DBHelper
{
    private static string connStr = ConfigurationManager.ConnectionStrings["MySQLConnectionString"].ConnectionString;

    public static MySqlConnection GetConnection()
    {
        return new MySqlConnection(connStr);
    }

    public static int ExecuteNonQuery(string sql, params MySqlParameter[] parameters)
    {
        using (MySqlConnection conn = GetConnection())
        {
            conn.Open();
            MySqlCommand cmd = new MySqlCommand(sql, conn);
            if (parameters != null) cmd.Parameters.AddRange(parameters);
            return cmd.ExecuteNonQuery();
        }
    }

    public static object ExecuteScalar(string sql, params MySqlParameter[] parameters)
    {
        using (MySqlConnection conn = GetConnection())
        {
            conn.Open();
            MySqlCommand cmd = new MySqlCommand(sql, conn);
            if (parameters != null) cmd.Parameters.AddRange(parameters);
            return cmd.ExecuteScalar();
        }
    }

    public static DataTable GetDataTable(string sql, params MySqlParameter[] parameters)
    {
        using (MySqlConnection conn = GetConnection())
        {
            conn.Open();
            MySqlCommand cmd = new MySqlCommand(sql, conn);
            if (parameters != null) cmd.Parameters.AddRange(parameters);
            MySqlDataAdapter adapter = new MySqlDataAdapter(cmd);
            DataTable dt = new DataTable();
            adapter.Fill(dt);
            return dt;
        }
    }

    public static MySqlDataReader GetReader(string sql, params MySqlParameter[] parameters)
    {
        MySqlConnection conn = GetConnection();
        conn.Open();
        MySqlCommand cmd = new MySqlCommand(sql, conn);
        if (parameters != null) cmd.Parameters.AddRange(parameters);
        return cmd.ExecuteReader(CommandBehavior.CloseConnection);
    }

    public static bool ExecuteTransaction(params (string sql, MySqlParameter[] param)[] commands)
    {
        using (MySqlConnection conn = GetConnection())
        {
            conn.Open();
            MySqlTransaction transaction = conn.BeginTransaction();
            try
            {
                foreach (var (sql, param) in commands)
                {
                    MySqlCommand cmd = new MySqlCommand(sql, conn, transaction);
                    if (param != null) cmd.Parameters.AddRange(param);
                    cmd.ExecuteNonQuery();
                }
                transaction.Commit();
                return true;
            }
            catch
            {
                transaction.Rollback();
                return false;
            }
        }
    }
}