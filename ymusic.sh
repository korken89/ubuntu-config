#!/bin/bash
echo Music search string:
read str
youtube-viewer --search \"$str\" --all -n -s -C #-d -dp -rp
