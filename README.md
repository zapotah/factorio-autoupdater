# Factorio-autoupdater
Autoupdater script for factorio-base and mods

This factorio-updater available here:
https://github.com/narc0tiq/factorio-updater

and factorio-mod-updater with my patch for dry-run here:
https://github.com/astevens/factorio-mod-updater

factorio-updater uses factorio-init available here:
https://github.com/Bisa/factorio-init

## Usage
Add to cron something like this (this checks for updates every two hours):
```bash
0 */2 * * * /opt/factorio-init/auto-update.sh
```
