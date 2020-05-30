#!/bin/bash

rm  fifo.txt
touch fifo.txt


radiostation()          {
                      mpg123 --control --utf8 --title --preload 1 --buffer 768 --smooth "$1" >> fifo.txt  2>&1> /dev/null &
                      sleep 1
                      result=$(tail -n 40 fifo.txt|grep -a --line-buffered "StreamTitle"| sed -e 's/;.*//' -e 's/.*=//' -e "s/'//g")
                      #station=$1
                      station=$(tail -n 10 fifo.txt|grep -m1 --line-buffered "ICY-NAME"| sed -e 's/ICY-NAME: //' -e 's/ /_/g' -e 's/\./_/g' )
                      kdialog --title "Radio Info" --passivepopup "$result" 10
                      
                      }
                      
        
        
        
       
    while true; do   
       
    wahl=$(kdialog --title "K+Radio" --radiolist "$station" 1 "Dot FM 8072" off  2  "Dot FM 8042" off 3 "SWR3" off)
    
    onoff=$?
    
    if [ $onoff -eq 1 ]; then
    killall mpg123
    exit
    elif [ $onoff -eq 0 ]; then
    killall mpg123
    fi
    
    
    
    
    if [ "$wahl" = 3 ]; then
    radiostation "http://swr-swr3-live.cast.addradio.de/swr/swr3/live/mp3/128/stream.mp3" 
    elif [ "$wahl" = 2 ]; then
    radiostation http://relay.181.fm:8042
    elif [ "$wahl" = 1 ]; then
    radiostation http://relay.181.fm:8072 
    
    
    fi

    done
    
    
    
