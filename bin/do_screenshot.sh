#!/usr/bin/env bash

sleep 1
if [ "$*" = "window" ]
then
    import -silent -border -transparent-color '#00000000' -frame -descend -density 1200 /tmp/screenshot.png && \
        convert /tmp/screenshot.png -bordercolor black -border 50 /tmp/new.png && \
        convert /tmp/new.png +fuzz -fill none -draw "color 0,0 floodfill" -background none -flatten /tmp/new.png && \
        convert /tmp/new.png \( +clone -background black -shadow 100x40+0+16 \) +swap -background none -layers merge +repage /tmp/new.png
    elif [ "$*" = "area" ]; then
        import -silent -density 1200 /tmp/new.png
    elif [ "$*" = "screen" ]; then
        import -silent -window root /tmp/new.png
    else
        echo Incorrect option >&2
        exit 2
fi && \
xclip -selection clipboard -t image/png /tmp/new.png
