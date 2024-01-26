#!/bin/bash

# Get current informations
current_user="$USER"
current_directory="$PWD"

# Path to the wallpaper folder
wallpaper_folder="/home/$current_user/Images/Wallpaper"

echo "Creating change_wallpaper.sh script"

# Create change_wallpaper.sh script
cat <<EOL > "../$current_directory/change_wallpaper.sh"
#!/bin/bash

wallpaper_folder="$wallpaper_folder"
files=("\$wallpaper_folder"/*)
random_file="\${files[RANDOM % \${#files[@]}]}"
gsettings set org.gnome.desktop.background picture-uri "file://\$random_file"
EOL

# Allow the execution of change_wallpaper.sh script
chmod +x "$current_directory/change_wallpaper.sh"

echo "Creating change_wallpaper.service file..."

# Create change_wallpaper.service service file
cat <<EOL > "$current_directory/change_wallpaper.service"
[Unit]
Description=Change Wallpaper Service
After=graphical.target

[Service]
User=$current_user
ExecStart=/bin/bash $current_directory/change_wallpaper.sh

[Install]
WantedBy=default.target
EOL

# Allow the execution of the change_wallpaper.sercice service file
chmod +x "$current_directory/change_wallpaper.service"

echo "Creating change_wallpaper.time file..."

# Create change_wallpaper.timer timer file
cat <<EOL > "$current_directory/change_wallpaper.timer"
[Unit]
Description=Change Wallpaper Timer

[Timer]
OnCalendar=*-*-* 08,14,18:30:00
Persistent=true

[Install]
WantedBy=timers.target
EOL

# Allow the execution of the change_wallpaper.timer timer file
chmod +x "$current_directory/change_wallpaper.timer"

# Copy service and timer in /etc/systemd/system
sudo mv "$current_directory/change_wallpaper.service" "/etc/systemd/system/"
sudo mv "$current_directory/change_wallpaper.timer" "/etc/systemd/system/"

echo "Enabling and starting the service..."

# Enable and start the service
sudo systemctl daemon-reload
sudo systemctl enable change_wallpaper.timer
sudo systemctl start change_wallpaper.timer

echo "Wallpaper change service is now set up and running"
