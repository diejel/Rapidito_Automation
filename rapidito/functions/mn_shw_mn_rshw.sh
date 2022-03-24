#!/bin/sh
menu_reshow(){

  options=( "Several Network Object creation"
   "Host/Group creation"
   "Host addition into an existing group"
   "Addition of a single IP address to Blacklist group"
   "Addition of several IPs to Blacklist group (simple-paste)"
   "Addition of a dns-domain list to a Blacklist (simple-paste)"
   "Adding a list of IP addresses to the Blacklist group"
   "Add Blocklist from Feed"
   "Verify the existence of an IP address within Blacklist"
   "Verify the existence of host within group"
   "Schedule Policy Installation"
   "Schedule Recursive Policy Installation"
   "Schedule Recursive Policy Installation all Policy Package"
   "Check IP reputation" "Take off IPs from blacklist (routine)"
   "Create CSV Indicator file" "Exit" )

  let condition_val="${#options[@]}"
  echo " -------------- Choose an option : ------------------";
  for ((k=1; k <= condition_val ; k++)) ; do
         echo  "$k ) ${options[k-1]}"
  done 
}    


menu_show(){

printf "\t\t [Menu]\n"
echo "Choose an option:"
options=( "Several Network Object creation" 
    "Host/Group creation"
    "Host addition into an existing group"
    "Addition of a single IP address to Blacklist group"
    "Addition of several IPs to Blacklist group (simple-paste)"
    "Addition of a dns-domain list to a Blacklist (simple-paste)"
    "Adding a list of IP addresses to the Blacklist group"
    "Add Blocklist from Feed"
    "Verify the existence of an IP address within Blacklist"
    "Verify the existence of host within group"
    "Schedule Policy Installation"
    "Schedule Recursive Policy Installation"
    "Schedule Recursive Policy Installation all Policy Package"
    "Check IP reputation" "Take off IPs from blacklist (routine)"
    "Create CSV Indicator file"
    "Exit" )

select opt in "${options[@]}"
     do
         case $opt in
             "Several Network Object creation")
                 #echo "you chose choice 1"
                 logout
                 process_login
                 ask_caseID
                 group_ranges
                 publish_changes
                 logout
                 menu_reshow 
                  ;;
             "Host/Group creation")
                 #echo "you chose choice 2"
                 logout
                 process_login
                 ask_caseID
                 add_host_and_assign_optional
                 publish_changes
                 logout
                 menu_reshow 
                  ;;
             "Host addition into an existing group")
                 #echo "you chose choice 3"
                 logout
                 process_login
                 ask_caseID
                 add_host_to_group
                 publish_changes
                 logout
                 menu_reshow
                 ;;
             "Addition of a single IP address to Blacklist group")
                 #echo "you chose choice 4"
                 logout
                 process_login
                 ask_caseID
                 add_ip_to_blacklist
                 publish_changes
                 logout
                 menu_reshow
                 ;;
             "Addition of several IPs to Blacklist group (simple-paste)")
                 logout
                 process_login
                 ask_caseID
                 add_list_cp_blacklist
                 publish_changes 
                 logout
                 menu_reshow
                 ;;
             "Addition of a dns-domain list to a Blacklist (simple-paste)")
                 logout
                 process_login
                 ask_caseID
                 blacklist_dns_domain
                 publish_changes 
                 logout
                 menu_reshow
                 ;;
             "Adding a list of IP addresses to the Blacklist group")
                 #echo "you chose choice 5"
                 logout
                 process_login
                 ask_caseID
                 add_list_to_blacklist
                 publish_changes 
                 logout
                 menu_reshow
                 ;;
             "Add Blocklist from Feed")
                 #echo "you chose choice 6"
                 logout
                 process_login
                 ask_caseID
                 exct_blklst
                 publish_changes 
                 logout
                 menu_reshow
                 ;;              
             "Verify the existence of an IP address within Blacklist")
                 echo "you chose $opt"
                 ;;
             "Verify the existence of host within group")
                 echo "you chose $opt"
                 ;;
             "Schedule Policy Installation")
                 echo "you chose $opt"
                 process_login
                 sched_pol
                 logout
                 ;;
             "Schedule Recursive Policy Installation")
                 echo "you chose $opt"
                 process_login
                 sched_pol_recursive
                 logout
                 ;;
             "Schedule Recursive Policy Installation all Policy Package")
                 echo "you chose $opt"
                 process_login
                 sched_pol_recursive_all
                 logout
                 ;;
             "Check IP reputation")
                 query_reputation
                 menu_reshow
                 ;;
             "Take off IPs from blacklist (routine)")
                 logout
                 process_login
                 ask_caseID
                 ip_clean_routine
                 publish_changes
                 logout
                 menu_reshow
                 ;;
             "Create CSV Indicator file")
                 process_login
                 ask_caseID
                 create_indicator
                 logout
                 ;;
             "Exit")
                 exit
                 ;;
             *) echo "Invalid Option"
                 ;;
         esac
     done
}