#!/bin/bash 
week=$(date -d "-7days" +"%F") 
lastBU=$(ls $HOME | grep -E "Backup-[0-9]{4}-[0-9]{2}-[0-9]{2}" | tail -1) 
lastBUadress="" 
 
if [[ ! -e $HOME/backup-report ]]; then 
                touch $HOME/backup-report 
fi 
 
if [[ $lastBU != "" ]]; then 
        lastBUdate=$(date --date=$(echo $lastBU | sed "s/^Backup-//") +"%F") 
        if [[ $lastBUdate < $week ]]; then 
                lastBUadress=$HOME/Backup-$(date +"%F") 
                echo "Making new backup" 
                echo Backup-$(date +"%F") >> $HOME/backup-report 
                mkdir $lastBUadress 
        else 
                lastBUadress=$HOME/$lastBU 
        fi 
else 
        lastBUadress=$HOME/Backup-$(date +"%F") 
        mkdir $lastBUadress 
fi 
 
for name in $(ls "$HOME/source"); do 
        if [[ -e $lastBUadress/$name && $(stat $lastBUadress/$name -c%s) -ne $(stat $HOME/source/$name -c%s) ]]; then 
                touch $lastBUadress/$name.$(date +"%F") 
                mv $lastBUadress/$name $lastBUadress/$name.$(date +"%F") 
                cp $HOME/source/$name $lastBUadress/$name 
                echo $name.$(date +"%F") >> $HOME/backup-report 
        else 
                cp $HOME/source/$name $lastBUadress/$name 
                echo $name >> $HOME/backup-report 
        fi 
done
