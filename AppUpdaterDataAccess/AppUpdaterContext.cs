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
        private const string DESCRIPTION_COL = "Description";
        private const string FILE_DATA_COL = "Data";
        private const string FILE_EXTENSION_COL = "Extension";
        private const string FILE_FOLDERPATH_COL = "FolderPath";
        private const string FILE_HASH_COL = "Hash";
        private const string FILE_ID_COL = "FileId";
        private const string FILE_ISSTARTUPFILE_COL = "IsStartupFile";
        private const string FILE_NAME_COL = "FileName";
        private const string FILE_SIZE_COL = "Size";
        private const string FILE_UPLOADPATH_COL = "UploadPath";
        private const string GET_FILE_DATA_SP = "GetFileData";
        private const string LIST_APP_FILE_INFOS_SP = "ListApplicationFileInfos";
        private const string LIST_APPS_SP = "ListApplications";
        private const string SAVE_APP_FILE_SP = "SaveApplicationFile";
        private const string SAVE_APP_SP = "SaveApplication";
        private const string VERSION_COL = "Version";
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
        public void GetFileData(AppFile file)
        {
            using (var con = OpenConnection())
            {
                using (var cmd = new SqlCommand(GET_FILE_DATA_SP, con) { CommandType = CommandType.StoredProcedure })
                {
                    cmd.Parameters.AddWithValue("@" + FILE_ID_COL, file.FileId);
                    using (var reader = cmd.ExecuteReader())
                    {
                        if (!reader.Read()) return;

                        file.Data = ReadFileData(reader);
                        file.Hash = ReadFileHash(reader);
                    }
                }
            }
        }

        public IEnumerable<AppFile> ListApplicationFileInfos(SysApplication app)
        {
            using (var con = OpenConnection())
            {
                using (
                    var cmd = new SqlCommand(LIST_APP_FILE_INFOS_SP, con) { CommandType = CommandType.StoredProcedure })
                {
                    cmd.Parameters.AddWithValue("@" + APP_ID_COL, app.ApplicationId);
                    using (var reader = cmd.ExecuteReader())
                    {
                        while (reader.Read())
                        {
                            yield return ReadFileInfo(reader);
                        }
                    }
                }
            }
        }

        public IEnumerable<SysApplication> ListApplications()
        {
            using (var con = OpenConnection())
            {
                using (var cmd = new SqlCommand(LIST_APPS_SP, con) { CommandType = CommandType.StoredProcedure }
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

        public void SaveApplication(SysApplication app)
        {
            using (var con = OpenConnection())
            {
                using (var cmd = new SqlCommand(SAVE_APP_SP, con) { CommandType = CommandType.StoredProcedure })
                {
                    cmd.Parameters.AddWithValue("@" + APP_ID_COL, app.ApplicationId);
                    cmd.Parameters.AddWithValue("@" + APP_NAME_COL, app.ApplicationName);
                    cmd.Parameters.AddWithValue("@" + VERSION_COL, app.Version);
                    cmd.Parameters.AddWithValue("@" + DESCRIPTION_COL, app.Description);
                    var appId = Convert.ToInt32(cmd.ExecuteScalar());
                    app.ApplicationId = appId;
                }
            }
        }

        public void SaveApplicationFile(SysApplication app, AppFile file)
        {
            using (var con = OpenConnection())
            {
                using (var cmd = new SqlCommand(SAVE_APP_FILE_SP, con) { CommandType = CommandType.StoredProcedure })
                {
                    cmd.Parameters.AddWithValue("@" + APP_ID_COL, app.ApplicationId);
                    cmd.Parameters.AddWithValue("@" + APP_NAME_COL, app.ApplicationName);
                    cmd.Parameters.AddWithValue("@" + FILE_ID_COL, file.FileId);
                    cmd.Parameters.AddWithValue("@" + FILE_NAME_COL, file.FileName);
                    cmd.Parameters.AddWithValue("@" + FILE_EXTENSION_COL, file.Extension);
                    cmd.Parameters.AddWithValue("@" + FILE_DATA_COL, file.Data);
                    cmd.Parameters.AddWithValue("@" + FILE_HASH_COL, file.Hash);
                    cmd.Parameters.AddWithValue("@" + VERSION_COL, file.Version);
                    cmd.Parameters.AddWithValue("@" + FILE_SIZE_COL, file.Size);
                    cmd.Parameters.AddWithValue("@" + DESCRIPTION_COL, file.Description);
                    cmd.Parameters.AddWithValue("@" + FILE_FOLDERPATH_COL, file.FolderPath);
                    cmd.Parameters.AddWithValue("@" + FILE_UPLOADPATH_COL, file.UploadPath);
                    cmd.Parameters.AddWithValue("@" + FILE_ISSTARTUPFILE_COL, file.IsStartupFile);

                    using (var reader = cmd.ExecuteReader())
                    {
                        if (!reader.Read()) return;

                        app.ApplicationId = ReadApplicationId(reader);
                        file.FileId = ReadFileId(reader);
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

        private static SysApplication ReadApplication(IDataRecord reader)
        {
            return new SysApplication
            {
                ApplicationId = ReadApplicationId(reader),
                ApplicationName = ReadApplicationName(reader),
                Version = ReadVersion(reader),
                Description = ReadDescription(reader)
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

        private static string ReadDescription(IDataRecord reader)
        {
            return Convert.ToString(reader[DESCRIPTION_COL]);
        }

        private static byte[] ReadFileData(IDataRecord reader)
        {
            return reader[FILE_DATA_COL] as byte[];
        }

        private static string ReadFileFolderPath(IDataRecord reader)
        {
            return Convert.ToString(reader[FILE_FOLDERPATH_COL]);
        }

        private static byte[] ReadFileHash(IDataRecord reader)
        {
            return reader[FILE_HASH_COL] as byte[];
        }

        private static int? ReadFileId(IDataRecord reader)
        {
            var value = reader[FILE_ID_COL];
            return value is DBNull ? (int?)null : Convert.ToInt32(value);
        }

        private static AppFile ReadFileInfo(IDataRecord reader)
        {
            return new AppFile
            {
                FileId = ReadFileId(reader),
                FileName = ReadFileName(reader),
                Version = ReadVersion(reader),
                FolderPath = ReadFileFolderPath(reader),
                IsStartupFile = ReadIsStartupFile(reader)
            };
        }

        private static string ReadFileName(IDataRecord reader)
        {
            return Convert.ToString(reader[FILE_NAME_COL]);
        }

        private static bool ReadIsStartupFile(IDataRecord reader)
        {
            var value = reader[FILE_ISSTARTUPFILE_COL];
            return !(value is DBNull) && Convert.ToBoolean(value);
        }

        private static Version ReadVersion(IDataRecord reader)
        {
            var value = reader[VERSION_COL];
            return value is DBNull ? null : new Version(Convert.ToString(value));
        }
        #endregion
    }
}