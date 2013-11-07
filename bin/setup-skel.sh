#!/bin/bash

SKEL_DIR=.skel
BACKUP_DIR=~/orig-skel

link_file () {
    local SRC=$1/$2
    local DEST=$2
    [ -f $DEST ] && mv $DEST $BACKUP_DIR
    ln -s $SRC $DEST
}

cd
mkdir -p $BACKUP_DIR

#echo $(dirname $0)
#echo $(dirname $(readlink -e $0))
ln -s $SKEL_DIR/bin

for x in \
    .bash_profile .bashrc .colordiffrc .conkyrc .emacs .gitconfig \
    .imwheelrc .inputrc \
    .screenrc .tmux.conf .tmux-default.conf \
    .vimperatorrc .vimrc \
    .xbindkeysrc .Xdefaults .xinitrc .Xmodmap .xmonad .xscreensaver \
    ; do
    link_file $SKEL_DIR $x
done

ln -s $SKEL_DIR/.xinitrc .xsession

ED=~/.emacs.d
mkdir -p $ED
cd $ED
ln -s ../.skel/elisp

ELD=~/src/elisp
mkdir -p $ELD
cd $ELD
git clone https://github.com/jwiegley/use-package.git
git clone http://www.dr-qubit.org/git/undo-tree.git
git clone https://github.com/emacsmirror/icicles.git
git clone https://github.com/haskell/haskell-mode.git
git clone https://github.com/fgallina/multi-web-mode.git
git clone https://github.com/mkmcc/gnuplot-mode.git
git clone https://github.com/tjarvstrand/edts.git
