source ./common.sh

if status_service &>/dev/null; then
	stop_service
	sleep 2
else
	start_service
fi
