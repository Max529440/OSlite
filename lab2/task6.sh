#!/bin/bash

# Переменные для отслеживания максимальной используемой памяти
max_mem=0
max_mem_pid=""

# Перебираем директории процессов в /proc
for pid_dir in /proc/[0-9]*/; do
    pid=$(basename "$pid_dir")

    # Извлекаем информацию о потреблении памяти из файла status
    mem=$(awk '/VmRSS/ {print $2}' "$pid_dir/status" 2>/dev/null)

    # Если значение памяти присутствует и больше текущего максимума, обновляем значения
    if [[ -n "$mem" && $mem -gt $max_mem ]]; then
        max_mem=$mem
        max_mem_pid=$pid
    fi
done

# Выводим информацию о процессе с максимальным потреблением памяти
if [ -n "$max_mem_pid" ]; then
    echo "Процесс с PID $max_mem_pid имеет наибольшее потребление памяти: $max_mem кБ"
else
    echo "Не удалось найти процесс с максимальным потреблением памяти."
fi
