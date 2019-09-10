#!/usr/bin/env bash

## apply the patch and do not fail if already applied

base_dir=$(dirname $0)
patch_output=$(patch -p0 -N -r /tmp/nvm-patch.rej -i ${base_dir}/nvm.sh.patch)

if [[ $? != 0 && ! $(echo "${patch_output}" | grep "2 out of 2 hunks ignored") ]]
then
    exit 1
fi
