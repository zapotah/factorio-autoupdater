# Factorio-autoupdater
Autoupdater script for factorio-base and mods

Factorio-updater available here:
https://github.com/narc0tiq/factorio-updater

Factorio-mod-updater with my patch for dry-run here (I have since added some cosmetic fixes as well, but you can do those yourself):
https://github.com/astevens/factorio-mod-updater

Factorio-updater uses factorio-init available here:
https://github.com/Bisa/factorio-init

## Usage
The paths in this script expect factorio-updater and factorio-mod-updater to be deployed as per the default recommendations of the authors of those scripts. Modify to your needs. Put auto-update.sh into /opt/factorio-init and add to root crontab something like this (this checks for updates every two hours). 

```bash
SHELL=/bin/bash
0 */2 * * * /opt/factorio-init/auto-update.sh
```

## Options
The autoupdater script by default outputs only messages when there is an update, but outputs everything it does into syslog through logger inside the script (logger is assumed to exist on the system in $PATH). if you want to have output of current versions, add -p after the script as a switch and it will output the current version of the server and Mods installed even if there is no update.
