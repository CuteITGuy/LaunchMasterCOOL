using System;
using System.Diagnostics;
using System.IO;
using System.Linq;
using System.Security.Cryptography;
using System.Text.RegularExpressions;
using CB.Model.Common;


namespace AppUpdaterModels
{
    public class AppFile: ObservableObject
    {
        #region Fields
        private byte[] _data;
        private string _description;
        private string _extension;
        private int? _fileId;
        private string _fileName;
        private string _folderPath;
        private byte[] _hash;

        private bool _isStartupFile;
        private long _size;
        private string _uploadPath;
        private Version _version;
        #endregion


        #region  Constructors & Destructor
        public AppFile() { }

        public AppFile(string filePath, string appFolder)
        {
            Initialize(filePath, appFolder);
        }
        #endregion


        #region  Properties & Indexers
        public byte[] Data
        {
            get { return _data; }
            set { SetProperty(ref _data, value); }
        }

        public string Description
        {
            get { return _description; }
            set { SetProperty(ref _description, value); }
        }

        public string Extension
        {
            get { return _extension; }
            set { SetProperty(ref _extension, value); }
        }

        public int? FileId
        {
            get { return _fileId; }
            set { SetProperty(ref _fileId, value); }
        }

        public string FileName
        {
            get { return _fileName; }
            set { SetProperty(ref _fileName, value); }
        }

        public string FolderPath
        {
            get { return _folderPath; }
            set { SetProperty(ref _folderPath, value); }
        }

        public byte[] Hash
        {
            get { return _hash; }
            set { SetProperty(ref _hash, value); }
        }

        public bool IsStartupFile
        {
            get { return _isStartupFile; }
            set { SetProperty(ref _isStartupFile, value); }
        }

        public long Size
        {
            get { return _size; }
            set { SetProperty(ref _size, value); }
        }

        public string UploadPath
        {
            get { return _uploadPath; }
            set { SetProperty(ref _uploadPath, value); }
        }

        public Version Version
        {
            get { return _version; }
            set { SetProperty(ref _version, value); }
        }
        #endregion


        #region Implementation
        private static string GetAssemblyDescription(string filePath)
        {
            var fileVersionInfo = FileVersionInfo.GetVersionInfo(filePath);
            return fileVersionInfo.FileDescription;
        }

        private static Version GetAssemblyVersion(string filePath)
        {
            var fileVersionInfo = FileVersionInfo.GetVersionInfo(filePath);
            return new Version(fileVersionInfo.FileVersion);
        }

        private string GetDescription(string filePath)
        {
            switch (Path.GetExtension(filePath))
            {
                case ".dll":
                case ".exe":
                    return GetAssemblyDescription(filePath);
                default:
                    return GetGenericDescription(filePath);
            }
        }

        private static string GetGenericDescription(string filePath)
        {
            const string PATTERN = @"(?i?m)\b<description\s{0,}\:?\s{0,}(.+)/>$";
            var contents = File.ReadAllText(filePath);
            var match = Regex.Match(contents, PATTERN);
            return match.Groups.Count > 1 ? match.Groups[1].Value : null;
        }

        private static Version GetGenericVersion(string filePath)
        {
            const string PATTERN = @"(?i)\b(?:version|ver|v)\s*\:?\s*(\d+\.\d+\.\d+\.\d+)";
            var contents = File.ReadAllText(filePath);
            var matches = Regex.Matches(contents, PATTERN);
            return matches.Count == 0
                       ? new Version(0, 0) : matches.Cast<Match>().Max(m => new Version(m.Groups[1].Value));
        }

        private static byte[] GetMd5Hash(byte[] data)
        {
            using (var md5 = MD5.Create())
            {
                return md5.ComputeHash(data);
            }
        }

        private static string GetRelativePath(string childPath, string parentFolder)
        {
            var childUri = new Uri(childPath);
            if (parentFolder.EndsWith(Path.DirectorySeparatorChar.ToString()))
                parentFolder += Path.DirectorySeparatorChar;
            var parentUri = new Uri(parentFolder);
            return Uri.UnescapeDataString(parentUri.MakeRelativeUri(childUri).ToString().Replace('/',
                Path.DirectorySeparatorChar));
        }

        private static Version GetVersion(string filePath)
        {
            switch (Path.GetExtension(filePath))
            {
                case ".dll":
                case ".exe":
                    return GetAssemblyVersion(filePath);
                default:
                    return GetGenericVersion(filePath);
            }
        }

        private void Initialize(string filePath, string appFolder)
        {
            if (filePath == null) throw new ArgumentNullException(nameof(filePath));
            var fileInfo = new FileInfo(filePath);

            if (fileInfo.Exists) throw new IOException(nameof(filePath));

            FileName = fileInfo.Name;
            Extension = fileInfo.Extension;
            Data = File.ReadAllBytes(filePath);
            Hash = GetMd5Hash(Data);
            Version = GetVersion(filePath);
            Size = fileInfo.Length;
            Description = GetDescription(filePath);
            FolderPath = GetRelativePath(filePath, appFolder);
            UploadPath = filePath;
        }
        #endregion
    }
}