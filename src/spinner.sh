#!/bin/bash

# Shorts:
#   spinner.start(use,subject)
#   run your functions.
#   spinner.stop

# Suppressed Variables
if (( 1<2 )); then
# Colors
Clear="\033[0m";
Blue="\033[1;34m";
Genta="\033[1;35m";
Green="\033[1;32m";
Red="\033[1;31m";
Yelo="\033[1;33m";
Gora="\033[1;97m"
# BG Colors.
BGRed="\033[1;41m";
BGGreen="\033[1;42m";
BGYelo="\033[1;43m";
# Status Colors.
StatusRed="${BGRed}${Gora}";
StatusGreen="${BGGreen}${Gora}";
StatusYelo="${BGYelo}${Gora}";
CircleIcon="● ";
Success="SUCCESS";
Failure="FAILED";
Scribe=(
  "${Blue}${CircleIcon}${Green}${CircleIcon}${Yelo}${CircleIcon}${Red}${CircleIcon}${Genta}${CircleIcon}    "
  " ${Green}${CircleIcon}${Yelo}${CircleIcon}${Red}${CircleIcon}${Genta}${CircleIcon}${Blue}${CircleIcon}   "
  "  ${Red}${CircleIcon}${Genta}${CircleIcon}${Yelo}${CircleIcon}${Blue}${CircleIcon}${Green}${CircleIcon}  "
  "   ${Genta}${CircleIcon}${Blue}${CircleIcon}${Green}${Yelo}${CircleIcon}${CircleIcon}${Red}${CircleIcon} "
  "    ${Blue}${CircleIcon}${Green}${CircleIcon}${Red}${CircleIcon}${Yelo}${CircleIcon}${Genta}${CircleIcon}"
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
      let Cols=$(echo $COLUMNS)-${#2}-8
      printf "%${Cols}s"
      while true; do
        for i in {0..4}; do
          printf "\b\r\033[2K${Clear}${2} ${Scribe[i]}"
          sleep 0.12
        done
        for i in {4..0}; do
          printf "\b\r\033[2K${Clear}${2} ${Scribe[i]}"
          sleep 0.12
        done
      done
    ;;
    stop ) 
      [[ -z ${3} ]] && {
      echo "error: spinner isn't running." &&
      exit 1;
      };
     kill ${3} > /dev/null 2>&1
     echo -en "\b${Clear} ➙ ";
     [[ $2 -eq 0 ]] &&
       echo -e "${StatusGreen} ${Success} ${Clear}" || {
       echo -e "${StatusRed} ${Failure} ${Clear}" &&
       exit 1;
      };
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
  [[ ${#} -eq 2 ]] ||
  { echo "error: 'missing args'" && return 1; };
  local UseCase="${1} '${Green}${2}${Clear}'..."
  spinner.setCursor off
  _spinner start "${UseCase}" &
  _SpinnerPid="${!}"
  disown
}

# spinner.stop()
#   Stops spinner to spin.
spinner.stop(){
  _spinner stop ${?} ${_SpinnerPid};
  unset ${_SpinnerPid};
  spinner.setCursor on
}