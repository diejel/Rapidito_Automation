#!/bin/sh
add_host_to_group(){
  read -p "Type the host name: " host_name
  read -p "Which the group name? : " group
  printf "...Adding the host : $host_name to the group: $group\n"
  add_host_response=$( mgmt_cli set group name $group members.add $host_name  tags $tag_value comments $caseID -s $(pwd)/$usr/".id_${usr}_secret.txt" 2> /dev/null )
  on_error_print_and_exit "Error: The host addition to the specified group operation, has failed.\n $add_host_response \n"
}