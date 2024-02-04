#!/bin/bash

# path.isdir(dir) ~ bool
# Checks that directory exist or not.
# 
# ARGS:
# - dir (str): takes directory path.
path.isdir(){
  # checking dir exist or not.
  test -d "${1}";
}

# path.isfile(file) ~ bool
# Checks that file exist or not.
#  
# ARGS:
# - file (str): takes file path.
path.isfile(){
  # checking file exist or not.
  test -f "${1}";
}

# file.move(src,dst)
# This can use to move files.
#  
# ARGS:
# - src (str): takes source path.
# - dst (str): takes destination path.
file.move(){
  # moving file to destination.
  mv -f "${1}" "${2}" 2>/dev/null;
}

# file.copy(src,dst)
# This can use to copy files.
#  
# ARGS:
# - src (str): takes source path.
# - dst (str): takes destination path.
file.copy(){
  # copying files to destination.
  cp -rf "${1}" "${2}" 2>/dev/null;
}

# file.erase(file)
#
# ARGS:
# - file (str): takes file path.
file.erase(){
  # cleaning file.
  truncate -s 0 "${1}";
}

# file.pop(pos,file)
# Popout given position of line in file.
#
# ARGS:
# - pos (int): takes position.
# - file (str): takes file path.
file.pop(){
  # return final result.
  sed -i "${1}d" "${2}";
}

# file.readlines.int(file) ~ int
# Gives you total lines of a file.
#
# ARGS:
# - file (str): takes file path.
file.readlines.int(){
  # return final result.
  wc -l "${1}" | awk '{print $1}';
}

# file.readline(pos,file) ~ str
# Gives you line from given position of file.
#  
# ARGS:
# - pos (int): takes position.
# - file (str): takes file path.
file.readline(){
  # return final result.
  sed -n "${1}p" "${2}";
}

# file.readlines(file) ~ STRIP.
# Gives you STRIP array of lines of given file.
#  
# ARGS:
# - file (str): takes file path.
file.readlines(){
  # taking file arg from user.
  local ARGFile="${1}";
  # getting total count of lines of file.
  local ARGFileCount=$(file.readlines.int "${ARGFile}");
  # STRIP variable to store data.
  STRIP=();
  # loop to get all lines of file.
  for ((i = 1; i <= ARGFileCount; i++)); do
    # appending lines to STRIP variable.
    STRIP+=("$(sed -n "${i}p" "${ARGFile}")");
  done
  export STRIP;
  # return function.
  return;
}

# file.readline.tall(file) ~ str
# Gives you largest line of file.
# 
# ARGS:
# - file (str): takes file path.
file.readline.tall(){
  # return final result.
  awk 'length > max_length { max_length = length; max_line = $0 } END { print max_line }' "${1}";
}

# file.replace.pos(str,pos,file)
# This replace text from given line of file.
# 
# ARGS:
# - str (str): takes string to replace.
# - pos (int): takes position.
# - file (str): takes file path.
file.replace.pos(){
  # return final result.
  sed -i "${2}c\\${1}" "${3}";
}

# file.search(str,file) ~ str
# Search given text in file & return you that line.
# 
# ARGS:
# - str (str): takes string to search.
# - file (str): takes file path.
file.search(){
  # return final result.
  grep "${1}" "${2}";
}

# file.search.pos(str,file) ~ pos
# Search given text in file & return you position (eg: 1,2).
# 
# ARGS:
# - str (str): takes string to search.
# - file (str): takes file path.
file.search.pos(){
  # return final result.
  grep -n "${1}" "${2}" | cut -d: -f1 | head -n 1;
}

# path.dirArray(dir,@--by-time,@--no-extension) ~ STRIP.
# Gives you array of files in given directory.
#  
# ARGS:
# - dir (str): takes directory path.
# - --by-time (obj,optional): list will be sorted by time.
# - --no-extension (obj,optional): list have no file extensions.
path.dirArray(){
  local ARGDir=${1} && shift;
  local UriFile=".Uri";
  # check directory exist.
  path.isdir "${ARGDir}" && {
    # listing files to a file.
    if [[ "${*}" == *"--by-time"* ]]; then
      ls -t "${ARGDir}" > "${UriFile}";
      shift;
    else ls "${ARGDir}" > "${UriFile}";
    fi
    # no extension of requested files.
    if [[ "${*}" == *"--no-extension"* ]]; then
      local UriChotuData="$(sed 's/\(.*\)\.\(.*\)/\1/' "${UriFile}")";
      echo "${UriChotuData}" > "${UriFile}";
    fi
  } &&
  # reading data from uri file.
  file.readlines "${UriFile}" &&
  # delete that temp file.
  rm "${UriFile}" &&
  # return function.
  return 0;
}

# file.append.hori(str,pos,file)
# This appends text to file horizontally.
#
# ARGS:
# - str (str): takes string to append it.
# - pos (int): takes position.
# - file (str): takes file path.
file.append.hori(){
  # checking args given or not.
  [[ ${#} -eq 3 ]] ||
  { echo "error: 'missing args'" && return 1; };
  local String="${1}";
  local Pos="${2}";
  local ARGFile="${3}";
  local ConsVar="$(file.readline "${Pos}" "${ARGFile}")";
  local ConsVar+="${String}"; # concat
  file.replace.pos "${ConsVar}" "${Pos}" "${ARGFile}";
}

# file.append.vert(str,pos,file)
# This appends text to file vertically.
#
# ARGS:
# - str (str): takes string to append it.
# - pos (int): takes position.
# - file (str): takes file path.
file.append.vert(){
  # checking args given or not.
  [[ ${#} -eq 3 ]] ||
  { echo "error: 'missing args'" && return 1; };
  local String="${1}";
  local Pos="${2}"; # needs to reduce one.
  local ARGFile="${3}";
  local Pos="$(( Pos - 1 ))";
  sed -i "${Pos}r /dev/stdin" "${ARGFile}" <<< "${String}";
}
