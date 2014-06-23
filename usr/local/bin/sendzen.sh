#!/bin/bash

#
# The purpose of this silly script is to send an event to ZenAlert
# Awfully coded by jtheo
#

# Here a couple of variables: the file with the security key of ZenAlert account and the thing_id of the device
zenkey=/etc/zenalert.key
zenurl=https://api.zenalert.com

# Just a couple of check if the file with the keys exist and it's not zero length 
if [[ -e $zenkey ]] && [[ -s $zenkey  ]] 
then 
    . $zenkey
else
    echo "The file $zenkey doesn't exits or it's empty, You have to write in there your security_key and the thing_id of this device"
    exit 1
fi

# Okey, the file exits and we've loaded, but you have write you keys? 

if [[ -z $thing_id ]] || [[ -z $security_key ]] 
then
    echo "You have to edit the file $zenkey and write your security_key and the thing_id of this device"
    exit 1
fi

# Apparently yes

usage()
{
cat << EOF
usage: $0 options

The purpose of this script is to send signal to zenalert

OPTIONS:
-h      Show this message
-d      Description to send
-c      code (alive, critical, warning, unknow)
Description and code are mandatory!

EOF
}

# Take here: http://wiki.bash-hackers.org/howto/getopts_tutorial
# The script read the command line switch and put their value in variable

while getopts "hd:c:" opt; do
  case $opt in
    d) description=$OPTARG
       ;;
    c) code=$OPTARG
       ;;
    h) usage
       exit 1
       ;;
   \?)
       echo "Invalid option: -$OPTARG" >&2
       exit 1
       ;;
    :)
       usage
       exit 1
       ;;
  esac
done

if [[ -z $code ]] || [[ -z $description ]] 
then
    usage
    exit 1
fi


if [ "x$description" == "x" ]
then
  description="Stay calm and Don't Panic!"
fi
#

# A sort of url sanitization, just change avery space with %20 
description=$(echo $description | sed "s/ /%20/g")

curl "${zenurl}/signal?code=${code}&thing_id=${thing_id}&security_key=${security_key}&description=${description}"

