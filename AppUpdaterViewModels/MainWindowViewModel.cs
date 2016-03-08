using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using System.Windows.Input;
using AppUpdaterDataAccess;
using AppUpdaterModels;
using CB.Model.Common;


namespace AppUpdaterViewModels
{
    public class MainWindowViewModel: ViewModelBase
    {
        #region Fields
        private SysApplication[] _applications;
        private readonly AppUpdaterContext _appUpdaterContext = new AppUpdaterContext();
        private bool _canLoad;
        private IEnumerable<AppFile> _files;
        private ICommand _initializeAsyncCommand;
        private ICommand _initializeCommand;
        private ICommand _loadAsyncCommand;
        private ICommand _loadCommand;
        private SysApplication _selectedApplication;
        #endregion


        #region  Properties & Indexers
        public SysApplication[] Applications
        {
            get { return _applications; }
            private set { SetProperty(ref _applications, value); }
        }

        public bool CanLoad
        {
            get { return _canLoad; }
            private set { SetProperty(ref _canLoad, value); }
        }

        public IEnumerable<AppFile> Files
        {
            get { return _files; }
            private set { SetProperty(ref _files, value); }
        }

        public ICommand InitializeAsynCommand
            => GetCommand(ref _initializeAsyncCommand, async _ => await InitializeAsync());

        public ICommand InitializeCommand => GetCommand(ref _initializeCommand, _ => Initialize());

        public ICommand LoadAsynCommand
            => GetCommand(ref _loadAsyncCommand, async _ => await LoadAsync(), _ => CanLoad);

        public ICommand LoadCommand => GetCommand(ref _loadCommand, _ => Load(), _ => CanLoad);

        public SysApplication SelectedApplication
        {
            get { return _selectedApplication; }
            set { SetProperty(ref _selectedApplication, value); }
        }
        #endregion


        #region Methods
        public void Initialize()
        {
            Applications = _appUpdaterContext.ListApplications().ToArray();
            if (Applications.Any()) SelectedApplication = Applications.First();
        }

        public async Task InitializeAsync() => await Task.Run(() => Initialize());

        public void Load() { }

        public async Task LoadAsync() => await Task.Run(() => Load());
        #endregion
    }
}