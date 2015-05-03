#!/bin/bash

#########################
## DESKTOP PREFERENCES ##
#########################

function apply-preferences()
{
  ## Mac OSX
  if [[ $OSTYPE == darwin* ]]
  then

      ## do not write useless trash to samba shares
      defaults write com.apple.desktopservices DSDontWriteNetworkStores true

      ## disable the warning when changing a file extension
      defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

      ## don't run anything on X11/XQuartz opening
      defaults write org.x.X11 app_to_run /usr/bin/true
      defaults write org.macosforge.xquartz.X11 app_to_run /usr/bin/true

      ## disable the Dashboard
      defaults write com.apple.dashboard mcx-disabled -bool true

      ## disable previews in Mail attachments
      defaults write com.apple.mail DisableInlineAttachmentViewing -bool yes

  ## Linux
  else

      ## Preferences requiring an active X11 session
      if [[ -n "$DISPLAY" ]]
      then
          ## on Ubuntu
          if which lsb_release &> /dev/null && [[ "$(lsb_release --id --short)" == Ubuntu ]]
          then
              # on current Ubuntu releases
              if [[ "$(lsb_release --release --short)" > '12.04' ]]
              then

                  # disable the Unity scrollbar
                  gsettings set com.canonical.desktop.interface scrollbar-mode normal

              # on 12.04 or older releases
              else

                  # disable the Unity scrollbar
                  gsettings set org.gnome.desktop.interface ubuntu-overlay-scrollbars false
              fi
          fi

          # desktop preferences: MATE
          if gsettings list-schemas | grep org.mate.caja &> /dev/null
          then
              gsettings set org.mate.background       show-desktop-icons    true
              gsettings set org.mate.caja.desktop     computer-icon-visible false
              gsettings set org.mate.caja.desktop     home-icon-visible     false
              gsettings set org.mate.caja.desktop     network-icon-visible  false
              gsettings set org.mate.caja.desktop     trash-icon-visible    false
              gsettings set org.mate.caja.desktop     volumes-visible       false
              gsettings set org.mate.caja.preferences default-folder-viewer list-view
              gsettings set org.mate.caja.list-view   default-zoom-level    smallest
              # @fixme
              #gsettings set org.gnome.desktop.interface    monospace-font-name   'Ubuntu Mono 11'
              #gsettings set org.gnome.desktop.interface    font-name             'Ubuntu 10'
              #gsettings set org.gnome.desktop.interface   document-font-name    'Sans 11'
              #gsettings set org.gnome.nautilus.desktop    font                  ''
          fi

          # desktop preferences: Cinnamon
          if gsettings list-schemas | grep org.nemo.desktop &> /dev/null
          then
              # the following setting make Cinnamon 2.4 crash
              #gsettings set org.nemo.desktop               show-desktop-icons    true
              gsettings set org.nemo.desktop               computer-icon-visible false
              gsettings set org.nemo.desktop               home-icon-visible     false
              gsettings set org.nemo.desktop               network-icon-visible  false
              gsettings set org.nemo.desktop               trash-icon-visible    false
              gsettings set org.nemo.desktop               volumes-visible       false
              gsettings set org.nemo.preferences           default-folder-viewer list-view
              gsettings set org.nemo.list-view             default-zoom-level    smallest
              gsettings set org.gnome.desktop.interface    monospace-font-name   'Ubuntu Mono 11'
              gsettings set org.cinnamon.desktop.interface font-name             'Ubuntu 10'
              gsettings set org.gnome.desktop.interface    document-font-name    'Sans 9'
              #gsettings set org.nemo.desktop              font                  ''
          fi

          # desktop preferences: Gnome/Unity
          if gsettings list-schemas | grep org.gnome.nautilus.preferences &> /dev/null
          then
              # apply only if no Cinnamon session is running, othrwise it will also replace the desktop background image
              if [[ -z "${CINNAMON_VERSION}" ]]
              then
                  gsettings set org.gnome.desktop.background   show-desktop-icons    true
              fi

              # the key org.gnome.nautilus.desktop.computer-icon-visible may not exists on some systems
              if gsettings get org.gnome.nautilus.desktop computer-icon-visible &> /dev/null
              then
                  gsettings set org.gnome.nautilus.desktop     computer-icon-visible false
              fi

              gsettings set org.gnome.nautilus.desktop     home-icon-visible     false
              gsettings set org.gnome.nautilus.desktop     network-icon-visible  false
              gsettings set org.gnome.nautilus.desktop     trash-icon-visible    false
              gsettings set org.gnome.nautilus.desktop     volumes-visible       false
              gsettings set org.gnome.nautilus.preferences default-folder-viewer list-view
              gsettings set org.gnome.nautilus.list-view   default-zoom-level    smallest
              gsettings set org.gnome.desktop.interface    monospace-font-name   'Ubuntu Mono 11'
              gsettings set org.gnome.desktop.interface    font-name             'Ubuntu 10'
              gsettings set org.gnome.desktop.interface    document-font-name    'Sans 9'
              #gsettings set org.gnome.nautilus.desktop    font                  ''

              # move the window buttons to the right
              gsettings set org.gnome.desktop.wm.preferences button-layout ':minimize,maximize,close'

              # set only one workspace
              gsettings set org.gnome.desktop.wm.preferences num-workspaces 1

          fi

          # gedit preferences
          if gsettings list-schemas | grep org.gnome.gedit.preferences.editor &> /dev/null
          then
              gsettings set org.gnome.gedit.preferences.editor tabs-size            4
              gsettings set org.gnome.gedit.preferences.editor insert-spaces        true
              gsettings set org.gnome.gedit.preferences.editor create-backup-copy   false
              gsettings set org.gnome.gedit.preferences.editor display-line-numbers true
              gsettings set org.gnome.gedit.preferences.editor auto-indent          true
              gsettings set org.gnome.gedit.preferences.editor wrap-mode            'none'
              gsettings set org.gnome.gedit.preferences.editor display-line-numbers true
              gsettings set org.gnome.gedit.preferences.editor scheme               'tango'
          fi

          # gnome-terminal preferences
          gconftool --set /apps/gnome-terminal/profiles/Default/use_theme_colors    --type boolean false
          gconftool --set /apps/gnome-terminal/profiles/Default/background_type     --type string  transparent
          gconftool --set /apps/gnome-terminal/profiles/Default/background_darkness --type float   0.95
          gconftool --set /apps/gnome-terminal/profiles/Default/background_color    --type string  "#0F4F199901B4"
          gconftool --set /apps/gnome-terminal/profiles/Default/foreground_color    --type string  "#D3D3D7D7CFCF"

      fi

  fi
}
