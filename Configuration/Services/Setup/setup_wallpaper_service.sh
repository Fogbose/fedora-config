#!/bin/bash

# Get current informations
current_user="$USER"
current_directory="$(realpath "$(dirname "$0")")" # Use realpath to get global path of the script

# Path to wallpaper folder, scripts and services
wallpaper_folder="/home/$current_user/Images/Wallpaper"
script_path="$current_directory/.."
unit_path="/etc/systemd/system"

echo "Creating change_wallpaper.sh script"

# Create change_wallpaper.sh script
cat <<EOL > "$script_path/change_wallpaper.sh"
#!/bin/bash

export DISPLAY=:O # Set the display for GUI operations
export GSETTINGS_BACKEND=dconf # Set the backend for gsettings

wallpaper_folder="$wallpaper_folder"
files=("\$wallpaper_folder"/*)
random_file="\${files[RANDOM % \${#files[@]}]}"
gsettings set org.gnome.desktop.background picture-uri "file://\$random_file"
EOL

# Allow the execution of change_wallpaper.sh script
chmod +x "$script_path/change_wallpaper.sh"

echo "Creating change_wallpaper.service file..."

# Create change_wallpaper.service service file
cat <<EOL | sudo tee "$unit_path/change_wallpaper.service" >/dev/null
[Unit]
Description=Change Wallpaper Service
After=graphical.target

[Service]
User=$current_user
Environment=Display=:0
ExecStart=/bin/bash $script_path/change_wallpaper.sh

[Install]
WantedBy=default.target
EOL

# Allow the execution of the change_wallpaper.sercice service file
sudo chmod 664 "$unit_path/change_wallpaper.service"

echo "Creating change_wallpaper.timer file..."

# Create change_wallpaper.timer timer file
cat <<EOL | sudo tee "$unit_path/change_wallpaper.timer" >/dev/null
[Unit]
Description=Change Wallpaper Timer

[Timer]
OnCalendar=*-*-* 08,14,16:03:00
Persistent=true

[Install]
WantedBy=timers.target
EOL

# Allow the execution of the change_wallpaper.timer timer file
sudo chmod 664 "$unit_path/change_wallpaper.timer"

echo "Enabling and starting the service..."

# Enable and start the service
sudo systemctl daemon-reload
sudo systemctl enable change_wallpaper.timer
sudo systemctl start change_wallpaper.timer

echo "Wallpaper change service is now set up and running"
