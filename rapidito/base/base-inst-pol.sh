#!/bin/sh
#We will schedule policy installation
ans_ver=$( ls -d /opt/CPshrd-* | cut -d"/" -f3 | cut -d- -f2 );sms_vers="$ans_ver";
source /opt/CPshrd-$sms_vers/tmp/.CPprofile.sh
JQ=${CPDIR}/jq/jq
usuario=$(echo $0 | sed 's/.sh$//i' | awk -F '[-]' '{print $7}')
mat_cred=( $( < /var/rapidito/$usuario/.snh ) )
usr=${mat_cred[0]}
pass=${mat_cred[1]}
mat_target_fw=();
num=0;
mat_pol_pkg=( $( mgmt_cli show packages -u $usr -p $pass | grep -i 'name:' | cut -d':' -f2 | egrep -v "User|Standard" | sed -e 's/"//g' ) )

for (( i=0; i<${#mat_pol_pkg[@]}; i++ ))
do    
    mat_target_fw+=( $(mgmt_cli show package name ${mat_pol_pkg[$i]} -u $usr -p $pass | grep -i 'target-name' | cut -d':' -f2 | sed 's/"//g') )
    let "num = i + 1"
    let "den = ${#mat_pol_pkg[@]}/2"
    echo "Aplicando Policy no Firewall ${mat_pol_pkg[i+1]} | Progresso: [ $num / $den ]";
    mgmt_cli install-policy policy-package ${mat_pol_pkg[$i]} access true threat-prevention true targets.1 ${mat_target_fw[$i]} -u $usr -p $pass | tee -a /var/rapidito/$usuario/logs/scheduled_task_$usuario-$(date +%d%m%Y ).txt 
    sleep 10
done

#rm -rf $0
#17-03-2021--05-23--cron-task.sh

#sed '/^[0-9].*crontask/d' /home/dcubaz/scripts/cronfake
#sudo bash -c " sed '/^[0-9].*crontask/d' /etc/crontab "
#rm -rf $0

