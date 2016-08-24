#!/bin/bash
set -e

export MYSQL_ROOT_PASSWORD=password

/usr/local/bin/run >>/tmp/mysql.log 2>&1 &


mkdir -p "$(rbenv root)/plugins"
git clone git://github.com/tpope/rbenv-aliases.git \
  "$(rbenv root)/plugins/rbenv-aliases"
rbenv alias --auto

rbenv global 2.3

cd /root/cf-dotnet-sdk-builder

export DB=mysql

bash -i
