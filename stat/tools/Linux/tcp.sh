#!/bin/sh

. ./sock.subr

html_table_header

netstat -W -t -l -p -4 -n |grep ^tcp|tr "/" " " |awk '{printf $4" "$8"\n"}' | while read _ips _proc; do
	get_bind_info ${_ips}
	get_desc ${_proc}
	echo "<tr>"
	echo "<td>${_port}</td><td>tcp</td><td>${_interface}</td><td>${_proc}</td><td>${_desc}</td>"
	echo "</tr>"
done

endof_html_table_header
