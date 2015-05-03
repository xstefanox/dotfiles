#!/bin/bash

############
## APACHE ##
############

if which apache2ctl &> /dev/null
then
    [[ $UID != 0 ]] && alias a2enmod='sudo a2enmod'
    [[ $UID != 0 ]] && alias a2ensite='sudo a2ensite'
    [[ $UID != 0 ]] && alias a2dismod='sudo a2dismod'
    [[ $UID != 0 ]] && alias a2dissite='sudo a2dissite'
    [[ $UID == 0 ]] && alias a2vhosts='apache2ctl -t -D DUMP_VHOSTS' || alias a2vhosts='sudo apache2ctl -t -D DUMP_VHOSTS'
    [[ $UID == 0 ]] && alias a2modules='apache2ctl -t -D DUMP_MODULES' || alias a2modules='sudo apache2ctl -t -D DUMP_MODULES'

    # an utility function to generate virtual hosts configuration files
    function a2genvhost()
    {
        local server_name=$1
        local document_root=$2
        local force=$3
        local vhosts_path="/etc/apache2/sites-available"
        local file_ext

        [[ -z "${server_name}" || -z "${document_root}" ]] && echo "Usage: ${FUNCNAME} <server_name> <document_root> [--force]" && return 1

        if [[ $(apache2 -v | sed -n '/Server version/ s:.*/[[:digit:]]\+\.\([[:digit:]]\+\).*:\1: p') -ge 4 ]]
        then
            file_ext=".conf"
        fi

        [[ -e "${vhosts_path}/${server_name}${file_ext}" && "${force}" != "--force" ]] && echo "VirtualHost ${server_name} already exists" && return 1

        groupname="$(groups | awk '{ print $1 }')"

        vhost_content="$(cat << __EOT__
<VirtualHost *:80>

    ServerName ${server_name}.localhost
    DocumentRoot ${document_root}

    ## drop rights if possible
    <IfModule mpm_itk_module>
        AssignUserId ${USER} ${groupname}
    </IfModule>

    ## configure logging
    ErrorLog  \${APACHE_LOG_DIR}/${server_name}.localhost_error.log
    CustomLog \${APACHE_LOG_DIR}/${server_name}.localhost_access.log combined

    ## configure the document root
    <Directory ${document_root}>

        Options Indexes FollowSymlinks MultiViews
        AllowOverride all

        ## Apache 2.4
        <IfModule mod_authz_core.c>
            Require all granted
        </IfModule>

        ## Apache 2.2
        <IfModule !mod_authz_core.c>
            Order allow,deny
            Allow from all
        </IfModule>

    </Directory>

</VirtualHost>

__EOT__
)"

        if [[ $UID != 0 ]]
        then
            echo "${vhost_content}" | sudo tee "${vhosts_path}/${server_name}${file_ext}" &> /dev/null
        else
            echo "${vhost_content}" > "${vhosts_path}/${server_name}${file_ext}"
        fi

        echo "VirtualHost configured, reload Apache to enable"
    }
fi
