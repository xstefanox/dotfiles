# WII hd mount point
if [[ $OSTYPE == darwin* ]]
then
  export PATH=/Volumes/WII/bin:$PATH
else
  export PATH=/media/WII/bin:$PATH
fi

## Size of a Nintendo WII ISO image
export WII_ISO_SIZE="4699979776"
