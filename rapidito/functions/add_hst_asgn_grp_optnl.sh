#!/bin/sh
add_host_and_assign_optional(){
  read -p "Type the hostname:" host_name
  show_host_response=$(mgmt_cli show host name $host_name -s $(pwd)/$usr/".id_${usr}_secret.txt" 2> /dev/null)
    if [ $? -ne 0 ]; then
        create_new_host_flag=true
    
    else # host already exist in DB.
        read -p "The host: $host_name already exists in database, do you want to edit? [Y], or not and exit [N]?:"  edit
        case $edit in
          y|Y)
               create_new_host_flag=false
                  ;;
          n|N)
               logout
                  ;;
               #exit 0
               #   ;;
           *)
               printf "Invalid Option." 
        esac   

    fi

read -p "Type the IP addres of $host_name :" ip
on_empty_input_print_and_exit "$ip" "Error: The IP address can not be empty."
    #Create host
    if [ $create_new_host_flag == true ]; then
        printf "Creating new host: $host_name with the following address : $ip\n"
        new_host_response=$(mgmt_cli add host name $host_name ip-address $ip tags $tag_value comments $caseID -s $(pwd)/$usr/".id_${usr}_secret.txt"  2> /dev/null)
        on_error_print_and_exit "Error: The object creation process has failed. \n$new_host_response"
    else
        printf "Editing the existent host: $host_name\n"
        set_host_response=$(mgmt_cli set host name $host_name ipv4-address $ip tags $tag_value comments $caseID -s $(pwd)/$usr/".id_${usr}_secret.txt" 2> /dev/null)
        on_error_print_and_exit "Error: The editing object process has failed : $host_name\n $set_host_response"
    fi


#Add hosts to groups
    while [ true ]; do
        printf "\n Type the name of the group ( can leave empty to skip this step ):\n"
        read -e group

        if [ -z $group ]; then
            break
        fi

#Run show-group in order to check if the group exists.
        show_group_response=$( mgmt_cli show group name $group  tags $tag_value -s $(pwd)/$usr/".id_${usr}_secret.txt" --format json 2> /dev/null )

        if [ $? -ne 0 ]; then
            group_not_found_err=$( echo $show_group_response | $JQ '.code | contains("generic_err_object_not_found")' )
            if [ $group_not_found_err ]; then
                printf "Creating new group: $group and adding the host: $host_name to the group\n"
                add_group_response=$( mgmt_cli add group name $group members $host_name tags $tag_value -s $(pwd)/$usr/".id_${usr}_secret.txt" 2> /dev/null )
                on_error_print_and_exit "Error: The group creation and adding host processes have failed. \n $add_group_response \n"
            else
                handle_error "Error: The group ( $group ) existence verification process has failed. "
            fi
        else #Add the host to the group
            printf "Adding the host : $host_name to the $group group\n"
            add_host_response=$( mgmt_cli set group name $group members.add $host_name  tags $tag_value comments $caseID -s $(pwd)/$usr/".id_${usr}_secret.txt" 2> /dev/null )
            on_error_print_and_exit "Error: The adding host operation to the specified group has failed.\n $add_host_response \n"
        fi
    done
} 