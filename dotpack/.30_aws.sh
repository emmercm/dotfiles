__aws_completions() {
    # NOTE: `autoload -Uz compinit && compinit` will need to happen before sourcing any of these!

    if command -v aws &> /dev/null && command -v aws_completer &> /dev/null; then
        aws() {
            unset -f "$0"
            # https://docs.aws.amazon.com/cli/v1/userguide/cli-configure-completion.html#cli-command-completion-linux
            complete -C '/usr/local/bin/aws_completer' aws
            $0 "$@"
        }
    fi
}
__aws_completions


__aws_lazy_install() {
    if ! command -v aws &> /dev/null && command -v brew &> /dev/null; then
        aws() {
            brew install awscli
            unset -f "$0"
            $0 "$@"
        }
    fi

    if ! command -v awslocal &> /dev/null && command -v brew &> /dev/null; then
        awslocal() {
            pip3 install awscli-local
            unset -f "$0"
            $0 "$@"
        }
    fi
}
__aws_lazy_install
