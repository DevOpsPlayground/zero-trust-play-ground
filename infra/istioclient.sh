#!/bin/bash
set -e
set -o pipefail
set -u



Directory="$PWD/istio-$ISTIO_VERSION"
if [ -d "$Directory" ];
then
    echo -e "it's exits\n"
fi
### To check if directory does not exist
if [ ! -d "$Directory" ];
then 
    echo -e "It's not there\n"

    curl -L https://istio.io/downloadIstio | ISTIO_VERSION=$ISTIO_VERSION TARGET_ARCH=x86_64 sh -
    
    if [ -d "$Directory" ];
        then
            echo -e "it's exits\n"
            cd istio-$ISTIO_VERSION
            export PATH=$PWD/bin:$PATH
    fi
    
    sudo cp ./bin/istioctl /usr/local/bin/istioctl
    sudo chmod +x /usr/local/bin/istioctl

    uname -a
fi

echo $PWD/

istioctl version

istioctl profile list

istioctl x precheck 
