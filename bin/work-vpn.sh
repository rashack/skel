#!/bin/bash

cd ~/vpnkeys
sudo openvpn --daemon --script-security 2 --config work-vpn.ovpn
