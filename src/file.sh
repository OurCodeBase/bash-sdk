#!/bin/bash

# path.isdir(dir) -> bool
#   Checks that directory exist or not.
# Args:
#   dir (str) > takes directory path.
path.isdir(){
  # checking dir exist or not.
  test -d "${1}";
}

# path.isfile(file) -> bool
#   Checks that file exist or not.
# Args:
#   file (str) > takes file path.
path.isfile(){
  # checking file exist or not.
  test -f "${1}";
}

# file.move(src,dst)
#   This can use to move files.
# Args:
#   src (str) > takes source path.
#   dst (str) > takes destination path.
file.move(){
  # moving file to destination.
  mv -f "${1}" "${2}" 2>/dev/null;
}

# file.copy(src,dst)
#   This can use to copy files.
# Args:
#   src (str) > takes source path.
#   dst (str) > takes destination path.
file.copy(){
  # copying files to destination.
  cp -rf "${1}" "${2}" 2>/dev/null;
}

# file.erase(file)
# Args:
#   file (str) > takes file path.
file.erase(){
  # cleaning file.
  truncate -s 0 "${1}";
}

# file.pop(pos,file)
#   Popout given position of line in file.
# Args:
#   pos (int) > takes position.
#   file (str) > takes file path.
file.pop(){
  # return final result.
  sed -i "${1}d" "${2}";
}

# file.readlines.int(file) -> int
#   Gives you total lines of a file.
# Args:
#   file (str) > takes file path.
file.readlines.int(){
  # return final result.
  wc -l "${1}" | awk '{print $1}';
}

# file.readline(pos,file) -> str
#   Gives you line from given position of file.
# Args:
#   pos (int) > takes position.
#   file (str) > takes file path.
file.readline(){
  # return final result.
  sed -n "${1}p" "${2}";
}

# file.readlines(file) -> STRIP.
#   Gives you STRIP array of lines of given file.
# Args:
#   file (str) > takes file path.
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

# file.readline.tall(file) -> str
#   Gives you largest line of file.
# Args:
#   file (str) > takes file path.
file.readline.tall(){
  # return final result.
  awk 'length > max_length { max_length = length; max_line = $0 } END { print max_line }' "${1}";
}

# file.replace.pos(str,pos,file)
#   This replace text from given line of file.
# Args:
#   str (str) > takes string to replace.
#   pos (int) > takes position.
#   file (str) > takes file path.
file.replace.pos(){
  # return final result.
  sed -i "${2}c\\${1}" "${3}";
}

# file.search(str,file) -> str
#   Search given text in file & return you that line.
# Args:
#   str (str) > takes string to search.
#   file (str) > takes file path.
file.search(){
  # return final result.
  grep "${1}" "${2}";
}

# file.search.pos(str,file) -> pos
#   Search given text in file & return you position (eg: 1,2).
# Args:
#   str (str) > takes string to search.
#   file (str) > takes file path.
file.search.pos(){
  # return final result.
  grep -n "${1}" "${2}" | cut -d: -f1 | head -n 1;
}

# path.dirArray(dir,*options) -> STRIP.
#   Gives you array of files in given directory.
# Args:
#   dir (str) > takes directory path.
#   --by-time (obj) > Optional: list will be sorted by time.
#   --no-extension (obj) > Optional: list have no file extensions.
path.dirArray(){
  # taking directory arg from user.
  local ARGDir=${1} && shift;
  # array list file location.
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
#   This appends text to file horizontally.
# Args:
#   str (str) > takes string to append it.
#   pos (int) > takes position.
#   file (str) > takes file path.
file.append.hori(){
  # takes string as arg.
  local String="${1}";
  # takes position as arg.
  local Pos="${2}";
  # takes file as arg.
  local ARGFile="${3}";
  # checking args given or not.
  [[ ${#} -eq 3 ]] ||
  { echo "error: 'missing args'" && return 1; };
  # reading line from given position.
  local Vir="$(file.readline "${Pos}" "${ARGFile}")";
  # concating string to it.
  local Vir+="${String}";
  # replacing the line from file.
  file.replace.pos "${Vir}" "${Pos}" "${ARGFile}";
  # return function.
  return;
}

# file.append.vert(str,pos,file)
#   This appends text to file vertically.
# Args:
#   str (str) > takes string to append it.
#   pos (int) > takes position.
#   file (str) > takes file path.
file.append.vert(){
  # takes text as arg.
  local String="${1}";
  # takes position as arg & have to reduce one.
  local Pos="${2}";
  # takes file as arg.
  local ARGFile="${3}";
  # checking args given or not.
  [[ ${#} -eq 3 ]] ||
  { echo "error: 'missing args'" && return 1; };
  # reduce one from variable.
  local Pos="$(( Pos - 1 ))";
  # do operation.
  sed -i "${Pos}r /dev/stdin" "${ARGFile}" <<< "${String}";
  # return function.
  return;
}
