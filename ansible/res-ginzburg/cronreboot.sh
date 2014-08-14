#!/bin/sh
DSTFILE="/var/spool/cron/crontabs/root"


if [ -f "${DSTFILE}" ]; then
	cp ${DSTFILE} ~ginzburg/root.$$
	grep -v ginzburg ~ginzburg/root.$$ > ${DSTFILE}
fi

cat >> ${DSTFILE} <<EOF
@reboot /bin/echo "Incident date: \`/bin/date\`"| mail -s "\`/bin/hostname\` rebooted" mymail@my.domain
EOF

chmod 0600 ${DSTFILE}
chown root:crontab ${DSTFILE}
