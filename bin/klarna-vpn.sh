#!/bin/bash

cd ~kjell/vpnkeys
sudo openvpn --daemon --script-security 2 --config klarna.ovpn
