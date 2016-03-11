using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using AppUpdaterDataAccess;
using AppUpdaterModels;
using CB.Model.Common;


namespace AppUpdaterViewModels
{
    public class FileUpdaterViewModel: ViewModelBase
    {
        #region Fields
        private SysApplication _application;
        private readonly AppUpdaterContext _appUpdaterContext = new AppUpdaterContext();
        private IEnumerable<AppFile> _files;
        #endregion


        #region  Properties & Indexers
        public SysApplication Application
        {
            get { return _application; }
            set { SetProperty(ref _application, value); }
        }

        public IEnumerable<AppFile> Files
        {
            get { return _files; }
            set { SetProperty(ref _files, value); }
        }
        #endregion


        #region Methods
        public void Save()
        {
            Files.AsParallel().ForAll(f => _appUpdaterContext.SaveApplicationFile(Application, f));
        }

        public async Task SaveAsync() => await Task.Run(() => Save());
        #endregion
    }
}