#!/bin/sh
handle_error(){
	 printf "\n$1\n" #print error msg
	 mgmt_cli discard -s $(pwd)/$usr/".id_${usr}_secret.txt" > /dev/null
	 logout
	 exit 1
		}