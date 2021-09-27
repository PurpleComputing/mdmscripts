#!/bin/sh
lpadmin -p "HP-Color-Laserjet-Pro-MFP-M479fdw" -D "HP Color Laserjet Pro MFP M479fdw" -L "Main Office" -o printer-is-shared=false -E -v ipp://192.168.1.16 -m everywhere
