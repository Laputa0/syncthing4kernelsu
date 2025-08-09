ASH_STANDALONE=1

MODDIR=${0%/*}
SYNCTHING_BIN="${MODDIR}/bin/syncthing"
SYNCTHING_LOG="${MODDIR}/log.txt"
export XDG_STATE_HOME="${MODDIR}"
export HOME="${MODDIR}"

# flush logs
rm -f $SYNCTHING_LOG
$SYNCTHING_BIN &> ${MODDIR}/log.txt
