#!/usr/bin/env bash

if which procs &> /dev/null
then
   source <(procs --gen-completion-out bash)
fi
