# Execute `sh` interactively in an Alpine container
alias dalpine="docker run --interactive --tty alpine:latest sh --"

# Execute `bash` interactively in the Docker container
# @param {string} $1 Container name
dbash() {
    docker exec --interactive --tty "$1" bash --
}

# Execute `bash` interactively in a Debian container
alias ddebian="docker run --interactive --tty debian:latest bash --"

# Get the digest hash of a Docker image
# @param {string} $1 name[:tag][@digest]
ddigest() {
    if [[ -x "$(command -v skopeo)" ]]; then
        skopeo inspect --raw "docker://$1" | shasum --algorithm 256 | awk '{print "sha256:"$1}'
    else
        docker pull "$1" &> /dev/null || true
        docker inspect --format '{{index .RepoDigests 0}}' "$1" | awk -F "@" '{print $2}'
    fi
}

# Kill all running Docker containers
dkillall() {
    docker kill $(docker ps --quiet) 2> /dev/null || true
}

# List all layers of a Docker container
# @param {string} $1 name[:tag][@digest]
dlayers() {
    docker pull "$1" &> /dev/null || true
    docker inspect --format '{{range .RootFS.Layers}}{{println .}}{{end}}' "$1"
}

# Follow the logs from a Docker container
# @param {string} $1 Container name
# @param {number=} $2 Tail length
dlogs() {
    docker logs --tail ${2:-0} --follow "$1"
}

# Kill all running Docker containers and delete all container data
alias dprune="dkillall && docker system prune --all --force && docker images purge"

# List all Docker containers
alias dps="docker ps"

# Execute `sh` interactively in the Docker container
# @param {string} $1 Container name
dsh() {
    docker exec --interactive --tty "$1" sh --
}

# Execute `bash` interactively in a Ubuntu container
alias dubuntu="docker run --interactive --tty ubuntu:latest bash --"
