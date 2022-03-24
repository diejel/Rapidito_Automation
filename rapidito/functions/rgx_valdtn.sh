validate_syntax4_blocklist () {
	IP_syntax="[0-99]{1,3}\.[0-99]{1,3}\.[0-99]{1,3}\.[0-99]{1,3}"
	ip_input=$1
	if [[ ( $ip_input =~ $IP_syntax ) ]]; then
		#exit 0 ;
		echo "Match Success"
	else
        echo "Do not Match"
        #exit 1;
    fi

}

regex_sede_reg_cidr () {
	IP_regex_reg="177\.202\.40\.([4,5][5-9,0-1])|201\.15\.99\.(5[0-6])|189\.30\.131\.(16[2-8])|201\.24\.3\.(4[2-8])|200\.96\.135\.(5[0-6])|200\.96\.135\.(16[2-8])|200\.140\.139\.(21[0-6])|201\.88\.0\.(1[8,9][6-9,0-2])"
	IP_regex_sede="187\.6\.111\.(25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[1-9][0-9]|[0-9])|191\.33\.183\.(23[2-8])"
	IP_regex_cidr="172\.([1][6-9]|[2][0-9]|[3][0-1])\.(25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[1-9][0-9]|[0-9])\.(25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[1-9][0-9]|[0-9])|192\.168\.(25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[1-9][0-9]|[0-9])\.(25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[1-9][0-9]|[0-9])|10\.(25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[1-9][0-9]|[0-9])\.(25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[1-9][0-9]|[0-9])\.(25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[1-9][0-9]|[0-9])|127\.(25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[1-9][0-9]|[0-9])\.(25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[1-9][0-9]|[0-9])\.(25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[1-9][0-9]|[0-9])"
	var=$1
	if [[ ($var =~ $IP_regex_reg) || ($var =~ $IP_regex_cidr)  || ( $var =~ $IP_regex_sede )]]; then
		IP_matched=${BASH_REMATCH[0]} 
		echo "IP-Regex-detected: $IP_matched"
		exit 1
	else
		echo "PASS"
		exit 0
	fi
}


