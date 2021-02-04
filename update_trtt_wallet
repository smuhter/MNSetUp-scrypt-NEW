#!/bin/bash

clear

cd ~
killall -9 trittiumd
sleep 1

rm /usr/local/bin/trittium*

cd /usr/local/bin/

wget https://github.com/Trittium/trittium/releases/download/v3.0.2.0/Trittium-3.0.2.0-Linux.zip
sleep 1

unzip Trittium-3.0.2.0-Linux.zip
sleep 1

rm Trittium-3.0.2.0-Linux.zip
sleep 1

su tritt
trittiumd -daemon
