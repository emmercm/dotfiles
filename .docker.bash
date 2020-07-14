# Execute `sh` interactively in an Alpine container
alias dalpine="docker run --interactive --tty alpine:latest sh --"

# Execute `bash` interactively in the Docker container
# @param {string} $1 Container name
dbash() {
    docker exec --interactive --tty "$1" -- bash
}

# Execute `bash` interactively in a Debian container
alias ddebian="docker run --interactive --tty debian:latest bash --"

# Get the digest hash of a Docker image
# @param {string} $1 name[:tag|@digest]
dhash() {
    docker pull "$1" &> /dev/null || true
    docker inspect --format='{{index .RepoDigests 0}}' "$1" | awk -F "@" '{print $2}'
}

# Kill all running Docker containers
dkillall() {
    docker kill $(docker ps --quiet) 2> /dev/null || true
}

# List all layers of a Docker container
# @param {string} $1 name[:tag|@digest]
dlayers() {
    docker pull "$1" &> /dev/null || true
    docker inspect --format '{{range .RootFS.Layers}}{{println .}}{{end}}' "$1"
}

# Kill all running Docker containers and delete all container data
alias dprune="dkillall && docker system prune --all --force && docker images purge"

# Execute `sh` interactively in the Docker container
# @param {string} $1 Container name
dsh() {
    docker exec --interactive --tty "$1" -- sh
}
