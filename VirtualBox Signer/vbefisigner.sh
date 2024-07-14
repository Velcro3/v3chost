#!/bin/bash
if [ $(id -u) -ne 0 ]; then
echo "Run as root! exiting..."
exit 0
fi
echo "Welcome to VBOX Secure Boot Signer."
echo "This is a script to sign VirtualBox Kernel Modules for EFI Secure Boot."
echo "Choose your distro package manager: "
echo "1) apt"
echo "2) dnf"
echo "3) zypper"
echo "4) pkcon"
read -n 1 -p "Package Manager: "
echo "Satisfying dependencies..."
case $REPLY in
    "1")
        apt install mokutil openssl
        ;;
    "2")
        dnf install mokutil openssl
        ;;
    "3")
        zypper install mokutil openssl
        ;;
    "4")
        pkcon install mokutil openssl
        ;;
esac
echo "Setting up to sign drivers..."
mkdir /root/signed-modules
cd /root/signed-modules
openssl req -new -x509 -newkey rsa:2048 -keyout MOK.priv -outform DER -out MOK.der -nodes -days 36500 -subj "/CN=VirtualBox"
chmod 600 MOK.priv
echo "Choose password on this step."
mokutil --import MOK.der
echo "Your system will reboot. Use Keyboard to choose Enroll MOK, Continue, and enter the password you just chose."
echo "Setting up post-reboot script..."
wget https://raw.githubusercontent.com/Velcro3/v3chost/main/VirtualBox%20Signer/postreboot.sh -o /root/vbsprs
echo "Run sudo /root/vbsprs after reboot in a console to finish setup."
reboot
