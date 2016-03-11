using System;
using CB.Model.Common;


namespace AppUpdaterModels
{
    public class SysApplication: ObservableObject
    {
        #region Fields
        private int? _applicationId;
        private string _applicationName;

        private bool _canSave;
        private string _description;
        private Version _version;
        #endregion


        #region  Properties & Indexers
        public int? ApplicationId
        {
            get { return _applicationId; }
            set { SetProperty(ref _applicationId, value); }
        }

        public string ApplicationName
        {
            get { return _applicationName; }
            set { if (SetProperty(ref _applicationName, value)) UpdateCanSave(); }
        }

        public bool CanSave
        {
            get { return _canSave; }
            private set { SetProperty(ref _canSave, value); }
        }

        public string Description
        {
            get { return _description; }
            set { SetProperty(ref _description, value); }
        }

        public Version Version
        {
            get { return _version; }
            set { SetProperty(ref _version, value); }
        }
        #endregion


        #region Implementation
        private void UpdateCanSave()
        {
            CanSave = !string.IsNullOrEmpty(ApplicationName);
        }
        #endregion
    }
}