using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using AppUpdaterModels;


namespace AppUpdaterDataAccess
{
    public class AppUpdaterContext
    {
        #region Fields
        private const string APP_ID_COL = "ApplicationId";
        private const string APP_NAME_COL = "ApplicationName";
        private const string DEFAULT_CONNECTION_CS = "defaultConnection";
        private const string LIST_APPLICATIONS_SP = "ListApplications";
        private readonly string _connectionString;
        #endregion


        #region  Constructors & Destructor
        public AppUpdaterContext(): this(GetConnectionString()) { }

        public AppUpdaterContext(string connectionString)
        {
            _connectionString = connectionString;
        }
        #endregion


        #region Methods
        public IEnumerable<SysApplication> ListApplications()
        {
            using (var con = OpenConnection())
            {
                using (var cmd = new SqlCommand(LIST_APPLICATIONS_SP, con) { CommandType = CommandType.StoredProcedure }
                    )
                {
                    using (var reader = cmd.ExecuteReader())
                    {
                        while (reader.Read())
                        {
                            yield return ReadApplication(reader);
                        }
                    }
                }
            }
        }
        #endregion


        #region Implementation
        private static string GetConnectionString()
        {
            return ConfigurationManager.ConnectionStrings[DEFAULT_CONNECTION_CS].ConnectionString;
        }

        private SqlConnection OpenConnection()
        {
            var con = new SqlConnection(_connectionString);
            con.Open();
            return con;
        }

        private SysApplication ReadApplication(IDataRecord reader)
        {
            return new SysApplication
            {
                ApplicationId = ReadApplicationId(reader),
                ApplicationName = ReadApplicationName(reader)
            };
        }

        private static int? ReadApplicationId(IDataRecord reader)
        {
            var value = reader[APP_ID_COL];
            return value is DBNull ? (int?)null : Convert.ToInt32(value);
        }

        private static string ReadApplicationName(IDataRecord reader)
        {
            return Convert.ToString(reader[APP_NAME_COL]);
        }
        #endregion
    }
}