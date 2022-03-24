#!/bin/sh
process_login(){
   #cd /var/rapidito/
   echo "----------------------------------";
   printf "[ Authentication Process ]\n"
   echo "-----------------------------------";
   read -p "Type your SmartConsole username:" usr
   read -s -p "Type you password:" pass
   query_exist_dir=$(ls -dslh */ | grep $usr) &> /dev/null
   if [ $? -ne 0 ]; then
       mkdir -p $(pwd)/$usr && chmod 760 -R $(pwd)/$usr
       mkdir -p $(pwd)/$usr/logs/$( date +%d-%m-%Y )
       mkdir -p $(pwd)/$usr/blacklist/$( date +%d-%m-%Y )
       mkdir -p $(pwd)/$usr/sch/$( date +%d-%m-%Y )
       mkdir -p $(pwd)/$usr/indicators/$( date +%d-%m-%Y )
       mkdir -p $(pwd)/$usr/recursive/$( date +%d-%m-%Y )
       mkdir -p $(pwd)/$usr/updatable_blocklist/$( date +%d-%m-%Y )
       mkdir -p $(pwd)/$usr/updatable_blocklist/$( date +%d-%m-%Y )/history
       mgmt_cli login user $usr password "$pass"  > $(pwd)/$usr/.id_${usr}_secret.txt
       echo $usr $pass > $(pwd)/$usr/.snh
       on_error_print_and_exit "Error: The login process has failed, check if server is UP and is enabled the api_management_tool(run 'api status')"
       printf "\n...Hi $usr!, this is your first time here, this is why have been created a personal folder for you: \n $(pwd)/$usr/"
       printf "\n In your personal folder you can upload several files which will be integrated to r[API]dito functions \n\n."
   else
       printf "\n Updating your session key ...\n"
       mgmt_cli login user $usr password $pass  > $(pwd)/$usr/".id_${usr}_secret.txt"
       mkdir -p $(pwd)/$usr/logs/$( date +%d-%m-%Y )
       mkdir -p $(pwd)/$usr/blacklist/$( date +%d-%m-%Y )
       mkdir -p $(pwd)/$usr/sch/$( date +%d-%m-%Y )
       mkdir -p $(pwd)/$usr/indicators/$( date +%d-%m-%Y )
       mkdir -p $(pwd)/$usr/recursive/$( date +%d-%m-%Y )
       mkdir -p $(pwd)/$usr/updatable_blocklist/$( date +%d-%m-%Y )
       mkdir -p $(pwd)/$usr/updatable_blocklist/$( date +%d-%m-%Y )/history
       on_error_print_and_exit "Error: The login process has failed, check if server is UP and is enabled the api_management_tool(run 'api status')"
       
   fi
}

