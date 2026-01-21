#!/bin/bash
#CREATED BY Younes DECHRAOUI - FIXED VERSION

printf "Installing RDP - Please Be Patient... " >&2

{
# Create user with proper permissions
sudo useradd -m -s /bin/bash DECO
echo 'DECO:0000' | sudo chpasswd
sudo usermod -aG sudo DECO

# Update system
sudo apt-get update -y

# Install Chrome Remote Desktop
wget -q https://dl.google.com/linux/direct/chrome-remote-desktop_current_amd64.deb
sudo dpkg --install chrome-remote-desktop_current_amd64.deb || true
sudo apt install --assume-yes --fix-broken

# Install desktop environment
sudo DEBIAN_FRONTEND=noninteractive apt install --assume-yes xfce4 desktop-base xfce4-terminal

# Configure Chrome Remote Desktop session
sudo bash -c 'echo "exec /etc/X11/Xsession /usr/bin/xfce4-session" > /etc/chrome-remote-desktop-session'
sudo apt install --assume-yes xscreensaver

# Disable display manager to avoid conflicts
sudo systemctl stop lightdm 2>/dev/null
sudo systemctl disable lightdm 2>/dev/null

# Install Chrome browser
wget -q https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo dpkg --install google-chrome-stable_current_amd64.deb || true
sudo apt install --assume-yes --fix-broken

# Install additional utilities
sudo apt install nautilus nano firefox -y

# Add user to chrome-remote-desktop group
sudo usermod -aG chrome-remote-desktop DECO

# Fix permissions for DECO user
sudo chown -R DECO:DECO /home/DECO

} &> /dev/null && printf "\nSetup Complete " >&2 || printf "\nError Occurred " >&2

printf '\nCheck https://remotedesktop.google.com/headless  Copy Command Of Debian Linux And Paste Below\n'
read -p "Paste Here: " CRP

# Execute Chrome RDP command as DECO user properly
sudo -u DECO bash << EOF
export HOME=/home/DECO
cd ~
$CRP
EOF

printf '\nCheck https://remotedesktop.google.com/access/ \n\n'

# Final system update
if sudo apt-get upgrade -y &> /dev/null
then
    printf "\nUpgrade Completed Successfully\n" >&2
    printf "\nYour RDP should be ready. Use:\n"
    printf "Username: DECO\n"
    printf "Password: 0000\n"
    printf "\nAccess at: https://remotedesktop.google.com/access/\n"
else
    printf "\nError Occurred during upgrade\n" >&2
fi
