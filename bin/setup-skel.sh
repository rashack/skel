#!/bin/bash

set -eu

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

ln_s() {
    local SRC=$1/$2
    local DEST=$2
    if ! [ "$(readlink $DEST)" = "$SRC" ] ; then
        if [ -a $DEST ] ; then
            echo "mv $DEST $BACKUP_DIR"
            mv $DEST $BACKUP_DIR
        fi
        echo "ln -s $SRC $DEST"
        ln -s $SRC $DEST
    else
        echo "ln_s: not linking: $DEST -> $SRC"
    fi
}

link_skel_files() {
    cd
    mkdir -p $BACKUP_DIR
    mkdir -p ~/.ssh

    #echo $(dirname $0)
    #echo $(dirname $(readlink -e $0))
    local BIN_DIR=$SKEL_DIR/bin
    if [ -L ~/bin ] ; then
        if ! [ $(readlink ~/bin) = "$BIN_DIR" ] ; then
            ln -s $BIN_DIR
        fi
    fi

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
        .repos \
        .screenrc \
        .tmux-default.conf \
        .tmux.conf \
        .vimperatorrc \
        .vimrc \
        .xbindkeysrc \
        .xinitrc \
        .xmonad \
        .xscreensaver \
        .zshrc \
        ; do
        ln_s $SKEL_DIR $x
    done

    mkdir -p ~/.gnupg
    if ! [ -L ~/.gnupg/gpg.conf ] ; then
        ln -s -t ~/.gnupg ../.skel/gpg.conf
    fi

    ln -s $SKEL_DIR/.xinitrc .xsession
    mkdir -p ~/.stack
    ln -rs $SKEL_DIR/stack-config.yaml ~/.stack/config.yaml

    ln -srt $SKEL_DIR/bin/ $HOME/src/kjell/doc/bin/doc
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
    ln -s ../.skel/elisp
    download_elisp
}

setup-zsh-and-oh-my-zzshell() {
    cd
    ln -s .skel/.zshrc
    mkdir -p .oh-my-zsh/custom/themes
    ln -srt .skel/kjellz.zsh-theme .oh-my-zsh/custom/themes
    cd -
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

ohmyzshell() {
    if ! [ -d ~/.oh-my-zsh/ ] ; then
        echo "Oh my zshell not installed?"
        exit 1
    fi
    cd ~/.oh-my-zsh/custom/themes
    ln -s ../../../.skel/kjellz.zsh-theme .
}

all() {
    link_skel_files
    update_emacs_deps
    download_other
    ohmyzshell
}

while getopts "aelo" opt ; do
    case $opt in
        a) all ; exit 0 ;;
        e) update_emacs_deps ; exit 0 ;;
        l) link_skel_files ; exit 0 ;;
        o) download_other ; exit 0 ;;
        z) ohmyzshell ; exit 0 ;;
    esac
done
shift `expr $OPTIND - 1`

usage
