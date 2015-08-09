#!/bin/bash

############
## DOCKER ##
############

alias docker-purge-images='docker rmi $(docker images -q)'
alias docker-purge-containers='docker rm $(docker ps -a -q)'
