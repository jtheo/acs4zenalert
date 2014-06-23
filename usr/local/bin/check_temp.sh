#!/bin/bash


#Original Idea: http://kernelreloaded.blog385.com/index.php/archives/formatting-output-from-raspberry-pi-temperature-sensors/

usage()
{
cat << EOF
usage: $0 options

The purpose of this script is to check CPU temperature

OPTIONS:
-h      Show this message
-w      warning threshold (in celsius degree)
-c      critical threshold (in celsius degree)

Example:
$0 -w 60 -c 80 
Meaning: check the CPU temperature, if it's more than 60° (celsius) raise a warning, if it's more than 80° raise a critical.

EOF
}

 
while getopts "hw:c:" opt; do
  case $opt in
    w) warning=$OPTARG
       ;;
    c) critical=$OPTARG
       ;;
    s) status=$OPTARG
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

if [[ -z $warning ]] || [[ -z $critical ]]
then
    usage
    exit 1
fi

temperature=$(($(cat /sys/class/thermal/thermal_zone0/temp|cut -c1-2))).$(($(cat /sys/class/thermal/thermal_zone0/temp|cut -c3-5)))
check_temp=$(echo $temperature | cut -d "." -f 1)

if [ $check_temp -lt $warning ]
then 
  echo "OK - CPU Temperature: ${check_temp}°"
  exit 0
elif [ $check_temp -ge $warning ] && [ $check_temp -lt $critical ]; then
  echo "Warning - CPU Temperature: ${check_temp}°"
  exit 1
elif [ $check_temp -ge $critical ]; then
  echo "Critical - CPU Temperature: ${check_temp}°"
  exit 2
else
  echo "Unknow - CPU Temperature: ${check_temp}°"
  exit 3
fi
