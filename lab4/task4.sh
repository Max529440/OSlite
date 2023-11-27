#!/bin/bash 
 
dateRegex="[0-9]{4}-[0-1][0-9]-[0-3][0-9]" 
lastDate=$(ls $HOME | grep -E "^Backup-${dateRegex}$" | sort | tail -n 1 | awk -F - '{print $2"-"$3"-"$4}') 
 
if [[ $lastDate == "--" ]]; then 
  echo "You don't have any backups." 
  exit 1 
fi 
 
if [[ ! -d $HOME/restore ]]; then 
  mkdir $HOME/restore 
fi 
 
# deleted swag (exists swag.hasgdjh) restore swag.tetret 
 
files=$(for file in `ls $HOME/Backup-$lastDate`; do 
  if [[ $file =~ .${dateRegex}$ ]]; then 
    echo ${file::-11} 
  else 
    echo $file 
  fi 
done | sort | uniq) 
 
for file in $files; do 
  cp $HOME/Backup-$lastDate/$file $HOME/restore/$file 
done
