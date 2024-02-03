#!/bin/bash

if (( 1<2 )); then
# dir of current file.
Dir="$(dirname "${BASH_SOURCE[0]}")";
fi

source "${Dir}"/os.sh
source "${Dir}"/say.sh
source "${Dir}"/string.sh

# source os.sh
# source say.sh
# source string.sh

# Stores object that you selected.
askObject='';
# Stores position of object that you selected.
askPosition='';

# ask.case(title) ~ bool
# This takes case ( yes or no ) for any work.
#
# ARGS:
# - title (str): takes title (eg: You're Agree).
ask.case(){
  echo -ne "\n    ${1}";
  read -p " ? [Y/n] " ARGS;
  echo;
  case "${ARGS}" in
    y|Y|'') 
      return 0;
    ;;
    n|N) 
      say.error "Process Aborted.\n";
      exit 1;
    ;;
    *) say.error "You have to enter only \n
      \t\t 'Y' for Yes & \n
      \t\t 'n' for No.\n";
      exit 1;
    ;;
  esac
}

# ask.choice(title,list) ~ var
# This creates a simple menu.
# 
# ARGS:
# - title (str): takes title (eg: Choose One).
# - list (array): takes array as arg.
#
# RETURNS:
# - var (str): result in 'askObject' & 'askPosition' variables.
ask.choice(){
  PS3="
  ${1}: ";
  shift;
  local ARGs=("${@}");
  echo;
  select ARG in "${ARGs[@]}"
  do
    if text.isdigit "${REPLY}"; then
      say.error "You can only input 'digits'.\n";
      exit 1;
    elif [[ "${REPLY}" -gt "${#ARGs[@]}" ]]; then
      say.error "You should input correct digits.\n";
      exit 1;
    else
      askObject="${ARG}";
      askPosition="${REPLY}";
      break;
    fi
  done
}
