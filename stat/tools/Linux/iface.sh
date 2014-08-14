#!/bin/sh

html_table_header()
{
cat <<EOF
<table class="images">
        <thead>
        <tr>
                <th></th>
                <th></th>
        </tr>
        </thead><tbody>
EOF
}

endof_html_table_header()
{
cat <<EOF
</tbody></table>
EOF
}



html_table_header

ns=$( awk '/nameserver/{print $2}' /etc/resolv.conf |xargs )

echo "<tr>"
echo "<td>DNS сервер:</td><td>${ns}</td>"
echo "</tr>"


nics=$( /sbin/ifconfig -s|tail -n +2 |cut -d " " -f 1 )


for i in ${nics}; do
	echo "<tr>"
	echo "<td>"
	printf "<strong>${i}</strong> "
	echo "</td><td>"
	/sbin/ifconfig ${i} |grep "inet addr:" |tr -d "[:alpha:]:" |awk '{printf "IP: "$1", MASK: "$2}'
	echo "\n</td>"
	echo "</tr>"
done

endof_html_table_header
