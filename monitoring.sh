#!/bin/bash

# Liste des couleurs

RED='\e[1;31m%s\e[0m'
GREEN='\e[1;32m%s\e[0m'
YELLOW='\e[1;33m%s\e[0m'
BLUE='\e[1;34m%s\e[0m'
MAGENTA='\e[1;35m%s\e[0m'
CYAN='\e[1;36m%s\e[0m'

# Affichage de l'architecture du systeme d'exloitation et sa version kernel

ARCHITECTURE=$( uname -a )

# Affichage du nombre de processeurs physiques & virtuels

PROCESSORPHY=$(nproc)
PROCESSORVIR=$(cat /proc/cpuinfo | grep "processor" | wc -l)

# Affichage de la memoire vive disponible sur le serveur et son taux d'utilisation en %

MEMORY_USAGE1=$(free -m | grep "Mem" | awk '{printf $3}' )
MEMORY_USAGE2=$(free -m | grep "Mem" | awk '{printf $2}' )
MEMORY_USAGE3=$(free -m | grep "Mem" | awk '{printf ("%.2f"), $3*100/$2}')

# Affichage Disk Usage ( memoire disponible )

DISK1=$(df -h | awk '$NF=="/"{printf "%d", $3}')
DISK2=$(df -h | awk '$NF=="/"{printf "%d", $2}')
DISK3=$(df -h | awk '$NF=="/"{printf "%s", $5}')

# Affichage taux d'utilisation procsesseur %

CPU=$(top -bn1 | grep "load" | awk '{printf "%.1f", $9}')

# Affiche la date et l'heure du dernier start

LAST_REBOOT=$(who -b | awk '{printf $3 " "$4}')

#Affichage si LVM est actif

LVM=$(lsblk | grep lvm | awk '{if ($1) {printf "yes";exit;} else {printf "no"}} ')

# Affiche le nombre de connection actives

TCP=$(cat /proc/net/sockstat | awk '$1 == "TCP:" {printf $3}')

# Afficher le nombre d'utilisateur

ULOG=$(users | wc -w)

# Affiche L'adresse IPV4 du serveur et celle du MAC (Media Access Control)

IPV4=$(hostname -I)
MAC=$(ip a | grep "link/ether" | awk '{printf $2}')

# Affiche le nombre de commande executer grace a sudo

SUDO=$(cat /var/log/auth.log | grep -a "sudo" | wc -l)

#Mise en forme du script
wall "
`printf "$GREEN" "#Architecture:"` `printf "$YELLOW" ${ARCHITECTURE}`
`printf "$BLUE" "#CPU physical:"` `printf "$CYAN" ${PROCESSORPHY}`
`printf "$BLUE" "#vCPU: "`  `printf "$CYAN" ${PROCESSORVIR}`
`printf "$GREEN" "#Memory Usage:"` `printf "$MAGENTA" ${MEMORY_USAGE1}/${MEMORY_USAGE2}MB`(${MEMORY_USAGE3}%)
`printf "$GREEN" "#Disk Usage:"` `printf "$MAGENTA" ${DISK1}/${DISK2}Gb (${DISK3})`
`printf "#CPU load:"` `printf "$MAGENTA" ${CPU}%`
`printf "$YELLOW" "#Last boot :" ${LAST_REBOOT}`
`printf "$RED" "#LVM use:"` ${LVM}
`printf "$RED" "#Connection TCP:"` ${TCP} `printf "$RED" "HAS BEEN ESTABLISHED"`
`printf "$GREEN" "#User log:"`  ${ULOG} Users
`printf "$GREEN" "#Network: IP:"` ${IPV4} `printf "GREEN" "MAC: "` ${MAC}
`printf "$GREEN" "#sudo:"` ${SUDO} `printf "$GREEN" "uses"`
"
