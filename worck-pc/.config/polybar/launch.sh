#!/bin/bash

# Завершить текущие экземпляры polybar
#killall -q polybar

# Ожидание полного завершения работы процессов
#while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

# Запуск Polybar со стандартным расположением конфигурационного файла в ~/.config/polybar/config
#polybar mybar &

#echo "Polybar загрузился..."#!/bin/bash

# Завершить текущие экземпляры polybar
killall -q polybar

# Ожидание полного завершения работы процессов
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

# Запуск Polybar со стандартным расположением конфигурационного файла в ~/.config/polybar/config

polybar status -r &
sleep 10
polybar example -r &
#sleep1 15
#polybar -c ~/.config/polybar/config1 example1 -r &


echo "Polybar загрузился..."
