__mysql_setup() {
    # Set path environment variables
    if command -v brew &> /dev/null; then
        while read -r DIR; do
            [[ -z "${DIR}" ]] && continue
            if [[ -d "${DIR}/bin" ]]; then
                export PATH="${DIR}/bin:${PATH}"
            fi
        done <<< "$(find "${HOMEBREW_PREFIX}/opt" -maxdepth 1 -follow -type d -name "mysql-client*")"
    fi
}
__mysql_setup


__mysql_lazy_install() {
    if ! command -v mysql &> /dev/null && command -v brew &> /dev/null; then
        mysql() {
            brew install mysql-client
            __mysql_setup
            unset -f mysql
            mysql "$@"
        }
    fi
}
__mysql_lazy_install
