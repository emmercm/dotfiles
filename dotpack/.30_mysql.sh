__mysql_setup() {
    # Set path environment variables
    if command -v brew &> /dev/null; then
        while read -r DIR; do
            if [[ -d "${DIR}/bin" ]]; then
                export PATH="${DIR}/bin:${PATH}"
            fi
        done <<< "$(find "${HOMEBREW_PREFIX}/opt" -maxdepth 1 -follow -type d -name "mysql-client*")"
    fi
}
__mysql_setup
