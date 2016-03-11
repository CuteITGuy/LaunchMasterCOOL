using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Linq;
using System.Threading.Tasks;
using System.Windows.Input;
using AppUpdaterDataAccess;
using AppUpdaterModels;
using CB.Model.Common;


namespace AppUpdaterViewModels
{
    public class ApplicationRowViewModel: ViewModelBase
    {
        #region Fields
        private string _applicationFolder;
        private readonly AppUpdaterContext _appUpdaterContext = new AppUpdaterContext();
        private bool _canSave;
        private bool _canUpdate;
        private bool _isWatched;
        private ICommand _saveAsyncCommand;
        private ICommand _saveCommand;
        #endregion


        #region  Constructors & Destructor
        public ApplicationRowViewModel()
        {
            Application.PropertyChanged += Application_PropertyChanged;
        }
        #endregion


        #region  Properties & Indexers
        public SysApplication Application { get; } = new SysApplication();

        public string ApplicationFolder
        {
            get { return _applicationFolder; }
            set { if (SetProperty(ref _applicationFolder, value)) UpdateCanUpdate(); }
        }

        public bool CanSave
        {
            get { return _canSave; }
            private set { if (SetProperty(ref _canSave, value)) UpdateCanUpdate(); }
        }

        public bool CanUpdate
        {
            get { return _canUpdate; }
            private set { SetProperty(ref _canUpdate, value); }
        }

        public bool IsWatched
        {
            get { return _isWatched; }
            set { if (SetProperty(ref _isWatched, value)) ChangeWatch(); }
        }

        public ICommand SaveAsynCommand => GetCommand(ref _saveAsyncCommand, async _ => await SaveAsync(), _ => CanSave)
            ;

        public ICommand SaveCommand => GetCommand(ref _saveCommand, _ => Save(), _ => CanSave);
        #endregion


        #region Methods
        public void Save()
        {
            _appUpdaterContext.SaveApplication(Application);
        }

        public async Task SaveAsync()
        {
            CanSave = false;
            await Task.Run(() => Save());
            UpdateCanSave();
        }

        public void UpdateFiles(IEnumerable<string> files)
        {
            
        }

        public void UpdateFiles() { }

        public void UpdateFolder() { }
        #endregion


        #region Event Handlers
        private void Application_PropertyChanged(object sender, PropertyChangedEventArgs e)
        {
            if (
                !nameof(SysApplication.ApplicationName).Equals(e.PropertyName,
                    StringComparison.InvariantCultureIgnoreCase)) return;
            UpdateCanSave();
        }
        #endregion


        #region Implementation
        private void ChangeWatch()
        {
            throw new NotImplementedException();
        }

        private void UpdateCanSave() => CanSave = Application != null && Application.CanSave;

        private void UpdateCanUpdate() => CanUpdate = CanSave && !string.IsNullOrEmpty(ApplicationFolder);
        #endregion
    }
}