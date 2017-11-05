#!/bin/bash

#
# Script to make backlight take smaller steps as it approaches 0
#

BLVAL=$(xbacklight)
BLVAL=${BLVAL%.*} # To int
STEP=1

if [ $BLVAL -gt 20 ]
then
  STEP=10
elif [ $BLVAL -gt 10 ]
then
  STEP=5
fi

if [ $1 == "inc" ]
then
  xbacklight -inc $STEP
fi

if [ $1 == "dec" ]
then
  xbacklight -dec $STEP
fi

