#!/bin/sh
# cp /config/* /home/qbittorrent/.config/qBittorrent/

# Allow groups to change files.
umask 002
echo "Running \"$@\"..."
exec "$@"
