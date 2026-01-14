##### https://www.docker.com

export BUILDKIT_PROGRESS=plain
export PROGRESS_NO_TRUNC=1


__docker_lazy_install() {
    if ! command -v dive &> /dev/null && command -v brew &> /dev/null; then
        dive() {
            brew install dive
            unset -f "$0"
            $0 "$@"
        }
    fi

    if ! command -v skopeo &> /dev/null && command -v brew &> /dev/null; then
        skopeo() {
            brew install skopeo
            unset -f "$0"
            $0 "$@"
        }
    fi
}
__docker_lazy_install


__docker_funcs() {
    # Auto/lazy-start Docker if it's not running
    if command -v docker &> /dev/null; then
        docker() {
            if [[ "${OSTYPE:-}" == "darwin"* ]]; then
                # macOS
                ps axo pid,command | grep -v grep | grep -q /Applications/Docker.app/Contents/MacOS/Docker || (
                    open --background -a Docker
                    while true; do
                        command docker ps &> /dev/null && break
                        sleep 1
                    done
                )
            fi
            command docker "$@"
        }

        alias docker-compose="docker compose --compatibility"
    elif command -v docker-compose &> /dev/null; then
        docker-compose() {
            docker ps &> /dev/null # start
            command docker-compose "$@"
        }
    fi
    # Start docker before commands that need it
    for command in \
        dive \
        tilt \
    ; do if command -v "${command}" &> /dev/null; then
        # shellcheck disable=SC2139
        alias "${command}"="docker ps &> /dev/null; command \"${command}\""
    fi; done

    # Execute `sh` interactively in an Alpine container
    alias dalpine="docker run --interactive --tty --rm alpine:latest sh --"

    # Execute `bash` interactively in the Docker container
    # @param {string} $1 Container name
    dbash() {
        docker exec --interactive --tty "$1" bash --
    }

    # Get the digest hash of a Docker image
    # @param {string} $1 name[:tag][@digest]
    ddigest() {
        if command -v skopeo &> /dev/null; then
            skopeo inspect --raw "docker://$1" | shasum --algorithm 256 | awk '{print "sha256:"$1}'
        else
            docker pull "$1" &> /dev/null || true
            docker inspect --format '{{index .RepoDigests 0}}' "$1" | awk -F "@" '{print $2}'
        fi
    }

    # Kill a Docker container
    # @param {string} $1 Container name
    alias dkill="docker kill"

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
        docker logs --tail "${2:-0}" --follow "$1"
    }

    # Kill all running Docker containers and delete all container data
    alias dprune="dkillall && docker volume prune --force && docker system prune --all --force && docker images purge"

    # List all Docker containers
    alias dps="docker ps"

    # Remove a Docker container
    # @param {string} $1 Container name
    alias drm="docker rm --force"

    # Remove all Docker containers
    drmall() {
        docker rm --force "$(docker ps --quiet)" 2> /dev/null || true
    }

    # Remove a Docker container and its volumes
    # @param {string} $1 Container name
    alias drmv="docker rm --force --volumes"

    # Execute `sh` interactively in the Docker container
    # @param {string} $1 Container name
    dsh() {
        docker exec --interactive --tty "$1" sh --
    }

    # Run a "top"-like stream of Docker container stats
    alias dstats="docker stats"
    alias dtop="dstats"
}
__docker_funcs


__docker_containers() {
    # Execute `bash` interactively in a Debian container
    alias ddebian="docker run --interactive --tty --rm debian:latest bash --"

    # Execute `sh` interactively in a Flink container
    # @param {string=} $1 Image tag
    dflink() {
        docker run --interactive --tty --rm "${@:2}" "flink:${1:-latest}" sh --
    }

    # Execute `gremlin` interactively in a TinkerPop container
    # @param {string=} $1 Image tag
    dgremlin() {
        docker run --interactive --tty --rm "${@:2}" "tinkerpop/gremlin-console:${1:-latest}" gremlin --
    }

    # Execute `sh` interactively in a Docker-in-Docker container
    alias dind="docker run --interactive --tty --rm docker:dind sh --"

    # Execute `jshell` interactively in a Java JDK container
    # @param {string=} $1 Image tag
    djava() {
        if [[ "${1:-}" == "" ]] && command -v java &> /dev/null; then
            set -- "$(java --version | head -1 | sed 's/"//g' | sed -E 's/(.* )?([0-9]+)\.[0-9]+\.[0-9]+.*/\2/')"
        fi

        if [[ -z "$1" || "${1:-}" -ge 9 ]]; then
            docker run --interactive --tty --rm "${@:2}" "openjdk:${1:-latest}" jshell
        else
            docker run --interactive --tty --rm "${@:2}" "openjdk:$1" bash -c "wget --quiet https://github.com/beanshell/beanshell/releases/download/2.1.0/bsh-2.1.0.jar && java -cp bsh-*.jar bsh.Interpreter"
        fi
    }

    # Execute `mysql` interactively in a MySQL server container
    # @param {string=} $1 Image tag
    dmysql() {
        local container_id
        container_id=$(docker run --rm --env MYSQL_ROOT_PASSWORD=password --detach "mysql:${1:-latest}") &&
            docker exec "${container_id}" mysqladmin ping --wait &&
            until docker exec "${container_id}" mysqladmin --password=password status &> /dev/null ; do sleep 1 ; done &&
            docker exec --interactive --tty "${container_id}" mysql --password=password --database=mysql &&
            docker rm --force --volumes "${container_id}" > /dev/null
    }

    # Run a detached instance of the MySQL server container (username: root)
    # REPL: mysql --host=127.0.0.1 --port 3306 --user=root --password=password --database=mysql
    # @param {string=} $1 Image tag
    dmysqld() {
        docker run --rm --env MYSQL_ROOT_PASSWORD=password --publish 3306:3306 --detach "${@:2}" "mysql:${1:-latest}"
    }

    # Execute `bash` interactively in a Node.js container
    # @param {string=} $1 Image tag
    dnode() {
        docker run --interactive --tty --rm "${@:2}" "node:${1:-latest}" bash --
    }

    # Execute `psql` interactively in a PostgreSQL server container
    # @param {string=} $1 Image tag
    dpostgres() {
        local container_id
        container_id=$(docker run --rm --env POSTGRES_PASSWORD=password --detach "postgres:${1:-latest}") &&
            until docker exec "${container_id}" pg_isready ; do sleep 1 ; done &&
            docker exec --interactive --tty "${container_id}" psql --username postgres &&
            docker rm --force --volumes "${container_id}" > /dev/null
    }
    alias dpostgresql="dpostgres"

    # Run a detached instance of the PostgreSQL server container (username: postgres)
    # @param {string=} $1 Image tag
    dpostgresd() {
        docker run --rm --env POSTGRES_PASSWORD=password --publish 5432:5432 --detach "${@:2}" "postgres:${1:-latest}"
    }
    alias dpostgresqld="dpostgres"

    # Execute `bash` interactively in a Ubuntu container
    alias dubuntu="docker run --interactive --tty --rm ubuntu:latest bash --"
}
__docker_containers