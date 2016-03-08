using CB.Model.Common;


namespace AppUpdaterModels
{
    public class SysApplication: ObservableObject
    {
        #region Fields
        private int? _applicationId;
        private string _applicationName;
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
            set { SetProperty(ref _applicationName, value); }
        }
        #endregion
    }
}