#!/bin/bash

# Support only Yaml syntax database.

# _db.isfile(file) -> bool
#   Checks that db file exist or not.
# Args:
#   file (str) > takes file path.
_db.isfile(){
  # checking file exist or not.
  test -f "${1}";
}

# _db.iskey(key,file) -> bool
#   Checks that key is exist or not.
# Args:
#   key (str) > takes key of db.
#   file (str) > takes file path.
_db.iskey(){
  grep "${1}: " "${2}" &>/dev/null;
}

# db.read(key,file) -> str
#   Give you data of key of yaml db.
# Args:
#   key (str) > takes key of db.
#   file (str) > takes file path.
db.read(){
  # checking args given or not.
  if [[ ! ${#} -eq 2 ]]; then
    echo "error: 'missing args'";
    return 1;
  fi
  if _db.iskey "${1}" "${2}"; then
    local dbValue;
    dbValue="$(grep "${1}: " "${2}")";
    echo "${dbValue}" | awk -F': ' '{sub(/^[^:]*: /, ""); print}';
    return 0;
  else
    echo "error: ${1}: 'key not exists'";
    return 1;
  fi
}

# db.create(key,value,file)
#   Adds data key and value to db.
# Args:
#   key (str) > takes key of db.
#   value (str) > takes value of key.
#   file (str) > takes file path.
db.create(){
  # checking args given or not.
  if [[ ! ${#} -eq 3 ]]; then
    echo "error: 'missing args'";
    return 1;
  fi
  if _db.iskey "${1}" "${3}"; then
    echo "error: ${1}: 'key already exist'";
    return 1;
  else
    echo -ne "\n${1}: ${2}" >> "${3}";
    return 0;
  fi
}

# db.update(key,value,file)
#   Update data of key in db file.
# Args:
#   key (str) > takes key of db.
#   value (str) > takes update value of key.
#   file (str) > takes file path.
db.update(){
  # checking args given or not.
  if [[ ! ${#} -eq 3 ]]; then
    echo "error: 'missing args'";
    return 1;
  fi
  if _db.iskey "${1}" "${3}"; then
    # taking key arg.
    local dbKey="${1}";
    # taking update value of given key.
    local dbUpdatedValue="${2}";
    # taking db file path.
    local dbFile="${3}";
    # getting old value of given key.
    local dbValue;
    dbValue="$(db.read "${dbKey}" "${dbFile}")";
    # concating key and old value.
    local dbKeyValuePair="${dbKey}: ${dbValue}";
    # getting position of concated line in file.
    local dbKeyValuePairPos;
    dbKeyValuePairPos="$(grep -n "${dbKeyValuePair}" "${dbFile}" | cut -d: -f1 | head -n 1;)";
    # replacing value from old to new.
    local dbUpdatedKeyValuePair="${dbKeyValuePair/${dbValue}/"${dbUpdatedValue}"}";
    # placing updated value to position.
    sed -i "${dbKeyValuePairPos}c\\${dbUpdatedKeyValuePair}" "${dbFile}";
  else
    echo "error: ${1}: 'key not exists'";
    return 1;
  fi
}

# db.delete(key,file)
#   Delete key and value of db file.
# Args:
#   key (str) > takes key of db.
#   file (str) > takes file path.
db.delete(){
  # checking args given or not.
  if [[ ! ${#} -eq 2 ]]; then
    echo "error: 'missing args'";
    return 1;
  fi
  local dbKey="${1}: ";
  local dbFile="${2}";
  if _db.iskey "${1}" "${2}"; then
    local dbKeyPos;
    dbKeyPos="$(grep -n "${dbKey}" "${dbFile}" | cut -d: -f1 | head -n 1;)";
    sed -i "${dbKeyPos}d" "${dbFile}";
  else
    echo "error: ${1}: 'key not exists'";
    return 1;
  fi
}
