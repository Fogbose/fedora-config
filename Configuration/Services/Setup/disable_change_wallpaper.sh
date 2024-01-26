#!/bin/bash

# Get current informations
current_user="$USER"
current_directory="$PWD"

echo "Stopping and disabling the change_wallpaper.timer service..."

# Stop and disable the service
sudo systemctl stop change_wallpaper.timer
sudo systemctl disable change_wallpaper.timer

echo "Removing the change_wallpaper.service and change_wallpaper.timer files ..."

# Remove the service and timer files from /etc/systemd/system
sudo rm "/etc/systemd/system/change_wallpaper.service"
sudo rm "/etc/systemd/system/change_wallpaper.timer"

echo "Removing change_wallpaper.sh script..."

# Remove the change_wallpaper.sh script
rm "$../current_directory/change_wallpaper.sh"

echo "Service disabled."
