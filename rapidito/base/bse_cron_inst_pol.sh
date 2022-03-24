#!/bin/sh
#We will schedule policy installation
ans_ver=$( ls -d /opt/CPshrd-* | cut -d"/" -f3 | cut -d- -f2 );sms_vers="$ans_ver";
source /opt/CPshrd-$sms_vers/tmp/.CPprofile.sh #Remeber to change it to variables accordingly to version of firewall
JQ=${CPDIR}/jq/jq
usuario=$(echo $0 | sed 's/.sh$//i' | awk -F '[/]' '{print $4}' );
echo "$usuario" ;
cron_pol_pkg_name=$(echo $0 | sed 's/.sh$//i' | awk -F '[/]' '{print $7}' | cut -d_ -f1 );
echo $cron_pol_pkg_name ;
mat_cred=( $( < /var/rapidito/$usuario/.snh ) )
usr=${mat_cred[0]}
pass=${mat_cred[1]}
cron_target_fw_mat=();
num=0 ;
port=443 ;

cron_target_fw_mat=( $(mgmt_cli show package name $cron_pol_pkg_name -u $usr -p $pass | grep -i 'target-name' | cut -d':' -f2 | sed 's/"//g') ) 

for (( i = 0; i < ${#cron_target_fw_mat[@]}; i++ )); do
  let "num = i + 1"
  pub_ip_fw=$(mgmt_cli show simple-gateway name ${cron_target_fw_mat[$i]} -u $usr -p $pass --version 1.1 | grep -i 'ipv4-address' | egrep -v '^10.*|^127.*|^192.168*|^169.*|^172.*' | cut -d":" -f2 | cut -d"\"" -f2 | tr '\n' ' ' | cut -d' ' -f1)
  resp_ip_fw=$( nc -z -v -w 2 $pub_ip_fw $port )
  if [[ $resp_ip_fw -eq 0 ]] ; then

        echo "Installing policy in firewall ${cron_target_fw_mat[$i]} within Policy Package $cron_pol_pkg_name ... ";
        mgmt_cli install-policy policy-package $cron_pol_pkg_name access true threat-prevention true targets.1 ${cron_target_fw_mat[$i]} -u $usr -p $pass | tee -a /var/rapidito/$usuario/logs/log_recursive_task_$usuario-$(date +%d%m%Y ).txt 
        sleep 4
  
  else
        :
  fi
  
done


#rm -rf $0
#17-03-2021--05-23--cron-task.sh

#sed '/^[0-9].*crontask/d' /home/dcubaz/scripts/cronfake
#sudo bash -c " sed '/^[0-9].*crontask/d' /etc/crontab "
#rm -rf $0


