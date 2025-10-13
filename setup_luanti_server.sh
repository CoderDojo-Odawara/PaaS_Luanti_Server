#!/bin/bash

# 依存パッケージの準備
echo "依存パッケージの準備..."
sudo apt update
sudo apt install -y g++ ninja-build cmake libsqlite3-dev libcurl4-openssl-dev zlib1g-dev libgmp-dev libjsoncpp-dev libzstd-dev libncurses-dev screen unzip

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

# luanti.confの導入
echo "Luanti.confの導入..."
curl -O https://raw.githubusercontent.com/CoderDojo-Odawara/PaaS_Luanti_Server/main/luanti.conf

# ゲームとMODのダウンロード (オプション)
echo "ゲームとMODのダウンロード (オプション)..."
cd games
wget -O mineclonia.zip https://content.luanti.org/packages/ryvnf/mineclonia/download/
unzip mineclonia.zip
rm mineclonia.zip
cd ..
cd mods
wget -O xcompat.zip https://content.luanti.org/packages/mt-mods/xcompat/download/
unzip xcompat.zip
rm xcompat.zip
wget -O lwscratch.zip https://content.luanti.org/packages/mt-mods/lwscratch/download/
unzip lwscratch.zip
rm lwscratch.zip
cd ..

#worldの作成とMODの適用設定
echo "worldの作成とMODの適用設定"
timeout -s SIGINT 10 ./bin/luantiserver --gameid mineclonia --world worlds/world --config ./luanti.conf
echo "load_mod_xcompat = true" >> ./worlds/world/world.mt
echo "load_mod_lwscratch = true" >> ./worlds/world/world.mt

echo "完了！ startluanti.shを実行してサーバーを起動してください。"
