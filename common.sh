ASH_STANDALONE=1

MODDIR=${0%/*}
SYNCTHING_BIN="/system/bin/syncthing"
SYNCTHING_LOG="${MODDIR}/syncthing.log"
SYNCTHING_HOME="/data/adb/syncthing"
SYNCTHING_ARGS="--log-file=$SYNCTHING_LOG --log-level=INFO --log-max-size=1048576 --no-browser --no-restart --no-upgrade --home=$SYNCTHING_HOME"

# redirect log file
function relog(){
	LOG_NAME=$1
	LOG_PATH="${MODDIR}/$LOG_NAME"
	: > $LOG_PATH
	exec >> $LOG_PATH 2>&1
}

function get_pid(){
	pidof syncthing
}

# start syncthing service
function start_service(){
	echo "$(date '+%Y-%m-%d %H:%M') | Syncthing starting..."
	[[ -z "$(get_pid)" ]] && HOME="$SYNCTHING_HOME" $SYNCTHING_BIN $SYNCTHING_ARGS &>/dev/null &
	until [[ -n "$(get_pid)" ]]; do
		sleep 1
		echo "$(date '+%Y-%m-%d %H:%M') | syncthing started...*$(get_pid)*"
	done
}

# stop syncthing service
function stop_service(){
	echo "$(date '+%Y-%m-%d %H:%M') | Syncthing stopping..."
	[[ -n "$(get_pid)" ]] && pkill syncthing
	until [[ -z "$(get_pid)" ]]; do
		sleep 1
		echo "$(date '+%Y-%m-%d %H:%M') | syncthing stopped..."
	done
}

