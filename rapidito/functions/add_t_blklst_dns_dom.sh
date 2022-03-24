#!/bin/sh
blacklist_dns_domain(){

clear;cont=0
echo -e "FQDN Domain: The specified domain will be blocked without consider any sub-domains"
echo -e "e.g: \t www.site.com.br \n"
echo -e "Non-FQDN Domain: The specified domain will be blocked considering up to 10 level sub-domains"
echo -e "e.g: \t .site.com.br"
echo -e "\t\t shopping.site.com.br"
echo -e "\t\t principal.shopping.site.com.br\n"
read -p "Are those FQDN(y) or Non-FQDN(n) domains? [y/n]:" res_fqdn
if [[ "$res_fqdn" == "y" || "$res_fqdn" == "Y" ]]; then
    val_fqdn=false ;
    STARTTIME=$(date +%s)
    echo -e "Paste the domains to be blocked: \n"
    while read -r inputtext 
    do
        if [ -z $inputtext ]; then
            break;
        fi
        let "cont = cont + 1"
        echo -e "Creating the network domain object.."
        echo -e "\n$cont) DOMAIN: '.$inputtext' "; 
        mgmt_cli add dns-domain name ".$inputtext" is-sub-domain $val_fqdn tags $tag_value comments $caseID -s $(pwd)/$usr/".id_${usr}_secret.txt"
        mgmt_cli set group name $fqdn_groupname members.add ".$inputtext" tags $tag_value comments "Each FQDN domain follows a case ID" -s $(pwd)/$usr/".id_${usr}_secret.txt"
        #echo "$val_fqdn"   
    done
    ENDTIME=$(date +%s)
    let "time_total_s = ENDTIME - STARTTIME"
    let "time_total_m =  time_total_s/60 "
    echo "The elapsed time was $time_total_s seconds ..."
elif [[ "$res_fqdn" == "n" || "$res_fqdn" == "N" ]]; then
    val_fqdn=true ;
    STARTTIME=$(date +%s)
    echo -e "Paste the DOMAINs to be blocked: \n"
    while read -r inputtext 
    do
        if [ -z $inputtext ]; then
            break;
        fi
        let "cont = cont + 1"
        echo -e "Creating the network domain object.."
        echo -e "\n$cont) DOMAIN: '.$inputtext' "; 
        mgmt_cli add dns-domain name ".$inputtext" is-sub-domain $val_fqdn tags $tag_value comments $caseID -s $(pwd)/$usr/".id_${usr}_secret.txt"
        mgmt_cli set group name $fqdn_groupname members.add ".$inputtext" tags $tag_value comments "FQDN and Non-FQDN  to be blocked, indicate the Case ID" -s $(pwd)/$usr/".id_${usr}_secret.txt"
        #echo "$val_fqdn"   
    done
    ENDTIME=$(date +%s)
    let "time_total_s = ENDTIME - STARTTIME"
    let "time_total_m =  time_total_s/60 "
    echo "The elapsed time was $time_total_s seconds ..."

else
    echo -e "Invalid response! \n "
    echo -e "Exiting from r[API]dito ...\n"
    exit 1
    #read -p "Esses dommains sao FQDN ou Non-FQDN? [y/n]:" res_fqdn
fi

}