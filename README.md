# Factorio-autoupdater
Autoupdater script for factorio-base and mods

Factorio-updater available here:
https://github.com/narc0tiq/factorio-updater

Factorio-mod-updater with my patch for dry-run here:
https://github.com/astevens/factorio-mod-updater

Factorio-updater uses factorio-init available here:
https://github.com/Bisa/factorio-init

## Usage
The paths in this script expect factorio-updater and factorio-mod-updater to be deployed as per the default recommendations of the authors of those scripts. Modify to your needs. Put auto-update.sh into /opt/factorio-init and add to cron something like this (this checks for updates every two hours and doesnt send notifications when the script executes properly and there is no update, but outputs a line to syslog regardless):
```bash
SHELL=/bin/bash
0 */2 * * * /opt/factorio-init/auto-update.sh | /usr/bin/tee >(/usr/bin/logger -t "factorio update") | /bin/grep -v 'No new update'
```
