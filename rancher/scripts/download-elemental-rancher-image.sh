#!/usr/bin/env bash

namespace=${namespace:-fleet-default}

# convert all parameters to named arguments
while [ $# -gt 0 ]; do
    if [[ $1 == "--help" ]]; then
        usage
        exit 0
    elif [[ $1 == "--"* ]]; then
        v="${1/--/}"
        declare "$v"="$2"
        shift
    fi
    shift
done

programname=$0
function usage {
    echo ""
    echo "Download a Rancher Image to your local filesystem."
    echo ""
    echo "usage: $programname --namespace string --imagename string"
    echo ""
    echo "  --namespace     string   The namespace where the image is located (default: fleet-default)"
    echo "                           (example: my-namespace)"
    echo "  --imagename     string   The name of the image that is going to be downloaded"
    echo "                           (example: my-custom-image)"
    echo ""
}

function die {
    printf "Script failed: %s\n\n" "$1"
    exit 1
}

if [[ -z $namespace ]]; then
    usage
    die "Missing parameter --namespace"
elif [[ -z $imagename ]]; then
    usage
    die "Missing parameter --imagename"
fi


isofile="$(pwd)/${imagename}.iso"

[ -f "${isofile}" ] && die "${isofile} already exists, aborting"
echo "Downloading image=${imagename} using namespace=${namespace}"
echo "- Waiting for image to become ready"
kubectl wait --for=condition=ready pod -n ${namespace} ${imagename}

status=$?
if [ $status -ne 0 ]; then
    die "An error occurred while waiting for the image to become ready"
fi

echo "- Image is ready proceeding with download"
echo "- Downloading image"
wget --no-check-certificate `kubectl get seedimage -n ${namespace} ${imagename} -o jsonpath="{.status.downloadURL}"` -O ${isofile}

