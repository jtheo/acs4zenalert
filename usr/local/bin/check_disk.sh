#!/bin/bash

usage()
{
cat << EOF
usage: $0 options

The purpose of this script is to check disk space used per filesystem

OPTIONS:
-h      Show this message
-w      warning threshold (in percentage)
-c      critical threshold (in percentage)
-f      filesystem to check (/, /var, etc)

Example:
$0 -w 80 -c 90 -f /
Meaning: check the disk space used in root (/) and raise a warning if it's more than 80% or a critical event if more than 90%

EOF
}

 
while getopts "hw:c:f:" opt; do
  case $opt in
    w) warning=$OPTARG
       ;;
    c) critical=$OPTARG
       ;;
    f) filesystem=$OPTARG
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

if [[ -z $warning ]] || [[ -z $critical ]] || [[ -z $filesystem ]]
then
    usage
    exit 1
fi

if [ ${#filesystem} -gt 1 ]
  then 
      filesystem=$(echo $filesystem | sed 's|\(.*\)/$|\1|')
fi

percent=$(df | grep " $filesystem$" | head -1 | awk '{print $5}' | tr -d "%")

if [ $percent -lt $warning ]
then 
  result="OK - $filesystem: $percent%"
  exit_status=0
elif [ $percent -ge $warning ] && [ $percent -lt $critical ]; then
  result="Warning - $filesystem: $percent%"
  exit_status=1
elif [ $percent -ge $critical ]; then
  result="Critical - $filesystem: $percent%"
  exit_status=2
else
  result="Unknow - $filesystem: $percent%"
  exit_status=3
fi

echo $result
exit $exit_status
