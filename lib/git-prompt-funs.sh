#!/usr/bin/env bash

__git_ps1_show_upstream ()
{
    local key value
    local svn_remote svn_url_pattern count n
    local upstream=git legacy="" verbose="" name=""

    svn_remote=()
    # get some config options from git-config
    local output="$(git config -z --get-regexp '^(svn-remote\..*\.url|bash\.showupstream)$' 2>/dev/null | tr '\0\n' '\n ')"
    while read -r key value; do
	case "$key" in
	    bash.showupstream)
		GIT_PS1_SHOWUPSTREAM="$value"
		if [[ -z "${GIT_PS1_SHOWUPSTREAM}" ]]; then
		    p=""
		    return
		fi
		;;
	    svn-remote.*.url)
		svn_remote[$((${#svn_remote[@]} + 1))]="$value"
		svn_url_pattern="$svn_url_pattern\\|$value"
		upstream=svn+git # default upstream is SVN if available, else git
		;;
	esac
    done <<< "$output"

    # parse configuration values
    for option in ${GIT_PS1_SHOWUPSTREAM}; do
	case "$option" in
	    git|svn) upstream="$option" ;;
	    verbose) verbose=1 ;;
	    legacy)  legacy=1  ;;
	    name)    name=1 ;;
	esac
    done

    # Find our upstream
    case "$upstream" in
	git)    upstream="@{upstream}" ;;
	svn*)
	    # get the upstream from the "git-svn-id: ..." in a commit message
	    # (git-svn uses essentially the same procedure internally)
	    local -a svn_upstream
	    svn_upstream=($(git log --first-parent -1 \
				--grep="^git-svn-id: \(${svn_url_pattern#??}\)" 2>/dev/null))
	    if [[ 0 -ne ${#svn_upstream[@]} ]]; then
		svn_upstream=${svn_upstream[${#svn_upstream[@]} - 2]}
		svn_upstream=${svn_upstream%@*}
		local n_stop="${#svn_remote[@]}"
		for ((n=1; n <= n_stop; n++)); do
		    svn_upstream=${svn_upstream#${svn_remote[$n]}}
		done

		if [[ -z "$svn_upstream" ]]; then
		    # default branch name for checkouts with no layout:
		    upstream=${GIT_SVN_ID:-git-svn}
		else
		    upstream=${svn_upstream#/}
		fi
	    elif [[ "svn+git" = "$upstream" ]]; then
		upstream="@{upstream}"
	    fi
	    ;;
    esac

    # Find how many commits we are ahead/behind our upstream
    if [[ -z "$legacy" ]]; then
	count="$(git rev-list --count --left-right \
				"$upstream"...HEAD 2>/dev/null)"
    else
	# produce equivalent output to --count for older versions of git
	local commits
	if commits="$(git rev-list --left-right "$upstream"...HEAD 2>/dev/null)"
	then
	    local commit behind=0 ahead=0
	    for commit in $commits
	    do
		case "$commit" in
		    "<"*) ((behind++)) ;;
		    *)    ((ahead++))  ;;
		esac
	    done
	    count="$behind	$ahead"
	else
	    count=""
	fi
    fi

    # calculate the result
    if [[ -z "$verbose" ]]; then
	case "$count" in
	    "") # no upstream
		p="" ;;
	    "0	0") # equal to upstream
		p="=" ;;
	    "0	"*) # ahead of upstream
		p=">" ;;
	    *"	0") # behind upstream
		p="<" ;;
	    *)	    # diverged from upstream
		p="<>" ;;
	esac
    else
	case "$count" in
	    "") # no upstream
		p="" ;;
	    "0	0") # equal to upstream
		p=" u=" ;;
	    "0	"*) # ahead of upstream
		p=" u+${count#0	}" ;;
	    *"	0") # behind upstream
		p=" u-${count%	0}" ;;
	    *)	    # diverged from upstream
		p=" u+${count#*	}-${count%	*}" ;;
	esac
	if [[ -n "$count" && -n "$name" ]]; then
	    __git_ps1_upstream_name=$(git rev-parse \
				          --abbrev-ref "$upstream" 2>/dev/null)
	    if [ $pcmode = yes ] && [ $ps1_expanded = yes ]; then
		p="$p \${__git_ps1_upstream_name}"
	    else
		p="$p ${__git_ps1_upstream_name}"
		# not needed anymore; keep user's
		# environment clean
		unset __git_ps1_upstream_name
	    fi
	fi
    fi

}


# Helper function to read the first line of a file into a variable.
# __git_eread requires 2 arguments, the file path and the name of the
# variable, in that order.
__git_eread ()
{
    test -r "$1" && IFS=$'\r\n' read "$2" <"$1"
}

# see if a cherry-pick or revert is in progress, if the user has committed a
# conflict resolution with 'git commit' in the middle of a sequence of picks or
# reverts then CHERRY_PICK_HEAD/REVERT_HEAD will not exist so we have to read
# the todo file.
__git_sequencer_status ()
{
    local todo
    if test -f "$g/CHERRY_PICK_HEAD"
    then
	r="|CHERRY-PICKING"
	return 0;
    elif test -f "$g/REVERT_HEAD"
    then
	r="|REVERTING"
	return 0;
    elif __git_eread "$g/sequencer/todo" todo
    then
	case "$todo" in
	    p[\ \	]|pick[\ \	]*)
		r="|CHERRY-PICKING"
		return 0
		;;
	    revert[\ \	]*)
		r="|REVERTING"
		return 0
		;;
	esac
    fi
    return 1
}

