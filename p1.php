#!/usr/bin/env php
<?php

function ips() {
	global $json_a;

	if (empty($json_a['ansible_facts']['ansible_all_ipv4_addresses'])) {
		echo "&nbsp;";
		return 0;
	}

	$num=0;

	foreach ($json_a['ansible_facts']['ansible_all_ipv4_addresses'] as $ip ) {
		$num++;
		if ( $num == 1 ) {
			echo "<strong>$ip</strong><br>".PHP_EOL;
		} else {
			echo "$ip<br>".PHP_EOL;
		}
	}
	echo PHP_EOL;
}

function storage() {
	global $json_a;

	
	
	if (empty($json_a['ansible_facts']['ansible_devices'])) { 
		echo "&nbsp;";
		return 0;
	}

	echo "<strong>Storage</strong>: ";
	foreach (array_keys($json_a['ansible_facts']['ansible_devices']) as $dev ) {
		if (empty($json_a['ansible_facts']['ansible_devices']["$dev"]['size'])) {
			$size="Unkown size";
		} else {
			$size=$json_a['ansible_facts']['ansible_devices']["$dev"]['size'];
		}
		echo $dev."($size) ";
	}
	echo PHP_EOL;
}

function kernel() {
	global $json_a;

	if (empty($json_a['ansible_facts']['ansible_cmdline']['BOOT_IMAGE'])) {
		echo "&nbsp;";
		return 0;
	}

	$kernel=$json_a['ansible_facts']['ansible_cmdline']['BOOT_IMAGE'].PHP_EOL;
	echo "<strong>Kernel</strong>: ".$kernel;
}

function ossystem() {
	global $json_a;

	if (empty($json_a['ansible_facts']['ansible_distribution'])) {
		echo "&nbsp;";
		return 0;
	}


	$ossystem=$json_a['ansible_facts']['ansible_distribution']." ".$json_a['ansible_facts']['ansible_distribution_version'].PHP_EOL;

	if (empty($ossystem)) {
		echo "&nbsp;";
		return 0;
	}
	echo "<strong>OS System</strong>: ".$ossystem;
}

function hostname() {
	global $json_a;

	if (empty($json_a['ansible_facts']['ansible_hostname'])) {
		echo "&nbsp;";
		return 0;
	}


	$hostname=$json_a['ansible_facts']['ansible_hostname'].PHP_EOL;

	if (empty($hostname)) {
		echo "&nbsp;";
		return 0;
	}
	echo "<strong>Hostname</strong>: ".$hostname;
}

function fqdn() {
	global $json_a;

	if (empty($json_a['ansible_facts']['ansible_fqdn'])) {
		echo "&nbsp;";
		return 0;
	}


	$fqdn=$json_a['ansible_facts']['ansible_fqdn'].PHP_EOL;

	if (empty($fqdn)) {
		echo "&nbsp;";
		return 0;
	}
	echo "<strong>FQDN</strong>: ".$fqdn;
}

function arch() {
	global $json_a;

	if (empty($json_a['ansible_facts']['ansible_machine'])) {
		echo "&nbsp;";
		return 0;
	}


	$arch=$json_a['ansible_facts']['ansible_machine'].PHP_EOL;

	if (empty($arch)) {
		echo "&nbsp;";
		return 0;
	}
	echo "<strong>Arch</strong>: ".$arch;
}

function mem() {
	global $json_a;

	if (empty($json_a['ansible_facts']['ansible_memtotal_mb'])) {
		echo "&nbsp;";
		return 0;
	}


	$mem=$json_a['ansible_facts']['ansible_memtotal_mb'].PHP_EOL;

	if (empty($mem)) {
		echo "&nbsp;";
		return 0;
	}
	echo "<strong>Mem</strong>: ".$mem;
}

function cpu() {
	global $json_a;

	if (empty($json_a['ansible_facts']['ansible_processor'])) {
		echo "&nbsp;";
		return 0;
	}

	$num=0;
	foreach (array_keys($json_a['ansible_facts']['ansible_processor']) as $cpu ) {
		$num++;
	}
	$cpu=$json_a['ansible_facts']['ansible_processor'][0];
	echo "<strong>CPU</strong>: ".$cpu." ($num core's)";
	echo PHP_EOL;
}

