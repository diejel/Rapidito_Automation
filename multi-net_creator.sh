#!/bin/sh
multi-netw-object-creator(){
      cont=0;
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


      read -p "Type the name of the group that will be created:" GroupName
      mgmt_cli add group name "$GroupName" tags $tag_value comments $caseID -s $(pwd)/$usr/".id_${usr}_secret.txt"
      # PrefixNetName=zoom
      read -p "Set a prefix name for the new network objects:" PrefixNetName
      echo -e  "Paste the network addresses in CIDR format(A.B.C.D/EF):\n"
      while read -r inputtext 
      do
           if [ -z $inputtext ]; then
              break;
           fi
           let "cont = cont + 1"
           echo -e "Creating the network object.."
           echo -e "\n$cont) $GroupName: $inputtext"; 
           full_address=$( extend_mask "$inputtext" )
           mask=$( echo $inputtext | cut -d/ -f2 )
           net=$( echo $full_address | cut -d, -f1 )
           mask_extend=$( echo $full_address | cut -d, -f2 )
           NetComplementName="$PrefixNetName-$net-$mask" 
           mgmt_cli add network name $NetComplementName subnet $net subnet-mask $mask_extend tags $tag_value comments $caseID -s $(pwd)/$usr/".id_${usr}_secret.txt"
           mgmt_cli set group name $GroupName members.add $NetComplementName tags $tag_value comments $caseID -s $(pwd)/$usr/".id_${usr}_secret.txt"
           
      done
      }
multi-netw-object-creator