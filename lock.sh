#!/bin/bash

LOCK_ICON=$HOME/.config/ubuntu-config/lock.png

scrot /tmp/screen.png
convert /tmp/screen.png -scale 10% -scale 1000% /tmp/screen.png
#convert /tmp/screen.png -blur 0x5 /tmp/screen.png

if [[ -f $LOCK_ICON ]]
then

  N_SCREENS=$(xrandr -q | grep " connected" | wc -l)

  if [ "$N_SCREENS" -gt "1" ]; then
    # placement x/y
    PX=0
    PY=0
    # lockscreen image info
    R=$(file $LOCK_ICON | grep -o '[0-9]* x [0-9]*')
    RX=$(echo $R | cut -d' ' -f 1)
    RY=$(echo $R | cut -d' ' -f 3)

    SR=$(xrandr --query | grep ' connected' | cut -f3 -d' ')
    for RES in $SR
    do
        # monitor position/offset
        SRX=$(echo $RES | cut -d'x' -f 1)                   # x pos
        SRY=$(echo $RES | cut -d'x' -f 2 | cut -d'+' -f 1)  # y pos
        SROX=$(echo $RES | cut -d'x' -f 2 | cut -d'+' -f 2) # x offset
        SROY=$(echo $RES | cut -d'x' -f 2 | cut -d'+' -f 3) # y offset
        PX=$(($SROX + $SRX/2 - $RX/2))
        PY=$(($SROY + $SRY/2 - $RY/2))

        convert /tmp/screen.png $LOCK_ICON -geometry +$PX+$PY -composite -matte  /tmp/screen.png
        #echo "done"
    done
  else
    convert /tmp/screen.png $LOCK_ICON -gravity center -composite -matte /tmp/screen.png
  fi
fi

#dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.Stop
i3lock -e -n -i /tmp/screen.png
