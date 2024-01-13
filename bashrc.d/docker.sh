#!/bin/bash

############
## DOCKER ##
############

alias docker-purge-images='docker rmi $(docker images -q)'
alias docker-purge-containers='docker ps --all --format {{.ID}} | xargs docker rm --force'
alias docker-purge-volumes='docker volume ls --format {{.Name}} | xargs docker volume rm'
alias docker-purge-tc-containers='docker ps --all --format {{.ID}} --filter label=org.testcontainers=true | xargs docker rm --force --volumes'
alias docker-purge-tc-networks='docker network ls --format {{.ID}} --filter label=org.testcontainers=true | xargs docker network rm'
alias docker-purge-stopped-containers='docker ps --all --format {{.ID}} --filter "status=exited" | xargs docker rm --force'
