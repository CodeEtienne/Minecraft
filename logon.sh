#!/bin/bash

# Terminal colors
BLACK=$(tput setaf 0)
RED=$(tput setaf 1)
GREEN=$(tput setaf 2)
YELLOW=$(tput setaf 3)
LIME_YELLOW=$(tput setaf 190)
BLUE=$(tput setaf 4)
MAGENTA=$(tput setaf 5)
CYAN=$(tput setaf 6)
WHITE=$(tput setaf 7)
BRIGHT=$(tput bold)
NORMAL=$(tput sgr0)
BLINK=$(tput blink)
REVERSE=$(tput smso)
UNDERLINE=$(tput smul)

# Prints a line with color using terminal codes
Print_Style() {
  printf "%s\n" "${2}$1${NORMAL}"
}
echo
Print_Style "Welcome to $(hostname)!" "$BRIGHT"
echo
UNAME=$(uname -a)
TotalMemory=$(awk '/MemTotal/ { printf "%.0f\n", $2/1024 }' /proc/meminfo)
AvailableMemory=$(awk '/MemAvailable/ { printf "%.0f\n", $2/1024 }' /proc/meminfo)
UsedMemory=$(($TotalMemory-$AvailableMemory))
PercentUsed=$(($UsedMemory*100/$TotalMemory))
CPUTemp=$(vcgencmd measure_temp|cut -d"=" -f2)
CPUFreq=$(vcgencmd get_config arm_freq|cut -d"=" -f2)
IPaddr=$(hostname -I)
DefaultGateway=$(ip route show|head -1|awk '{ print $3 }')
Print_Style "$UNAME" "$YELLOW"
uptime
echo
Print_Style "MINECRAFT" "$RED"
mcrcon -H $IPaddr -p *PASSWORD* "list"
echo
Print_Style "MEMORY" "$RED"
Print_Style "Total memory: $TotalMemory - Available Memory: $AvailableMemory - Used Memory: $UsedMemory" "$NORMAL"
Print_Style "Percentage used memory: $PercentUsed%" "$NORMAL"
echo
Print_Style "CPU" "$RED"
Print_Style "Frequency: $CPUFreq Mhz"
Print_Style "Temperature: $CPUTemp" "$NORMAL"
Print_Style "Top 10 ressource intensive processes:"
ps -eo pcpu,pid,user,args | sort -k 1 -r | head -10
echo
Print_Style "NETWORK" "$RED"
Print_Style "IP address: $IPaddr" "$NORMAL"
Print_Style "DefaultGateway: $DefaultGateway"
echo
