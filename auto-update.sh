#!/bin/bash
PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin

cd /opt/factorio
su -c "/opt/factorio-init/factorio update --dry-run" factorio | grep 'No new updates'
servupdate=$?
su -c "/opt/factorio-mod-updater/factorio-mod-updater --dry-run" factorio > /dev/null
modupdate=$?
if [ $servupdate == 0 ] && [ $modupdate == 0 ]
then
        echo "No new update for Factorio or Mods"
        logger "No new update for Factorio or Mods"
        exit 0;
elif [ $servupdate == 2 ] || [ $modupdate == 2 ]
then
        echo "New update"
        logger "Updating Factorio or mods"
        if [ $servupdate == 2 ]
        then
                su -c '/opt/factorio-init/factorio cmd "Server will be restarted in 1 minute to upgrade to new factorio version"' factorio
        fi
        if [ $modupdate == 2 ]
        then
                su -c '/opt/factorio-init/factorio cmd "Server will be restarted in 1 minute to upgrade mods"' factorio
        fi
        sleep 50
        su -c '/opt/factorio-init/factorio cmd "Server restarting in 10 seconds"' factorio
        sleep 10
        su -c '/opt/factorio-init/factorio cmd "Server restarting now"' factorio
        systemctl stop factorio.service
        if [ $servupdate == 2 ]
        then
                echo "Server update found"
                su -c "/opt/factorio-init/factorio update" factorio
        fi
        if [ $modupdate == 2 ]
        then
                echo "Mod update found"
                su -c "/opt/factorio-mod-updater/factorio-mod-updater" factorio
        fi
        systemctl start factorio.service
        exit 0;
else
        echo "Something went boo-boo somewhere..."
        exit 1;
fi
