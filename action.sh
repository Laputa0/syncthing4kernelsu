source ./common.sh

echo "Running..."

pid_list=$(get_pid)
if [[ -z "$pid_list" ]]
then
	echo "$(date '+%Y-%m-%d %H:%M') | ACTION: Starting Service..."
	start_service
	sleep 3
	exit 0
fi

if [[ -n "$pid_list" ]]
then
	
	echo "$(date '+%Y-%m-%d %H:%M') | ACTION: Stopping Service..."
	stop_service
	sleep 3
	exit 0
fi

