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

# url.contentSize(url) -> int
#   Gives you size of content file in MBs.
# Args:
#   url (str) > takes url as string.
# Returns:
#   size (int) > size in MBs (eg: 60).
url.contentSize(){
  # checking required functions.
  inspect.is_func 'wget';
  local contentSizeVar="$(wget --spider "${1}" --no-check-certificate 2>&1)";
  local contentSize="$(echo "${contentSizeVar}" | grep -i length: | awk '{print $2}')";
  echo "$(( contentSize/1048576 ))";
}

# url.contentChart(urls,*paths)
#   This is used to chart urls and size.
# Args:
#   urls (array) > takes one or array of urls.
#   paths (array) > Optional: takes file paths.
url.contentChart(){
  inspect.ScreenSize '81' '38';
  # taking urls and content path.
  local ARGs=("${@}")
  # size of all contents.
  local PuraSize=0;
  # turning off cursor of terminal.
  setCursor off;
  echo;
  say.success "📦 Getting Information Urls";
  echo -e "
    ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
    ┃                           INFORMATION FILES                        ┃ 
    ┣━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┫
    ┃            FILE NAME                          FILE SIZE            ┃
    ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛";
  for ARG in "${ARGs[@]}"
  do
    # url of content.
    local ContentUrl="$(echo "${ARG}" | awk '{print $1}')";
    # path of content.
    local ContentPath="$(echo "${ARG}" | awk '{print $2}')";
    # check if path is provided.
    [[ -z "${Path}" ]] &&
    local ContentVar="$(echo "${ContentUrl}" | awk -F/ '{print $NF}')" ||
    local ContentVar="$(echo "${ContentPath}" | awk -F/ '{print $NF}')";
    # taking content size of url.
    local ContentSize="$(url.contentSize "${ContentUrl}")";
      printf  "    ┃      ${Green}%-36s${Clear}       ${Yelo}%8s${Clear}           ┃\n" "${ContentVar}" "${ContentSize} MB";
      echo -e "    ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛";
    # add all size of contents.
    local PuraSize=$(( PuraSize+ContentSize ))
  done
  # print total content size.
    printf    "    ┃     [ ${Yelo}%5s${Clear} ]  ─────────────────────────────>    ${Green}%7s${Clear} %-2s        ┃" "TOTAL" "${PuraSize} MB";
    echo -e "\n    ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛";
  setCursor on;
}

# url.getContent(urls,*paths)
#   This is used to get files via urls.
# Args:
#   urls (array) > takes one or array of url.
#   paths (array) > Optional: takes files path.
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
