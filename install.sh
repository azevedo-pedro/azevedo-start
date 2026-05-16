#!/bin/bash

START="$HOME/Developer/azevedo-start"

if [[ -d $START ]]; then
  echo 'Checking azevedo-start directory'
else
  echo 'Cloning azevedo-start'
  git clone https://github.com/azevedo-pedro/azevedo-start.git $START
fi

cd $START

source colors.sh

msg "Starting azevedo-start setup..."

source install/environment.sh
source install/softwares.sh
source install/settings.sh
source install/claude.sh

msg_ok "Setup complete! Restart your terminal."
