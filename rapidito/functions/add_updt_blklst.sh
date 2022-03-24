add_updt_list_to_blocklist(){
#cd $(pwd)/$usr/blacklist/
#Variaveis:
source ./config/init.rap
FILE_in=$1 #$(pwd)/$usr/updatable_blocklist/$( date +%d-%m-%Y )/updatable_blocklist-$(date +%d%m%Y).txt
FILE_out_ip_summ=$2 #$(pwd)/$usr/updatable_blocklist/$( date +%d-%m-%Y )/summary_updatable_blocklist-$(date +%d%m%Y).rap && touch $FILE_out_ip_summ

group=$cfg_updt_blocklist_group ; #serpro-blacklist-mt
color=$cfg_updt_color_blocklist ; #blue
hostname_prefix=$cfg_updt_prefix_blocklist ;  #updatable-blacklist-serpro 
#Test of existence
#out=$(ls -l $(pwd)/$usr/updatable_blocklist/$( date +%d-%m-%Y ) | grep ip_list-$( date +%HH-%MM ).txt )
#echo " I detected the following file: $(ls -l $(pwd)/$usr/updatable_blocklist/$( date +%d-%m-%Y ) |  grep -i ip_list-$( date +%HH-%MM ).txt | awk '{print $9}') ";
  


sed -i -e 's/\r//g' $FILE_in
line=($(awk -F= '{print $1}' $FILE_in))
#initialize  entitle
echo -e "||\t\tIP\t||\tSTATUS ( was added? )\t||\n" > $FILE_out_ip_summ
#count
let "cont = 0"
#loop logic
cont=0
  
## group separation to reduce overload ####
  
num_elements=${#line[@]};
factor=$cfg_factor_blacklist; #400
let "mod_factor = $num_elements/$factor"
let "res_factor = $num_elements%$factor"
cont_mod=0;cont_fact=0
echo "The total IP addresses to be processed are: $num_elements"
echo "Will be added in groups of $factor IPs, in order to not overload the server"
echo "Quant. Groups: $mod_factor"
echo "Quant. Residual : $res_factor"
STARTTIME=$(date +%s)
  if [ $num_elements -le $factor ]; then
      echo "---------------------------------------------------------------------------------------------------"
      echo "The amount of IP addresses is lower than the factor ($factor), the process will remain normally..."
      echo -e "------------------------------------------------------------------------------------------------\n"
      for ip in "${line[@]}"; do
        mgmt_cli add host name "$hostname_prefix-$ip" ip-address $ip tags $tag_value color $color comments $caseID -s $(pwd)/$usr/".id_${usr}_secret.txt" >> $(pwd)/$usr/logs/$( date +%d-%m-%Y )/log-updatable_blocklist.txt  
        if [ $? -ne 0 ]; then
            let "cont = cont + 1"
            echo "  $cont) $ip ------------> NO" | tee -a $FILE_out_ip_summ
        else
            let "cont = cont + 1"
            mgmt_cli set group name $group members.add "$hostname_prefix-$ip" color $color tags $tag_value comments "Each IP da serpro follows a case ID" -s $(pwd)/$usr/".id_${usr}_secret.txt"  >> $(pwd)/$usr/logs/$( date +%d-%m-%Y )/log-updatable_blocklist.txt
            echo "  $cont) $ip ------------> YES" | tee -a $FILE_out_ip_summ
        fi
        let "num_col_nec=(cont*($(tput cols)-7))/${#line[@]}"
        let "porc_at=($num_col_nec*100)/($(tput cols)-7)"
        echo "";
        printf  "[ " && printf '#%.0s' $(seq 1 $num_col_nec) && echo -e " ] | $porc_at%\n"
        
      done

      
  else
      for ip in "${line[@]}"; 
      do
          let "cont_fact = cont_fact + 1"; 
			    if ( [ $cont_fact -le $factor ]  && [ $cont_mod -lt $mod_factor ] ); then
				        #paste same routine
                        mgmt_cli add host name "$hostname_prefix-$ip" ip-address $ip tags $tag_value color $color comments $caseID -s $(pwd)/$usr/".id_${usr}_secret.txt" >> $(pwd)/$usr/logs/$( date +%d-%m-%Y )/log-updatable_blocklist.txt 
                        if [ $? -ne 0 ]; then
                            let "cont = cont + 1"
                            echo "  $cont) $ip ------------> NO" | tee -a $FILE_out_ip_summ
                        else
                            let "cont = cont + 1"
                            mgmt_cli set group name $group members.add "$hostname_prefix-$ip" color $color tags $tag_value comments "Each IP da serpro follows a case ID" -s $(pwd)/$usr/".id_${usr}_secret.txt"  >> $(pwd)/$usr/logs/$( date +%d-%m-%Y )/log-updatable_blocklist.txt 
                            echo "  $cont) $ip ------------> YES" | tee -a $FILE_out_ip_summ
                        fi
                        let "num_col_nec=(cont*($(tput cols)-7))/${#line[@]}"
                        let "porc_at=($num_col_nec*100)/($(tput cols)-7)"
                        echo num_colunas_nec : $num_col_nec
                        echo progress: $porc_at
                        printf  "[ " && printf '#%.0s' $(seq 1 $num_col_nec) && echo -e " ] | $porc_at%\n" 
                        # end paste same routine
			    elif ( [ $cont_fact -gt $factor ] && [ $cont_mod -lt $mod_factor ] ); then
				      let "cont_mod = cont_mod + 1"
				      let "cont_fact = 0"
				      let "cont_fact = cont_fact +1"
                      #paste same routine
                      mgmt_cli add host name "$hostname_prefix-$ip" ip-address $ip tags $tag_value color $color comments $caseID -s $(pwd)/$usr/".id_${usr}_secret.txt" >>  $(pwd)/$usr/logs/$( date +%d-%m-%Y )/log-updatable_blocklist.txt 
                      if [ $? -ne 0 ]; then
                           let "cont = cont + 1"
                           echo "  $cont) $ip ------------> NO" | tee -a $FILE_out_ip_summ
                      else
                           let "cont = cont + 1"
                           mgmt_cli set group name $group members.add "$hostname_prefix-$ip" color $color tags $tag_value comments "Each IP da serpro follows a case ID" -s $(pwd)/$usr/".id_${usr}_secret.txt"  >>  $(pwd)/$usr/logs/$( date +%d-%m-%Y )/log-updatable_blocklist.txt 
                           echo "  $cont) $ip ------------> YES" | tee -a $FILE_out_ip_summ
                      fi
                      let "num_col_nec=(cont*($(tput cols)-7))/${#line[@]}"
                      let "porc_at=($num_col_nec*100)/($(tput cols)-7)"
                      echo num_colunas_nec : $num_col_nec
                      echo progress: $porc_at
                      printf  "[ " && printf '#%.0s' $(seq 1 $num_col_nec) && echo -e " ] | $porc_at%\n" 
                      # end paste same routine 
        			  echo "Performing the publish operation of the $cont_mod group ..."
                      publish_changes
			    elif ( [ $cont_mod -eq $mod_factor ] && [ $cont_fact -lt $factor ] ); then
				      echo "Adding the residual quantity ..."
    		          #paste same routine
                      mgmt_cli add host name "$hostname_prefix-$ip" ip-address $ip tags $tag_value color $color comments $caseID -s $(pwd)/$usr/".id_${usr}_secret.txt" >>  $(pwd)/$usr/logs/$( date +%d-%m-%Y )/log-updatable_blocklist.txt 
                      if [ $? -ne 0 ]; then
                           let "cont = cont + 1"
                           echo "  $cont) $ip ------------> NO" | tee -a $FILE_out_ip_summ
                      else
                           let "cont = cont + 1"
                           mgmt_cli set group name $group members.add "$hostname_prefix-$ip" color $color tags $tag_value comments "Each IP da serpro follows a case ID" -s $(pwd)/$usr/".id_${usr}_secret.txt"  >>  $(pwd)/$usr/logs/$( date +%d-%m-%Y )/log-updatable_blocklist.txt 
                            echo "  $cont) $ip ------------> YES" | tee -a $FILE_out_ip_summ
                      fi
                      let "num_col_nec=(cont*($(tput cols)-7))/${#line[@]}"
                      let "porc_at=($num_col_nec*100)/($(tput cols)-7)"
                      echo num_colunas_nec : $num_col_nec
                      echo progress: $porc_at
                      printf  "[ " && printf '#%.0s' $(seq 1 $num_col_nec) && echo -e " ] | $porc_at%\n" 
                      # end paste same routine 			
			    fi
      done
    
  fi

ENDTIME=$(date +%s)
let "time_total_s = ENDTIME - STARTTIME"
let "time_total_m =  time_total_s/60 "
echo " The elapsed time was $time_total_s seconds ..."
### end group separation #####


}