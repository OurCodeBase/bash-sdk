#!/bin/bash

Clear="\033[0m";
# Suppressed Variables
if (( 1<2 )); then
# Colors
Gora="\033[1;97m"
# BG Colors.
BGRed="\033[1;41m";
BGGreen="\033[1;42m";
BGYelo="\033[1;43m";
# Status Colors.
StatusRed="${BGRed}${Gora}";
StatusGreen="${BGGreen}${Gora}";
StatusYelo="${BGYelo}${Gora}";
# Global variables.
Source="'([^']*)'";
fi

# Colors
Red="\033[1;31m";
Green="\033[1;32m";
Yelo="\033[1;33m";

# say.gencolor()
#   Gives you a random color code.
say.gencolor(){
  local STRIP=(
    "\033[1;31m"
    "\033[1;32m"
    "\033[1;33m"
    "\033[1;34m"
    "\033[1;35m"
    "\033[1;36m"
  );
  echo "${STRIP[$(( RANDOM % ${#STRIP[@]} ))]}";
  return 0;
}

# say(str) -> str
#   Say strings with syntax highlighting feature.
say(){
  local String="${1}";
  local STRIP=(${String});
  local String='';
  for Uri in "${STRIP[@]}"
  do
    if [[ "${Uri}" =~ ${Source} ]]; then
      local Color="$(say.gencolor)";
      local String+="${Color}${Uri}${Clear} ";
    else local String+="${Uri} ";
    fi
  done
  echo -e "${String}";
  return 0;
}

_status(){
  case "${1}" in
    -error) 
      local Color="\033[1;31m";
      local StatusColor="${StatusRed}";
      ;;
    -success) 
      local Color="\033[1;32m";
      local StatusColor="${StatusGreen}";
      ;;
    -warn) 
      local Color="\033[1;33m";
      local StatusColor="${StatusYelo}";
      ;;
  esac
  local String="${2}";
  local xSTRIP=(${String});
  local String='';
  for Uri in "${xSTRIP[@]}"
  do
    if [[ "${Uri}" =~ ${Source} ]]; then
      local String+="${Color}${Uri}${Clear} ";
    else local String+="${Uri} ";
    fi
  done
  echo -e "${StatusColor} INFO ${Clear} ➙ ${String}";
  return 0;
}

# say.error(str) -> str
#   Says error to terminal.
say.error(){
  _status -error "${@}";
}

# say.warn(str) -> str
#   Says warning to terminal.
say.warn(){
  _status -warn "${@}";
}

# say.success(str) -> str
#   Says success to terminal.
say.success(){
  _status -success "${@}";
}

# say.checkStatus(status) -> str
#   This prints success or failure according to exit code.
# Args:
#   status (int) > takes exit code.
say.checkStatus(){
  if [[ "${1}" == 0 ]]; then
    echo -e " ➙ ${StatusGreen} SUCCESS ${Clear}";
  else
    echo -e " ➙ ${StatusRed} FAILED ${Clear}";
    exit 1;
  fi
}
