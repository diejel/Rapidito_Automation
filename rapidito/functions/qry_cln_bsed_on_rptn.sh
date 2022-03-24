#!/bin/sh
##### Query Clean & Report #################################

ip_clean_routine() {

mkdir -p $(pwd)/$usr/reputation/$( date +%d-%m-%Y )
num_ip_analyze_start=1
num_ip_analyze_limit=100
cont_num_ip_analyzed=0

read -p " How many IP addresses would you like to process? [ $num_ip_analyze_start - $num_ip_analyze_limit ]: " num_ips

#Will be made a multiplication num_ips x 40 (Max time in random phase)
let " recalc_time = $num_ips*40 "
sed -i "s/session-timeout: 600/session-timeout: $recalc_time/g" $(pwd)/$usr/".id_${usr}_secret.txt"

FILE_in="$(pwd)/$usr/reputation/$( date +%d-%m-%Y )/req-verify-clean-$(date +%d%m%Y ).rap"
FILE_out="$(pwd)/$usr/reputation/$( date +%d-%m-%Y )/req-verify-result-$(date +%d%m%Y ).rap"

echo -e "| IP | \tSTATUS | \tDETAILS | \tCOUNTRY | \tDOMAIN |" > $FILE_out
group_to_clean="serpro-blacklist-mt";
prefix_host="serpro-blacklist";
res_retrieve_ips=$( mgmt_cli show group name $group_to_clean -s $(pwd)/$usr/".id_${usr}_secret.txt"  | egrep -ioh "blacklist-[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}" | cut -d'-' -f2 > $FILE_in )

  ip_query_clean_report () {
    IP_test="$1";content=$( curl_cli -k https://www.abuseipdb.com/check/$IP_test ); 
    val_ans=$( echo $content | egrep -ioh "ISP[</th>]{1,5}[[:space:]][<td>]{1,4}[[:space:]]*[a-zA-Z0-9_\s\t]{1,}[^\>]*|Domain name[^\s]{1,11}\b([a-z0-9]+(-[a-z0-9]+)*\.)+[a-z]{2,}\b|reported [01-99]{1,10} times|was.*found.*database|confidence of abuse is [^\s]{1,3}[00-99]{1,2}[^\]{1,5}")

    val_ans_hostname=$( echo $content | grep -iPoh 'hostname[^\s][a-z][^\s]{1,6}[[:space:]][^\s]{1,4}[[:space:]]\b((?=[a-z0-9-]{1,63}\.)(xn--)?[a-z0-9]+(-[a-z0-9]+)*\.)+[a-z]{2,63}\b')
    val_ans_country=$( echo $content | egrep -ioh 'Country<[^\-]{1,}[^\<]{1,}' )
    
    reported_times=$( echo $val_ans | egrep -ioh 'reported [0-9]{1,10} times' | cut -d' ' -f2 ); [ -z $reported_times ] && let "reported_times = 0 " || let "reported_times = $reported_times "
    reported_hostname=$( echo $val_ans_hostname | grep -Pioh '\b((?=[a-z0-9-]{1,63}\.)(xn--)?[a-z0-9]+(-[a-z0-9]+)*\.)+[a-z]{2,63}\b' );[ -z $reported_hostname ] &&  reported_hostname="N/A" ||  reported_hostname=$reported_hostname
    reported_porc_abuse=$( echo $val_ans | egrep -ioh '[00-99]{1,3}\%'| cut -d% -f1 ); [ -z $reported_porc_abuse ] && let "reported_porc_abuse = 0 " || let "reported_porc_abuse = $reported_porc_abuse "
    reported_domain=$(echo $val_ans | egrep -ioh '\b([a-z0-9]+(-[a-z0-9]+)*\.)+[a-z]{2,}\b');[ -z $reported_domain ] &&  reported_domain="N/A" ||  reported_domain=$reported_domain
    reported_status=$( echo $val_ans | egrep -ioh 'was.*found');
    reported_isp=$( echo $val_ans | egrep -ioh 'ISP[</th>]{1,5}[[:space:]][<td>]{1,4}[[:space:]]*[a-zA-Z0-9_\s\t]{1,}[^\>]*' | cut -d'<' -f3 | cut -d'>' -f2 );
    [ -z "$reported_isp" ] &&  reported_isp="N/A" ||  reported_isp=$reported_isp ; reported_country=$( echo $val_ans_country | cut -d'>' -f4 );
    
    
    if ( [ $reported_times -eq 0 ] && [ $reported_porc_abuse -eq 0 ] && [  "$reported_country"!=="" ] ); then
      echo -e "$IP_test |\t( WILL-BE-CLEANED ) | RP:$reported_porc_abuse, RT: $reported_times\t | \t$reported_country\t | \t$reported_domain" | tee -a $FILE_out 
      res_remove_ip_from_blacklist=$( mgmt_cli set group name $group_to_clean members.remove "$prefix_host-$IP_test" ignore-warnings true -s $(pwd)/$usr/".id_${usr}_secret.txt" )
      echo "$res_remove_ip_from_blacklist" >> $FILE_out
      res_delete_ip_from_blacklist=$( mgmt_cli delete host name "$prefix_host-$IP_test" ignore-warnings true -s $(pwd)/$usr/".id_${usr}_secret.txt" )
      echo "$res_delete_ip_from_blacklist" >> $FILE_out
       
    else
      echo -e "$IP_test |\t( WILL-REMAIN ) | RP:$reported_porc_abuse, RT: $reported_times\t | \t$reported_country\t | \t$reported_domain" | tee -a  $FILE_out 
    fi
   }

shuf() { awk 'BEGIN {srand(); OFMT="%.17f"} {print rand(), $0}' "$@" | sort -k1,1n | cut -d ' ' -f2-; }

line=( $( shuf $FILE_in) )
for ip in "${line[@]}"; do
   let " cont_num_ip_analyzed = cont_num_ip_analyzed + 1 "
   if [ $cont_num_ip_analyzed -le $num_ips ]; then
       echo "-----------------------------------------";
       echo "Processing $cont_num_ip_analyzed ...";
       echo "------------------------------------------";
       ip_query_clean_report $ip
       sleep  $(( ( RANDOM % 40 )  + 1 ))
   else
       break;
   fi

done

}


########### End Query Clean and Report #####################