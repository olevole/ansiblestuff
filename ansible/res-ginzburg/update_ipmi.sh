#!/bin/sh
# подгружает ipmi модули если их нет, запускает ipmitool и сохраняет
# IP Address в $OUTFILE, который дальше собирает скрипт инвентаризации

MYADMIN="mymail@my.domain"  # сюда алертим
HOSTNAME=$( hostname )
IPMITOOL=$( which ipmitool 2>/dev/null )
CHANNEL="1 2"  # полагаем что больше 2 каналов нет
OUTFILE="/etc/inv.mgmtip"

# fatal error. Print message then quit with exitval
err() {
	exitval=$1
	shift
	echo "$*" 1>&2
	mail -s "${HOSTNAME} update_ipmi error" ${MYADMIN} <<EOF
date: $( date )
$*
EOF
	exit $exitval
}

[ -z "${IPMITOOL}" -o ! -x "${IPMITOOL}" ] && err 1 "No such ipmitool"

grep -q ^ipmi_si /proc/modules || insmod ipmi_si
grep -q ^ipmi_devintf /proc/modules || insmod ipmi_devintf

trap "rm -f /tmp/ipmi.$$" HUP INT QUIT ABRT KILL TERM STOP

for i in ${CHANNEL}; do
	${IPMITOOL} lan print ${i} > /tmp/ipmi.$$ 2>/dev/null
	IP=$( /usr/bin/awk '/^IP Address   /{printf $4}' /tmp/ipmi.$$ )
	MAC=$( /usr/bin/awk '/^MAC Address   /{printf $4}' /tmp/ipmi.$$ )
	[ -n "${IP}" ] && break
done

rm -f /tmp/ipmi.$$

cat > ${OUTFILE} << EOF
<a href="http://${IP}" target="_blank">${IP}</a>
MAC: ${MAC}
EOF
