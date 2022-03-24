#!/bin/sh
#source ./base/bse_auto_inst_pol.sh
sched_pol(){
  echo -e "::: --- Remember that the actual system time and timezone is : $(date) --- :::\n"
	read -p "Type date and time for scheduling following the format [dd-mm-yyyy-HH-MM]:" data
	cont_data=($(echo $data | tr "-" " "))
	dd=${cont_data[0]}
	mm=${cont_data[1]}
	aaaa=${cont_data[2]}
	HH=${cont_data[3]}
	MM=${cont_data[4]}
  echo  "$MM $HH $dd $mm *    $(pwd)/$usr/sch/$( date +%d-%m-%Y )/$dd-$mm-$aaaa-$HH-$MM-crontask-$usr.sh 2> $(pwd)/$usr/logs/$( date +%d-%m-%Y )/err_scheduled_task_$usuario-$(date +%d%m%Y ).txt"  >> /var/spool/cron/$USER 
  cp -p $(pwd)/base/bse_auto_inst_pol.sh  $(pwd)/$usr/sch/$( date +%d-%m-%Y )/$dd-$mm-$aaaa-$HH-$MM-crontask-$usr.sh
  echo "";
  echo -e "----------------------------------------------------------------------";
  echo -e "Ready, the installationwas scheduled at : $HH:$MM hrs ( $dd/$mm/$aaaa )"
  echo -e "-----------------------------------------------------------------------"
  #sed '/^[0-9].*crontask/d' /home/dcubaz/scripts/cronfake
}
 
