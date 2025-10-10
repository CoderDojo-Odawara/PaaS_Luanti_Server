# PaaS_Luanti_Server
DojoPaaSにLuanti Serverを構築するためのスクリプト


## PaaSで使う場合
```shell
cd ~
curl -O https://raw.githubusercontent.com/CoderDojo-Odawara/PaaS_Luanti_Server/main/doitatonce.sh
curl -O https://raw.githubusercontent.com/CoderDojo-Odawara/PaaS_Luanti_Server/main/setup_luanti_server.sh
curl -O https://raw.githubusercontent.com/CoderDojo-Odawara/PaaS_Luanti_Server/main/startluanti.sh
sudo chmod +x ./doitatonce.sh
sudo chmod +x ./setup_luanti_server.sh
sudo chmod +x ./startluanti.sh
./doitatonce.sh
rm ./doitatonce.sh
./setup_luanti_server.sh
./startluanti.sh
```
サーバーが立ち上がったら　`Ctrl+A -> Ctrl+D` でスクリーン離脱。

サーバーを止める場合には
```shell
screen -r luanti
```
でスクリーンには入って`Ctrl+C`

また、一旦環境が構築できたら、以降は
```
./startluanti.sh
```
のみで運用する。
