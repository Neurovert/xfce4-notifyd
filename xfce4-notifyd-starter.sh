#!/bin/bash
# Xfce4 notifications daemon starter
# Determine the logged in user
MAIN_USERNAME="$(users | xargs | awk '{print $1}' | xargs)"
[ -z "$MAIN_USERNAME" ] && "Couldn't determine user" && exit 1
MAIN_USERNAME_ID=$(id -u "$MAIN_USERNAME")

DBUS_PATH="unix:path=/run/user/$MAIN_USERNAME_ID/bus"
[ "$1" ] && DBUS_PATH="$1"
[ ! -S "${DBUS_PATH##*=}" ] && echo "Dbus socket '${DBUS_PATH##*=}' not found, exiting." && exit 1
export DBUS_SESSION_BUS_ADDRESS="$DBUS_PATH"
export XAUTHORITY=/home/$MAIN_USERNAME/.Xauthority
export DISPLAY=:0
# Maybe need to first kill other notifyd instances
/usr/local/lib/xfce4/notifyd/xfce4-notifyd
