#!/bin/bash


if [[ -z "$NGROK_TOKEN" ]]; then
  echo "Please set 'NGROK_TOKEN'"
  exit 2
fi

if [[ -z "$USER_PASS" ]]; then
  echo "Please set 'USER_PASS' for user: $USER"
  exit 3
fi

echo "### Install ngrok ###"

wget -q https://bin.equinox.io/c/4VmDzA7iaHb/ngrok-stable-darwin-amd64.zip
unzip ngrok-stable-darwin-amd64.zip
chmod +x ./ngrok

echo "### Update user: $USER password ###"
echo -e "$USER_PASS\n$USER_PASS" | sudo passwd "$USER"

echo "### Start CodeServer proxy for 8080 port ###"

rm -f .ngrok.log
./ngrok authtoken "$NGROK_TOKEN"
nohup ./ngrok tcp 8080 --log ".ngrok.log" &

sleep 10
HAS_ERRORS=$(grep "command failed" < .ngrok.log)

mkdir -p ~/.config/code-server

echo bind-addr: 0.0.0.0:8080 >> ~/.config/code-server/config.yaml
echo auth: password >> ~/.config/code-server/config.yaml
echo password: 111111 >> ~/.config/code-server/config.yaml
echo cert: false >> ~/.config/code-server/config.yaml

wget https://github.com/coder/code-server/releases/download/v3.9.3/code-server-3.9.3-macos-amd64.tar.gz
tar xvf code-server-3.9.3-macos-amd64.tar.gz

if [[ -z "$HAS_ERRORS" ]]; then
  echo ""
  echo "=========================================="
  echo "To connect: $(grep -o -E "tcp://(.+)" < .ngrok.log | sed "s/tcp:\/\//ssh $USER@/" | sed "s/:/ -p /")"
  echo "=========================================="
else
  echo "$HAS_ERRORS"
  exit 4
fi

./code-server-3.9.3-macos-amd64/code-server