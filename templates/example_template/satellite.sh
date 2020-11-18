#!/bin/bash
# To be executed on sensors as root
DATE=$(date +%F_%T)
echo
echo "[$DATE] Begin Satellite"
echo "Starting $0 for rollout of $1 on $2 (dryrun: $3)..."
cd "$(dirname "$0")" #Change working directory to location of this script

SENSORTEMPLATE=$1
SENSORNAME=$2
SRC_DIR=/tmp/$SENSORTEMPLATE-$SENSORNAME
DRYRUN=$3
if [ "$DRYRUN" = "0" ]; then
    CPY="cp -r "
else
    echo "SATELLITE: Set to DRY-RUN, thus replacing cp with stat"
    CPY="stat -t "
fi

#Backing up old files

#Make Backup Dir
BACKUP_DIR="/root/BACKUP-$DATE"
echo "SATELLITE: Backing up old files to $BACKUP_DIR..."
mkdir $BACKUP_DIR

#Copy files to backup
cp -r /etc/test $BACKUP_DIR/.
cp -r /root/*.sh $BACKUP_DIR/.

echo "SATELLITE: Copying new files..."

#Copy files to etc
$CPY $SRC_DIR/etc/test /etc/.
#Copy files to /root
$CPY $SRC_DIR/root/*.sh /root/.

#"Cleanup"
#cd /
mv $SRC_DIR /root/$SENSORTEMPLATE-$DATE
echo "SATELLITE: Backing up new config to /root/$SENSORTEMPLATE-$DATE..."
DATE=$(date +%F_%T)
echo "SATELLITE: Done."
echo "[$DATE] End Satellite"
exit 0