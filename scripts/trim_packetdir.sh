#!/bin/bash

# trim_packetdir.sh: Delete old source packets
#
# (c) 2009 Marko Lindqvist
#
# This program is licensed under Gnu General Public License version 2.

export FILELIMIT=200

if test "x$1" = "x-h" || test "x$1" = "x--help" ; then
  HELP_RETURN=0
elif test "x$1" = "x" ; then
  HELP_RETURN=1
fi

if test "x$HELP_RETURN" != "x" ; then
  echo "Usage: $(basename $0) <packetdir>"
  exit $HELP_RETURN
fi

if ! test -f "$1/filelist.txt" ; then
  echo "Filelist $1/filelist.txt not found!" >&2
  exit 1
fi

declare -i FILECOUNT=$(wc -l "$1/filelist.txt" | sed 's/ .*//')

( sort -k 3 "$1/filelist.txt" | while read F1 F2 F3 F4 F5
  do
    if test $FILECOUNT -gt $FILELIMIT ; then
      rm "$1/$F5"
      FILECOUNT=$FILECOUNT-1
    else
      echo $F1 $F2 $F3 $F4 $F5
    fi
  done
) > "$1/filelist.tmp"

mv "$1/filelist.tmp" "$1/filelist.txt"
