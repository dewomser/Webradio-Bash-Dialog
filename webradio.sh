#!/bin/bash

command -v mpg123 >/dev/null 2>&1 || { echo -e "$RED PMRP requires 'mpg123' but it's not installed! Install 'mpg123' to enjoy PMRP. $NC" >&2; exit 1; }

DIALOG_CANCEL=1
DIALOG_ESC=255
DIALOG_OK=0
HEIGHT=0
WIDTH=0

rm  fifo.txt
touch fifo.txt
rm mpg123.fifo
mkfifo mpg123.fifo

radiostation()          {
                      mpg123 --control --utf8 --title --preload 1 --buffer 768 --smooth $1 > mpg123.fifo 2>&1> /dev/null &
                      cat mpg123.fifo >>fifo.txt &
                      result=$(tail -n 30 fifo.txt|grep -a --line-buffered "StreamTitle"| sed -e 's/;.*//' -e 's/.*=//' -e "s/'//g")
                      display_result "Webradio" 
                      
                      }

title=$( tail -n 1 fifo.txt|grep -a --line-buffered "StreamTitle"| sed -e 's/;.*//' -e 's/.*=//' -e "s/'//g")

display_result() {
  gdialog --title "$1" \
    --no-collapse \
    --stdout \
    --infobox "$result" 0 0 \
 
}

while true; do
  exec 3>&1
  selection=$(gdialog \
    --backtitle "SmaRPt Webradio" \
    --title "Webradio" \
    --clear \
    --cancel-label "Exit" \
    --menu "Senderauswahl:" $HEIGHT $WIDTH 4 \
    "1" "Radio1" \
    "2" "Radio2" \
    "3" "Radio3" \
    2>&1 1>&3)
  exit_status=$?
  exec 3>&-
  
  case $exit_status in
    $DIALOG_CANCEL)
      clear
      killall mpg123
      exit
      ;;
      $DIALOG_OK)
      killall mpg123
      ;;
           
    $DIALOG_ESC)
      clear
      killall mpg123
      exit 1
      ;;
  esac
  case $selection in
    0 )
      clear
  #    echo "Program terminated."
      killall mpg123
      ;;
    1 )
   radiostation http://relay.181.fm:8042
   ;;
    2 )
   radiostation http://relay.181.fm:8072 
    ;;
    3 )
    radiostation http://icyrelay.181.fm/181-blues_128k.mp3
     ;;
  esac
done

