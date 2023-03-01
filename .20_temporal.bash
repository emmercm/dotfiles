__temporal_completions() {
    # NOTE: `autoload -Uz compinit && compinit` will need to happen before sourcing any of these!

    if [[ -x "$(command -v tctl)" ]]; then
        tctl() {
            unset -f "$0"
            # shellcheck disable=SC1090
            source <(tctl completion "$(basename "$(ps -o comm= $$)")")
            $0 "$@"
        }
    fi
}
__temporal_completions


__tctl_funcs() {
    __tctl_table() {
        local columns=$1
        shift
        local column_count=$(echo "${columns}" | tr '|' '\n' | wc -l | awk '{print $1}')

        local tctl_output=$(tctl "$@" 2>&1)
        if [[ $? -ne 0 ]]; then
            echo "${tctl_output}"
            return 1
        fi
        tctl_output=$(echo "${tctl_output}" | grep -E "^(${columns}):")

        local temp_sep=';'
        local column_headers=$(echo "${tctl_output}" | head -${column_count} | awk '{print $1}')
        {
            echo "${column_headers}"
            echo "${tctl_output}" | sed 's/^[^:]*: //g'
        } | awk "{printf(\"%s%s\",\$0,NR%${column_count}?\"${temp_sep}\":\"\n\")}" | column -t -s "${temp_sep}" | awk 'NR<2{print $0;next}{print $0 | "sort"}' 
    }

    tnamespace() {
        __tctl_table "Name|State|Retention|ActiveClusterName|Clusters|IsGlobalNamespace" "$@" namespace list
    }
    alias tns=tnamespace
}
__tctl_funcs
