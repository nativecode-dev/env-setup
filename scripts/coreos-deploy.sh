#!/bin/bash

if [ "$1" = "" ]; then
    echo "Must provide a host name."
    exit 1
fi

if [ "$2" = "" ]; then
    echo "Must provide a template name."
    exit 1
fi

ARG_NAME="$1"
ARG_TEMPLATE="$2"

CFG_IGNITION="$PWD/scripts/templates/$ARG_TEMPLATE.json"

OVF_COREOS="coreos_production_vmware_ova.ovf"
OVF_ESXI65="coreos_production_vmware_ova-esxi65.ovf"

VM_HOST="$ESXI_DEPLOY_URI"
VM_NAME="$ARG_NAME"
VM_NET="Private"
VM_STORAGE="STORAGE"

# Download the production OVF
if [ ! -f "$OVF_COREOS" ]; then
    wget \
    https://stable.release.core-os.net/amd64-usr/current/coreos_production_vmware_ova_image.vmdk.bz2 \
    https://stable.release.core-os.net/amd64-usr/current/coreos_production_vmware_ova.ovf \
    ;
    
    bunzip2 coreos_production_vmware_ova_image.vmdk.bz2
fi

# Patch ovf file to improve compatibility with ESXi 6.5
if [ ! -f "$OVF_ESXI65" ]; then
    sed \
    -e "s/other26xLinux64Guest/other3xLinux64Guest/" \
    -e "s/<vssd:VirtualSystemType>.*<\/vssd:VirtualSystemType>/<vssd:VirtualSystemType>vmx-13<\/vssd:VirtualSystemType>/" \
    < "$OVF_COREOS" \
    > "$OVF_ESXI65" \
    ;
fi

CFG_IGNITION_DATA=$(envsubst < ${CFG_IGNITION} | base64)

ovftool \
-ds="$VM_STORAGE" \
--name="$VM_NAME" \
--net:"VM Network=$VM_NET" \
--X:guest:"coreos.config.data=$CFG_IGNITION_DATA" \
--X:guest:"coreos.config.data.encoding=base64" \
--powerOn --skipManifestCheck --X:noPrompting --noSSLVerify \
"$OVF_ESXI65" \
"$ESXI_DEPLOY_URI" \
;
