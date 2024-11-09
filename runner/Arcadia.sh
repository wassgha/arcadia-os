#!/bin/bash

#
# Environment settings
#
export TERM=linux
export LANG=en_US.UTF-8 # Ensure that the environment is configured to handle Unicode characters properly

#####################
#  GLOBAL VARIABLES #
#####################
current_OS=""
sudo_prefix="sudo"

sudo chmod 666 /dev/tty1
printf "\033c" > /dev/tty1
reset

# hide cursor
printf "\e[?25l" > /dev/tty1
dialog --clear

# check whether sudo is needed
if [[ "$EUID" -eq 0 ]]; then
  sudo_prefix=""
fi
$sudo_prefix chmod 666 /dev/uinput 2>> ./Store.log

echo "🎮 Starting Arcadia..."

# Set up folders and permissions
cd "$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )/Arcadia"
$ESUDO chmod +x ./Store


function get_current_OS() {
    # *"ArkOS"* *"RetroOZ"* *"TheRA"* *"JELOS"* *"ROCKNIX"* *"UnofficialOS"* *"NOSTIX"* 
    local current_OS

    if [[ -e "/usr/share/plymouth/themes/text.plymouth" ]]; then
        current_OS=$(grep "title=" "/usr/share/plymouth/themes/text.plymouth")
    elif [[ -e "/etc/os-release" ]]; then
        current_OS=$(grep "NAME" "/etc/os-release")
    fi
    echo "$current_OS"
}

current_OS=$(get_current_OS)
echo "Setting up for $current_OS ..."
# Setting up input an output for dialog management
if [ -t 1 ]; then
  $sudo_prefix chmod 666 "$(tty)" 2>> ./Store.log
elif [[ ( $current_OS == *"JELOS"* || $current_OS == *"UnofficialOS"* ) &&  "${UI_SERVICE}" = "weston.service" ]]; then
  exec </dev/tty >/dev/tty
  $sudo_prefix chmod 666 /dev/tty 2>> ./Store.log
else
  exec </dev/tty1 >/dev/tty1
  $sudo_prefix chmod 666 /dev/tty1 2>> ./Store.log
fi

#Workaround for window initialisation on weston
if [[ "${UI_SERVICE}" = "sway.service essway.service" ]]; then
  ./image-viewer "$(find ./data -name '*.png' -print -quit)" &
  PID=$!
  sleep 1
  kill $PID
  sleep 0.5
fi

#
# App initialisation
#
echo "Launching ..."

sleep 1
clear

echo "$(date)" > ./Store.log
if [ "${UI_SERVICE}" = "weston.service" ]; then
  run './Store 2>&1 | tee -a ./Store.log'
elif [ "${UI_SERVICE}" = "sway.service essway.service" ]; then
  foot -F ./Store 2>&1 | tee -a ./Store.log
else
  bash ./Store 2>&1 | tee -a ./Store.log
fi

#Trap clean up function
trap ExitApp EXIT
