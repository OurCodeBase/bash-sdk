#!/bin/bash

Clear="\033[0m";
# Suppressed Variables
if (( 1<2 )); then
# ----------
# Colors.
# Gora="\033[0;97m"
# ----------
# BG Colors.
# BGRed="\033[1;41m";
# BGGreen="\033[1;42m";
# BGYelo="\033[1;43m";
# BGBold="\033[1m";
# ----------
# Status Colors.
# StatusRed="${BGRed}${Gora}";
# StatusGreen="${BGGreen}${Gora}";
# StatusYelo="${BGYelo}${Gora}";
# ----------
# Global variables.
Pattern="'([^']*)'";
# Color plate.
COLOR_STRIP=(
  "\033[0;31m" # Red
  "\033[0;32m" # Green
  "\033[0;33m" # Yelo
  "\033[0;34m" # Blue
  "\033[0;35m" # Genta
  "\033[0;36m" # Cyan
);
fi

# say.gencolor() ~ color
# Generates color codes for you.
say.gencolor(){
  echo "${COLOR_STRIP[$(( RANDOM % ${#COLOR_STRIP[@]} ))]}";
}

# _say.colorizeString(str,@--gencolor,@--color <color>) ~ str
# Create and returns you raw colorized strings.
# 
# ARGS:
# - str (str): takes string as arg.
# - --gencolor (obj,optional): adds colors randomly to syntax.
# - --color <color> (str,optional): adds given color to syntax.
_say.colorizeString(){
  local ARGString="${1}";
  local isGenColorEnabled=1;
  local Sentence=(${ARGString});
  local String;
  shift;
  case "${1}" in
    --gencolor) 
      local isGenColorEnabled=0;
    ;;
    --color) 
      local Color="${2}";
    ;;
  esac
  for Shabd in "${Sentence[@]}"
  do
    if [[ "${Shabd}" =~ ${Pattern} ]]; then
      [[ "${isGenColorEnabled}" == 1 ]] || \
      local Color="$(say.gencolor)";
      local String+="${Color}${Shabd}${Clear} ";
    else
      local String+="${Shabd} ";
    fi
  done
  echo "${String}";
}

# say(str) ~ str
# Say strings with syntax highlighting feature.
say(){
  local String="$(_say.colorizeString "${1}" --gencolor)";
  echo -e "${String}";
}

_status(){
  case "${1}" in
    -error) 
      local Color="\033[0;31m";
      local Header="ERR";
    ;;
    -warn) 
      local Color="\033[0;33m";
      local Header="WARN";
    ;;
    -success) 
      local Color="\033[0;32m";
      local Header="INFO";
    ;;
  esac
  local String="$(_say.colorizeString "${2}" --color "${Color}")";
  echo -ne "[${Color} ${Header} ${Clear}]: ";
  echo -e "${String}";
}

# say.error(str) ~ str
# Says error to terminal.
say.error(){
  _status -error "${@}";
}

# say.warn(str) ~ str
# Says warning to terminal.
say.warn(){
  _status -warn "${@}";
}

# say.success(str) ~ str
# Says success to terminal.
say.success(){
  _status -success "${@}";
}

# say.checkStatus(exitCode) ~ str
# This prints success or failure according to exit code.
# 
# ARGS:
# - exitCode (int): takes exit code.
say.checkStatus(){
  if [[ "${1}" == 0 ]]; then
    echo -e " ~ [${COLOR_STRIP[1]} SUCCESS ${Clear}]";
  else
    echo -e " ~ [${COLOR_STRIP[0]} FAILED ${Clear}]";
    exit 1;
  fi
}