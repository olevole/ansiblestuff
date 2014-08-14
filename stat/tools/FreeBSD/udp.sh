#!/bin/sh
. ./sock.subr

html_table_header

sockstat -4l -P udp |tail -n +2 |awk '{printf $2" "$6"\n"}' |while read _proc _ips; do
	get_bind_info ${_ips}
	get_desc ${_proc}
	echo "<tr>"
	echo "<td>${_port}</td><td>udp</td><td>${_interface}</td><td>${_proc}</td><td>${_desc}</td>"
	echo "</tr>"
done

endof_html_table_header
