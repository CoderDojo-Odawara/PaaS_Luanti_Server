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

# 依存パッケージの準備
echo "依存パッケージの準備..."
sudo apt update
sudo apt install -y g++ ninja-build cmake libsqlite3-dev libcurl4-openssl-dev zlib1g-dev libgmp-dev libjsoncpp-dev libzstd-dev libncurses-dev screen

# LuaJITのビルド
echo "LuaJITのビルド..."
git clone https://github.com/LuaJIT/LuaJIT luajit
cd luajit
make amalg
cd ..

# Luantiの環境構築
echo "Luantiの環境構築..."
git clone -b stable-5 --depth 1 https://github.com/luanti-org/luanti.git
cd luanti
mkdir build; cd build
cmake .. -G Ninja -DBUILD_CLIENT=0 -DBUILD_SERVER=1 -DRUN_IN_PLACE=1 -DBUILD_UNITTESTS=0 \
  -DLUA_INCLUDE_DIR=../../luajit/src/ -DLUA_LIBRARY=../../luajit/src/libluajit.a
ninja
cd ..

# luanti.confの作成と修正
echo "luanti.confの作成と修正..."
cp minetest.conf.example luanti.conf
# 例: デフォルト権限の修正
sed -i 's/default_privileges = basic_player/default_privileges = basic_player,teleport,fly/' luanti.conf

# ゲームとMODのダウンロード (オプション)
echo "ゲームとMODのダウンロード (オプション)..."
cd games
wget https://git.minetest.land/MineClone2/MineClone2/-/archive/main/MineClone2-main.zip
unzip MineClone2-main.zip
mv MineClone2-main mineclonia
rm MineClone2-main.zip
cd ..
cd mods
wget -O lwscratch.zip https://content.luanti.org/packages/mt-mods/lwscratch/download/
unzip lwscratch.zip
rm lwscratch
cd ..
timeout -s SIGINT 10 ./bin/luantiserver --gameid mineclonia --world worlds/world --config ./luanti.conf
echo "load_mod_lwscratch = true" >> ./worlds/world/world.mt

echo "完了！ startluanti.shを実行してサーバーを起動してください。"
