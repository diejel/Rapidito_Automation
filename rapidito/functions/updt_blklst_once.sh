#!/bin/sh

# in vars:  url_list
feed_blocklist_from_src() {
#clear;
work_folder="$(pwd)/$usr/updatable_blocklist/$( date +%d-%m-%Y )"
#work_folder="/var/scripts"
#mkdir -p $work_folder/history
echo "$work_folder"
#read -p "Paste the Updatable Blocklist URL :" url_list
url_list=$1
actual_file=$( ls -1 $work_folder | egrep "ip_list-[00-99]{2}[H]-[00-99]{2}[M].txt" ) ; 

echo  "actual_file result code : $?";

# Validation of actual file , for syntaxis of 1st element
first_ip_file="$(curl_cli -k -s $url_list |  tr " " "\n" | head -n 1 )"
echo "first_ip_file: $first_ip_file"
return_validation=$(validate_syntax4_blocklist "$first_ip_file")
echo "resposta validate syntax: $return_validation" 
if [ $? -eq 0 ]; then
	echo "was success and entering to IF and evaluate"
	if [ -z "$actual_file" ]; then 
		curl_cli -k -s $url_list |  tr " " "\n" > $work_folder/ip_list-$( date +%HH-%MM ).txt  && first_file=true ;	 
	else 
		first_file=false ;
	fi
else
	echo "The updatable_blocklist is not complaining the IPV4 format"
	#exit 1;
fi
	
#if [ -z "$actual_file" ]; then
#	first_line="$(curl_cli -k -s $url_list |  tr " " "\n" | head -n 1 )"
#	if  [[ "$first_file" ~= "[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}" ]];then

	#> $work_folder/ip_list-$( date +%HH-%MM ).txt  && first_file=true ; 
#else first_file=false ;

#fi


echo  "if inline result code : $?"
md5_new=$( curl_cli -k -s "$url_list" |  tr " " "\n"  | md5sum );
#poderia se fazer download do novo no caso de nao ser a primeira vez
md5_new_res=$( echo $md5_new | cut -d" " -f1 );


actual_file_next=$( ls -1 $work_folder | egrep "ip_list-[00-99]{2}[H]-[00-99]{2}[M].txt" ) ;
#num_reg_actual=$( cat $actual_file_next | wc -l );

md5_actual=$( cd $work_folder ; ls -1 $work_folder | egrep "ip_list-[00-99]{2}[H]-[00-99]{2}[M].txt" | xargs md5sum ; cd - );
md5_actual_res=$( echo $md5_actual | cut -d" " -f1 );

echo "Existence query prev: $actual_file";
echo "Existence query next: $actual_file_next";
echo "MD5 ATUAL: $md5_actual_res";
echo "MD5 NOVO: $md5_new_res";
echo "Status first file: $first_file"; 

if [[ ( "$md5_new_res" == "$md5_actual_res" ) && ( "$first_file" == true ) ]]; then
	echo "sao iguais";
	out_file_path="$work_folder/history/summary-ip_list-$( date +%HH-%MM ).txt" && touch $out_file_path
	add_updt_list_to_blocklist "$work_folder/$actual_file_next" "$out_file_path" 
elif [[ ( "$md5_new_res" == "$md5_actual_res" ) && ( "$first_file" == false ) ]]; then
	echo "sao iguais, nao teve mudancas";
elif [[ ( "$md5_new_res" != "$md5_actual_res" ) && ( "$first_file" == false ) ]]; then
	echo "nao sao iguais,  teve mudancas, nao e a primeira vez";
	#ajeitar aqui 
	curl_cli -k -s $url_list |  tr " " "\n" > $work_folder/ip_list-$( date +%HH-%MM ).txt
	out_file_path="$work_folder/history/summary-ip_list-$( date +%HH-%MM ).txt" && touch $out_file_path
	file_new=$( ls -1 $work_folder | egrep "ip_list-[00-99]{2}[H]-[00-99]{2}[M].txt"| egrep -v "$actual_file_next" ) ;
	echo "file_new: $file_new"
	add_updt_list_to_blocklist "$work_folder/$file_new" "$out_file_path"
	cd $work_folder; ls -1  | egrep "ip_list-[00-99]{2}[H]-[00-99]{2}[M].txt"| egrep -v "$file_new" | xargs mv -t history ;cd -  
#else 
#	echo "sao distintos os md5"
#	#mv  "$work_folder/$actual_file_next" "$work_folder/history/" ; #rm -rf $work_folder/*.txt ;
#	out_file_path="$work_folder/history/summary-ip_list-$( date +%HH-%MM ).txt" && touch "$out_file_path"
#	add_updt_list_to_blocklist "$work_folder/$actual_file_next" "$out_file_path"
#	cd $work_folder; ls | egrep -v "$actual_file_next" | xargs -i {} mv history ;cd -   
fi
}