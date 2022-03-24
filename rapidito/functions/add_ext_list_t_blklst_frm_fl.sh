#!/bin/sh
add_list_to_blacklist(){
#cd $(pwd)/$usr/blacklist/
#Variaveis:
group=$cfg_groupname_blacklist #serpro-blacklist-mt
color=$cfg_color_blacklist #red
hostname_prefix=$cfg_hostname_prefix_blacklist #serpro-blacklist
#Test of existence
out=$(ls -l $(pwd)/$usr/blacklist/$( date +%d-%m-%Y ) | grep blacklist-$(date +%d%m%Y ).txt)

if [ $? -ne 0 ]; then
  echo " ================================================================================================";
  echo "| Place the IP list into the folder ./$usr/blacklist/$( date +%d-%m-%Y )                        |";
  echo "|                              e.g  blacklist-$(date +%d%m%Y ).txt                              |";
  echo "|-----------------------------------------------------------------------------------------------|";
  echo "| Format:                                                                                       |";
  echo "|    1.2.3.4                                                                                    |";
  echo "|    5.6.7.8                                                                                    |";
  echo "|       .                                                                                       |";
  echo "|       .                                                                                       |";
  echo "|       .                                                                                       |";
  echo "|                                                                                               |";
  echo " ================================================================================================ ";
  break;
else
  echo " I detected the following file: $(ls -l $(pwd)/$usr/blacklist/$( date +%d-%m-%Y ) |  grep -i blacklist-$(date +%d%m%Y).txt | awk '{print $9}') ";
  FILE_in=$(pwd)/$usr/blacklist/$( date +%d-%m-%Y )/blacklist-$(date +%d%m%Y).txt
  FILE_out_ip_summ=$(pwd)/$usr/blacklist/$( date +%d-%m-%Y )/summary_final_ip.rap && touch $FILE_out_ip_summ
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
        mgmt_cli add host name $hostname_prefix-$ip ip-address $ip tags $tag_value color $color comments $caseID -s $(pwd)/$usr/".id_${usr}_secret.txt" >> $(pwd)/$usr/logs/$( date +%d-%m-%Y )/log-blacklist-$(date +%d%m%Y ).txt  
        if [ $? -ne 0 ]; then
            let "cont = cont + 1"
            echo "  $cont) $ip ------------> NO" | tee -a $FILE_out_ip_summ
        else
            let "cont = cont + 1"
            mgmt_cli set group name $group members.add $hostname_prefix-$ip color $color tags $tag_value comments "Each IP da serpro follows a case ID" -s $(pwd)/$usr/".id_${usr}_secret.txt"  >> $(pwd)/$usr/logs/$( date +%d-%m-%Y )/log-blacklist-$(date +%d%m%Y ).txt
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
                        mgmt_cli add host name $hostname_prefix-$ip ip-address $ip tags $tag_value color $color comments $caseID -s $(pwd)/$usr/".id_${usr}_secret.txt" >> $(pwd)/$usr/logs/$( date +%d-%m-%Y )/log-blacklist-$(date +%d%m%Y ).txt  
                        if [ $? -ne 0 ]; then
                            let "cont = cont + 1"
                            echo "  $cont) $ip ------------> NO" | tee -a $FILE_out_ip_summ
                        else
                            let "cont = cont + 1"
                            mgmt_cli set group name $group members.add $hostname_prefix-$ip color $color tags $tag_value comments "Each IP da serpro follows a case ID" -s $(pwd)/$usr/".id_${usr}_secret.txt"  >> $(pwd)/$usr/logs/$( date +%d-%m-%Y )/log-blacklist-$(date +%d%m%Y ).txt
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
                      mgmt_cli add host name $hostname_prefix-$ip ip-address $ip tags $tag_value color $color comments $caseID -s $(pwd)/$usr/".id_${usr}_secret.txt" >> $(pwd)/$usr/logs/log-blacklist-$(date +%d%m%Y ).txt  
                      if [ $? -ne 0 ]; then
                           let "cont = cont + 1"
                           echo "  $cont) $ip ------------> NO" | tee -a $FILE_out_ip_summ
                      else
                           let "cont = cont + 1"
                           mgmt_cli set group name $group members.add $hostname_prefix-$ip color $color tags $tag_value comments "Each IP da serpro follows a case ID" -s $(pwd)/$usr/".id_${usr}_secret.txt"  >> $(pwd)/$usr/logs/log-blacklist-$(date +%d%m%Y ).txt
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
                      mgmt_cli add host name $hostname_prefix-$ip ip-address $ip tags $tag_value color $color comments $caseID -s $(pwd)/$usr/".id_${usr}_secret.txt" >> $(pwd)/$usr/logs/$( date +%d-%m-%Y )/log-blacklist-$(date +%d%m%Y ).txt  
                      if [ $? -ne 0 ]; then
                           let "cont = cont + 1"
                           echo "  $cont) $ip ------------> NO" | tee -a $FILE_out_ip_summ
                      else
                           let "cont = cont + 1"
                           mgmt_cli set group name $group members.add $hostname_prefix-$ip color $color tags $tag_value comments "Each IP da serpro follows a case ID" -s $(pwd)/$usr/".id_${usr}_secret.txt"  >> $(pwd)/$usr/logs/$( date +%d-%m-%Y )/log-blacklist-$(date +%d%m%Y ).txt
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

fi
}