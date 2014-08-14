#!/bin/sh
# идем по списку --list-hosts и сохраняем результат per host в файлах inv/<hostname>.inv и inv/.{descr,mgmtip,notes}.<hostname>.inv
# если есть файлы в каталоге overwrite/*, перезаписываем их в каталог inv/ - для тех хостов, где инфу взять нельзя (windows, other host)
# по файлам каталога inv/ отрабатывает php для json_decode и генерации финального варианта
set -e
#set -x xtrace

# fatal error. Print message then quit with exitval
err() {
	exitval=$1
	shift
	echo -e "$*" 1>&2
	exit $exitval
}

MYDIR=$( dirname $0 )
ANSIBLE=$( which ansible )
ANSIBLE_HOSTSFILE="${MYDIR}/hosts"
OVERWRITE_DIR="${MYDIR}/overwrite"
INVENTORY_DIR="${MYDIR}/inv"
MYUSER="olevole"
ASK_PASS=""
#ASK_PASS="--ask-pass"

[ -z "${ANSIBLE}" ] && err 1 "No such ansible here"

# temp:
[ -d "${INVENTORY_DIR}" ] && rm -rf ${INVENTORY_DIR}
#
[ ! -d "${INVENTORY_DIR}" ] && mkdir ${INVENTORY_DIR}
[ ! -d "${OVERWRITE_DIR}" ] && mkdir ${OVERWRITE_DIR}

for i in $( ansible -i ${ANSIBLE_HOSTSFILE} all --list-hosts ); do
	set +e

	trap "rm -f ${INVENTORY_DIR}/${i}.inv.$$" HUP INT QUIT ABRT KILL TERM STOP
	${ANSIBLE} --user=${MYUSER} ${ASK_PASS} -i ${ANSIBLE_HOSTSFILE} ${i} -m setup > ${INVENTORY_DIR}/${i}.inv.$$
	${ANSIBLE} -m shell --user=${MYUSER} ${ASK_PASS} -i ${ANSIBLE_HOSTSFILE} ${i} -a "test -r /home/olevole/card.html && cat /home/olevole/card.html" |tail -n +2 > ${INVENTORY_DIR}/card_${i}.inv.html

	# no connection or somethings else, break, do not modify old files
	[ $? -ne 0 ] && rm -f ${INVENTORY_DIR}/${i}.inv.$$ && continue

	#retreive by-hand inventory
	for n in inv.mgmtip inv.descr inv.location; do
		${ANSIBLE} -m shell --user=${MYUSER} ${ASK_PASS} -i ${ANSIBLE_HOSTSFILE} ${i} -a "test -r /etc/${n} && cat /etc/${n}" |tail -n +2 > ${INVENTORY_DIR}/.${i}.${n}
	done

	set -e

	# replace first line for graceful json format
	echo "{" > ${INVENTORY_DIR}/${i}.inv
	[ -f "${INVENTORY_DIR}/${i}.inv.$$" ] && tail -n +2 ${INVENTORY_DIR}/${i}.inv.$$ >> ${INVENTORY_DIR}/${i}.inv
	rm -f ${INVENTORY_DIR}/${i}.inv.$$
done

# overwrite area
find ${OVERWRITE_DIR} -type f -exec cp {} ${INVENTORY_DIR}/ \;

# temp
[ -f inv.tgz ] && rm -f inv.tgz
tar cfz inv.tgz inv

set +e
