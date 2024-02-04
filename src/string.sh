#!/bin/bash

# text.randize(array) ~ obj
# Gives you random object of array.
# 
# Args:
# - array (array): takes array of objects.
text.randize(){
  local array=("$@");
  echo "${array[$(( RANDOM % ${#array[@]} ))]}";
}

# text.isdigit(str) ~ bool
# Checks string is digit or not.
# 
# Args:
# - str (str): takes string as arg.
text.isdigit(){
  [[ "${1}" =~ ^[[:digit:]]+$ ]];
}

# text.replace(str,old,neu) ~ str
# This replace string to string.
# 
# Args:
# - str (str): takes string as arg.
# - old (str): takes string to replace.
# - neu (str): takes string to replace with.
text.replace(){
  local String="${1}";
  local lastString="${2}";
  local toString="${3}";
  # checking args given or not.
  if [[ ! ${#} -eq 3 ]]; then
      echo "error: 'missing args'";
      return 1;
  fi
  echo "${String/${lastString}/"${toString}"}";
}

# text.len(str) ~ int
# Gives you lenth of given string.
text.len(){
  echo "${#1}";
}

# text.len.strip(str) ~ int
# Gives you count of lines in given string.
# 
# Args:
# - str (str): takes string as arg.
text.len.strip(){
  echo "${@}" | wc -l
}

# text.startwith(str,startstr) ~ bool
# Checks that string startswith given substring or not.
# 
# Args:
# - str (str): takes string as arg.
# - startstr (str): takes substring as arg.
text.startwith(){
  [[ "${1}" == "${2}"* ]];
}

# text.startwith(str,endstr) ~ bool
# Checks that string endswith given substring or not.
# 
# Args:
# - str (str): takes string as arg.
# - endstr (str): takes substring as arg.
text.endswith(){
  [[ "${1}" == *"${2}" ]];
}

# text.contains(str,contain) ~ bool
# Checks that string contains substring or not.
# 
# Args:
# - str (str): takes string as arg.
# - contain (str): takes charachter.
text.contains(){
  [[ "${1}" == *"${2}"* ]];
}

# text.charCount(str,char) ~ int
# Gives you count of a given character in given string.
# 
# Args:
# - str (str): takes string as arg.
# - char (char): takes charachter.
text.charCount(){
  echo "${1}" | tr -cd "${2}" | wc -c
}

# text.replace_charAt(str,pos,char) ~ str
# Replace character of a string at given pos.
# 
# Args:
# - str (str): takes string as arg.
# - pos (int): takes position.
# - char (char): takes charachter.
text.replace_charAt(){
  # checking args given or not.
  [[ ${#} -eq 3 ]] ||
  { echo "error: 'missing args'" && return 1; };
  local String="${1}";
  local Pos="${2}";
  local Char="${3}";
  # Substring before the pos.
  local PreString="${String:0:Pos-1}";
  # Substring after the pos.
  local PostString="${String:Pos}";
  # Concatenate substrings with replace character.
  echo "${PreString}${Char}${PostString}";
}
