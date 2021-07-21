export BUILDKIT_PROGRESS=plain
export PROGRESS_NO_TRUNC=1


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

# Execute `gremlin` interactively in a TinkerPop container
alias gremlin="docker run --interactive --tty tinkerpop/gremlin-console:latest gremlin --"

# Kill a Docker container
# @param {string} $1 Container name
dkill() {
    docker kill "$1"
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

# Run an instance of the MySQL container (username: root)
alias dmysql="docker run --env MYSQL_ROOT_PASSWORD=password --publish 3306:3306 --detach mysql:latest"

# Run an instance of the PostgreSQL container (username: postgres)
alias dpostgres="docker run --env POSTGRES_PASSWORD=password --publish 5432:5432 --detach postgres:latest"
alias dpostgresql="dpostgres"

# Kill all running Docker containers and delete all container data
alias dprune="dkillall && docker system prune --all --force && docker images purge"

# List all Docker containers
alias dps="docker ps"

# Remove a Docker container
# @param {string} $1 Container name
drm() {
    docker rm --force "$1" 
}

# Remove all Docker containers
drmall() {
    docker rm --force $(docker ps --quiet) 2> /dev/null || true
}

# Remove a Docker container and its volumes
# @param {string} $1 Container name
drmv() {
    docker rm --force --volumes "$1"
}

# Execute `sh` interactively in the Docker container
# @param {string} $1 Container name
dsh() {
    docker exec --interactive --tty "$1" sh --
}

# Execute `bash` interactively in a Ubuntu container
alias dubuntu="docker run --interactive --tty ubuntu:latest bash --"
