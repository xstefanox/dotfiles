#!/bin/bash

############
## DOCKER ##
############

alias docker-purge-images='docker rmi $(docker images -q)'
alias docker-purge-containers='docker rm $(docker ps -a -q)'
alias docker-purge-volumes='docker volume ls --format {{.Name}} | xargs docker volume rm'
alias docker-purge-testcontainers='docker ps -a --format {{.ID}} --filter label=org.testcontainers=true | xargs docker rm -f'
