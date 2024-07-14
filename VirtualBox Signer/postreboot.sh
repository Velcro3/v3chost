#!/bin/bash
echo Continuing install of VBOX signing
echo "Signing VBox is nearly complete."
echo "Finding sign-file..."
sf=$(find /usr/src -name sign-file | sed -e "1d")
echo "Using created kernel module file to sign modules."
for modfile in $(dirname $(modinfo -n vboxdrv))/*.ko; do
    echo "Signing $modfile"
    $sf sha256 \
                                    /root/signed-modules/MOK.priv \
                                    /root/signed-modules/MOK.der "$modfile"
done
echo "Finished signing. Launching vboxconfig to configure modules."
/sbin/vboxconfig
echo "Modprobing vboxdrv..."
modprobe vboxdrv
echo "Done! exiting..."
exit 0