#!/bin/bash
convert left.png -rotate 90 up.png
convert left.png -rotate -90 down.png
convert left.png -rotate 180 right.png

for f in ps3 ps4 ps5 steam steam_deck switch xbox_360 xbox_one xbox_series; do
    for d in left right up down; do
        convert ../$f/left_stick.png $d.png -composite ../$f/left_stick_$d.png
        if [[ $f != steam ]]; then
            convert ../$f/right_stick.png $d.png -composite ../$f/right_stick_$d.png
        fi
    done
done

find -name '../*.png' -print0 | xargs -0 optipng -nc -nb -o7
