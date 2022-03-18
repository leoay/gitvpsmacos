#!/bin/bash

echo "### Install Frp ###"

wget https://github.com/fatedier/frp/releases/download/v0.40.0/frp_0.40.0_darwin_amd64.tar.gz

tar xvf ./frp_0.40.0_darwin_amd64.tar.gz

echo [common] >> ./frp_0.40.0_darwin_amd64/frpc_cu.ini
echo server_addr = $HOSTURL >> ./frp_0.40.0_darwin_amd64/frpc_cu.ini
echo server_port = 7000 >> ./frp_0.40.0_darwin_amd64/frpc_cu.ini
echo "" >> ./frp_0.40.0_darwin_amd64/frpc_cu.ini
echo [web48080] >> ./frp_0.40.0_darwin_amd64/frpc_cu.ini
echo type = tcp >> ./frp_0.40.0_darwin_amd64/frpc_cu.ini
echo local_ip = 127.0.0.1 >> ./frp_0.40.0_darwin_amd64/frpc_cu.ini
echo local_port = 22 >> ./frp_0.40.0_darwin_amd64/frpc_cu.ini
echo remote_port = 48080 >> ./frp_0.40.0_darwin_amd64/frpc_cu.ini

cat ./frp_0.40.0_darwin_amd64/frpc_cu.ini

nohup ./frp_0.40.0_darwin_amd64/frpc -c ./frp_0.40.0_darwin_amd64/frpc_cu.ini &

mkdir -p ~/.config/code-server

echo bind-addr: 0.0.0.0:8080 >> ~/.config/code-server/config.yaml
echo auth: password >> ~/.config/code-server/config.yaml
echo password: 111111 >> ~/.config/code-server/config.yaml
echo cert: false >> ~/.config/code-server/config.yaml

wget https://github.com/coder/code-server/releases/download/v3.9.3/code-server-3.9.3-macos-amd64.tar.gz
tar xvf code-server-3.9.3-macos-amd64.tar.gz

./code-server-3.9.3-macos-amd64/code-server