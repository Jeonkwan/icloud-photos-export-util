# icloud-photos-export-util

Create environment
```bash
# install git and python3
xcode-select --install

# create shared virtual env
sudo python3 -m venv /etc/py-venv-photo-export
source /etc/py-venv-photo-export/bin/activate
sudo pip install osxphotos
```

function to add in `~/.zshrc` or `~/.bashrc`
```bash
setup_photo_export() {
    echo "==> Activating Python Virtual Env"
    source /etc/py-venv-photo-export/bin/activate
    echo "==> Importing export functions"
    source $HOME/icloud-photos-export-util/export_command.sh
    echo "====== Export by year ======"
    echo "photos_export <TARGET_DIR> <YEAR>"
    echo "Example:\n\t photos_export ~/Downloads/photos-export 2012\n\n"
    echo "====== Export by season ======"
    echo "photos_export <TARGET_DIR> <YEAR> <SEASON>"
    echo "Example:\n\t photos_export ~/Downloads/photos-export 2014 1\n\n"
    echo "====== Export by month per season ======"
    echo "photos_export <TARGET_DIR> <YEAR> <SEASON> split"
    echo "Example: exporting season one into 3 months\n\t photos_export ~/Downloads/photos-export 2014 1 split\n\n"
}
```

open your terminal run:
```bash
setup_photo_export
```
then follow the example to run the `photos_export` function
