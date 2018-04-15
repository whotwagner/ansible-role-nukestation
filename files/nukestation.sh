#!/bin/bash

LOGDIR="/var/log/nukestation"
ENABLE_MAIL=0
MAIL_TO=root
MAIL_FROM=root

if [ -e /etc/nukestation/nukestation.conf ]
then
	source /etc/nukestation/nukestation.conf
fi

DATE=`date +%F-%T`
LOGFILE="${LOGDIR}/nukelog-${DATE}.log"

send_mail() {
	if [ $ENABLE_MAIL -eq 1 ]
	then
		DATE=`date +%F-%T`
		cat $LOGFILE  | mutt -e "set crypt_use_gpgme=no" -e "set from=$MAIL_FROM" -e "set use_envelope_from=yes" -s "Nukestation-Notification $DATE" -- $MAIL_TO
	fi
}

handle_error() {
	echo "ERROR at " `date +%F-%T` > $LOGFILE
	send_mail
	exit 1
}

run_pre() {
	trap 'echo "Error in run_pre()" 
	handle_error()' ERR

for i in `find /etc/nukestation/pre.d -type f -name \*.conf 2>> $LOGFILE`
do
	source $i $DEVICE $LOGFILE 2>> $LOGFILE
done
}

run_post() {
	trap 'echo "Error in run_post()" 
	handle_error()' ERR

for i in `find /etc/nukestation/post.d -type f -name \*.conf 2>> $LOGFILE`
do
	source $i $DEVICE $LOGFILE 2>> $LOGFILE
done
}

run_wipe() {
	trap 'echo "Error in run_wipe()" 
	handle_error()' ERR

nwipe --autonuke --nowait --nogui -l $LOGFILE $DEVICE 2>> $LOGFILE
}

sleep 3s

if [ $# -ne 1 ]
then
	echo "No device given" > $LOGFILE
	exit 1
else
	DEVICE=$1
fi






run_pre
run_wipe
run_post
send_mail

exit 0
