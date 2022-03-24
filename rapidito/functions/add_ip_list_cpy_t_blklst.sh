#!/bin/sh
add_list_cp_blacklist(){
 read -p "Paste the Ip addresses delimited by colons:" pasted_ip
 line=( $( echo $pasted_ip | tr ','  " "   ) )
 
### comeco logica lista ip ###
#Variaveis:
exist_group_name=$cfg_groupname_deny; #"GRP-Blacklist-MT"
color=$cfg_color_deny;  #red
hostname_prefix=$cfg_hostname_prefix_deny; #"blacklist" ;
FILE_out_ip_summ=$(pwd)/$usr/blacklist/$( date +%d-%m-%Y )/summary_final_ip-$(date +%d-%m-%y-%Hh%Mm).rap && touch $FILE_out_ip_summ
#FILE_out_ip_summ=$4

#initialize  entitle
echo -e "||\t\tIP\t||\tSTATUS (added?)\t||\n" > $FILE_out_ip_summ
let "cont = 0"

#loop logic
cont=0
  for ip in "${line[@]}"; do
        mgmt_cli add host name $hostname_prefix-$ip ip-address $ip tags $tag_value color $color comments $caseID -s $(pwd)/$usr/".id_${usr}_secret.txt" >> $(pwd)/$usr/logs/$( date +%d-%m-%Y )/log-blacklist-$(date +%d-%m-%y-%Hh%Mm ).txt  
        if [ $? -ne 0 ]; then
            let "cont = cont + 1"
            #let "num_col_nec=(cont*$(tput cols))/${#line[@]}"
            #let "porc_at=($num_col_nec*100)/$(tput cols)"
            echo "  $cont) $ip ------------> NO" | tee -a $FILE_out_ip_summ
            #echo num_colunas_nec : $num_col_nec
            #echo progress: $porc_at
        else
            let "cont = cont + 1"
            mgmt_cli set group name $exist_group_name members.add $hostname_prefix-$ip color $color tags $tag_value comments "Each host in Blacklist follows a Case ID" -s $(pwd)/$usr/".id_${usr}_secret.txt"  >> $(pwd)/$usr/logs/$( date +%d-%m-%Y )/log-blacklist-$(date +%d-%m-%y-%Hh%Mm ).txt
            echo "  $cont) $ip ------------> YES" | tee -a $FILE_out_ip_summ
            #echo num_colunas_nec : $num_col_nec
        fi
        let "num_col_nec=(cont*($(tput cols)-7))/${#line[@]}"
        let "porc_at=($num_col_nec*100)/($(tput cols)-7)"
        #echo num_colunas_nec : $num_col_nec
        echo progress: $porc_at
        printf  "[ " && printf '#%.0s' $(seq 1 $num_col_nec) && echo -e " ] | $porc_at%\n"

  done
### fim logica list ip ####

}