function model() {
	global $json_a;

	if (empty($json_a['ansible_facts']['ansible_product_name'])) {
		echo "&nbsp;";
		return 0;
	}


	$model=$json_a['ansible_facts']['ansible_product_name'].PHP_EOL;

	if (empty($model)) {
		echo "&nbsp;";
		return 0;
	}
	echo "<strong>Model</strong>: ".$model;
}


function descr() {
	global $inv_dir;
	global $entry;
	
	$fp = fopen($inv_dir."/.".$entry.".descr","r");

	if (!$fp) {
		echo "&nbsp;";
		return 0;
	}
	echo "<pre class=cli>";
	while (!feof($fp)) {
		$buffer=fgets($fp, 4096);
		echo $buffer;
	}
	echo "</pre>";
	fclose($fp);
}

function mgmtip() {
	global $inv_dir;
	global $entry;
	
	$fp = fopen($inv_dir."/.".$entry.".mgmtip","r");

	if (!$fp) {
		echo "&nbsp;";
		return 0;
	}
	echo "<pre class=cli>";
	while (!feof($fp)) {
		$buffer=fgets($fp, 4096);
		echo $buffer;
	}
	echo "</pre>";
	fclose($fp);
}

function location() {
	global $inv_dir;
	global $entry;
	
	$fp = fopen($inv_dir."/.".$entry.".location","r");

	if (!$fp) {
		echo "&nbsp;";
		return 0;
	}
	echo "<pre class=cli>";
	while (!feof($fp)) {
		$buffer=fgets($fp, 4096);
		echo $buffer;
	}
	echo "</pre>";
	fclose($fp);
}
?>

<?xml version="1.0" encoding="utf-8" standalone="yes"?>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<style type="text/css">
		body {
				height:100%;
				width:100%;
				margin:0 auto;
				font-family:'trebuchet ms', 'lucida grande', 'lucida sans unicode', arial, helvetica, sans-serif;
				font-size:100%;
		}
		
		label {float:left; padding-right:10px;}
		.field {clear:both; text-align:right; line-height:25px;}
		.main,.checkbox-list {float:left;}
		.s_checkbox {width:10px; height:10px}

		pre.cli {
			font-family:'trebuchet ms', 'lucida grande', 'lucida sans unicode', arial, helvetica, sans-serif;
			font-size:90%;
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
		}
		table.images td {
				padding:4px;
				border-bottom:1px solid silver;
				font-family:'trebuchet ms', 'lucida grande', 'lucida sans unicode', arial, helvetica, sans-serif;
				font-size:90%;
		}
		table.images tr:last-child td {
				border-bottom-width:0;
		}
        </style>
</head>
<body>
<table class="images">
	<thead>
	<tr>
		<th>No</th>
		<th>Hostname</th>
		<th>Description</th>
		<th>HW</th>
		<th>Location</th>
		<th>IPs</th>
		<th>MGMT IP</th>
	</tr>
	</thead><tbody>
<?php

### MAIN ###
$inv_dir="./inv";
$num=0;
echo "Last scan time: ".date(DATE_RFC2822);

if ($handle = opendir($inv_dir)) {

	while (false !== ($entry = readdir($handle))) {

		//skip for hidden files and . .. name of dirs
		if ($entry[0]==".") continue;

		$string = file_get_contents($inv_dir."/".$entry);

		if ( $string == NULL ) {
			echo "error file_get_contents for $entry";
			continue;
		}

		$json_a = json_decode($string,true);

		if (empty($json_a)) continue;
		$num++;

		echo "</tr>";

		//No
		echo "		<td>$num</td>".PHP_EOL;

		//hostname
		echo "		<td>";
		hostname();
		echo "<br>";
		fqdn();
		echo "		</td>".PHP_EOL;

		//descr
		echo "		<td>";
		descr();
		echo "		</td>".PHP_EOL;

		//hardware
		echo "		<td>";
		cpu();
		echo "<br>";
		model();
		echo "<br>";
		storage();
		echo "<br>";
		arch();
		echo "<br>";
		mem();
		echo "<br>";
		ossystem();
		echo "<br>";
		kernel();
		echo "		</td>".PHP_EOL;

		echo "		<td>";
		location();
		echo "		</td>".PHP_EOL;

		echo "		<td>";
		ips();
		echo "		</td>".PHP_EOL;

		echo "		<td>";
		mgmtip();
		echo "		</td>".PHP_EOL;

		echo "</tr>";

	}
	closedir($handle);
} else {
	echo "Can't opendir $inv_dir";
}

?>

</table>
</body>
</html>
