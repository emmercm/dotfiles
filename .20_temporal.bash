# Reset back to non-beta functionality
if [[ -x "$(command -v tctl)" ]]; then
    tctl config set version current
fi


__temporal_completions() {
    # NOTE: `autoload -Uz compinit && compinit` will need to happen before sourcing any of these!

    if [[ -x "$(command -v tctl)" ]]; then
        tctl() {
            unset -f "$0"
            # shellcheck disable=SC1090
            source <(tctl completion "$(basename "$(ps -o comm= $$ | sed 's/^-*//')")")
            $0 "$@"
        }

        temporal() {
            unset -f "$0"
            # shellcheck disable=SC1090
            source <(temporal completion "$(basename "$(ps -o comm= $$ | sed 's/^-*//')")")
            $0 "$@"
        }
    fi
}
__temporal_completions


__tctl_funcs() {
    __tctl_rows_to_table() {
        local columns=$1
        local column_count
        column_count=$(echo "${columns}" | tr '|' '\n' | wc -l | awk '{print $1}')

        tctl_output=$(cat)
        # v2.0.0-beta massaging: keys with two leading spaces, and values that span multiple lines (requires gsed)
        tctl_output=$(echo "${tctl_output}" | sed 's/^\s\s//m' | sed -e ':a' -e 'N' -e '$!ba' -e 's/ *\n  */ /g')
        # Only the keys we care about
        local tctl_output_filtered
        tctl_output_filtered=$(echo "${tctl_output}" | grep -E "^([a-zA-Z]+\.)?(${columns}):?\s")
        if [[ "${tctl_output_filtered}" ==  "" ]]; then
            echo "${tctl_output}"
            return 1
        fi
        tctl_output=${tctl_output_filtered}

        local temp_sep=';'
        local column_headers
        column_headers=$(echo "${tctl_output}" | head -${column_count} | awk '{print $1}')
        {
            echo "${column_headers}"
            echo "${tctl_output}" | sed 's/^[^ ]*\s*//g' | sed 's/ *$//g'
        } | awk "{printf(\"%s%s\", \$0,NR%${column_count} ? \"${temp_sep}\" : \"\n\")}" | column -t -s "${temp_sep}" | awk 'NR<2{print $0;next}{print $0 | "sort"}' 
    }

    __tctl_json_to_table() {
        local columns=$1

        tctl_output=$(cat)
        if ! echo "${tctl_output}" | jq &> /dev/null; then
            echo "${tctl_output}"
            return 1
        fi

        local default_value=' // "-"'
        echo "${tctl_output}" | jq --raw-output "[[$(echo "\"${columns}\"" | sed 's/|/", "/g')]], [.[] | [$(echo ".${columns}${default_value}" | sed "s@|@${default_value}, .@g")]] | .[] | @tsv" | column -t -s $'\t'
    }

    # List all Temporal clusters, outputting in a table format
    # @param {...string} $@ Additional flags to pass tctl
    tcluster() {
        tctl  "$@" admin cluster list | __tctl_json_to_table "cluster_name|cluster_id|cluster_address|version_info.current.version|is_connection_enabled|is_global_namespace_enabled"
    }
    alias tcl=tcluster

    # List all namespaces in a Temporal cluster, outputting in a table format
    # @param {...string} $@ Additional flags to pass tctl
    tnamespace() {
        tctl "$@" namespace list | __tctl_rows_to_table "Name|Id|.*Retention.*|ActiveClusterName|Clusters|IsGlobalNamespace|FailoverVersion"
    }
    alias tns=tnamespace
}
__tctl_funcs
