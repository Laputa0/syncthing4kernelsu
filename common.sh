ASH_STANDALONE=1

MODDIR=${0%/*}
SYNCTHING_DIR="/data/local/syncthing"
SYNCTHING_LOG="${SYNCTHING_DIR}/service.log"
SYNCTHING_BIN="${SYNCTHING_DIR}/bin/syncthing"
SYNCTHING_HOME="${SYNCTHING_DIR}/home"
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
	[[ -z "$(get_pid)" ]] && su shell -c "HOME=\"$SYNCTHING_HOME\" $SYNCTHING_BIN $SYNCTHING_ARGS &>${SYNCTHING_DIR}/output.log &"
	until [[ -n "$(get_pid)" ]]; do
		sleep 1
		spid=$(get_pid)
		echo "$(date '+%Y-%m-%d %H:%M') | syncthing started...*${spid}*"
		sleep 1
	done
}

# stop syncthing service
function stop_service(){
	echo "$(date '+%Y-%m-%d %H:%M') | Syncthing stopping..."
	[[ -n "$(get_pid)" ]] && pkill syncthing
	until [[ -z "$(get_pid)" ]]; do
		sleep 1
		echo "$(date '+%Y-%m-%d %H:%M') | syncthing stopped..."
		sleep 1
	done
}

