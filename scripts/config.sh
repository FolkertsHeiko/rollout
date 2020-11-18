#!/bin/bash
#********** GLOBAL *********#
export mc_glo_madcatversion="2.1.x"
echo "CONFIG: Running ($(pwd)/configs/$1.$2.config)..."
    if [ -f "$(pwd)/configs/$1.$2.config" ]; then
        source $(pwd)/configs/$1.$2.config
        echo "CONFIG: Configuration build environment template \"$2\" set for Host \"$1\""
    else
        echo "CONFIG: Config \"$(pwd)/configs/$1.$2.config\" for template \"$2\" and Host \"$1\ not found"
        exit 1
    fi
echo "CONFIG: Done."