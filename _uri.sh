#!/bin/bash

source ./src/say.sh
source ./src/file.sh
source ./src/string.sh

# contains module array that are added to result.
_usedModuleArray=();

# _uri.isfile(file) -> bool
#   An extention of path.isfile.
# Args:
#   file (str) > takes file path.
_uri.isfile(){
  # checking.
  if path.isfile "${1}"; then
    return 0;
  else
    say.error "There is no such '${1}' file.";
    exit 1;
  fi
}

# _uri.hasSource(file) -> bool
#   Checks that source exists in the code or not.
# Args:
#   file (str) > takes file path.
_uri.hasSource(){
  # checking that.
  grep -n '^source.*\.sh$' "${1}" &> /dev/null || 
  # taking user file arg.
  #_uri.isfile "${1}";
  exit 0;
}

# _uri.hasModuleAlready(module) -> bool
#   Tells you that module is already added or not.
# Args:
#   module (str) > takes module as arg (eg: ./src/ask.sh).
_uri.hasModuleAlready(){
  [[ "${_usedModuleArray[*]}" == *"${1}"* ]]
}

# _uri.moduleVar(path) -> str
#   Gives you variable of module.
# Args:
#   path (str) > takes module path.
_uri.moduleVar(){
  echo "${1}" | awk -F/ '{print $NF}' | awk -F. '{print $1}'
}

# _uri.chotuCode(file)
#   This returns you only required code from file.
# Args:
#   file (str) > takes file path.
_uri.chotuCode(){
  # let us return code.
  grep -vE "^\s*#|^\s*$" "${1}" 2> /dev/null || 
  # checking file exist or not if any errors.
  _uri.isfile "${1}";
}

# _uri.startSourceStrip(file) -> str
#   Gives you first sourced script path.
# Args:
#   file (str) > takes file path.
# Returns:
#   path (str) > This returns you first sourced script path (eg: ./src/say.sh).
_uri.startSourceStrip(){
  # taking file arg from user.
  local ARGFile="${1}";
  local Dir="./src";
  local SourceStrip="$(grep -n '^source.*\.sh$' "${ARGFile}" | awk '{print $2}' | head -n 1)";
  # grep -n "pattern" returns all source line no.s and lines also (seprated by :)
  # cut -d: -f1 cuts every line within : and provides us only first key using f1.
  # head -n 1 provides us only first line of no.
  # assign module variable.
  if text.startwith "${SourceStrip}" '"${Dir}"' || text.startwith "${SourceStrip}" '${Dir}'; then
    local SourceModule="${Dir}/$(echo "${SourceStrip}" | awk -F/ '{print $NF}')";
  else
    local SourceModule="${SourceStrip}";
  fi
  # checking file exist or not.
  _uri.isfile "${SourceModule}" &&
  # let us return path.
  echo "${SourceModule}";
  return 0;
}

# _uri.startSourceStrip.pos(file) -> int
#   Gives you first source position path of file.
# Args:
#   file (str) > takes file path.
# Returns:
#   pos (int) > returns you first source position.
_uri.startSourceStrip.pos(){
  # taking file arg from user.
  local ARGFile="${1}";
  grep -n '^source.*\.sh$' "${ARGFile}" | cut -d: -f1 | head -n 1 ||
  _uri.isfile "${ARGFile}";
  # grep -n "pattern" returns all source line no.s and lines also (seprated by :)
  # cut -d: -f1 cuts every line within : and provides us only first key using f1.
  # head -n 1 provides us only first line of no.
}

# _uri.addModuleSource(module,file)
#   Adds module to given file.
# Args:
#   module (str) > takes module path.
#   file (str) > takes file path.
_uri.addModuleSource(){
  # taking file arg from user.
  local ARGModule="${1}";
  # taking result file arg from user.
  local ARGResultFile="${2}";
  # convert module path to module only.
  local ARGModuleVar="$(_uri.moduleVar "${ARGModule}")";
  # checking that module already added or not. if added this returns from function.
  _uri.hasModuleAlready "${ARGModuleVar}" && return 0;
  # checking catogories.
  if [[ "${PRIMARY_MODULES[*]}" == *"${ARGModuleVar}"* ]]; then
    # position of catogory hash.
    local PosMap="$(file.search.int "#@PRIMARY_MODULES" "${ARGResultFile}")";
  elif [[ "${SECONDARY_MODULES[*]}" == *"${ARGModuleVar}"* ]]; then
    # position of catogory hash.
    local PosMap="$(file.search.int "#@SECONDARY_MODULES" "${ARGResultFile}")";
  elif [[ "${TERTIARY_MODULES[*]}" == *"${ARGModuleVar}"* ]]; then
    # position of catogory hash.
    local PosMap="$(file.search.int "#@TERTIARY_MODULES" "${ARGResultFile}")";
  else
    # position of catogory hash.
    local PosMap="$(file.search.int "#@OTHER_MODULES" "${ARGResultFile}")";
  fi
  # installing module.
  file.append.vert "$(_uri.chotuCode "${ARGModule}")" "$(( PosMap+1 ))" "${ARGResultFile}" &&
  # adding to array.
  _usedModuleArray+=("${ARGModuleVar}") &&
  say.success "Module: '${ARGModuleVar}' is added." &&
  # return function.
  return 0;
}
