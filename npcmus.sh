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
#     Run Com "/path/to/npcmus.sh" "" "npcmus" 5
#
#########################################################################

cmus-remote -Q | awk 'function toEnd(iStr, skip) { return substr(iStr, match(iStr, skip) + length(skip) + 1); } NR == 1 {if($0 ~ "running") {offline = 1; exit 1;} } NR == 2 && $1 ~ "file" {file = toEnd($0, "file");} $2 ~ "artist" {artist = toEnd($0, "artist");} $2 ~ "title" {title = toEnd($0, "title");} END { if(artist && title) {print "Now playing: ", artist, " - ", title;} else if(file) {print "Now playing: ", file;} }'
