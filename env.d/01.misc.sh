## home binary path
path_prepend "$HOME/.local/bin"

## Maximum allowed file size on a FAT32 filesystem
export FAT32_MAX_FILE_SIZE="$((2**32 - 1))"

## make history ignore commands starting with a space
export HISTIGNORE=' *'
