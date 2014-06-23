#!/bin/bash

usage()
{
cat << EOF
usage: $0 options

The purpose of this script is to check CPU load, free memory or swap space used

OPTIONS:
-h      Show this message
-w      warning threshold (in percentage)
-c      critical threshold (in percentage)
-s      status (the status can be memory, CPU, swap)

Example:
$0 -w 80 -c 90 -s cpu
Meaning: check the CPU, if the load is more than 80% raise a warning, if it's more than 90% raise a critical.

EOF
}

 
while getopts "hw:c:s:" opt; do
  case $opt in
    w) warning=$OPTARG
       ;;
    c) critical=$OPTARG
       ;;
    s) status=$OPTARG
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

if [[ -z $warning ]] || [[ -z $critical ]] || [[ -z $status ]]
then
    usage
    exit 1
fi

case $status in
  memory) 
          Mem=$(free | grep Mem:)
          total=$(echo $Mem | awk '{print $2}')
          free=$(echo $Mem | awk '{print $4}')
          percent=$(($free * 100 / $total))
          ;;
  swap)
          Mem=$(free | grep Swap:)
          total=$(echo $Mem | awk '{print $2}')
          free=$(echo $Mem | awk '{print $4}')
          percent=$((100 - ($free * 100 / $total)))
          ;;
  cpu)   
          # This is absolutely awful: this script has been written on a Raspberry Pi which doesn't install bc by default.
          # So, how to calculate the percentage of CPU load if You have values in floating point like as 0.03? Why do not delete the point and the initial zeros?
          # Then verify how many CPU you have in the system, add a couple of trailing zeros (ex: 1 CPU = 100%)
          # It's a little embarrassing uh? Yes! But it's working
        
          cpu_load=$(awk '{print $1}' /proc/loadavg | tr -d "." | sed 's/^0*\([0-9]*\)/\1/')
          total_cpu="$(grep -c "^processor" /proc/cpuinfo)00"
          percent=$(($cpu_load * 100 / $total_cpu))
          ;;
  *)
          usage
          ;;
esac

if [ $percent -lt $warning ]
then 
  echo "OK - $status: $percent%"
  exit 0
elif [ $percent -ge $warning ] && [ $percent -lt $critical ]; then
  echo "Warning - $status: $percent%"
  exit 1
elif [ $percent -ge $critical ]; then
  echo "Critical - $status: $percent%"
  exit 2
else
  echo "Unknow - $status: $percent%"
  exit 3
fi
