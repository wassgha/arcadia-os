#!/bin/bash

echo "🎮 Starting Arcadia Store..."

cd "$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )/ArcadiaStore"
$ESUDO chmod +x ./Store

echo "$(date)" > ./Store.log
if [ "${UI_SERVICE}" = "weston.service" ]; then
  run './Store 2>&1 | tee -a ./Store.log'
elif [ "${UI_SERVICE}" = "sway.service essway.service" ]; then
  foot -F ./Store 2>&1 | tee -a ./Store.log
else
  bash ./Store 2>&1 | tee -a ./Store.log
fi
