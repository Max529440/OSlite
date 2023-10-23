#!/bin/bash

> info.txt

for dir in /proc/[0-9]*; do
    pid=$(basename "$dir") # Функция basename используется для извлечения только числовой части имени каталога.

    ppid=$(awk '/PPid/ {print $2}' "$dir/status" 2>/dev/null)
    sum_exec_runtime=$(awk '/sum_exec_runtime/ {print $3}' "$dir/sched" 2>/dev/null)
    nr_switches=$(awk '/nr_switches/ {print $3}' "$dir/sched" 2>/dev/null)

    if [[ -n "$sum_exec_runtime" && -n "$nr_switches" ]]; then
        ART=$(bc -l <<< "scale=2; $sum_exec_runtime / $nr_switches")
    else
        ART="N/A"
    fi

# Скрипт проверяет, что информация о sum_exec_runtime и nr_switches доступна. Если оба значения доступны, то вычисляется среднее время выполнения процесса
# (ART) путем деления sum_exec_runtime на nr_switches с использованием утилиты bc. Если какая-либо информация отсутствует, то ART устанавливается
# равным "N/A".

    echo "ProcessID=$pid : Parent_ProcessID=${ppid:-N/A} : Average_Running_Time=$ART" >> info.txt
done

sort -t= -k3 -n info.txt
