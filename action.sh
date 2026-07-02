source ./common.sh

if status_service &>/dev/null; then
	stop_service
	sleep 2
else
	echo "请在5秒内按音量+键升级，否则跳过升级"
	button_check 10 && upgrade_check
	start_service
fi
