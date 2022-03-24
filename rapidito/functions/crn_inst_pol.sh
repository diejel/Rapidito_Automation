#!/bin/sh
sched_pol_recursive(){

		read -p "Which is the Policy-Package name you are attempting to install?:" cron_pol_pkg_name
		on_empty_input_print_and_exit "$cron_pol_pkg_name" "Error: The Policy-Package name can not be empty."

		cron_target_fw_response=$( mgmt_cli show package name "$cron_pol_pkg_name" -u $usr -p $pass > /dev/null ) 
		on_error_print_and_exit "Error: The Policy-Package verification process has failed : \n $cron_target_fw_response"

		echo "-------------------- Frequency --------------------------------"
		echo " - Everyday 02 times per day: D2"
		echo " - Every weekend 02 times per day: W2"
		echo " - Everyday at midnight: M1"
		echo "---------------------------------------------------------------"

		read -p "Which is the frequency Policy Package Installation you want to apply?:" opt_cron

		if [[ ( $opt_cron == "D2" ) || ( $opt_cron == "d2" ) ]]; then
			echo "The Installation will be set 02 times per day."
			read -p "Insert the 1st (HH:MM) and 2nd (HH:MM) followed by colons [e.g 10:20,21:30]:" hrs_mins_arry_d2
			on_empty_input_print_and_exit "$hrs_mins_arry_d2" "Error: The input hours can not be empty."
			
			h1=$(echo $hrs_mins_arry_d2 | cut -d, -f1 | cut -d: -f1 ) ; 
			m1=$(echo $hrs_mins_arry_d2 | cut -d, -f1 | cut -d: -f2 ) ;

			h2=$(echo $hrs_mins_arry_d2 | cut -d, -f2 | cut -d: -f1 ) ; 
			m2=$(echo $hrs_mins_arry_d2 | cut -d, -f2 | cut -d: -f2 ) ;

			echo  "$m1,$m2 $h1,$h2 * * *    $(pwd)/$usr/recursive/$( date +%d-%m-%Y )/"$cron_pol_pkg_name"_crontask_"$usr".sh 2> $(pwd)/$usr/logs/$( date +%d-%m-%Y )/stdout_recursive_task_$usuario-$(date +%d%m%Y ).txt"  >> /var/spool/cron/$USER 
		    cp -p $(pwd)/base/bse_cron_inst_pol.sh  $(pwd)/$usr/recursive/$( date +%d-%m-%Y )/"$cron_pol_pkg_name"_crontask_"$usr".sh
		    echo "";
		    echo -e "===============================================================================================";
		    echo -e "\t\t Frequency : Everyday , 02 times per day"
		    echo -e "===============================================================================================";
		    echo -e "-----------------------------------------------------------------------------------------------";
		    echo -e "\tReady, the recursive routine was scheduled at those times: $h1:$m1 , $h2:$m2 hrs \n "
		    echo -e "----------------------------------------------------------------------------------------------";

		elif [[  ( $opt_cron == "W2" ) || ( $opt_cron == "w2" ) ]]; then
			echo "The Installation will be set 02 on weekends."
			read -p "Insert the 1st (HH:MM) and 2nd (HH:MM) followed by colons [e.g 18:00,23:00]:" hrs_mins_arry_w2
			on_empty_input_print_and_exit "$hrs_mins_arry_w2" "Error: The input hours can not be empty."

			h1=$(echo $hrs_mins_arry_d2 | cut -d, -f1 | cut -d: -f1 ) ; 
			m1=$(echo $hrs_mins_arry_d2 | cut -d, -f1 | cut -d: -f2 ) ;

			h2=$(echo $hrs_mins_arry_d2 | cut -d, -f2 | cut -d: -f1 ) ; 
			m2=$(echo $hrs_mins_arry_d2 | cut -d, -f2 | cut -d: -f2 ) ;

			echo  "$m1,$m2 $h1,$h2 * * 6,0    $(pwd)/$usr/recursive/$( date +%d-%m-%Y )/"$cron_pol_pkg_name"_crontask_"$usr".sh 2> $(pwd)/$usr/logs/$( date +%d-%m-%Y )/recursive_task_$usuario-$(date +%d%m%Y ).txt"  >> /var/spool/cron/$USER 
		    cp -p $(pwd)/base/bse_cron_inst_pol.sh  $(pwd)/$usr/recursive/$( date +%d-%m-%Y )/"$cron_pol_pkg_name"_crontask_"$usr".sh
		    echo "";
		    echo -e "===============================================================================================";
		    echo -e "\t\t Frequency : Every weekend , 02 times per day"
		    echo -e "===============================================================================================";
		    echo -e "-----------------------------------------------------------------------------------------------";
		    echo -e "\tReady, the recursive routine was scheduled at those times: $h1:$m1 , $h2:$m2 hrs \n "
		    echo -e "----------------------------------------------------------------------------------------------";

		elif [[ ( $opt_cron == "M1" ) || ( $opt_cron == "m1" ) ]]; then
			
			echo  "0 0 * * *    $(pwd)/$usr/recursive/$( date +%d-%m-%Y )/"$cron_pol_pkg_name"_crontask_"$usr".sh 2> $(pwd)/$usr/logs/$( date +%d-%m-%Y )/recursive_task_$usuario-$(date +%d%m%Y ).txt"  >> /var/spool/cron/$USER 
		    cp -p $(pwd)/base/bse_cron_inst_pol.sh  $(pwd)/$usr/recursive/$( date +%d-%m-%Y )/"$cron_pol_pkg_name"_crontask_"$usr".sh
		    echo "";
		    echo -e "===============================================================================================";
		    echo -e "\t\t Frequency : Everyday at Midnight"
		    echo -e "===============================================================================================";
		    echo -e "-----------------------------------------------------------------------------------------------";
		    echo -e "\tReady, the recursive routine was scheduled everyday at: 00:00 hrs \n "
		    echo -e "----------------------------------------------------------------------------------------------";
		fi

}

#cron_target_fw_mat=( $(mgmt_cli show package name $cron_pol_pkg_name -u $usr -p $pass | grep -i 'target-name' | cut -d':' -f2 | sed 's/"//g') ) 
