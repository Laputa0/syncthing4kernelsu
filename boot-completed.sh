#
ASH_STANDALONE=1

MODDIR=${0%/*}
SYNCTHING_BIN="${MODDIR}/bin/syncthing"
export XDG_STATE_HOME="${MODDIR}"
export HOME="${MODDIR}"

$SYNCTHING_BIN &> ${MODDIR}/log.txt
