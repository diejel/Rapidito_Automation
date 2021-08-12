#!/bin/sh

#--------------------------------------------------------------------------------#
#                  Shell Script for Multiple Network Objects Creation            #
#--------------------------------------------------------------------------------#
#  - Developed by: Diego Cuba Zuniga                       - Country: Peru       #
#  - Email: dcubazuniga@gmail.com                          - Version: v1.0.1     #
#  - GitHub: https://github.com/diejel                                           #
#--------------------------------------------------------------------------------#

##===============================================================================#
## This Script belongs to r[API]dito's project which is an initiative tool for   #
##             contribute to network automation processes.                       # 
##============================================================================== #


show_banner() {
banner=`cat <<EOF
******************************************************************************
*          ___              _____    _____   ___       _   _   _             *
*         |  _|     /\     |  __ \  |_   _| |_  |     | | (_) | |            *
*   _ __  | |      /  \    | |__) |   | |     | |   __| |  _  | |_    ___    *
*  |  __| | |     / /\ \   |  ___/    | |     | |  / _  | | | | __|  / _ \   *
*  | |    | |    / ____ \  | |       _| |_    | | | (_| | | | | |_  | (_) |  *
*  |_|    | |_  /_/    \_\ |_|      |_____|  _| |  \__ _| |_| \\__|   \\___/ *
*         |___|                             |___|                            *
*                                                                            *
*                             (v1.0.1) - 12/10/2021                          *
*                                                                            *
******************************************************************************
r[API]dito is an iniatitive software for contributing to automation CheckPoint 
tasks. Its based on the API Management Tool.

%%%%%%%%%%% To clear input text : CTRL + Backspace %%%%%%%%%%%%%%%%%%%

Any Doubts and suggestions: dcubazuniga@gmail.com

-----------------------------------------------------------------------------
EOF
`
echo "${banner}"

}

publish_changes(){

  printf "\n Performing Publish Operation of Changes made on the system ...\n"
  res_publish=$( mgmt_cli publish  -s $(pwd)/".id_secret.txt" ) &> /dev/null
  echo -e "$res_publish\n"
  echo -e "\t============================================================================"
  echo -e "\t|\t Thats all, changes were published. Do not forget to Install the Policy.|"
  echo -e "\t============================================================================\n"
  
}

netCreator() {
      cont=0; 
      tag_value="via-r[API]dito-script";

        extend_mask(){

                net_full=$1 

                if  [ -z "$net_full" ]; then
                    exit;
                else
                    net=$( echo $net_full | cut -d/ -f1 );
                    mask=$( echo $net_full | cut -d/ -f2 );
                    res=$(( $mask % 8 ));mod_pos=$((  $mask / 8  ));
                fi

                case $res in
                  0)
                        next_octect=0;;
                  1)
                        next_octect=128;;
                  2)
                        next_octect=192;;
                  3)
                        next_octect=224 ;;
                  4)
                        next_octect=240;;
                  5)
                        next_octect=248;;
                  6)
                        next_octect=252;;
                  7)
                        next_octect=254;;
                  *)
                         echo "not match any"
                esac

                if [ $mod_pos -eq 1  ]; then
                        mask_extend=255.$next_octect.0.0
                        echo -e "\n$net,$mask_extend"

                elif [ $mod_pos -eq 2 ]; then
                        mask_extend=255.255.$next_octect.0
                        echo -e "\n$net,$mask_extend"

                elif [ $mod_pos -eq 3 ]; then
                        mask_extend=255.255.255.$next_octect
                        echo -e "\n$net,$mask_extend"
                else
                        mask_extend=255.255.255.255
                        echo -e "\n$net,$mask_extend"
                fi
                }


      echo "------------------------------------------"
      echo "        Authentication Process            "
      echo "------------------------------------------"
      echo " "
      read -p "Type your SmartConsole username:" usr
      read -s -p  "Type your SmartConsole password:" pass
      mgmt_cli login user $usr password $pass > $(pwd)/.id_secret.txt
      echo " "
      read -p "Type the name of the group that will be created:" GroupName
      mgmt_cli add group name "$GroupName" tags $tag_value -s $(pwd)/.id_secret.txt
      read -p "Set a prefix name for the new network objects:" PrefixNetName
      echo -e  "Paste the network addresses in CIDR format(A.B.C.D/EF):\n"
      while read -r inputtext 
      do
           if [ -z $inputtext ]; then
              break;
           fi
           let "cont = cont + 1"
           echo -e "\nCreating the network object.."
           echo  "-----------------------------------"
           echo -e "\n$cont) $GroupName: $inputtext"; 
           echo -e "-----------------------------------"
           full_address=$( extend_mask $inputtext )
           mask=$( echo $inputtext | cut -d/ -f2 )
           net=$( echo $full_address | cut -d, -f1 )
           mask_extend=$( echo $full_address | cut -d, -f2 )
           NetComplementName="$PrefixNetName-$net-$mask" 
           mgmt_cli add network name $NetComplementName subnet $net subnet-mask $mask_extend tags $tag_value -s $(pwd)/.id_secret.txt
           mgmt_cli set group name $GroupName members.add "$NetComplementName" tags $tag_value -s $(pwd)/.id_secret.txt
           
      done
      }

show_banner      
netCreator
publish_changes