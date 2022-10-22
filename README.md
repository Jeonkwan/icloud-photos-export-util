# icloud-photos-export-util
```bash
setup_photo_export() {
    echo "==> Activating Python Virtual Env"
    source /etc/py-venv-photo-export/bin/activate
    echo "==> Importing export functions"
    source $HOME/icloud-photos-export-util/export_command.sh
    echo "====== Export by year ======"
    echo "photos_export <TARGET_DIR> <YEAR>"
    echo "Example:\n\t photos_export ~/Downloads/photos-export 2012\n\n"
    echo "photos_export <TARGET_DIR> <YEAR> <SEASON>"
    echo "Example:\n\t photos_export ~/Downloads/photos-export 2014 1\n\n"
}
```