#!/bin/sh 
source /etc/profile.d/CP.sh
source /opt/CPshrd-R80/tmp/.CPprofile.sh
read -p "insira username:" usr
read -s -p "insira password:" pass
mgmt_cli login -u $usr -p $pass > /var/secret-temp.rap
cont=0;
line=( $( psql_client cpm postgres -c "SELECT objid, name, dlesession, cpmitable, subquery1.lockingsessionid, subquery1.operation FROM dleobjectderef_data, (SELECT lockedobjid, lockingsessionid, operation FROM locknonos) subquery1 WHERE subquery1.lockedobjid = objid and not deleted and dlesession >=0;" | egrep -i '[a-zA-Z0-9]{4,12}\-[a-zA-Z0-9]{4,12}\-[a-zA-Z0-9]{4,12}\-[a-zA-Z0-9]{4,12}\-[a-zA-Z0-9]{4,12}' | cut -d'|' -f5 | sort -u ) )
echo "The total locked objects found in the system are detailed below:"
echo "-----------------------------------------------------------------"
echo " $(psql_client cpm postgres -c "SELECT objid, name, dlesession, cpmitable, subquery1.lockingsessionid, subquery1.operation FROM dleobjectderef_data, (SELECT lockedobjid, lockingsessionid, operation FROM locknonos) subquery1 WHERE subquery1.lockedobjid = objid and not deleted and dlesession >=0;" )"
for uid in "${line[@]}"; do
        mgmt_cli discard uid $uid -s /var/secret-temp.rap
        if [ $? -ne 0 ]; then
            let "cont = cont + 1"
            echo "  $cont) $uid ------------> NOT removed"
        else
            let "cont = cont + 1"
            echo "  $cont) $uid ------------> YES was removed"
        fi
        let "num_col_nec=(cont*($(tput cols)-7))/${#line[@]}"
        let "porc_at=($num_col_nec*100)/($(tput cols)-7)"
        echo progress: $porc_at
        printf  "[ " && printf '#%.0s' $(seq 1 $num_col_nec) && echo -e " ] | $porc_at%\n"
done
mgmt_cli publish -s /var/secret-temp.rap
mgmt_cli logout -s /var/secret-temp.rap
echo "Dont forget: cpstop, wait 60 sec, cpstart ,wait 60 sec, and finally reboot the SmartCOnsole."
