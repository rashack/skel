#!/bin/bash

CMD="openvpn --daemon --script-security 2 --config work-vpn.ovpn"

kill_openvpn() {
    sudo pkill -9 -fx "$CMD"
}

start_openvpn() {
    cd /home/$SUDO_USER/.openvpnkeys
    sudo sh -c "$CMD"
}

is_openvpn_running() {
    pgrep -fx "$CMD" 2>&1 > /dev/null
}

openvpn_pid() {
    pgrep -fx "$CMD" | awk '{print $1}'
}

restart_openvpn() {
    if is_openvpn_running ; then
        echo "Killing running openvpn PID: $(openvpn_pid)"
        kill_openvpn
    fi
    echo "Starting openvpn"
    start_openvpn
    echo "Started openvpn PID: $(openvpn_pid)"
}

print_status() {
    #is_openvpn_running && echo "openvpn running PID: $(openvpn_pid)"
    if is_openvpn_running ; then
        echo "openvpn running PID: $(openvpn_pid)"
    else
        echo "openvpn is not running"
    fi
}
usage() {
    echo "$(basename $0): OPTION

    OPTION
        i    is openvpn is running or not, returns 0 or 1
        k    kill running openvpn
        p    print status of possibly running openvpn
        r    restart openvpn, kill possibly running and start a new
        s    start openvpn
"
}

if [ $# -lt 1 ] ; then
    usage
    print_status
    exit 1
fi

while getopts "ikprs" opt ; do
    case $opt in
        i) is_openvpn_running ;;
        k) kill_openvpn ;;
        p) print_status ;;
        r) restart_openvpn ;;
        s) start_openvpn ;;
    esac
done
shift `expr $OPTIND - 1`
