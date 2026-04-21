##### https://www.java.com/en/

__java_setup() {
    if [[ "${JAVA_HOME:-}" == "" && -x /usr/libexec/java_home ]]; then
        JAVA_HOME=$(/usr/libexec/java_home 2> /dev/null)
        export JAVA_HOME
    fi
    if [[ "${JAVA_HOME:-}" == "" ]]; then
        while read -r DIR; do
            [[ -z "${DIR}" ]] && continue
            export JAVA_HOME="${DIR}"
        done <<< "$(find /Library/Java/JavaVirtualMachines/*/Contents -maxdepth 1 -type d -name Home 2> /dev/null | sort --version-sort)"
    fi

    jversion() {
        java --version | head -1 | sed 's/"//g' | sed -E 's/(.* )?([0-9]+\.[0-9]+\.[0-9]+[^ ]+).*/\2/'
    }
}
__java_setup


__java_lazy_install() {
    if ! command -v flyway &> /dev/null && command -v brew &> /dev/null; then
        flyway() {
            brew install flyway
            unset -f flyway
            flyway "$@"
        }
    fi
}
__java_lazy_install


__java_funcs() {
    jversion() {
        java --version | head -1 | sed 's/"//g' | sed -E 's/(.* )?([0-9]+\.[0-9]+\.[0-9]+[^ ]+).*/\2/'
    }
}
__java_funcs
