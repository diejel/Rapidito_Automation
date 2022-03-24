#!/bin/sh
ask_caseID(){

  if [ $caseid_already_input == false ]; then
      read -p "Which is the 'Case ID' you are attending?: " caseID
      if [ -z $caseID ]; then
         on_empty_input_print_and_exit "$caseID" "Error: The 'case ID' can be empty."
         caseid_already_input=false
      else
         caseid_already_input=true
      fi
  else
      read -p "I remember you have already typed a previous 'Case ID', would you like to use the same? [y/n] : " ans_caseID
      case $ans_caseID in
        y|Y)
              :
              ;;
        n|N)
              read -p "Which is the new 'Case ID'? : " new_caseID
              caseID=$new_caseID
              ;;
      esac
    
  fi
} 
 