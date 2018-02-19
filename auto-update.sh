#!/bin/bash
PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin
export DISPLAY=:0.0

cd /opt/factorio
/opt/factorio-init/factorio update --dry-run | grep 'No new updates'
servupdate=$?
/opt/factorio-mod-updater/factorio-mod-updater --dry-run > /dev/null
modupdate=$?
if [ $servupdate == 0 ] && [ $modupdate == 0 ]
then
        echo "No new update for Factorio or Mods"
        #/opt/factorio-init/factorio cmd "SERVER NO NEW UPDATE"
        logger "No new update for Factorio or Mods"
        exit 0;
elif [ $servupdate == 2 ] || [ $modupdate == 2 ]
then
        echo "new update"
        logger "updating Factorio or mods"
        if [ $servupdate == 2 ]
        then
                /opt/factorio-init/factorio cmd "SERVER WILL BE RESTARTED IN 1 MINUTE TO UPDATE TO NEW FACTORIO VERSION"
        fi
        if [ $modupdate == 2 ]
        then
                /opt/factorio-init/factorio cmd "SERVER WILL BE RESTARTED IN 1 MINUTE TO UPDATE MODS"
        fi
        sleep 50
        /opt/factorio-init/factorio cmd "SERVER RESTARTING IN 10 SECONDS"
        sleep 10
        /opt/factorio-init/factorio cmd "SERVER RESTARTING"
        /bin/systemctl stop factorio.service
        if [ $servupdate == 2 ]
        then
                echo "Server update found"
                /opt/factorio-init/factorio update
        fi
        if [ $modupdate == 2 ]
        then
                echo "Mod update found"
                su -c /opt/factorio-mod-updater/factorio-mod-updater factorio
        fi
        /bin/systemctl start factorio.service
        exit 0;
else
        echo "Something went boo-boo somewhere..."
        exit 1;
fi
