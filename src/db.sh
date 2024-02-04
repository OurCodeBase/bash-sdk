#!/bin/bash

# Supports only yaml syntax database.

# _db.isKeyExist(key,file) ~ bool
# Checks that key is exist or not.
# 
# Args:
# - key (str): takes key of db.
# - file (str): takes file path.
_db.isKeyExist(){
  grep "${1}: " "${2}" &>/dev/null;
}

# db.read(key,file) ~ str
# Reads value of given key in db file.
# 
# Args:
# - key (str): takes key of db.
# - file (str): takes file path.
db.read(){
  # checking args given or not.
  [[ ${#} -eq 2 ]] ||
  { echo "error: 'missing args'" && return 1; };
  _db.isKeyExist "${1}" "${2}" ||
  { echo "error: ${1}: 'key not exists'" && return 1; };
  local dbValue="$(grep "${1}: " "${2}")";
  echo "${dbValue}" | awk -F': ' '{sub(/^[^:]*: /, ""); print}';
}

# db.create(key,value,file)
# Creates data key and value to db.
#  
# Args:
# - key (str): takes key of db.
# - value (str): takes value of key.
# - file (str): takes file path.
db.create(){
  # checking args given or not.
  [[ ${#} -eq 3 ]] ||
  { echo "error: 'missing args'" && return 1; };
  _db.isKeyExist "${1}" "${3}" &&
  { echo "error: ${1}: 'key already exists'" && return 1; };
  echo -ne "\n${1}: ${2}" >> "${3}";
}

# db.update(key,value,file)
# Update data of key in db file.
#  
# Args:
# - key (str): takes key of db.
# - value (str): takes update value of key.
# - file (str): takes file path.
db.update(){
  # checking args given or not.
  [[ ${#} -eq 3 ]] ||
  { echo "error: 'missing args'" && return 1; };
  _db.isKeyExist "${1}" "${3}" ||
  { echo "error: ${1}: 'key not exists'" && return 1; };
  local dbKey="${1}";
  local dbUpdateValue="${2}";
  local dbFile="${3}";
  local dbCurrentValue="$(db.read "${dbKey}" "${dbFile}")";
  local dbCurrentPair="${dbKey}: ${dbCurrentValue}"; # concated to create pair.
  local dbCurrentPairPos="$(grep -n "${dbCurrentPair}" "${dbFile}" | cut -d: -f1 | head -n 1;)";
  local dbUpdatedPair="${dbCurrentPair/${dbCurrentValue}/"${dbUpdateValue}"}";
  sed -i "${dbCurrentPairPos}c\\${dbUpdatedPair}" "${dbFile}"; # replaced full pair.
}

# db.delete(key,file)
# Delete key and value of db file.
#  
# Args:
# - key (str): takes key of db.
# - file (str): takes file path.
db.delete(){
  # checking args given or not.
  [[ ${#} -eq 2 ]] ||
  { echo "error: 'missing args'" && return 1; };
  _db.isKeyExist "${1}" "${2}" ||
  { echo "error: ${1}: 'key not exists'" && return 1; };
  local dbKey="${1}: ";
  local dbFile="${2}";
  local dbKeyPos="$(grep -n "${dbKey}" "${dbFile}" | cut -d: -f1 | head -n 1;)";
  sed -i "${dbKeyPos}d" "${dbFile}";
}
