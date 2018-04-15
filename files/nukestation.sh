#!/bin/bash
#
# Copyright Wolfgang Hotwagner <code@feedyourhead.at>.
# 
# This program is free software; you can redistribute it and/or modify it under
# the terms of the GNU General Public License as published by the Free Software
# Foundation, version 2.
#
# This program is distributed in the hope that it will be useful, but WITHOUT
# ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
# FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more
# details.
#
# You should have received a copy of the GNU General Public License along with
# this program; if not, write to the Free Software Foundation, Inc.,
# 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA. 

LOGDIR="/var/log/nukestation"
ENABLE_MAIL=0
MAIL_TO=root
MAIL_FROM=root
METHOD=dodshort
ROUNDS=1

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

nwipe -m $METHOD -r $ROUNDS --autonuke --nowait --nogui -l $LOGFILE $DEVICE 2>> $LOGFILE
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
