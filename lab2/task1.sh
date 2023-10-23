#!/bin/bash

name="user"
output="task1.txt"

process_count=$(ps -u $name | wc -l)

echo "$process_count" > $output

ps -u $name -o pid,cmd | awk 'NR > 1 {print $1 ":" $2}' >> $output # выводит только два столбца: "pid" (идентификатор процесса) и "cmd"
# awk фильтрует вывод, ропуская первую строкy, и выводит только значения из столбцов "pid" и "cmd" с разделителем ":".

cat $output
