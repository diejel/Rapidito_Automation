#!/bin/sh
read -p "Which is main folder in /var/? , rapidito or rapibeta :" main_folder 
if [[ $main_folder = "rapibeta" ]]; then
	$(grep -rl rapidito /var/rapibeta | xargs sed -i 's/rapidito/rapibeta/g' ; cd /var/$main_folder );
else
	cd /var/$main_folder ;
fi

echo "---------------------------------------------------";
echo -e "\tVerifying SMS Version ..."
ans_ver=$( ls -d /opt/CPshrd-* | cut -d"/" -f3 | cut -d- -f2 );
echo "Registering version detected in r[API]dito ..."
echo "#---------------------- Adding/Registering SMS version -------------------#" >> /var/$main_folder/config/init.rap 
echo sms_vers="$ans_ver" >>  /var/$main_folder/config/init.rap 
echo "System version is : $ans_ver";
echo -e "---------------------------------------------------\n";
echo "Loading dependencies ....";
for f in /var/$main_folder/functions/* ; do source $f ; done
echo "API Status verification process ..."
echo "-------------------------------------";
res_api=$(api status);
[[ $(echo "$res_api" | grep -i 'Not running') ]] && ( echo "The API looks like is not running, trying to restart it..." ; api restart  ) || echo "The API status looks like is working normallly"

echo -e "Applying corrections to overcome overload problems ..."
if [[ "$ans_ver" = "R81" ]]; then
	echo "The current version $ans_ver, does not need those corrections."
else
	echo "The current version $ans_ver, needs those corrections."
	echo "Applying correction from sK119553";
	cmd1=$(echo "_cpprof_add NGM_WEB_API_MAX_MEMORY 4096 0 0" >> /opt/CPshared/5.0/tmp/.CPprofile.sh);
	on_error_print_and_exit "Error: The correction process has failed : \n $cmd1"

	cmd2=$(echo "_cpprof_add NGM_WEB_API_JRE_64 1 0 0" >> /opt/CPshared/5.0/tmp/.CPprofile.sh);
    on_error_print_and_exit "Error: The correction process has failed : \n $cmd2"
    echo "Corrections were applied succesfully";
fi

echo "============= Alias Creation ===================="
echo "alias rapidito='cd /var/rapidito && bash /var/rapidito/rapidito-v2.sh'" >> ~/.bashrc
echo 'alias rapibeta="grep -rl rapidito /var/rapibeta | xargs sed -i 's/rapidito/rapibeta/g'; cd/var/rapibeta ; bash ./rapidito-v2.sh"' >> ~/.bashrc
echo "=================================================="
echo "The process Installation was finished!.."


