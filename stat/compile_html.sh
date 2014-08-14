#!/bin/sh
REALPATH=$( which realpath 2>/dev/null )
if [ -z "${REALPATH}" ]; then
	ROOTDIR="/home/ginzburg/stat"
else
	MYDIR=$( dirname $0 )
	ROOTDIR=$( realpath ${MYDIR}/../ )
fi

DOCDIR="${ROOTDIR}/docs"
DOCDIR_HIER="disk_layout function ident sock_layout title net_inv"
OS=$( uname -s )
H_BR="<br>"

for i in ${DOCDIR_HIER}; do
	if [ ! -d "${DOCDIR}/${i}" ]; then
		mkdir -p ${DOCDIR}/${i}
	fi
done

# automatic area
cd ${ROOTDIR}/tools/${OS} && ./mount.sh > ${DOCDIR}/disk_layout/fs.txt
cd ${ROOTDIR}/tools/${OS} && ./tcp.sh > ${DOCDIR}/sock_layout/tcp.txt
cd ${ROOTDIR}/tools/${OS} && ./udp.sh > ${DOCDIR}/sock_layout/udp.txt
cd ${ROOTDIR}/tools/${OS} && ./iface.sh > ${DOCDIR}/net_inv/net.txt

cat <<EOF
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<style type="text/css">
		body {
				height:100%;
				width:100%;
				margin:0 auto;
				font-family:'trebuchet ms', 'lucida grande', 'lucida sans unicode', arial, helvetica, sans-serif;
				font-size:80%;
		}
		
		label {float:left; padding-right:10px;}
		.field {clear:both; text-align:right; line-height:25px;}
		.main,.checkbox-list {float:left;}
		.s_checkbox {width:10px; height:10px}

		pre.cli {
			font-family:'trebuchet ms', 'lucida grande', 'lucida sans unicode', arial, helvetica, sans-serif;
			font-size:90%;
			background:#000000;
			color:#00FF00;
			border-bottom:3px solid gray;
		}

		table.images {
				border:1px solid gray;
				border-radius:6px;
				width:100%;
		}
		table.images th {
				background:#f0f0f0;
				padding:6px;
				font-weight:bold;
				border-bottom:3px solid gray;
				font-size:80%;
		}
		table.images td {
				padding:4px;
				border-bottom:1px solid silver;
				font-family:'trebuchet ms', 'lucida grande', 'lucida sans unicode', arial, helvetica, sans-serif;
				font-size:75%;
		}
		table.images tr:last-child td {
				border-bottom-width:0;
		}
        </style>

</head>
<h1>
EOF

if [ -f ${DOCDIR}/title/title.txt.local; then
	cat ${DOCDIR}/title/title.txt.local
else
	hostname
fi
${H_BR}
cat <<EOF
Сервер под управлением ОС Linux $( lsb_release -scir |xargs )
</h1>
${H_BR}
<h2>Функционал</h2>
${H_BR}
$( cat /etc/inv.descr )
`[ -f ${DOCDIR}/function/inv.descr.local ] && $( cat ${DOCDIR}/function/inv.descr )`
${H_BR}
<h2>Идентификация сервера</h2>
${H_BR}
Имя сервера: $( hostname )
${H_BR}
Тру-ля-ля
${H_BR}
$( cat ${DOCDIR}/net_inv/net.txt )
${H_BR}
<h2>Технические характеристики</h2>
${H_BR}
dmidecode и тд из Ansible json
${H_BR}
<h2>Организация дискового массива</h2>
${H_BR}
$( cat ${DOCDIR}/disk_layout/fs.txt )
`[ -f ${DOCDIR}/disk_layout/fs.txt.local ] && $( cat ${DOCDIR}/disk_layout/fs.txt.local )`
${H_BR}
<h2>Хосты прописываемые в /etc/hosts</h2>
${H_BR}
<pre class="cli">
$( grep -v "^#" /etc/hosts |grep . )
</pre>
${H_BR}
<h2>Список открытых портов</h2>
${H_BR}
<strong>tcp:</strong>
${H_BR}
$( cat ${DOCDIR}/sock_layout/tcp.txt )
`[ -f ${DOCDIR}/sock_layout/tcp.txt.local ] && $( cat ${DOCDIR}/sock_layout/tcp.txt.local )`
${H_BR}
<strong>udp:</strong>
${H_BR}
$( cat ${DOCDIR}/sock_layout/udp.txt )
`[ -f ${DOCDIR}/sock_layout/udp.txt.local ] && $( cat ${DOCDIR}/sock_layout/udp.txt.local )`
${H_BR}
<h2>Настройки программы фильтрации iptables</h2>
${H_BR}
<pre class="cli">
$( grep -v ^# /etc/rc.local |grep iptables )
</pre>
${H_BR}
EOF
