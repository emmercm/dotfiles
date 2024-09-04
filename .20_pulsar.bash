# @see https://archive.apache.org/dist/pulsar/
: "${PULSAR_STANDALONE_DIR:=${HOME}/Downloads/apache-pulsar-3.0.0}"

if [[ -d "${PULSAR_STANDALONE_DIR}" ]]; then
    if [[ -f "${PULSAR_STANDALONE_DIR}/pulsar-admin" ]]; then
        PULSAR_STANDALONE_DIR=${PULSAR_STANDALONE_DIR}/..
    fi
    export PATH="${PATH}:${PULSAR_STANDALONE_DIR}/bin"
fi


__pulsar_jre() {
    pulsar-shell() {
        if [[ -x /usr/libexec/java_home ]]; then
            # We need JRE v17+ for class file v61.0+
            # shellcheck disable=SC2034
            JAVA_HOME=$(/usr/libexec/java_home -v 17 2> /dev/null)
        fi
        command pulsar-shell "$@"
    }
}
__pulsar_jre


__pulsar_admin() {
    # pulsar-admin() {
    #     command pulsar-admin \
    #         ${PULSAR_ADMIN_URL:+--admin-url "${PULSAR_ADMIN_URL}"} \
    #         ${PULSAR_AUTH_PARAMS:+--auth-params "${PULSAR_AUTH_PARAMS}"} \
    #         ${PULSAR_AUTH_PLUGIN:+--auth-plugin "${PULSAR_AUTH_PLUGIN}"} \
    #         "$@"
    # }

    alias pclusters="pulsar-admin clusters list"
    alias pc=pclusters

    alias pnamespaces="pulsar-admin namespaces list"
    alias pn=pnamespaces

    alias pshell=pulsar-shell

    alias ptenants="pulsar-admin tenants list"
    alias pt=ptenants

    alias ptopics="pulsar-admin topics list"
    alias pt=ptopics
}
__pulsar_admin
