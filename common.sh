ASH_STANDALONE=1

SERVE_DIR="/data/local/syncthing"
SERVE_HOME="${SERVE_DIR}/home"
SERVE_BIN="${SERVE_DIR}/bin/syncthing"
SERVE_LOG="${SERVE_DIR}/service.log"
SERVE_ARGS="--log-file=$SERVE_LOG --log-level=INFO --log-max-size=1048576 --no-browser --no-restart --home=$SERVE_HOME"
SERVE_PID="${SERVE_DIR}/syncthing.pid"

# check service
function status_service(){
	if [ -f "$SERVE_PID" ]; then
		PID=$(cat "$SERVE_PID")
		if kill -0 "$PID" 2>/dev/null; then
			return 0
		else
			rm -f "$SERVE_PID"
			return 1
		fi
	else
		return 1
	fi
}

# start service
function start_service(){
	echo "$(date '+%Y-%m-%d %H:%M')"

	if [ -f "$SERVE_PID" ]; then
		PID=$(cat "$SERVE_PID")

		if kill -0 "$PID" 2>/dev/null; then
			echo "service is running. (PID: $PID)"
			return 0
		else
			rm -f "$SERVE_PID"
		fi
	fi
	echo "starting service..."
	for i in $(seq 90); do
		if ! status_service &>/dev/null; then
			su shell -c "$SERVE_BIN $SERVE_ARGS &> $SERVE_LOG &"
			echo $(pgrep syncthing) > "$SERVE_PID"
		else
			break
		fi
		sleep 1
	done
}

# stop service
function stop_service(){
	echo "$(date '+%Y-%m-%d %H:%M')"

	if [ ! -f "$SERVE_PID" ]; then
		echo "pid file is not found."
		return 0
	fi

	PID=$(cat "$SERVE_PID")
	if kill -0 $PID 2>/dev/null; then
		echo "stopping service..."
		kill $PID
		rm -f "SERVE_PID"
	else
		echo "process is not found."
		rm -f "SERVE_PID"
	fi
}

