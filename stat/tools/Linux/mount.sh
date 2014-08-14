#!/bin/sh
# $1 - /dev/sdaX
# return _type
get_type()
{
	local _num _tmp
	_tmp=$( echo $1 |tr -d "/[:alpha:]" )

	# проверяем как строчку а не test -gt для исключения потенц. ошибок с !is_integer?
	case "${_tmp}" in
		1|2|3|4)
			_type="Основной"
			return 0
	esac
	_type="Расширенный"
}

get_swap()
{
	cat /proc/swaps |tail -n +2 |while read _device _tmp; do
		_size=$( echo ${_tmp}|awk '{printf $2}' )
		_tmp=$( humanize_bytes ${_size} )
		echo "<td>${_device}</td><td>Расширенный</td><td>${_tmp}</td><td>-</td><td>Swap</td>"

	done
}

humanize_bytes()
{
	echo $1 | awk ' BEGIN { split("K,M,G,T,P,E,Z,Y,SZ",SZ,",") } { p=1;for(i=0;$1/p>1024;i++) p*=1024; printf "%4.1f%s", $1/p, SZ[i+1]}'
}


html_table_header()
{
cat <<EOF
<table class="images">
	<thead>
	<tr>
		<th>Раздел</th>
		<th>Тип</th>
		<th>Размер</th>
		<th>Тип ФС</th>
		<th>Точка монтирования</th>
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


# main
html_table_header

df -TPH| tail -n +2| sort -n -k1 |while read _device _fs _size _nop _nop _nop _mountpt; do
	case "${_device}" in
		/dev/mapper/logv-monitor|tmpfs|devpts|udev|proc|sysfs|/dev/disk/by-uuid*)
		continue
		;;
	esac
	get_type ${_device}
#	echo "${_device} ${_type} ${_size} ${_fs} ${_mountpt}"

	echo "<tr>"
	echo "<td>${_device}</td><td>${_type}</td><td>${_size}</td><td>${_fs}</td><td>${_mountpt}</td>"
	echo "</tr>"
done
get_swap

endof_html_table_header
