ASH_STANDALONE=1

MODDIR=${0%/*}
SYNCTHING_BIN="${MODDIR}/bin/syncthing"
SYNCTHING_LOG="${MODDIR}/log.txt"
export XDG_STATE_HOME="${MODDIR}"
export HOME="${MODDIR}"

# flush logs
: > $SYNCTHING_LOG

user_id=$(pm list packages -U|grep com.android.shell|cut -d':' -f3)
user_name="u0_a$user_id"

chown $user_name:$user_name $SYNCTHING_LOG

su -l $user_name -c "$SYNCTHING_BIN &> ${MODDIR}/log.txt"
