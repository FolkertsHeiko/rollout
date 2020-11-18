#!/bin/bash
DATE=$(date +%F_%T)
echo "[$DATE] Rollout v1.0. Begin:"
echo "ROLLOUT: Starting $0..."
cd "$(dirname "$0")" #Change working directory to location of this script

##### Load rollout main configuration file (Hosts to configure, requirements)#####
source ./configs/rollout.config

#check requirements
for BINARY in $REQUIREMENTS; do
    which $BINARY >/dev/null
    if [ $? != 0 ]; then
        echo "ROLLOUT: \"$BINARY\" missing or not in path."      
        exit 1
    fi
done;

#Write configs to deploy to ./files
source ./scripts/build.sh

#get password for sensors
echo -n "ROLLOUT: Enter USER for Hosts: "
read USER
echo -n "ROLLOUT: Enter Password for Hosts: "
read -s PASS
echo

#Copy files to sensors and execute
for index in ${!HOST_NAME[*]}; do
    SENSORIP="${HOST_IP[$index]}"
    SENSORNAME="${HOST_NAME[$index]}"
    SENSORTEMPLATE="${HOST_TEMPLATE[$index]}"
    source ./scripts/config.sh $SENSORNAME $SENSORTEMPLATE >/dev/null #(re)set environment vars for this sensor (silently)

    echo "ROLLOUT: SCP to $SENSORNAME ($USER@$SENSORIP:/tmp/$SENSORTEMPLATE-$SENSORNAME)..."
    sshpass -p $PASS scp -r "./files/$SENSORNAME" $USER@$SENSORIP:/tmp/$SENSORTEMPLATE-$SENSORNAME
    if [ $? != 0 ]; then #ERROR Handling
        echo -e "ROLLOUT: SCP: \e[31mFailed\e[39m"
        continue
    else
        echo -e "ROLLOUT: SCP: \e[32mSuccess\e[39m"
    fi

    #execute satellite script
    echo "ROLLOUT: Executing satellite..."
    sshpass -p $PASS ssh -t $USER@$SENSORIP "cp \"/tmp/$SENSORTEMPLATE-$SENSORNAME/satellite.sh\" /tmp/.; echo \"$PASS\" | sudo -S \"/tmp/satellite.sh\" \"$SENSORTEMPLATE\" \"$SENSORNAME\" $rollout_dryrun"
done

echo "ROLLOUT: Done."
DATE=$(date +%F_%T)
echo "[$DATE] End."
