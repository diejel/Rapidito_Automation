#!/bin/sh
debug_start_msg="Debug Start by";debug_end_msg="Debug End by";debug_rep_msg="Replication Start by"
debug_folder="/var/log"; usr_apache="/usr/local/apache2/logs";
echo -e "\n1) Creating Tshoot folder ... "
out_folder="/var/rapidito-tshoot/tshoot_gaia/$( date +%d-%m-%Y )"
mkdir -p $out_folder
echo -e "\n The folder was created at : $out_folder"
echo -e "\n2) Identification Process..."
echo "---------------------------------------------------";
sleep 3;
echo -e "\t Verifying SMS Version ..."
ans_ver=$( ls -d /opt/CPshrd-* | cut -d"/" -f3 | cut -d- -f2 );
ver_apache=( $(ls -1 /opt/CPshrd-$ans_ver/web/Apache/) ); 
args=( $(dbget -rva process:httpd2:arg | cut -d' ' -f2) );
echo -e "\tSystem version is : $ans_ver";
echo -e "---------------------------------------------------\n";
sleep 2;
echo -e "\n3) Doing Backup of current http2.conf file ..."
cp -p -v /web/conf/httpd2.conf  $out_folder/httpd2.conf_ORIGINAL
sleep 2;
echo -e "\n4) Setting the LogLevel to debug ..."
sed -ie 's/^LogLevel .*$/LogLevel debug/' /web/conf/httpd2.conf
sleep 2;
echo -e "\n5) Will be added some marks to identify the debug process"
echo -e "-----------------------------------------------------\n"
sleep 2;
read -p "Which your name:" name
echo -e "\n6) Appending the following mark: "
echo "$debug_start_msg $name at $(date)" | tee -a $debug_folder/httpd2_error_log $debug_folder/httpd2_access_log $debug_folder/secure $debug_folder/messages $usr_apache/access_log
sleep 2;
echo -e "\n7) Restarting the webserver ... "
tellpm process:httpd2;sleep 3;tellpm process:httpd2 t
sleep 3;
echo -e "\n8) Will be added some marks to identify the Starting Replication process"
echo "---------------------------------------------------------------------"
echo "Appending the following mark: "
echo "$debug_rep_msg $name at $(date)" | tee -a $debug_folder/httpd2_error_log $debug_folder/httpd2_access_log $debug_folder/secure $debug_folder/messages $usr_apache/access_log
sleep 3;
echo -e "\n9) Now, logs are being collected ..."
sleep 2;
echo -e "\n================================================================================================================="
echo "Perform some operations/tasks which are related with malfunction of Gaia Portal, will be detected and logged ..."
echo "========================================================================================================================"
sleep 5;
echo "waiting for user [20 sec] ...."; sleep 20 ;
echo -e "\n10) Now, will be added some marks to identify the End of debug process"
echo "---------------------------------------------------------------------"
echo "Appending the following mark: "
echo "$debug_end_msg $name at $(date)" | tee -a $debug_folder/httpd2_error_log $debug_folder/httpd2_access_log $debug_folder/secure $debug_folder/messages $usr_apache/access_log
sleep 3;
echo -e "\n11) All output logs are being collected..."
cp -p -v $debug_folder/httpd2_error_log* $out_folder
cp -p -v $debug_folder/httpd2_access_log* $out_folder
cp -p -v $debug_folder/secure* $out_folder
cp -p -v $debug_folder/messages* $out_folder
cp -p -v $usr_apache/access_log* $out_folder
sleep 5;
echo -e "\n12) Performing HTTPD2 daemon, and will be copied the error msg."
echo "--------------------------------------------------------------"
sleep 2;
echo "...Checking arguments that are needed for using"
run_action=$( /opt/CPshrd-$ans_ver/web/Apache/$ver_apache/bin/httpd2 "${args[0]}" "${args[1]}" "${args[2]}" "${args[3]}" "${args[4]}" "${args[5]}" &> $out_folder/response_msg_http2 )
echo $run_action | tee -a $out_folder/response_msg_http2
sleep 4;
echo -e "\n13) Restoring, the original /web/conf/httpd2.conf file ..."
cp -p -v /web/conf/httpd2.conf  $out_folder/httpd2.conf_DEBUG
cp -p -v $out_folder/httpd2.conf_ORIGINAL  /web/conf/httpd2.conf
sleep 2;
echo -e "\n14) Restarting the web server ...."
tellpm process:httpd2 ; sleep 3; tellpm process:httpd2 t
echo -e "\n----------------------------------------------"
echo "The process has been completed successfully!"
echo "-----------------------------------------------"
echo "Remember, logs are located at $out_folder"