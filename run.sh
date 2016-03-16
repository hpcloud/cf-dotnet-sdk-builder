#!/bin/bash
set -e

export MYSQL_ROOT_PASSWORD=password

/usr/local/bin/run >>/tmp/mysql.log 2>&1 &
rbenv global 2.2.4

cd /root/cf-dotnet-sdk-builder

bash -i
