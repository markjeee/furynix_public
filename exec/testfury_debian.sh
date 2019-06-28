#!/usr/bin/env bash

export FURY_APT_SOURCE_FILE=/etc/apt/sources.list.d/fury.list

apt update -y
apt install -y apt-transport-https

echo "deb [trusted=yes] $FURY_REPO_URL /" > $FURY_APT_SOURCE_FILE
echo "Added fury APT source: "
cat $FURY_APT_SOURCE_FILE

apt update -y

apt install -y gemfury
which fury
fury version
