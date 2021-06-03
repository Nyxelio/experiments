#!/bin/bash
echo "$@"
gksudo `cp -r "$@" /home/ftp`
cd /home/ftp
gksudo chown ftp:nogroup "$@"

