#!/bin/bash

# SWAP領域の設定
echo "SWAP領域の設定..."
sudo dd if=/dev/zero of=/swapfile bs=1M count=2048
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile
echo "/swapfile none swap sw 0 0" | sudo tee -a /etc/fstab

# 使用ポートの開放
echo "使用ポートの開放..."
sudo iptables -A INPUT -p udp --dport 30000 -j ACCEPT
sudo netfilter-persistent save
sudo netfilter-persistent reload
