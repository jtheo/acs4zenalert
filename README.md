ACSZA: Awful Check Script with event notification by Zen Alert
==============================================================

## Overview

A bunch of simple script to check CPU, free memory, swap and disk space used and if the public IP is
changed or if there's an anomaly send an event to Zen Alert

## Requirements

* Unix-like System (tested on a Raspberry Pi with Raspbian)
* cUrl
* ZenAlert free account

## Installation

Start with installing curl:
* apt-get install curl in debian/ubuntu
* yum install curl in redhat/centos)

Copy the files in the right directory:
I suggest you to put the files *.key in /etc so you doesn't need to change the script.
Inside the file "check" that I put in /etc/cron.d there's the schedules for the check, I like that, but if You like better to put in /etc/crontab or in the root crontab, please do it, it's just a matter of habit.
Last but not least, the scripts: I put them in /usr/local/bin You can put wherever you what, if You change the path remember to modify the schedule file.

## Basic Configuration

You have to configure the zenalert.key with you account key and the device id, please put the keys next to the equal sign as in:

    security_key=0000Z000-A00A-00Z0-Z000-123456789012
    thing_id=Z000Z000-0000-0000-ZZZ0-ZZ0ZZZZZZ00Z

If you have also an account on duckdns.org (it's nice, and a very good choice if You need a dynamic dns) put the token and the domain You've configured in the duckdns panel.

## Threshold Configuration
Take a look at the schedulation in /etc/cron.d/check (or wherever You've put them), in the first row:

    */5 * * * * root /usr/local/bin/check_to_zenalert.sh  /usr/local/bin/check_disk.sh -w 90 -c 95 -f / > /dev/null 2>&1

Every 5 minutes, all day, every day (*/5 * * * *) the user root will launch check_to_zenalert.sh which is a wrapper, something which the only purpose is to launch check_disk (in this case) with some parameters, take the result and if sonething is not ok, sent an event to ZenAlert.
The paramters meaning: -w indicate the warning threshold, -c indicate the critcal threshold and the -f indicate the filesystem You want to verify against the threshold above.
So, if the disk space occupation of / is more than 80% check_disk.sh will raise a warning event which it will be sent to Zenalert via check_to_zenalert.

Similar for check_cpu_mem, the parameters are:

    -w warning
    -c critical
    -s system (to check), at the moment you can check CPU, memory and swap utilization.

The keep alive's check is a little different from other check, maybe I'll rewrite better later


# That's it!

Enjoy and let me know if You have idea to better or other check.

# Monitor Raspberry Pi
Although this simple check can be used on any linux, they are made as example to use Zen Alert as an event notification system.

I developed all the script in a Raspberry Pi to have a basic environment and a common background for other linux distro. If You are looking for a monitor more nice to see (but actually without events notifications) You can try:

* ["RPi-Monitor"](https://github.com/XavierBerger/RPi-Monitor)
* ["Raspberry-Pi-Status"](https://github.com/GeekyTheory/Raspberry-Pi-Status)

# Other Lightweight Monitor
["Linux Dash (in python")](https://github.com/afaqurk/linux-dash)
