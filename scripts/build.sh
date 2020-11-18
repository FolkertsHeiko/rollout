#!/bin/bash
echo "BUILD: Running..."
##### Hosts to configure #####
# Arrays HOST_NAME=(...) and  HOST_IP=(...) are sourced from rollout.sh

rm -r files 2>/dev/null
mkdir files 2>/dev/null

#####Iterate over hosts
for index in ${!HOST_NAME[*]}; do 
    SENSORIP="${HOST_IP[$index]}"
    SENSORNAME="${HOST_NAME[$index]}"
    SENSORTEMPLATE="${HOST_TEMPLATE[$index]}"
    #Configure templates
    if [ -f "$(pwd)/templates/$SENSORTEMPLATE/satellite.sh" ]; then

        echo "BUILD: Bulding \"$SENSORNAME $SENSORIP $SENSORTEMPLATE\, configuring..."        
        source ./scripts/config.sh $SENSORNAME $SENSORTEMPLATE #set environment vars for this sensor
        ## make directory structure"
        mkdir "./files/$SENSORNAME"
        ln -s "$(pwd)/files/$SENSORNAME" "$(pwd)/files/$SENSORIP"

        if [ -f "$(pwd)/builds/$SENSORTEMPLATE.build" ]; then
            source ./builds/$SENSORTEMPLATE.build
            echo "BUILD: Configuration written in $(pwd)/files/$SENSORNAME"
        else
            echo "BUILD: Buildfile \"$(pwd)/builds/$SENSORTEMPLATE.build\" for template \"$SENSORTEMPLATE\"not found"
            exit 1
        fi

        ##copy satellite script and make executable
        cp ./templates/$SENSORTEMPLATE/satellite.sh ./files/$SENSORNAME/.
        chmod -R +x ./files/$SENSORNAME/satellite.sh

    else
        echo "BUILD: Template \"$(pwd)/templates/$SENSORTEMPLATE\" not found or satellite.sh missing in ./templates/$SENSORTEMPLATE."
        exit 1
    fi

done

echo "BUILD: Done."