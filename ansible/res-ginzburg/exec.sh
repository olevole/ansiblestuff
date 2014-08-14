#!/bin/sh
ANSIBLE=$( which ansible )
#ASK_PASS=""
#ASK_PASS="--ask-pass"
ASK_PASS="--ask-pass --ask-sudo-pass --sudo"

ANSIBLE_HOSTSFILE="/usr/local/ansible/hosts"

${ANSIBLE} --user=ginzburg ${ASK_PASS} -i ${ANSIBLE_HOSTSFILE} all -a "grep -v ^# /var/spool/cron/crontabs/root"
