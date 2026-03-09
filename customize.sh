ui_print "Syncthing for KernelSU."

if [ $IS64BIT == true ]; then
    echo "This device is arm64."
else
    echo "This device isn't arm64."
    ui_print "Failed."
    exit
fi

ui_print "Setting permissions..."
set_perm ${MODPATH}/bin/syncthing 0 0 0755
set_perm ${MODPATH}/service.sh 0 0 0755
set_perm ${MODPATH}/action.sh 0 0 0755

ui_print "Setting owner is shell:shell..."
chown -R shell:shell ${MODPATH}/bin

syncthing_dir=/data/local/syncthing
if [[ ! -d $syncthing_dir ]]; then
	mkdir $syncthing_dir
	chown shell:shell $syncthing_dir
fi

ui_print "Deleting old syncthing..."
rm -rf ${syncthing_dir}/bin
ui_print "Copying new syncthing..."
cp -rf ${MODPATH}/bin ${syncthing_dir}

ui_print "===================================="
ui_print "NOTICE: Please delete /data/local/syncthing manually after you deleted this module."
ui_print "===================================="

ui_print "Success."
