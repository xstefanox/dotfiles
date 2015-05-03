#!/bin/bash

##################
## LOCALIZATION ##
##################

[[ -z "$LC_ALL" && -n "$LANG" ]] && export LC_ALL="$LANG"
[[ -z "$LANG" && -n "$LC_ALL" ]] && export LANG="$LC_ALL"
