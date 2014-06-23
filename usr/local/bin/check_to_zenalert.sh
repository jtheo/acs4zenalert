#!/bin/bash

result=$($*)

case $? in
  0) code="" ;;
  1) code=warning ;;
  2) code=critical ;;
  3) code=unknow ;;
  *) echo "Something terrible is just happened"
     exit 255
   ;;
esac

if [[ -n $code ]]
  then
      /usr/local/bin/sendzen.sh -c $code -d "$result" > /dev/null 2>&1
fi
