#!/bin/bash

SKEL_DIR=.skel
BACKUP_DIR=~/orig-skel

usage() {
    echo -e "\
usage: $0 OPTION\n\
\n\
    -a    perform all other steps\n\
    -e    setup Emacs dependencies\n\
    -l    symlink files in .skel to home directory\n\
    -o    for other dependencies (e.g. clone some repos)\n"
}

link_file() {
    local SRC=$1/$2
    local DEST=$2
    [ -f $DEST ] && mv $DEST $BACKUP_DIR
    ln -s $SRC $DEST
}

link_skel_files() {
    cd
    mkdir -p $BACKUP_DIR
    mkdir -p ~/.ssh

    #echo $(dirname $0)
    #echo $(dirname $(readlink -e $0))
    ln -s $SKEL_DIR/bin

    for x in \
	.Xdefaults \
	.Xmodmap \
	.bash_profile \
	.bashrc \
	.colordiffrc \
	.conkyrc \
	.emacs \
	.gitconfig \
	.guile \
	.imwheelrc \
	.inputrc \
        .psqlrc \
	.repos-to-fetch \
	.screenrc \
	.tmux-default.conf \
	.tmux.conf \
	.vimperatorrc \
	.vimrc \
	.xbindkeysrc \
	.xinitrc \
	# TODO: fix this .xmonad \
	.xscreensaver \
	; do
	link_file $SKEL_DIR $x
    done

    mkdir -p ~/.gnupg
    ln -s -t ~/.gnupg ../.skel/gpg.conf

    ln -s $SKEL_DIR/.xinitrc .xsession
    mkdir -p ~/.stack
    ln -rs $SKEL_DIR/stack-config.yaml ~/.stack/config.yaml
}

EMACS_REPOS=(
    "undo-tree"                  "http://www.dr-qubit.org/git/undo-tree.git"
    "clojure-mode"               "https://github.com/clojure-emacs/clojure-mode.git"
    "cider"                      "https://github.com/clojure-emacs/cider.git"
    "dash"                       "https://github.com/magnars/dash.el.git"
    "icicles"                    "https://github.com/emacsmirror/icicles.git"
    "haskell-mode"               "https://github.com/haskell/haskell-mode.git"
    "gnuplot-mode"               "https://github.com/mkmcc/gnuplot-mode.git"
    "linum-relativenumber"       "https://github.com/scottjad/linum-relativenumber.git"
    "highlight-parentheses"      "https://github.com/nschum/highlight-parentheses.el.git"
    "markdown-mode"              "git://jblevins.org/git/markdown-mode.git"
    "zenburn-emacs"              "https://github.com/bbatsov/zenburn-emacs.git"
    "solarized-grey"             "ssh://my-github/rashack/solarized-grey.git"
    "yasnippet"                  "https://github.com/capitaomorte/yasnippet.git"
)

repo_name() {
    echo ${EMACS_REPOS[$(( $1 * 2 ))]}
}

repo_uri() {
    echo ${EMACS_REPOS[$(( $1 * 2 + 1 ))]}
}

# download Emacs extensions
download_elisp() {
    ELD=~/src/elisp
    mkdir -p $ELD
    cd $ELD

    for (( i = 0 ; i < ${#EMACS_REPOS[@]} / 2 ; i=$i+1 )) ; do
	REPO_NAME=$(repo_name $i)
	REPO_URI=$(repo_uri $i)
	if [ ! -d $ELD/$REPO_NAME ] ; then
	    echo "${REPO_NAME}: does not exist, cloning $REPO_URI"
	    git clone $REPO_URI $REPO_NAME
	fi
    done

}

update_emacs_deps() {
    ED=~/.emacs.d
    mkdir -p $ED
    cd $ED
#    ln -s ../.skel/elisp
    download_elisp
}

clone_git() {
    cd ~/src
    git clone https://github.com/git/git.git
    cd ~/.skel
    ln -s ../src/git/contrib/completion/git-completion.bash
    ln -s ../src/git/contrib/completion/git-prompt.sh
}

download_other() {
    # download stuff
    clone_git
}

all() {
    link_skel_files
    update_emacs_deps
    download_other
}

while getopts "aelo" opt ; do
    case $opt in
        a) all ; exit 0 ;;
        e) update_emacs_deps ; exit 0 ;;
        l) link_skel_files ; exit 0 ;;
        o) download_other ; exit 0 ;;
    esac
done
shift `expr $OPTIND - 1`

usage
