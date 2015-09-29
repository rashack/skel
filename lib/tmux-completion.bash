# bash completion for tmux
# Written by Oystein Steimler <oystein@nyvri.net>

_sessions() {
    SESSIONS=`tmux ls -F#{session_name} | xargs echo`
}

_tmux() {
    local cur prev comp
    COMPREPLY=()
    cur="${COMP_WORDS[COMP_CWORD]}"
    prev="${COMP_WORDS[COMP_CWORD-1]}"

    case "$prev" in
        attach)
            comp="-t"
            ;;
        att)
            comp="-t"
            ;;
        detach)
            comp="-s"
            ;;
        new)
            comp="-s"
            ;;
        -t|-s)
            _sessions
            comp="$SESSIONS"
            ;;
        tmux)
            comp="attach detach list ls new"
            ;;
    esac

    COMPREPLY=( $(compgen -W "${comp}" -- ${cur}) )
    return 0
}

complete -F _tmux tmux
