#!/bin/zsh

# kjellz.zsh-theme

ZSH_THEME_GIT_PROMPT_PREFIX=" %{$FG[239]%}(%{$reset_color%}%{$FG[063]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$FG[239]%})%{$reset_color%}"

ZSH_THEME_GIT_PROMPT_UNTRACKED="%%"
ZSH_THEME_GIT_PROMPT_ADDED="+"
ZSH_THEME_GIT_PROMPT_MODIFIED="*"
ZSH_THEME_GIT_PROMPT_RENAMED="~"
ZSH_THEME_GIT_PROMPT_DELETED="!"
ZSH_THEME_GIT_PROMPT_UNMERGED="?"
ZSH_THEME_GIT_PROMPT_AHEAD=">"
ZSH_THEME_GIT_PROMPT_BEHIND="<"
ZSH_THEME_GIT_PROMPT_DIVERGED="<>"
ZSH_THEME_GIT_PROMPT_STASHED="$"
#ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg_bold[green]%}%{✔%G%}"
#ZSH_THEME_GIT_PROMPT_CLEAN="="

# TODO: fix detached head "status/name"
function kzt_git_prompt {
  ref=$(git symbolic-ref HEAD 2> /dev/null) || return
	GIT_STATUS=$(git_prompt_status)
	if [[ -n $GIT_STATUS ]] ; then
		GIT_STATUS=" $GIT_STATUS"
	fi
  echo "$ZSH_THEME_GIT_PROMPT_PREFIX${ref#refs/heads/}$GIT_STATUS$ZSH_THEME_GIT_PROMPT_SUFFIX"
}

function preexec() {
    timer=${timer:-$SECONDS}
}

function precmd() {
    if [ $timer ]; then
        timer_show=$(($SECONDS - $timer))
        timer_show=$(printf '%.*f\n' 3 $timer_show)
        KZT_EXEC_TIME="%{$FG[241]%}${timer_show}s%{$reset_color%}"
        unset timer
    fi
}

# gray colour
KZTCG="%{$FG[239]%}"
# timestamp colour
KZTCT="%{$FG[068]%}"
# user/host colour
KZTCU="%{$FG[033]%}"
#KZTCU="%{$FG[033]%}%{$BG[243]%}"

# ISO-8601 timestamp
KZT_P_TS="${KZTCG}[${KZTCT}%D{%Y-%m-%d}${KZTCG}T${KZTCT}%D{%H:%M:%S}${KZTCG}]%{$reset_color%}"
# user and host
KZT_USR_HST="$KZTCU%n%{$reset_color%}${KZTCG}@%{$reset_color%}$KZTCU$SHORT_HOST%{$reset_color%}"
# exit code of previous command
KZT_ERR="${KZTCG}<%{$reset_color%}%(?.%{$FG[040]%}0%{$reset_color%}.%{$FG[001]%}%?%{$reset_color%})${KZTCG}>%{$reset_color%}"

PROMPT='╭ $KZT_P_TS $KZT_USR_HST $KZT_ERR $KZT_EXEC_TIME$(kzt_git_prompt)
╰ ${KCG}%{$reset_color%}%{$terminfo[bold]$FG[034]%}%~%{$reset_color%} %(!.#.$) '
