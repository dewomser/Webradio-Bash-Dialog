#!/bin/bash

# Achtung, das Script erzeugt 2 Dateien im selben Ordner wie dieses Script
# radio.txt und fifo.txt
# Diese beiden Dateien werden zwingend benötigt und werden nach jedem Start neu erzeugt.

# Vorraussetzungen werden geprüft Kdialog und mpg123 müssen installiert sein, sonst keine Mucke. 
command -v kdialog >/dev/null 2>&1 || { echo -e "\e[41mDieses Radio benötigt Kdialog. Das Programm 'kdialog' muss installiert werden.\e[0m" >&2; exit 1; }
command -v mpg123 >/dev/null 2>&1 || { kdialog --sorry "Kdialog ist installiert, wenn Du jetzt noch\n'mpg123' instalierst, funktioniert das Radio !" >&2; exit 1; }

#--------- Hier kann man 3 Radiosender  eintragen----------------
# KEINE LEERZEICHEN im Radionamen benutzen !
# 1-3 = Reihenfolge  | Radionamen | on/off = Aus/Abgewählt | url1-3 =Streaming-URL 
sender1=(1 DotFM_8072 off) ; url1="http://relay.181.fm:8072"
sender2=(2 DotFM_8042 off) ; url2="http://relay.181.fm:8042"
sender3=(3 SWR3 off )      ; url3="http://swr-swr3-live.cast.addradio.de/swr/swr3/live/mp3/128/stream.mp3"
#-------------------bis hier her--------------------------------

station=Radiosender
echo $url1 > radio.txt
echo $url2 >> radio.txt
echo $url3 >> radio.txt


loopy=1
rm  fifo.txt
touch fifo.txt

radiostation()          {
                      
                      mpg123 --control --utf8 -@ radio.txt --title --preload 1 --buffer 768 --smooth -l "$1" >> fifo.txt  2>&1> /dev/null &
                      sleep 1
                      result=$(tail -n 25 fifo.txt|grep -a --line-buffered "StreamTitle"| sed -e 's/;.*//' -e 's/.*=//' -e "s/'//g")
                      station=$(tail -n 10 fifo.txt|grep -m1 --line-buffered "ICY-NAME"| sed -e 's/ICY-NAME: //' -e 's/ /_/g' -e 's/\./_/g' )
                      kdialog --title "Radio Info" --passivepopup "$result" 10
                      
                      }

                      
while [ "$loopy" -eq 1 ] ; do

 wahl=$(kdialog --title "K+Radio" --radiolist "$station" "${sender1[0]}" "${sender1[1]}" "${sender1[2]}" "${sender2[0]}" "${sender2[1]}" "${sender2[2]}" "${sender3[0]}" "${sender3[1]}" "${sender3[2]}" )

 onoff=$?

    if [ $onoff -eq 1 ]; then
    killall mpg123
    exit
    elif [ $onoff -eq 0 ]; then
    killall mpg123
    sender1[2]=off
    sender2[2]=off
    sender3[2]=off
    fi
        
   if [ "$wahl" = 3 ]; then
    radiostation 3
    sender3[2]=on
    elif [ "$wahl" = 2 ]; then
    radiostation 2
    sender2[2]=on
    elif [ "$wahl" = 1 ]; then
    radiostation 1
    sender1[2]=on
    fi
done 

exit   
    
    
    
