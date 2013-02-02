#!/bin/sh
#########################################################################
#
#   npcmus - outputs what cmus is currently playing.
#   Copyleft (cl) 2010 velusip, velusip@gmail.com
#
#########################################################################
#
#     npcmus requires awk and cmus
#
#   Protips:
#   * irssi - print to channel with /npc
#     /alias npc exec -nosh -window -out - /path/to/npcmus.sh
#   * irssi - print only to you with /np
#     /alias np exec -nosh -window - /path/to/npcmus.sh
#   * nicotine - print to channel with /np
#     Alt + e, n --> Other --> enter /path/to/npcmus.sh
#   * xmobarrc - commands = []
#     Run Com "sh" ["/path/to/npcmus.sh"] "npcmus" 10
#
#########################################################################

cmus-remote -Q | awk '\
function toEnd(iStr, skip)\
{\
    return substr(iStr, match(iStr, skip) + length(skip) + 1);\
}\
function tagless(iStr)\
{\
    return substr(iStr, match(iStr, "/[^/]*/[^/]*$") );\
}\
NR == 1 {\
    if($0 ~ "running") {\
        offline = 1; exit 1\
    }\
}\
NR == 2 && $1 ~ "file" {\
    file = toEnd($0, "file");\
}\
NR != 2 && $2 ~ "^artist$" {\
    if(artist == "")\
    {\
        artist = toEnd($0, "artist");\
    }\
}\
NR != 2 && $2 ~ "^album$" {\
    if(album == "")\
    {\
        album = toEnd($0, "album");\
    }\
}\
NR != 2 && $2 ~ "title" {\
    title = toEnd($0, "title");\
}\
$2 ~ "shuffle" && $3 ~ "true" {\
    shuffle = " (S)";\
}\
END {\
    np = "OnAir" shuffle ": ";\
    if(artist && album && title)\
    {\
        print np, artist, "-", album, "-", title\
    }\
    if(artist && title)\
    {\
        print np, artist, "-", title\
    }\
    else if(file)\
    {\
        print np, tagless(file);\
    }\
}'
