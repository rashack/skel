#!/bin/bash

CMD="openvpn --daemon --script-security 2 --config work-vpn.ovpn"

sudo pkill -9 -f "$CMD"
sudo sh -c "$CMD"
