#!/bin/sh
add_ip_to_blacklist(){
  
  read -p "Type the IP address of the host that will be blocked : " ip_blacklist
  host_name="$cfg_hostname_prefix_deny-$ip_blacklist"
  
  res=$(regex_sede_reg_cidr "$ip_blacklist")
  if  (  [ $? -eq  0 ]  &&  [ $res == "PASS" ]  ); then
      mgmt_cli add host name $host_name ip-address $ip_blacklist tags $tag_value color $cfg_color_deny comments $caseID -s $(pwd)/$usr/".id_${usr}_secret.txt"  2> /dev/null
      group=$cfg_groupname_deny ; #"GRP-Blacklist-MT"
      printf "Adding the host ( $host_name ) to the group ( $group ) \n"
      add_host_response_blacklist=$( mgmt_cli set group name $group members.add $host_name color red tags $tag_value comments "Each IP follow a case ID" -s $(pwd)/$usr/".id_${usr}_secret.txt" 2> /dev/null )
      on_error_print_and_exit "Error: The adding operation of $host_name host to the $group group, has failed.\n $add_host_response_blacklist \n";
   
  elif [ $? -eq 1 ]; then
  	echo " The IP $ip_blacklist belongs to the EXCEPTIONS group, in fact will not be blocked";
    on_error_print_and_exit
    exit 1;
  fi

} 
