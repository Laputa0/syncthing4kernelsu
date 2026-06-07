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

# upgrade syncthing
function upgrade_syncthing(){
	# upgrade
	local tmp_dir="/data/local/tmp/syncthing_tmp"
	down_url=$(curl -s -L https://api.github.com/repos/syncthing/syncthing/releases/latest| \
	    grep 'browser_download_url'|grep -Eo 'https://.*linux-arm64.*\.tar\.gz' || return 0)
	rm -rf ${tmp_dir} && mkdir -p ${tmp_dir} && cd ${tmp_dir}
	curl -L -o ${tmp_dir}/syncthing.tar.gz ${down_url} || return 0
	tar -xzf ${tmp_dir}/syncthing.tar.gz || return 0
	mv ${tmp_dir}/syncthing-linux-arm64-*/syncthing ${SERVE_BIN}
	chown shell:shell ${SERVE_BIN}
	chmod 755 ${SERVE_BIN}
}


# upgrade check
function upgrade_check(){
	echo "$(date '+%Y-%m-%d %H:%M')"
	# return if no network
	if [[ ! ping -c 2 baidu.com ]]; then
		echo "no network."
		return 0
	fi

	# file not found or other reason, need upgrade
	su shell -c "$SERVE_BIN version" || upgrade_syncthing

	# return if already latest version
	c_ver=$(su shell -c "$SERVE_BIN version"|cut -d' ' -f2)
	l_ver=$(curl -s -L https://api.github.com/repos/syncthing/syncthing/releases/latest| \
		grep 'browser_download_url'|grep -Eo 'https://.*linux-arm64.*\.tar\.gz'| \
		grep -Eo 'v[0-9]+\.[0-9]+\.[0-9]+'|head -1 || return 0)
	if [[ "${c_ver:-0}" = "${l_ver:-1}" ]]; then
		echo "already latest version: ${c_ver:-unknown}"
		return 0
	fi
	echo "new version is available: ${l_ver:-unknown} (current: ${c_ver:-unknown})"
	upgrade_syncthing
}
