#!/bin/bash

INTERFACE=$1

if [ -z "$INTERFACE" ]; then
        echo "Uso: sudo $0 <interfaz>"
        echo "Ejemplo: sudo $0 eth0"
        exit 1
fi

echo "[*] Buscando hosts con arp-scan en $INTERFACE..."
arp-scan -I "$INTETRFACE" --localnet

echo ""
echo "[*] Introduce IP victima:"
read TARGET

echo ""
echo "[*] Scanning $TARGET..."
nmap -p- --open -sS -sC -sV --min-rate 5000 -n -vvv -Pn "$TARGET" -oN scan

echo ""
echo "[*] Checking connection:"
TTL=$(ping -c 1 "$TARGET" | grep -oE "ttl=[0-9]+")

if [ $TTL == "ttl=64" ]; then
        echo "Linux host detected."
elif [ $TTL == "ttl=128" ]; then
        echo "Windows host detectted."
else
        echo "host type not detected."
fi
