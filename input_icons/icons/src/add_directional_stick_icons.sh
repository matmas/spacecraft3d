#!/bin/bash
for f in ps3 ps4 ps5 steam steam_deck switch xbox_360 xbox_one xbox_series; do
    for d in left right up down; do
        convert ../$f/left_stick.png $d.png -composite ../$f/left_stick_$d.png
        if [[ $f != steam ]]; then
            convert ../$f/right_stick.png $d.png -composite ../$f/right_stick_$d.png
        fi
    done
done
