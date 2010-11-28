#!/bin/bash
#########################################################################
#
#   spai!  Take screenshot, preview, assess, upload to imgur.
#   Copyleft (cl) 2010 velusip, velusip@gmail.com
#
#########################################################################
#
#     spai! requires curl, scrot, feh, (grep, X, ... bash).  Just run it
#   under X with ./spai.sh and follow the onscreen instructions.
#
#   Protips:
#   * You can press Esc to close the preview.
#   * spai! saves a copy locally even when uploading.
#   * Populates X "primary" selection.  Change if you want:
#       xclip -selection primary  =>  xclip -selection c
#   * Instead print the imgur URL to stdout:
#       echo "Done."  =>  xclip -selection -o
#
#   tnx hunterm for idea, imgur for host/api, and Sirupsen for scrape:
#       http://sirupsen.com/a-simple-imgur-bash-screenshot-utility/
#
#########################################################################
# spai!'s imgur key 73dac580f5af975538021ca70686fdf1

#Sirupsen's function
function uploadImage {
  curl -s -F "image=@$1" -F "key=73dac580f5af975538021ca70686fdf1" http://imgur.com/api/upload.xml | grep -E -o "<original_image>(.)*</original_image>" | grep -E -o "http://i.imgur.com/[^<]*"
}

#datestamp file the way I like it.  e.g. scrot_hostname_YYYYMMDDHHMM.png
thedate=`date +%Y%m%d`
thetime=`date +%H%M`
thishost=`echo "$STY" | grep -o "\([^.]*$\)"`
img='scrot_'${thishost}'_'${thedate}${thetime}'.png'

#check for a screenshot directory, doesn't matter really
if [ -d ~/.screenshot ]; then
    cd ~/.screenshot
fi

#check for dependencies
if [ ! -x /usr/bin/scrot ]; then
    echo "Missing dependency: scrot"
    exit 1;
elif [ ! -x /usr/bin/curl ]; then
    echo "Missing dependency: curl"
    exit 1;
elif [ ! -x /usr/bin/feh ]; then
    echo "Missing dependency: feh"
    exit 1;
fi

#select area for a picture
scrot -s "$img"

#fork preview
feh "$img"&

#prompt
echo -n "[D]elete, [S]tore, [I]mgur? [Enter]"
read action
case "$action" in
    [Dd]) rm "$img";;
    [Ii]) uploadImage "$img" | xclip -selection primary;;
esac

#[S]tore, lol
echo "Done!"
