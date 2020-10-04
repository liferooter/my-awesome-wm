#!/usr/bin/env bash
B='#1099bbff'  # blank
C='#ffffff22'  # clear ish
D='#00ffffcc'  # default
T='#00eeeeee'  # text
W='#880000bb'  # wrong
V='#00bbbbbb'  # verifying

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
--image ~/.config/awesome/themes/pretty/background.jpg \
-e \
-C
