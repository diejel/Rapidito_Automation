#!/bin/sh
#We will schedule policy installation
ans_ver=$( ls -d /opt/CPshrd-* | cut -d"/" -f3 | cut -d- -f2 );sms_vers="$ans_ver";
source /opt/CPshrd-$sms_vers/tmp/.CPprofile.sh #Remeber to change it to variables accordingly to version of firewall
JQ=${CPDIR}/jq/jq
usuario=$(echo $0 | sed 's/.sh$//i' | awk -F '[/]' '{print $4}' );
mat_cred=( $( < /var/rapidito/$usuario/.snh ) )
usr=${mat_cred[0]}
pass=${mat_cred[1]}
mat_target_fw=();
num=0 ;
port=443 ;
mat_pol_pkg=( $( mgmt_cli show packages -u $usr -p $pass | grep -i 'name:' | cut -d':' -f2 | egrep -v "User|Standard" | sed -e 's/"//g' ) )

for (( i=0; i<${#mat_pol_pkg[@]}; i++ ))
do    
    mat_target_fw=( $(mgmt_cli show package name ${mat_pol_pkg[$i]} -u $usr -p $pass | grep -i 'target-name' | cut -d':' -f2 | sed 's/"//g') )
    for (( n = 0; n < ${#mat_target_fw[@]}; n++ )); do
        let "num = n + 1"
        let "den = ${#mat_pol_pkg[@]}"
        echo "Installing policy in Firewall ${mat_target_fw[$n]} within Policy-Package ${mat_pol_pkg[$i]} ";
        echo "Progress: [ $num / $den ]";
        pub_ip_fw=$(mgmt_cli show simple-gateway name ${mat_target_fw[$n]} -u $usr -p $pass  | grep -i 'ipv4-address' | egrep -v '^10.*|^127.*|^192.*|^169.*|^172.*' | cut -d":" -f2 | cut -d"\"" -f2 | tr '\n' ' ' | cut -d' ' -f1)
        resp_ip_fw=$( nc -z -v -w 2 $pub_ip_fw $port )
        if [[ $resp_ip_fw -eq 0 ]] ; then
              mgmt_cli install-policy policy-package ${mat_pol_pkg[$i]} access true threat-prevention true targets.1 ${mat_target_fw[$n]} -u $usr -p $pass | tee -a /var/rapidito/$usuario/logs/scheduled_task_$usuario-$(date +%d%m%Y ).txt 
              sleep 3
        else
              :
        fi
    done
    

done



#rm -rf $0
#17-03-2021--05-23--cron-task.sh

#sed '/^[0-9].*crontask/d' /home/dcubaz/scripts/cronfake
#sudo bash -c " sed '/^[0-9].*crontask/d' /etc/crontab "
#rm -rf $0


