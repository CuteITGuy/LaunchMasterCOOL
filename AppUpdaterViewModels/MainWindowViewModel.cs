using System.Threading.Tasks;
using System.Windows.Input;
using CB.Model.Common;


namespace AppUpdaterViewModels
{
    public class MainWindowViewModel: ViewModelBase
    {
        #region Fields
        private bool _canLoad;
        private ICommand _initializeAsyncCommand;
        private ICommand _initializeCommand;
        private ICommand _loadAsyncCommand;
        private ICommand _loadCommand;
        #endregion


        #region  Properties & Indexers
        public bool CanLoad
        {
            get { return _canLoad; }
            private set { SetProperty(ref _canLoad, value); }
        }

        public ICommand InitializeAsynCommand
            => GetCommand(ref _initializeAsyncCommand, async _ => await InitializeAsync());

        public ICommand InitializeCommand => GetCommand(ref _initializeCommand, _ => Initialize());

        public ICommand LoadAsynCommand
            => GetCommand(ref _loadAsyncCommand, async _ => await LoadAsync(), _ => CanLoad);

        public ICommand LoadCommand => GetCommand(ref _loadCommand, _ => Load(), _ => CanLoad);
        #endregion


        #region Methods
        public void Initialize() { }

        public async Task InitializeAsync() => await Task.Run(() => Initialize());

        public void Load() { }

        public async Task LoadAsync() => await Task.Run(() => Load());
        #endregion
    }
}