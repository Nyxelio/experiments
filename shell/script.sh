#!/bin/sh -x

LANG2=`echo "$LANG" | awk -F'"' '{print $1}' | awk -F'_' '{print $1}'`
n=1
texte()
{
cat lang | grep "$LANG2$n#" |awk -F"#" '{print $2}'
n=$(( $n + 1 ))
}


zenity --info --text="`texte`"
zenity --info --text="`texte`"
