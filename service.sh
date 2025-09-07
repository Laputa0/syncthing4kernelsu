source ./common.sh
# write this log to service
relog service.log
# start syncthing
set -x
start_service
