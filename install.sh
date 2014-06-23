#!/bin/bash

zenkey=zenalert.key
duckey=duckdns.key

if [ "x$USER" != "xroot" ]
then
  echo "You must run this script as root, sudoers are welcomed"
  exit 1
fi

echo "Minimal install script"
echo "Starting with the copy of the scripts"
read -p "The scripts will be overwritten, should I continue? [y/N]" answer

while true
do 
  case $answer in
    [yY]* ) echo "Ok, I'm starting"
            break
            ;;

    [nN]* ) echo "Ok, I'm exiting"
            exit 255
            ;;

    *)      echo "Just enter Y or N, please"
            exit 254
            ;;
  esac
done  

cp -v usr/local/bin/* /usr/local/bin

if [ $? -ne 0 ]
then
  echo "Something goes wrong, please check errors"
  exit 2
fi

if [[ ! -e /etc/$zenkey ]]
then
  echo "Copy $zenkey: It look like it doesn't exits" 
  cp -i etc/$zenkey /etc/$zenkey
else
  echo "$zenkey already present, I'll step over"
fi

if [[ ! -e /etc/$duckey ]]
then
  echo "Copy $duckey: It look like it doesn't exits"
  cp -i etc/$duckey /etc/$duckey
else
 echo "$duckey already present, I'll step over"
fi

if [[ ! -e /etc/cron.d ]]
then
  mkdir -p /etc/cron.d
fi

if [[ ! -e /etc/cron.d/check ]]
then
  echo "check scheduled not present, I'll copy it"
  cp -i etc/cron.d/check /etc/cron.d
else
  echo "check schedules already present. I'm stopping right here!"
fi

echo "Installation terminated apparently without errors"

