#!/bin/bash
PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games

cd /opt/factorio
servversion=$(su -c "/opt/factorio-init/factorio version" factorio)
servupdateoutput=$(su -c "/opt/factorio-init/factorio update --dry-run" factorio)
servupdate=$?
modupdateoutput=$(su -c "/opt/factorio-mod-updater/factorio-mod-updater --dry-run" factorio)
modupdate=$?
if [ $servupdate == 0 ] && [ $modupdate == 0 ]
then
        echo "No new update for Factorio or Mods. Server version: "$servversion
        echo "$servupdateoutput" |(logger -t "factorio update")
        echo "$modupdateoutput" |(logger -t "factorio update")
        exit 0;
elif [ $servupdate == 2 ] || [ $modupdate == 2 ]
then
        echo "New update"
        logger "Updating Factorio or mods"
        if [ $servupdate == 2 ]
        then
                su -c '/opt/factorio-init/factorio cmd "Server will be restarted in 1 minute to upgrade to new factorio version"' factorio | tee >(logger -t "factorio update")
        fi
        if [ $modupdate == 2 ]
        then
                su -c '/opt/factorio-init/factorio cmd "Server will be restarted in 1 minute to upgrade mods"' factorio | tee >(logger -t "factorio update")
        fi
        sleep 50
        su -c '/opt/factorio-init/factorio cmd "Server restarting in 10 seconds"' factorio | tee >(logger -t "factorio update")
        sleep 10
        su -c '/opt/factorio-init/factorio cmd "Server restarting now"' factorio | tee >(logger -t "factorio update")
        systemctl stop factorio.service
        if [ $servupdate == 2 ]
        then
                echo "Server update found"
                su -c "/opt/factorio-init/factorio update" factorio | tee >(logger -t "factorio update")
        fi
        if [ $servupdate == 0 ]
        then
                echo "No new update for Factorio. Server version: "$servversion
                echo "$servupdateoutput" |(logger -t "factorio update")
        fi
        if [ $modupdate == 2 ]
        then
                echo "Mod update found"
                su -c "/opt/factorio-mod-updater/factorio-mod-updater" factorio | tee >(logger -t "factorio update")
        fi
        if [ $modupdate == 0 ]
        then
                echo "No new update for Mods."
                echo "$modupdateoutput" |(logger -t "factorio update")
        fi
        systemctl start factorio.service
        exit 0;
else
        echo "Something went boo-boo somewhere..."
        exit 1;
fi
