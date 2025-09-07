ui_print "Syncthing for KernelSU."

if [ $IS64BIT == true ]; then
    echo "This device is arm64."
else
    echo "This device isn't arm64."
    ui_print "Failed."
    exit
fi

ui_print "Setting permissions..."
set_perm ${MODPATH}/system/bin/syncthing 0 0 0755
set_perm ${MODPATH}/service.sh 0 0 0755
set_perm ${MODPATH}/action.sh 0 0 0755

ui_print "===================================="
ui_print "NOTICE: Please delete /data/syncthing manually when you deleted this module."
ui_print "===================================="


ui_print "Success."
