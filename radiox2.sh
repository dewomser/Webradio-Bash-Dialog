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
sender3=(3 Antenne_Bayern off) ; url3="http://mp3channels.webradio.antenne.de/antenne"
sender4=(4 Nova off) ; url4="http://st03.dlf.de/dlf/03/128/mp3/stream.mp3"
sender5=(5 HR-INFO off); url5="http://hr-hrinfo-live.cast.addradio.de/hr/hrinfo/live/mp3/128/stream.mp3"
sender6=(6 Rockland off) ; url6="http://188.94.97.90/rockland.mp3"
sender7=(7 SWR3 off) ; url7="http://swr-swr3-live.cast.addradio.de/swr/swr3/live/mp3/128/stream.mp3"




#-------------------bis hier her--------------------------------

station=Radiosender
echo $url1 > radio.txt
{
echo $url2
echo $url3
echo $url4
echo $url5
echo $url6 
echo $url7
} >> radio.txt

loopy=1
radiostation_letzt=0
if [ -f fifo.txt ]; then
  rm fifo.txt
fi
touch fifo.txt

radiostation()         {
                        mpg123 --control --utf8 -@ radio.txt --title --preload 1 --buffer 768 --smooth -l "$1" >> fifo.txt  2>&1> /dev/null &
                        if [ "$radiostation_letzt" -ne "$*" ] ; then sleep 2 ; fi ; radiostation_letzt=$*
                        result1=$(tail -n 30 fifo.txt)
                        result=$(echo "$result1" | grep -a --line-buffered "StreamTitle"| sed -e 's/;.*//' -e 's/.*=//' -e "s/'//g")
                        station=$(echo "$result1" | grep "ICY-NAME" | tail -1 | sed -e 's/ICY-NAME: //' -e 's/ /_/g' -e 's/\./_/g' )
                        kdialog --title "Radio Info" --passivepopup "$result" 10
                        
                        }

while [ "$loopy" -eq 1 ] ; do

    wahl=$(kdialog --icon music --title "K+Radio" --radiolist "$station" "${sender1[0]}" "${sender1[1]}" "${sender1[2]}" "${sender2[0]}" "${sender2[1]}" "${sender2[2]}" "${sender3[0]}" "${sender3[1]}" "${sender3[2]}" "${sender4[0]}" "${sender4[1]}" "${sender4[2]}" "${sender5[0]}" "${sender5[1]}" "${sender5[2]}" "${sender6[0]}" "${sender6[1]}" "${sender6[2]}" "${sender7[0]}" "${sender7[1]}" "${sender7[2]}")

    onoff=$?
    pkill -f mpg123  
    
    if [ $onoff -eq 1 ]; then
    exit
    elif [ $onoff -eq 0 ]; then
    sender1[2]=off
    sender2[2]=off
    sender3[2]=off
    sender4[2]=off
    sender5[2]=off
    sender6[2]=off
    sender7[2]=off
    fi

    if [ "$wahl" = 7 ]; then
    radiostation 7
    sender7[2]=on
    elif [ "$wahl" = 6 ]; then
    radiostation 6
    sender6[2]=on
    elif [ "$wahl" = 5 ]; then
    radiostation 5
    sender5[2]=on
    elif [ "$wahl" = 4 ]; then
    radiostation 4
    sender4[2]=on
    elif [ "$wahl" = 3 ]; then
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
