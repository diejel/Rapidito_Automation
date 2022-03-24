#!/bin/bash
JQ=${CPDIR}/jq/jq
caseid_already_input=false
source ./config/init.rap
for f in ./functions/* ; do source $f ; done

show_banner(){

# Bash Menu Script Example
banner=`cat <<EOF
******************************************************************************
*          ___              _____    _____   ___       _   _   _             *
*         |  _|     /\     |  __ \  |_   _| |_  |     | | (_) | |            *
*   _ __  | |      /  \    | |__) |   | |     | |   __| |  _  | |_    ___    *
*  |  __| | |     / /\ \   |  ___/    | |     | |  / _  | | | | __|  / _ \   *
*  | |    | |    / ____ \  | |       _| |_    | | | (_| | | | | |_  | (_) |  *
*  |_|    | |_  /_/    \_\ |_|      |_____|  _| |  \__ _| |_| \\__|   \\___/   *
*         |___|                             |___|                            *
*                                                                            *
*	                          (v2.0) - 16/03/2022                        *
*                                                                            *
******************************************************************************
r[API]dito is an iniatitive software for contributing to automation CheckPoint 
tasks. Its based on the API Management Tool.

%%%%%%%%%%% To clear input text : CTRL + Backspace %%%%%%%%%%%%%%%%%%%

Any Doubts and suggestions: dcubazuniga@gmail.com
                 [ IP SMS TARGET : $ip_sms ]
-----------------------------------------------------------------------------
EOF
`
echo "${banner}"
}
    
clear
show_banner
menu_show