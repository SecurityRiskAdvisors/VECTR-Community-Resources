#!/bin/bash
sudo su -

vectrName=$1
azureLocation=$2

apt-get update
apt-get -y install ca-certificates curl gnupg lsb-release

mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null

apt-get update
apt-get install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin
apt-get install -y unzip collectd jq
mkdir -p /opt/vectr

echo $vectrName > /home/ubuntu/name.txt

cd /opt/vectr/

wget $(curl 'https://api.github.com/repos/SecurityRiskAdvisors/VECTR/releases?page=1&per_page=1' | jq -r '.[0].assets[] | select(.browser_download_url | endswith(".zip")) | .browser_download_url') -O /opt/vectr/latestRelease.zip
unzip latestRelease.zip

NAME=$(head -n 1 /home/ubuntu/name.txt)
DOMAIN=.$azureLocation.cloudapp.azure.com
ADDRESS=$NAME$DOMAIN
JWS=$(openssl rand -hex 24)
JWE=$(openssl rand -hex 24)

sed -i 's/VECTR_PORT=8081/VECTR_PORT=443/' .env
sed -i "s/VECTR_HOSTNAME=sravectr.internal/VECTR_HOSTNAME=$ADDRESS/" .env
sed -i "s/VECTR_EXTERNAL_HOSTNAME=/VECTR_EXTERNAL_HOSTNAME=$ADDRESS/" .env
sed -i "s/JWS_KEY=CHANGEME/JWS_KEY=$JWS/" .env
sed -i "s/JWE_KEY=CHANGEMENOW/JWE_KEY=$JWE/" .env

docker compose up -d