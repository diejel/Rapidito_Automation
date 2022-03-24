#!/bin/sh
query_reputation(){

read -p "Type the IP address : " IP_test
#IP_test="$1";
content=$( curl_cli -k https://www.abuseipdb.com/check/$IP_test );
val_ans=$( echo $content | egrep -ioh "ISP[</th>]{1,5}[[:space:]][<td>]{1,4}[[:space:]]*[a-zA-Z0-9_\s\t]{1,}[^\>]*|Domain name[^\s]{1,11}\b([a-z0-9]+(-[a-z0-9]+)*\.)+[a-z]{2,}\b|reported [01-99]{1,10} times|was.*found.*database|confidence of abuse is [^\s]{1,3}[00-99]{1,2}[^\]{1,5}")
# ISP<[^\s]{1,5}[[:space:]][^\s]{1,5}\<[^\<]{1,}
# val_ans=$( echo $content | egrep -ioh "ISP[^\s]{1,5}[[:space:]][^\s]{1,5}\<[^\<]{1,}|Domain name[^\s]{1,11}\b([a-z0-9]+(-[a-z0-9]+)*\.)+[a-z]{2,}\b|reported [01-99]{1,10} times|was.*found.*database|confidence of abuse is [^\s]{1,3}[00-99]{1,2}[^\]{1,5}" | nl)
val_ans_hostname=$( echo $content | grep -iPoh 'hostname[^\s][a-z][^\s]{1,6}[[:space:]][^\s]{1,4}[[:space:]]\b((?=[a-z0-9-]{1,63}\.)(xn--)?[a-z0-9]+(-[a-z0-9]+)*\.)+[a-z]{2,63}\b')
val_ans_country=$( echo $content | egrep -ioh 'Country<[^\-]{1,}[^\<]{1,}' )
echo ".::. Online Reputation Scan Tool .::."
echo "--------------------------------------"
echo "";
reported_times=$( echo $val_ans | egrep -ioh 'reported [0-9]{1,10} times' | cut -d' ' -f2 ); [ -z $reported_times ] && let "reported_times = 0 " || let "reported_times = $reported_times "
reported_hostname=$( echo $val_ans_hostname | grep -Pioh '\b((?=[a-z0-9-]{1,63}\.)(xn--)?[a-z0-9]+(-[a-z0-9]+)*\.)+[a-z]{2,63}\b' );[ -z $reported_hostname ] &&  reported_hostname="N/A" ||  reported_hostname=$reported_hostname
reported_porc_abuse=$( echo $val_ans | egrep -ioh '[00-99]{1,3}\%'| cut -d% -f1 ); [ -z $reported_porc_abuse ] && let "reported_porc_abuse = 0 " || let "reported_porc_abuse = $reported_porc_abuse "
reported_domain=$(echo $val_ans | egrep -ioh '\b([a-z0-9]+(-[a-z0-9]+)*\.)+[a-z]{2,}\b');[ -z $reported_domain ] &&  reported_domain="N/A" ||  reported_domain=$reported_domain
reported_status=$( echo $val_ans | egrep -ioh 'was.*found');
reported_isp=$( echo $val_ans | egrep -ioh 'ISP[</th>]{1,5}[[:space:]][<td>]{1,4}[[:space:]]*[a-zA-Z0-9_\s\t]{1,}[^\>]*' | cut -d'<' -f3 | cut -d'>' -f2 );
[ -z "$reported_isp" ] &&  reported_isp="N/A" ||  reported_isp=$reported_isp ; 
reported_country=$( echo $val_ans_country | cut -d'>' -f4 );
echo " IP/FQDN Requested: $IP_test "
echo " Status: $reported_status "
echo " ISP: $reported_isp "
echo " Domain name: $reported_domain "
echo " Hostname: $reported_hostname "
echo " Country: $reported_country "
echo " Reported times: $reported_times "
echo " Abuse Confidence percent (%): $reported_porc_abuse "
echo "---------------------------------------"

}