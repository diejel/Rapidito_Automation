#!/bin/sh
logout(){
	mgmt_cli logout -s $(pwd)/$usr/".id_${usr}_secret.txt" &> /dev/null
 	}