___git_ps1 ()
{
    local detached=no
    local printf_format=' (%s)'

    local repo_info rev_parse_exit_code
    repo_info="$(git rev-parse --git-dir --is-inside-git-dir \
		--is-bare-repository --is-inside-work-tree \
		--short HEAD 2>/dev/null)"
    rev_parse_exit_code="$?"

    if [ -z "$repo_info" ]; then
	printf "repo_info is empty"
    fi

    local short_sha=""
    if [ "$rev_parse_exit_code" = "0" ]; then
	short_sha="${repo_info##*$'\n'}"
	repo_info="${repo_info%$'\n'*}"
    fi
    local inside_worktree="${repo_info##*$'\n'}"
    repo_info="${repo_info%$'\n'*}"
    local bare_repo="${repo_info##*$'\n'}"
    repo_info="${repo_info%$'\n'*}"
    local inside_gitdir="${repo_info##*$'\n'}"
    local g="${repo_info%$'\n'*}"

    if [ "true" = "$inside_worktree" ] &&
	   [ -n "${GIT_PS1_HIDE_IF_PWD_IGNORED-}" ] &&
	   [ "$(git config --bool bash.hideIfPwdIgnored)" != "false" ] &&
	   git check-ignore -q .
    then
	return $exit
    fi

    local r=""
    local b=""
    local step=""
    local total=""
    if [ -d "$g/rebase-merge" ]; then
	__git_eread "$g/rebase-merge/head-name" b
	__git_eread "$g/rebase-merge/msgnum" step
	__git_eread "$g/rebase-merge/end" total
	if [ -f "$g/rebase-merge/interactive" ]; then
	    r="|REBASE-i"
	else
	    r="|REBASE-m"
	fi
    else
	if [ -d "$g/rebase-apply" ]; then
	    __git_eread "$g/rebase-apply/next" step
	    __git_eread "$g/rebase-apply/last" total
	    if [ -f "$g/rebase-apply/rebasing" ]; then
		__git_eread "$g/rebase-apply/head-name" b
		r="|REBASE"
	    elif [ -f "$g/rebase-apply/applying" ]; then
		r="|AM"
	    else
		r="|AM/REBASE"
	    fi
	elif [ -f "$g/MERGE_HEAD" ]; then
	    r="|MERGING"
	elif __git_sequencer_status; then
	    :
	elif [ -f "$g/BISECT_LOG" ]; then
	    r="|BISECTING"
	fi

	if [ -n "$b" ]; then
	    :
	elif [ -h "$g/HEAD" ]; then
	    # symlink symbolic ref
	    b="$(git symbolic-ref HEAD 2>/dev/null)"
	else
	    local head=""
	    if ! __git_eread "$g/HEAD" head; then
		printf "__git_eread $g/HEAD: returned non-zero"
	    fi
	    # is it a symbolic ref?
	    b="${head#ref: }"
	    if [ "$head" = "$b" ]; then
		detached=yes
		b="$(
				case "${GIT_PS1_DESCRIBE_STYLE-}" in
				(contains)
					git describe --contains HEAD ;;
				(branch)
					git describe --contains --all HEAD ;;
				(tag)
					git describe --tags HEAD ;;
				(describe)
					git describe HEAD ;;
				(* | default)
					git describe --tags --exact-match HEAD ;;
				esac 2>/dev/null)" ||

		    b="$short_sha..."
		b="($b)"
	    fi
	fi
    fi

    if [ -n "$step" ] && [ -n "$total" ]; then
	r="$r $step/$total"
    fi

    local w=""
    local i=""
    local s=""
    local u=""
    local c=""
    local p=""

    if [ "true" = "$inside_gitdir" ]; then
	if [ "true" = "$bare_repo" ]; then
	    c="BARE:"
	else
	    b="GIT_DIR!"
	fi
    elif [ "true" = "$inside_worktree" ]; then
	if [ -n "${GIT_PS1_SHOWDIRTYSTATE-}" ] &&
	       [ "$(git config --bool bash.showDirtyState)" != "false" ]
	then
	    git diff --no-ext-diff --quiet || w="*"
	    git diff --no-ext-diff --cached --quiet || i="+"
	    if [ -z "$short_sha" ] && [ -z "$i" ]; then
		i="#"
	    fi
	fi
	if [ -n "${GIT_PS1_SHOWSTASHSTATE-}" ] &&
	       git rev-parse --verify --quiet refs/stash >/dev/null
	then
	    s="$"
	fi

	if [ -n "${GIT_PS1_SHOWUNTRACKEDFILES-}" ] &&
	       [ "$(git config --bool bash.showUntrackedFiles)" != "false" ] &&
	       git ls-files --others --exclude-standard --directory --no-empty-directory --error-unmatch -- ':/*' >/dev/null 2>/dev/null
	then
	    u="%${ZSH_VERSION+%}"
	fi

	if [ -n "${GIT_PS1_SHOWUPSTREAM-}" ]; then
	    __git_ps1_show_upstream
	fi
    fi

    local z="${GIT_PS1_STATESEPARATOR-" "}"

    # NO color option unless in PROMPT_COMMAND mode
    if [ -n "${GIT_PS1_SHOWCOLORHINTS-}" ]; then
	__git_ps1_colorize_gitstring
    fi

    b=${b##refs/heads/}

    local f="$w$i$s$u"
    local gitstring="$c$b${f:+$z$f}$r$p"

    printf -- "$printf_format" "$gitstring"

}
