#!/bin/bash

############
## PYTHON ##
############

# configure python path for every installed version
for full_version in $(compgen -c | if [[ $OSTYPE == darwin* ]]
then
    sed -n -E '/^python[[:digit:]]\.[[:digit:]]+$/ p'
else
    sed -n -r '/^python[[:digit:]]\.[[:digit:]]+$/ p'
fi | sort --version-sort)
do
    version=${full_version/python/}
    short_version=${version/./}
    site_packages_path=$HOME/.eggs/$version/site-packages

    export PYTHONPATH$short_version=$site_packages_path
    export PYTHONBINPATH$short_version=$site_packages_path/bin
    export PATH=$site_packages_path/bin:$PATH
    export PYTHONPATH=$site_packages_path:$PYTHONPATH

    # make pip use the default paths and install every egg into the user home

    if [[ $version =~ ^3 ]]
    then
        pip_bin=pip3
    else
        pip_bin=pip
    fi

    eval "function pip$version()
    {
        local target_var=PYTHONPATH$short_version

        if [[ \$1 == install ]]
        then
            $pip_bin \$@  --only-binary=:all: --python-version $short_version --target \${!target_var}
        else
            $pip_bin \$@
        fi
    }" && export -f pip$version
done

unset full_version version short_version site_packages_path pip_bin
