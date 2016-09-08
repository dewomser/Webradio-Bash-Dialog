#! /bin/bash


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


display_result() {
  gdialog --title "$1" \
    --no-collapse \
    --stdout \
    --msgbox "$result" 0 0 \
  #--tailboxbg fifo.txt 0 0

}

while true; do
  exec 3>&1
  selection=$(gdialog \
    --backtitle "SmaRPt Webradio" \
    --title "Menu" \
    --clear \
    --cancel-label "Exit" \
    --menu "Please select:" $HEIGHT $WIDTH 4 \
    "1" "Radio1" \
    "2" "Radio2" \
    "3" "Radio3" \
    2>&1 1>&3)
  exit_status=$?
  exec 3>&-
  
  case $exit_status in
    $DIALOG_CANCEL)
      clear
   #   echo "Program terminated."
      killall mpg123
      exit
      ;;
      $DIALOG_OK)
      
   #   echo "Program terminated."
      killall mpg123
       ;;
      
      
      
    $DIALOG_ESC)
      clear
   #   echo "Program aborted." >&2
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
   mpg123 --control --utf8 --title --preload 1 --buffer 768 --smooth http://relay.181.fm:8042 > mpg123.fifo 2>&1> /dev/null &
 

  
  #exec -c "mpg123 -@ http://mp3-live.swr3.de/swr3_m.m3u 2>&1> /dev/null |grep --line-buffered "StreamTitle"> mpg123.fifo"l
   cat mpg123.fifo >>fifo.txt &
  
  result=$(tail -n 30 fifo.txt|grep --line-buffered "StreamTitle"| sed -e 's/;.*//' -e 's/.*=//' -e "s/'//g")
    
     display_result "Webradio" 

      ;;
    2 )
      mpg123 --control --utf8 --title --preload 1 --buffer 768 --smooth http://relay.181.fm:8072 > mpg123.fifo 2>&1> /dev/null &
 

  
  #exec -c "mpg123 -@ http://mp3-live.swr3.de/swr3_m.m3u 2>&1> /dev/null |grep --line-buffered "StreamTitle"> mpg123.fifo"l
   cat mpg123.fifo >>fifo.txt &
  
  result=$(tail -n 30 fifo.txt|grep --line-buffered "StreamTitle"| sed -e 's/;.*//' -e 's/.*=//' -e "s/'//g")
    
     display_result "Webradio" 

      ;;
    3 )
       mpg123 --control --utf8 --title --preload 1 --buffer 768 --smooth http://icyrelay.181.fm/181-blues_128k.mp3 > mpg123.fifo 2>&1> /dev/null &
 

  
  #exec -c "mpg123 -@ http://mp3-live.swr3.de/swr3_m.m3u 2>&1> /dev/null |grep --line-buffered "StreamTitle"> mpg123.fifo"l
   cat mpg123.fifo >>fifo.txt &
  
  result=$(tail -n 30 fifo.txt|grep --line-buffered "StreamTitle"| sed -e 's/;.*//' -e 's/.*=//' -e "s/'//g")
    
     display_result "Webradio" 

      
      ;;
  esac
done

