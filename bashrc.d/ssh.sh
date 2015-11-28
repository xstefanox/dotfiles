#!/bin/bash

#########
## SSH ##
#########

# wrap the ssh command to automatically restore the window title on exit
if command -v ssh &> /dev/null
then
  function ssh()
  {
      local ssh="'$(which ssh)'"
      local item
      local retval

      # quote each argument
      for item in $@
      do
          ssh+=" '${item}'"
      done

      # execute the command
      eval "${ssh}"

      # save the return value
      retval=$?

      # restore the window title
      echo -ne "\033]0;Terminal\007"

      return $retval
  }
fi
