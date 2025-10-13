# PaaS_Luanti_Server
CoderDojo Japanから提供されている[DojoPaaS](https://github.com/coderdojo-japan/dojopaas)
にLuanti Serverを自動構築するためのスクリプト

## 構築する環境
- ゲームはmineclonia
- 適用するMODはLWscratchのみ
- 作成するワールド名は　`world`
- ダメージなし、クリエイティブモード適用
- 与えられる権限は標準権限＋ fly, teleport
  

## 手順

### 必要なファイル類をダウンロード、実行権限付与
```shell
cd ~
curl -O https://raw.githubusercontent.com/CoderDojo-Odawara/PaaS_Luanti_Server/main/doitatonce.sh
curl -O https://raw.githubusercontent.com/CoderDojo-Odawara/PaaS_Luanti_Server/main/setup_luanti_server.sh
curl -O https://raw.githubusercontent.com/CoderDojo-Odawara/PaaS_Luanti_Server/main/startluanti.sh
sudo chmod +x ./doitatonce.sh
sudo chmod +x ./setup_luanti_server.sh
sudo chmod +x ./startluanti.sh
```
### SWAP領域作成　port開放（ここはサーバーを建ててから一回のみでOKなので手順に従ってｓｈファイルを削除するのが無難です）
```shell
./doitatonce.sh
rm ./doitatonce.sh
```
### Luanti環境構築
```shell
./setup_luanti_server.sh
```

### Luantiサーバ起動
```shell
./startluanti.sh
```

Luantiサーバが立ち上がったら　`Ctrl+A -> Ctrl+D` でスクリーン離脱。
ここまできたらSSH接続を切ってもOK。

サーバーを止める場合には
```shell
screen -r luanti
```
でスクリーンに入って`Ctrl+C`


### 環境を一から作り直したいのであれば。。。
Luantiサーバが停止している状態で
```shell
rm -rf luajit
rm -rf luant
./setup_luanti_server.sh
```

#### おまけ
作成されたworldは　`~/luanti/worlds/world` にあります。  
こちらをバックアップすることでworldのレストア、移植等可能になります。
