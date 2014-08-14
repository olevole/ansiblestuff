#!/bin/sh
. ./sock.subr

html_table_header

netstat -W -u -l -p -4 -n |grep ^udp|tr "/" " " |awk '{printf $4" "$7"\n"}'|while read _ips _proc; do
	get_bind_info ${_ips}
	get_desc ${_proc}
	echo "<tr>"
	echo "<td>${_port}</td><td>udp</td><td>${_interface}</td><td>${_proc}</td><td>${_desc}</td>"
	echo "</tr>"
done

endof_html_table_header
