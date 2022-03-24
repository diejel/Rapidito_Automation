#!/bin/sh
on_error_print_and_exit(){
	if [ $? -ne 0 ]; then
   	  handle_error "$1"
    fi  
 }