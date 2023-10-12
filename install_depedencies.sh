#!/bin/bash 

sed -i -e 's/deb.debian.org/archive.debian.org/g' -e 's|security.debian.org|archive.debian.org/|g' -e '/stretch-updates/d' /etc/apt/sources.list
apt-get update
# Install docker
apt-get curl
curl -fsSL https://get.docker.com -o get-docker.sh
sh get-docker.sh
# Install amke
apt-get install make
# Install git
apt-get install -y git
# Install osmium
apt-get update -y
apt-get install -y osmium-tool
# Install docker-compose
apt-get install -y docker-compose
# Install wget
apt-get install -y wget

