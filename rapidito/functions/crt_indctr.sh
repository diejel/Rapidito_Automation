#!/bin/sh
create_indicator () {

mkdir -p $(pwd)/$usr/indicators/$( date +%d-%m-%Y )
FILE_indic_in=$(pwd)/$usr/indicators/$( date +%d-%m-%Y )/indicator-req-$(date +%d%m%Y ).txt
FILE_indic_out=$(pwd)/$usr/indicators/$( date +%d-%m-%Y )/indicator-result-$(date +%d%m%Y ).csv && touch $FILE_indic_out
product_1="AV";product_2="AB";
echo -e "Will be created a .csv file, which contains the certain format\n in order to be uploaded to SmartConsole\n"
echo -e "As soon as the file be uploaded, you must choose the action (Prevent/Detect)\n"
echo -e "Which is the indicator type?"
indicador_option=("Domain" "URL" "MD5" )
confidence_option=("low" "medium" "high" )
severity_option=("low" "medium" "high" )
create_csv_file_progress () {
    let "cont = 0"
    cont=0
    STARTTIME=$(date +%s)
    for value_object in "${line[@]}"; do
        if [ $type_object == "MD5" ]; then
            echo malicious-indicator-$type_object-$cont-$product_1,$value_object,$type_object,$confidence_object,$severity_object,$product_1,"$caseID" | tee -a $FILE_indic_out
            let "cont = cont + 1"
            let "num_col_nec=(cont*($(tput cols)-7))/${#line[@]}"
            let "porc_at=($num_col_nec*100)/($(tput cols)-7)"
            echo progress: $porc_at
            printf  "[ " && printf '#%.0s' $(seq 1 $num_col_nec) && echo -e " ] | $porc_at%\n"
        else
             echo malicious-indicator-$type_object-$cont-$product_1,$value_object,$type_object,$confidence_object,$severity_object,$product_1,"$caseID" | tee -a $FILE_indic_out
             echo malicious-indicator-$type_object-$cont-$product_2,$value_object,$type_object,$confidence_object,$severity_object,$product_2,"$caseID" | tee -a $FILE_indic_out
             let "cont = cont + 1"
             let "num_col_nec=(cont*($(tput cols)-7))/${#line[@]}"
             let "porc_at=($num_col_nec*100)/($(tput cols)-7)"
             echo progress: $porc_at
             printf  "[ " && printf '#%.0s' $(seq 1 $num_col_nec) && echo -e " ] | $porc_at%\n"
        fi     
    done
     ENDTIME=$(date +%s)
     let "time_total_s = ENDTIME - STARTTIME"
     let "time_total_m =  time_total_s/60 "
     echo "The elapsed time was $time_total_s seconds ..."
     echo "The file created is : $FILE_indic_out "
     echo "Now, just only you should upload the file to the SmartConsole :), bye"
}

#Test of existence
out_indic_file=$( ls -l $(pwd)/$usr/indicators/$( date +%d-%m-%Y ) | grep indicator-req-$(date +%d%m%Y ).txt )
if [ $? -ne 0 ]; then
  echo " ================================================================================================";
  echo "| Place the indicators file into the folder /$usr/indicators/$( date +%d-%m-%Y )                |";
  echo "|                              e.g  indicator-req-$(date +%d%m%Y ).txt                          |";
  echo "|-----------------------------------------------------------------------------------------------|";
  echo "| Format:                                                                                      |";
  echo "|    domain.net                                                                                 |";
  echo "|    malicious-net.cn                                                                           |";
  echo "|       .                                                                                       |";
  echo "|       .                                                                                       |";
  echo "|       .                                                                                       |";
  echo "|                                                                                               |";
  echo " ================================================================================================ ";
  break;
else
          echo " I found the following file: $(ls -l $(pwd)/$usr/indicators/$( date +%d-%m-%Y ) |  grep -i indicator-req-$(date +%d%m%Y ).txt | awk '{print $9}') ";
          sed -i -e 's/\r//g' $FILE_indic_in
          line=($(awk -F= '{print $1}' $FILE_indic_in))     
          select type_object in "${indicador_option[@]}"
          do
               case $type_object in
                    "Domain")
                    echo "You have choosen $type_object"
                    
                    echo "Which is the confidence level?"
                    select confidence_object in "${confidence_option[@]}"
                              do
                                   case $confidence_object in
                                        "low")
                                        echo "You have choosen $confidence_object"
                                   
                                        echo  "Which is the severity level?"
                                        select severity_object in "${severity_option[@]}"
                                             do
                                                  case $severity_object in
                                                  "low")
                                                       echo "You have choosen $severity_object"
                                                       create_csv_file_progress
                                                       break;
                                                  ;;
                                                  "medium")
                                                       echo "You have choosen $severity_object"
                                                       create_csv_file_progress
                                                       break;
                                                  ;;
                                                  "high")
                                                       echo "You have choosen $severity_object"
                                                       create_csv_file_progress
                                                       break;
                                                  ;;
                                                  esac
                                             done
                                        ;;
                                        "medium")
                                        echo "You have choosen $confidence_object"
                                        echo  "Which is the severity level?"
                         
                                             select severity_object in "${severity_option[@]}"
                                             do
                                                  case $severity_object in
                                                  "low")
                                                       echo "You have choosen $severity_object"
                                                       create_csv_file_progress
                                                       break;
                                                  ;;
                                                  "medium")
                                                       echo "You have choosen $severity_object"
                                                       create_csv_file_progress
                                                       break;
                                                  ;;
                                                  "high")
                                                       echo "You have choosen $severity_object"
                                                       create_csv_file_progress
                                                       break;
                                                  ;;
                                                  
                                                  esac
                                             done
                                        ;;

                                        "high")
                                        echo "You have choosen $confidence_object"
                                        echo  "Which is the severity level?"
                                        
                                             select severity_object in "${severity_option[@]}"
                                             do
                                                  case $severity_object in
                                                  "low")
                                                       echo "You have choosen $severity_object"
                                                       create_csv_file_progress
                                                       break;
                                                  ;;
                                                  "medium")
                                                       echo "You have choosen $severity_object"
                                                       create_csv_file_progress
                                                       break;
                                                  ;;
                                                  "high")
                                                       echo "You have choosen $severity_object"
                                                       create_csv_file_progress
                                                       break;
                                                  ;;
                                                
                                                  esac
                                             done
                                        ;;
                                   esac
                                   break
                              done
                    ;;
               "URL")
                    echo "You have choosen $type_object"
               
                    echo "Which is the confidence level?"
                    select confidence_object in "${confidence_option[@]}"
                              do
                                   case $confidence_object in
                                        "low")
                                        echo "You have choosen $confidence_object"
                                        
                                        echo  "Which is the severity level?"
                                        select severity_object in "${severity_option[@]}"
                                             do
                                                  case $severity_object in
                                                  "low")
                                                       echo "You have choosen $severity_object"
                                                       create_csv_file_progress
                                                       break;
                                                  ;;
                                                  "medium")
                                                       echo "You have choosen $severity_object"
                                                       create_csv_file_progress
                                                       break;
                                                  ;;
                                                  "high")
                                                       echo "You have choosen $severity_object"
                                                       create_csv_file_progress
                                                       break;
                                                  ;;

                                                  esac
                                             done
                                        ;;
                                        "medium")
                                        echo "You have choosen $confidence_object"
                                        echo "Which is the severity level?"
                                   
                                             select severity_object in "${severity_option[@]}"
                                             do
                                                  case $severity_object in
                                                  "low")
                                                       echo "You have choosen $severity_object"
                                                       create_csv_file_progress
                                                       break;
                                                  ;;
                                                  "medium")
                                                       echo "You have choosen $severity_object"
                                                       create_csv_file_progress
                                                       break;
                                                  ;;
                                                  "high")
                                                       echo "You have choosen $severity_object"
                                                       create_csv_file_progress
                                                       break;
                                                  ;;
                                                  esac
                                             done
                                        ;;

                                        "high")
                                        echo "You have choosen $confidence_object"
                                        echo "Which is the severity level?"
                                   
                                             select severity_object in "${severity_option[@]}"
                                             do
                                                  case $severity_object in
                                                  "low")
                                                       echo "You have choosen $severity_object"
                                                       create_csv_file_progress
                                                       break;
                                                  ;;
                                                  "medium")
                                                       echo "You have choosen $severity_object"
                                                       create_csv_file_progress
                                                       break;
                                                  ;;
                                                  "high")
                                                       echo "You have choosen $severity_object"
                                                       create_csv_file_progress
                                                       break;
                                                  ;;
                                                  esac
                                             done
                                        ;;
                                   "critical")
                                        echo "You have choosen $confidence_object"
                                        echo  "Which is the severity level?"
                                        
                                             select severity_object in "${severity_option[@]}"
                                             do
                                                  case $severity_object in
                                                  "low")
                                                       echo "You have choosen $severity_object"
                                                       create_csv_file_progress
                                                       break;
                                                  ;;
                                                  "medium")
                                                       echo "You have choosen $severity_object"
                                                       create_csv_file_progress
                                                       break;
                                                  ;;
                                                  "high")
                                                       echo "You have choosen $severity_object"
                                                       create_csv_file_progress
                                                       break;
                                                  ;;
                                                  esac
                                             done
                                        ;;

                                   esac
                                   break
                              done

                    ;;
               "MD5")
                    echo "You have choosen $type_object"
                    echo "Which is the confidence level?"
                    select confidence_object in "${confidence_option[@]}"
                              do
                                   case $confidence_object in
                                        "low")
                                        echo "You have choosen $confidence_object"
                                   
                                        echo  "Which is the severity level?"
                                        select severity_object in "${severity_option[@]}"
                                             do
                                                  case $severity_object in
                                                  "low")
                                                       echo "You have choosen $severity_object"
                                                       create_csv_file_progress
                                                       break;
                                                  ;;
                                                  "medium")
                                                       echo "You have choosen $severity_object"
                                                       create_csv_file_progress
                                                       break;
                                                  ;;
                                                  "high")
                                                       echo "You have choosen $severity_object"
                                                       create_csv_file_progress
                                                       break;
                                                  ;;
                                                  esac
                                             done
                                        ;;
                                        "medium")
                                        echo "You have choosen $confidence_object"
                                        echo  "Which is the severity level?"
                         
                                             select severity_object in "${severity_option[@]}"
                                             do
                                                  case $severity_object in
                                                  "low")
                                                       echo "You have choosen $severity_object"
                                                       create_csv_file_progress
                                                       break;
                                                  ;;
                                                  "medium")
                                                       echo "You have choosen $severity_object"
                                                       create_csv_file_progress
                                                       break;
                                                  ;;
                                                  "high")
                                                       echo "You have choosen $severity_object"
                                                       create_csv_file_progress
                                                       break;
                                                  ;;
                                                  esac
                                             done
                                        ;;

                                        "high")
                                        echo "You have choosen $confidence_object"
                                        echo  "Which is the severity level?"
                                        
                                             select severity_object in "${severity_option[@]}"
                                             do
                                                  case $severity_object in
                                                  "low")
                                                       echo "You have choosen $severity_object"
                                                       create_csv_file_progress
                                                       break;
                                                  ;;
                                                  "medium")
                                                       echo "You have choosen $severity_object"
                                                       create_csv_file_progress
                                                       break;
                                                  ;;
                                                  "high")
                                                       echo "You have choosen $severity_object"
                                                       create_csv_file_progress
                                                       break;
                                                  ;;

                                                  esac
                                             done
                                        ;;
                                 
                                   esac
                                   break
                              done
                    ;;
               "URL")
                    echo "You have choosen $type_object"
               
                    echo "Which is the confidence level?"
                    select confidence_object in "${confidence_option[@]}"
                              do
                                   case $confidence_object in
                                        "low")
                                        echo "You have choosen $confidence_object"
                                        
                                        echo  "Which is the severity level?"
                                        select severity_object in "${severity_option[@]}"
                                             do
                                                  case $severity_object in
                                                  "low")
                                                       echo "You have choosen $severity_object"
                                                       create_csv_file_progress
                                                       break;
                                                  ;;
                                                  "medium")
                                                       echo "You have choosen $severity_object"
                                                       create_csv_file_progress
                                                       break;
                                                  ;;
                                                  "high")
                                                       echo "You have choosen $severity_object"
                                                       create_csv_file_progress
                                                       break;
                                                  ;;
                                                
                                                  esac
                                             done
                                        ;;
                                        "medium")
                                        echo "You have choosen $confidence_object"
                                        echo "Which is the severity level?"
                                   
                                             select severity_object in "${severity_option[@]}"
                                             do
                                                  case $severity_object in
                                                  "low")
                                                       echo "You have choosen $severity_object"
                                                       create_csv_file_progress
                                                       break;
                                                  ;;
                                                  "medium")
                                                       echo "You have choosen $severity_object"
                                                       create_csv_file_progress
                                                       break;
                                                  ;;
                                                  "high")
                                                       echo "You have choosen $severity_object"
                                                       create_csv_file_progress
                                                       break;
                                                  ;;
                                             
                                                  esac
                                             done
                                        ;;

                                        "high")
                                        echo "You have choosen $confidence_object"
                                        echo "Which is the severity level?"
                                   
                                             select severity_object in "${severity_option[@]}"
                                             do
                                                  case $severity_object in
                                                  "low")
                                                       echo "You have choosen $severity_object"
                                                       create_csv_file_progress
                                                       break;
                                                  ;;
                                                  "medium")
                                                       echo "You have choosen $severity_object"
                                                       create_csv_file_progress
                                                       break;
                                                  ;;
                                                  "high")
                                                       echo "You have choosen $severity_object"
                                                       create_csv_file_progress
                                                       break;
                                                  ;;
                                                  
                                                  esac
                                             done
                                        ;;


                                   esac
                                   break
                              done
                    
                    ;;
               esac
               break
          done
fi

unix2dos $FILE_indic_out

}