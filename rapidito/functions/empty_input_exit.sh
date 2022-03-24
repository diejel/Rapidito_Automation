#!/bin/sh
on_empty_input_print_and_exit(){
	if [ -z "$1" ]; then
		printf "$2\n" #print err msg
		logout
		exit 0
	fi	
}