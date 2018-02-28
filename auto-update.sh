#!/bin/bash
PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

cd /opt/factorio
servversion=$(su -c "/opt/factorio-init/factorio version" factorio)
servupdateoutput=$(su -c "/opt/factorio-init/factorio update --dry-run" factorio)
servupdate=$?
modupdateoutput=$(su -c "/opt/factorio-mod-updater/factorio-mod-updater --dry-run" factorio)
modupdate=$?

if [ $servupdate == 0 ] && [ $modupdate == 0 ]
then
        if [ "$1" == "-p" ] # make a switch to print out current versions of mods and factorio even if there are no updates. This can be useful if you want the versions to be reported via email.
        then
                echo "No new update for Factorio or Mods."
                echo "Server version: "$servversion
                echo "Mod Versions:"
                echo "$modupdateoutput" | grep -B 1 "Current"
        fi
        echo "$servupdateoutput" |(logger -t "factorio autoupdate")
        echo "$modupdateoutput" |(logger -t "factorio autoupdate")
        exit 0;
elif [ $servupdate == 2 ] || [ $modupdate == 2 ]
then
        echo "New update"
        logger "Updating Factorio or mods"
        if [ $servupdate == 2 ]
        then
                su -c '/opt/factorio-init/factorio cmd "Server will be restarted in 1 minute to upgrade to new factorio version"' factorio | tee >(logger -t "factorio autoupdate")
        fi
        if [ $modupdate == 2 ]
        then
                su -c '/opt/factorio-init/factorio cmd "Server will be restarted in 1 minute to upgrade mods"' factorio | tee >(logger -t "factorio autoupdate")
        fi
        sleep 50
        su -c '/opt/factorio-init/factorio cmd "Server restarting in 10 seconds"' factorio | tee >(logger -t "factorio autoupdate")
        sleep 10
        su -c '/opt/factorio-init/factorio cmd "Server restarting now"' factorio | tee >(logger -t "factorio autoupdate")
        systemctl stop factorio.service
        if [ $servupdate == 2 ]
        then
                echo "Factorio update found"
                su -c "/opt/factorio-init/factorio update" factorio | tee >(logger -t "factorio autoupdate")
        fi
        if [ $servupdate == 0 ]
        then
                if [ "$1" == "-p" ] # output non-updated components
                then
                        echo "No new update for Factorio."
                        echo "Server version: "$servversion
                fi
                echo "$servupdateoutput" |(logger -t "factorio autoupdate")
        fi
        if [ $modupdate == 2 ]
        then
                echo "Mod update found"
                su -c "/opt/factorio-mod-updater/factorio-mod-updater" factorio | tee >(logger -t "factorio autoupdate")
        fi
        if [ $modupdate == 0 ]
        then
                if [ "$1" == "-p" ] # output non-updated components
                then
                        echo "No new update for Mods."
                        echo "Mod Versions:"
                        echo "$modupdateoutput" | grep -B 1 "Current"
                fi
                echo "$modupdateoutput" |(logger -t "factorio autoupdate")
        fi
        systemctl start factorio.service
        exit 0;
else
        echo "Something went boo-boo somewhere..."
        exit 1;
fi
