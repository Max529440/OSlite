#!/bin/bash 
 
if [[ $# -ne 1 ]]; then 
        echo "Only one filename was expected, not $#." 
        exit 1 
fi 
 
found=0 
 
for i in $(grep -h $1 ~/.trash.log) 
do 
        found=1 
        rmPath=$(echo $i | awk -F "_" '{print $1}') 
        trFile=$(echo $i | awk -F "_" '{print $2}') 
        fullPath=~/.trash/$trFile 
        if [[ -e $fullPath ]]; then 
                echo "$rmPath is file wich you want to restore?" 
                echo "If you want to restore $rmPath enter \"YES\"." 
                echo "Otherwise enter \"NO\"." 
                read answer 
 
                while [[ $answer != "YES" && $answer != "NO" ]]; do 
                        echo "$rmPath is file wich you want to restore?" 
                        echo "If you want to restore $rmPath enter \"YES\"." 
                        echo "Otherwise enter \"NO\"." 
                        read answer 
                done 
 
                if [[ $answer == "YES" ]]; then 
                        if [[ ! -d $(dirname $rmPath) ]]; then 
                                if [[ ! -e ~/$1 ]]; then 
                                        echo "$(dirname $rmPath) has been restored in home directory" 
                                        ln $fullPath ~/$1 
                                else 
                                        finalName=$1 
                                        while [[ -f ~/$finalName ]]; do 
                                                echo "File with this name already exist. Enter a new file name." 
                                                read finalName 
                                        done 
                                        ln $fullPath ~/$finalName 
                                fi 
                        else
                                if [[ ! -e $rmPath ]]; then 
                                        ln $fullPath $rmPath 
 
                                else 
                                        finalName=$rmPath 
                                        while [[ -f $finalName ]]; do 
                                                echo "File with this name already exist. Enter a new file name." 
                                                read finalName 
                                        done 
                                        ln $fullPath "$(dirname $rmPath)/$finalName" 
                                fi 
                        fi 
                        rm $fullPath 
                        grep -v $trFile ~/.trash.log > ~/.trashTemp.log 
                        mv ~/.trashTemp.log ~/.trash.log 
                fi 
        fi 
done 


if [ $found -ne 1 ]; then
        echo "File wasn't found in trash."
        exit 1
fi
