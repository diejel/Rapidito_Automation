#!/bin/sh
publish_changes(){
  #cd /var/rapidito/
  #Publish changes
  printf "\n Performing Publish Operation of Changes made on the system ...\n"
  res_publish=$( mgmt_cli publish  -s $(pwd)/$usr/".id_${usr}_secret.txt" ) &> /dev/null
  on_error_print_and_exit "Error: Publish process has failed. $res_publish "
  echo -e "$res_publish\n"
  echo -e "\t============================================================================"
  echo -e "\t|\t Thats all, changes were published. Do not forget to Install the Policy.|"
  echo -e "\t============================================================================\n"
  caseid_already_input=true
  
}