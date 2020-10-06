#!/usr/bin/env bash
B='#4545bb22'  # blank
C='#ffffff22'  # clear ish
D='#4545bbcc'  # default
T='#ffffffff'  # text
W='#880000bb'  # wrong
V='#45bbbbbb'  # verifying

i3lock \
--insidevercolor=$C   \
--ringvercolor=$V     \
\
--insidewrongcolor=$C \
--ringwrongcolor=$W   \
\
--insidecolor=$B      \
--ringcolor=$D        \
--linecolor=$B        \
--separatorcolor=$D   \
\
--verifcolor=$T        \
--wrongcolor=$T        \
--timecolor=$T        \
--datecolor=$T        \
--layoutcolor=$T      \
--keyhlcolor=$W       \
--bshlcolor=$W        \
\
--screen 1            \
--blur 0              \
--clock               \
--indicator           \
--timestr="%H:%M:%S"  \
--datestr="%A, %m %Y" \
--keylayout 2        \
-e \
--image ~/.config/awesome/bin/locker.png \
-C
