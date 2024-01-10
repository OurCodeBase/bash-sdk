#!/bin/bash

# Shorts:
#   spinner.start(use,subject)
#   run your functions.
#   spinner.stop

# Colors
if (( 2>1 )); then
Clear="\033[0m";
Blue="\033[1;34m";
Genta="\033[1;35m";
Green="\033[1;32m";
Red="\033[1;31m";
Yelo="\033[1;33m";
fi

# Global Variables
if (( 2>1 )); then
icon="● ";
success="SUCCESS";
error="FAILED";
list=(
  "${Blue}${icon}${Green}${icon}${Yelo}${icon}${Red}${icon}${Genta}${icon}    "
  " ${Green}${icon}${Yelo}${icon}${Red}${icon}${Genta}${icon}${Blue}${icon}   "
  "  ${Red}${icon}${Genta}${icon}${Yelo}${icon}${Blue}${icon}${Green}${icon}  "
  "   ${Genta}${icon}${Blue}${icon}${Green}${Yelo}${icon}${icon}${Red}${icon} "
  "    ${Blue}${icon}${Green}${icon}${Red}${icon}${Yelo}${icon}${Genta}${icon}"
)
fi

# spinner.setCursor(on~off)
#   Switch terminal cursor easily.
spinner.setCursor(){
  setterm -cursor "${1}";
}

_spinner(){
    case $1 in
    start ) 
      let cols=$(echo $COLUMNS)-${#2}-8
      printf "%${cols}s"
      while true; do
        for i in {0..4}; do
          printf "\b\r\033[2K${Clear}${2} ${list[i]}"
          sleep 0.12
        done
        for i in {4..0}; do
          printf "\b\r\033[2K${Clear}${2} ${list[i]}"
          sleep 0.12
        done
      done
    ;;
    stop ) 
      if [[ -z ${3} ]]; then
       echo "error: spinner isn't running."
       exit 1
     fi
     kill ${3} > /dev/null 2>&1
     echo -en "\b${Clear}  -> ["
     if [[ $2 -eq 0 ]]; then
       echo -en " ${Green}${success}${Clear} "
     else
       echo -en " ${Red}${error}${Clear} "
       exit 1;
     fi
     echo -e "${Clear}]"
    ;;
    *) 
      echo "error: invalid args, try again with {start/stop}"
      exit 1
    ;;
  esac  
}

# spinner.start(use,subject)
#   Starts spinner to spin.
# Args:
#   use (str) > takes process (eg: installing, processing).
#   subject (str) > takes subject (eg: file, function).
# Means:
#   (use, subject) > (Processing 'Sleep')
spinner.start(){
  if [[ ! ${#} -eq 2 ]]; then
      echo "error: 'missing args'";
      return 1;
  fi
  local uri="${1} '${Green}${2}${Clear}'..."
  # required cmds.
  spinner.setCursor off
  _spinner start "${uri}" &
  _spinner_pid="${!}"
  disown
}

# spinner.stop()
#   Stops spinner to spin.
spinner.stop(){
  _spinner stop ${?} ${_spinner_pid};
  unset ${_spinner_pid};
  spinner.setCursor on
}
