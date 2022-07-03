export BUILDKIT_PROGRESS=plain
export PROGRESS_NO_TRUNC=1


__docker_completions() {
    if [[ -x "$(command -v brew)" && -d "/Applications/Docker.app" && -z "$(find "$(brew --prefix)/etc/bash_completion.d" -maxdepth 1 -name "docker*")" ]]; then
        find "/Applications/Docker.app" -follow -type f -name "*.bash-completion" -exec ln -sf "{}" "$(brew --prefix)/etc/bash_completion.d/" \;
    fi
}
__docker_completions


__docker_funcs() {
    # Auto/lazy-start Docker if it's not running
    if [[ -x "$(command -v docker)" ]]; then
        docker() {
            local docker
            docker=$(pinpoint docker)
            if [[ "${OSTYPE:-}" == "darwin"* ]]; then
                # macOS
                ps axo pid,command | grep -v grep | grep --quiet /Applications/Docker.app/Contents/MacOS/Docker || (
                    open --background -a Docker
                    while true; do
                        "${docker}" ps &> /dev/null && break
                        sleep 1
                    done
                )
            fi
            "${docker}" "$@"
        }
    fi
    if [[ -x "$(command -v docker-compose)" ]]; then
        docker-compose() {
            docker ps &> /dev/null # start
            "$(pinpoint docker-compose)" "$@"
        }
    fi

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
    # @param {string=} $1 Image tag
    dgremlin() {
        docker run --interactive --tty "tinkerpop/gremlin-console:${1:-latest}" gremlin --
    }

    # Execute `sh` interactively in a Docker-in-Docker container
    alias dind="docker run --interactive --tty docker:dind sh --"

    # Execute `jshell` interactively in a Java JDK container
    # @param {string=} $1 Image tag
    djava() {
        if [[ "${1:-}" == "" && -x "$(command -v java)" ]]; then
            set -- "$(java --version | head -1 | sed 's/"//g' | sed -E 's/(.* )?([0-9]+)\.[0-9]+\.[0-9]+.*/\2/')"
        fi

        if [[ -z "$1" || "${1:-}" -ge 9 ]]; then
            docker run --interactive --tty "openjdk:${1:-latest}" jshell
        else
            docker run --interactive --tty "openjdk:$1" bash -c "wget --quiet https://github.com/beanshell/beanshell/releases/download/2.1.0/bsh-2.1.0.jar && java -cp bsh-*.jar bsh.Interpreter"
        fi
    }

    # Kill a Docker container
    # @param {string} $1 Container name
    dkill() {
        docker kill "$1"
    }

    # Kill all running Docker containers
    dkillall() {
        # shellcheck disable=SC2046
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

    # Execute `mysql` interactively in a MySQL server container
    # @param {string=} $1 Image tag
    dmysql() {
        local container_id
        container_id=$(docker run --env MYSQL_ROOT_PASSWORD=password --detach "mysql:${1:-latest}") &&
            docker exec "${container_id}" mysqladmin ping --wait && sleep 1 &&
            docker exec --interactive --tty "${container_id}" mysql --password=password &&
            docker rm --force --volumes "${container_id}" > /dev/null
    }

    # Run a detached instance of the MySQL server container (username: root)
    # @param {string=} $1 Image tag
    dmysqld() {
        docker run --env MYSQL_ROOT_PASSWORD=password --publish 3306:3306 --detach "mysql:${1:-latest}"
    }

    # Execute `psql` interactively in a PostgreSQL server container
    # @param {string=} $1 Image tag
    dpostgres() {
        local container_id
        container_id=$(docker run --env POSTGRES_PASSWORD=password --detach "postgres:${1:-latest}") &&
            until docker exec "${container_id}" pg_isready ; do sleep 1 ; done &&
            docker exec --interactive --tty "${container_id}" psql --username postgres &&
            docker rm --force --volumes "${container_id}" > /dev/null
    }
    alias dpostgresql="dpostgres"

    # Run a detached instance of the PostgreSQL server container (username: postgres)
    # @param {string=} $1 Image tag
    dpostgresd() {
        docker run --env POSTGRES_PASSWORD=password --publish 5432:5432 --detach "postgres:${1:-latest}"
    }
    alias dpostgresqld="dpostgres"

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
        docker rm --force "$(docker ps --quiet)" 2> /dev/null || true
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
}
__docker_funcs
