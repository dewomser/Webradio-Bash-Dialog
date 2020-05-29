#!/bin/bash

rm  fifo.txt
touch fifo.txt
station_status_3="SWR_3 off"
station_status_2="Dot_FM_8042 off"
station_status_1="Dot_FM_8072 off"

radiostation()          {
                      mpg123 --control --utf8 --title --preload 1 --buffer 768 --smooth "$1" >> fifo.txt  2>&1> /dev/null &
                      result=$(tail -n 25 fifo.txt|grep -a --line-buffered "StreamTitle"| sed -e 's/;.*//' -e 's/.*=//' -e "s/'//g")
                      station=$1
                      kdialog --title "Radio Info" --passivepopup "$result" 10
                      
                      }
                      
        
        
        
       
    while true; do   
       
    wahl=$(kdialog --title "K+Radio" --radiolist "$station" 1 $station_status_1 2 $station_status_2 3 $station_status_3)
    
    onoff=$?
    
    if [ $onoff -eq 1 ]; then
    killall mpg123
    exit
    elif [ $onoff -eq 0 ]; then
    killall mpg123
    fi
    
    
    
    
    if [ "$wahl" = 3 ]; then
    radiostation "http://swr-swr3-live.cast.addradio.de/swr/swr3/live/mp3/128/stream.mp3" 
    station_status_3="SWR_3 on"
    station_status_2="Dot_FM_8042 off"
    station_status_1="Dot_FM_8072 off"
    elif [ "$wahl" = 2 ]; then
    radiostation http://relay.181.fm:8042
    station_status_3="SWR_3 off"
    station_status_2="Dot_FM_8042 on"
    station_status_1="Dot_FM_8072 off"
    elif [ "$wahl" = 1 ]; then
    radiostation http://relay.181.fm:8072
    station_status_3="SWR_3 off"
    station_status_2="Dot_FM_8042 off"
    station_status_1="Dot_FM_8072 on"
    fi

    done
    
    
    
