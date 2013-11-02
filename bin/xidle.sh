#!/bin/bash

XIDLE=~/bin/xidle

if ! [ -x $XIDLE ] ; then
    rm -f $XIDLE
    SRC=/tmp/xidle.c
echo \
'
#include <time.h>
#include <stdio.h>
#include <unistd.h>
#include <X11/Xlib.h>
#include <X11/Xutil.h>
#include <X11/extensions/scrnsaver.h>

/* code from Perl library */
int GetIdleTime () {
    time_t idle_time;
    static XScreenSaverInfo *mit_info;
    Display *display;
    int screen;
    mit_info = XScreenSaverAllocInfo();
    if((display=XOpenDisplay(NULL)) == NULL) { return(-1); }
    screen = DefaultScreen(display);
    XScreenSaverQueryInfo(display, RootWindow(display,screen), mit_info);
    idle_time = (mit_info->idle) / 1000;
    XFree(mit_info);
    XCloseDisplay(display);
    return idle_time;
}

int main() {
    printf("%d\n", GetIdleTime());
    return 0;
}' > $SRC

    gcc -o $XIDLE -L/usr/X11R6/lib/ -lX11 -lXext -lXss $SRC
    strip $XIDLE
    chmod +x $XIDLE
fi

$XIDLE
