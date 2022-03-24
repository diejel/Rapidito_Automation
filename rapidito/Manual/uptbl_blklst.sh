#!/bin/sh

#https://s3.i02.estaleiro.serpro.gov.br/blocklist/blocklist.txt

read -p "Paste the Updatable Blocklist URL :" url_list
content_list=$(curl_cli -k -s "$url_list"); 
one_col_list=$( echo $content_list | tr " " "\n" > $(pwd)/$usr/updatable_blocklist/ip_list-$( date +%d-%m-%Y ).txt );
#cat ip_list-$( date +%d-%m-%Y ).txt
