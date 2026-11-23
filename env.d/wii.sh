# WII hd mount point
if [[ $OSTYPE == darwin* ]]
then
  path_prepend /Volumes/WII/bin
else
  path_prepend /media/WII/bin
fi

## Size of a Nintendo WII ISO image
export WII_ISO_SIZE="4699979776"
