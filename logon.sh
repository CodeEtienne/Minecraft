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

# Setting the variables
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

# Minecraft
echo
Print_Style "MINECRAFT" "$RED"
<<<<<<< HEAD
mcrcon -H $IPaddr -p C0sm0s1826 "list"

# Memory
=======
mcrcon -H $IPaddr -p *PASSWORD* "list"
>>>>>>> 96929af39d1ab98f235a47d0e597213f3fee0a26
echo
Print_Style "MEMORY" "$RED"
Print_Style "Total memory: $TotalMemory - Available Memory: $AvailableMemory - Used Memory: $UsedMemory" "$NORMAL"
Print_Style "Percentage used memory: $PercentUsed%" "$NORMAL"

# CPU
echo
Print_Style "CPU" "$RED"
Print_Style "Frequency: $CPUFreq Mhz"
Print_Style "Temperature: $CPUTemp" "$NORMAL"
Print_Style "Top 10 ressource intensive processes:"
ps -eo pcpu,pid,user,args | sort -k 1 -r | head -10

# Network
echo
Print_Style "NETWORK" "$RED"
Print_Style "IP address: $IPaddr" "$NORMAL"
Print_Style "DefaultGateway: $DefaultGateway"
echo
