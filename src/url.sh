#!/bin/bash

if (( 1<2 )); then
# dir of current file.
Dir="$(dirname "${BASH_SOURCE[0]}")";
fi

source "${Dir}"/ask.sh
source "${Dir}"/say.sh
source "${Dir}"/cursor.sh
source "${Dir}"/spinner.sh
source "${Dir}"/inspect.sh

# source ask.sh
# source say.sh
# source cursor.sh
# source spinner.sh
# source inspect.sh

# url.contentSize(url) ~ int
# Gives you size of content file in MiB.
# 
# ARGS:
# - url (str): takes url as string.
# 
# RETURNS:
# - size (int): size in MiB (eg: 60).
url.contentSize(){
  # checking required functions.
  inspect.is_func 'wget';
  local ContentSizeVar="$(wget --spider "${1}" --no-check-certificate 2>&1)";
  local ContentSize="$(echo "${ContentSizeVar}" | grep -i length: | awk '{print $2}')";
  echo "$(( ContentSize/1048576 ))";
}

# url.contentChart(urls,@paths)
# This is used to chart urls and size.
# 
# ARGS:
# - urls (array): takes one or array of urls.
# - paths (array,optional): takes file paths.
url.contentChart(){
  inspect.ScreenSize '50' '12';
  local ARGs=("${@}")
  local PuraSize=0;
  setCursor off;
    echo -e "
  ╭─ Content ────────────────────────────────────╮";
    echo -e "  │                                              │";
    printf "  │  %-34s %-7s  │\n" 'Content' 'Size';
    printf "  │  %-34s %-7s  │\n" '──────────────────────────────────' '───────';
  for ARG in "${ARGs[@]}"
  do
    local ContentUrl="$(echo "${ARG}" | awk '{print $1}')";
    local ContentPath="$(echo "${ARG}" | awk '{print $2}')";
    [[ -z "${ContentPath}" ]] &&
    local ContentVar="$(echo "${ContentUrl}" | awk -F/ '{print $NF}')" ||
    local ContentVar="$(echo "${ContentPath}" | awk -F/ '{print $NF}')";
    local ContentSize="$(url.contentSize "${ContentUrl}")";
      printf "  │  ${Green}%-34s${Clear} ${Yelo}%3s${Clear} %-3s  │\n" "${ContentVar}" "${ContentSize}" 'MiB';
    local PuraSize=$(( PuraSize+ContentSize ))
  done
    echo -e "  │                                              │";
    echo -e "  ╰──────────────────────────────────────────────╯\n";
    echo -e "  ╭─ TOTAL ────────────────────╮";
  printf "  │  %14s: ${Green}%4s${Clear} %3s  │\n" "Download Size" "${PuraSize}" 'MiB';
  echo -e "  ╰────────────────────────────╯";
  setCursor on;
  return 0;
}

# url.getContent(urls,@paths)
# This is used to get files via urls.
# 
# ARGS:
# - urls (array): takes one or array of url.
# - paths (array,optional): takes files path.
url.getContent(){
  local ARGs=("${@}")
  url.contentChart "${ARGs[@]}";
  inspect.is_func 'wget';
  # request permission.
  if ask.case 'Download Files'; then
    for ARG in "${ARGs[@]}"
    do
      local ContentUrl="$(echo "${ARG}" | awk '{print $1}')";
      local ContentPath="$(echo "${ARG}" | awk '{print $2}')";
      if [[ -z "${ContentPath}" ]]; then
      wget "${ContentUrl}" -q --show-progress --no-check-certificate
      else wget -O "${ContentPath}" "${ContentUrl}" -q --show-progress --no-check-certificate
      fi
      say.checkStatus "${?}";
    done
  fi
}
