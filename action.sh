source ./common.sh

if status_service &>/dev/null; then
	stop_service
	sleep 2
else
	upgrade_check
	start_service
fi
