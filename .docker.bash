# Execute `sh` interactively in the Docker container
# @param {string} $1 Container name
dsh() {
    docker exec --interactive --tty "$1" -- sh
}

# Execute `bash` interactively in the Docker container
# @param {string} $1 Container name
dbash() {
    docker exec --interactive --tty "$1" -- bash
}

# Kill all running Docker containers
dkillall() {
    docker kill $(docker ps --quiet) 2> /dev/null || true
}

# Kill all running Docker containers and delete all container data
alias dprune="dkillall && docker system prune --all --force && docker images purge"