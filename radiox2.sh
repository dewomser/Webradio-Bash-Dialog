#!/bin/bash
#----------------
# Dieses Radio braucht eine Liste

## entweder von Github downloaden
# radio.txt in den selben Ordner kopieren wie das Script
# In der Zeile mpg123…  die URL ersetzten durch radio.txt 

## Oder nichts machen (default)
# dann wird die Liste von Github geholt.
# Macht Sinn, weil für Internetradio muß man sowieso online sein.
# ------------------


command -v kdialog >/dev/null 2>&1 || { echo -e "\e[41mDieses Radio benötigt Kdialog. Das Programm 'kdialog' muss installiert werden.\e[0m" >&2; exit 1; }
command -v mpg123 >/dev/null 2>&1 || { kdialog --sorry "Kdialog ist installiert, wenn Du jetzt noch\n'mpg123' instalierst, funktioniert das Radio !" >&2; exit 1; }



loopy=1
rm  fifo.txt
touch fifo.txt

radiostation()          {
                      mpg123 --control --utf8 -@ http://raw.githubusercontent.com/dewomser/Webradio-Bash-Dialog/master/radio.txt --title --preload 1 --buffer 768 --smooth -l "$1" >> fifo.txt  2>&1> /dev/null &
                      sleep 1
                      result=$(tail -n 25 fifo.txt|grep -a --line-buffered "StreamTitle"| sed -e 's/;.*//' -e 's/.*=//' -e "s/'//g")
                      #station="$1. Radio"
                      station=$(tail -n 10 fifo.txt|grep -m1 --line-buffered "ICY-NAME"| sed -e 's/ICY-NAME: //' -e 's/ /_/g' -e 's/\./_/g' )
                      kdialog --title "Radio Info" --passivepopup "$result" 10
                      
                      }
while [ "$loopy" -eq 1 ] ; do
        
        
 wahl=$(kdialog --title "K+Radio" --radiolist "$station" 1 "Dot FM 8072" off  2  "Dot FM 8042" off 3 "SWR3" off)
    
 onoff=$?
 #echo $onoff    
    if [ $onoff -eq 1 ]; then
    killall mpg123
    exit
    elif [ $onoff -eq 0 ]; then
    killall mpg123
    fi
    
    
   if [ "$wahl" = 3 ]; then
    radiostation 3
    
    elif [ "$wahl" = 2 ]; then
    radiostation 2
    
    elif [ "$wahl" = 1 ]; then
    radiostation 1 
    fi
             
done 
   
exit   
    
    
    
