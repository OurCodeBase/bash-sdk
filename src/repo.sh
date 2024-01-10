#!/bin/bash

if (( 1<2 )); then
# dir of current file.
Dir="$(dirname "${BASH_SOURCE[0]}")";
fi

source "${Dir}"/spinner.sh
source "${Dir}"/cursor.sh
source "${Dir}"/inspect.sh
source "${Dir}"/ask.sh

# source spinner.sh
# source cursor.sh
# source inspect.sh
# source ask.sh

# repo.size(api) -> str
#   Used to get size of a repo.
# Args:
#   api (str) > takes api of github repo. (eg: "OurCodeBase/bash-sdk")
# Returns:
#   size (int) > gives you file size in MB. (eg: 30 MB)
repo.size(){
  # checking curl is installed or not.
  inspect.is_func curl;
  local Api="$(echo "${1}" | awk '{print $1}')";
  local UriSize=$(curl "https://api.github.com/repos/${Api}" 2> /dev/null | grep size | head -1 | tr -dc '[:digit:]');
  local UriSize=$(( UriSize/1024 ));
  echo "${UriSize} MB";
  return;
}

# repo.chart(apis)
#   Used to view info of given repositories.
# Args:
#   apis (array) > takes array of repository api.
repo.chart(){
  echo;
  inspect.ScreenSize 81 38;
  local ARGs=("${@}");
  setCursor off;
  say.success "📦 Getting Information Repository";
  echo -e "
    ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
    ┃                         INFORMATION REPOSITORY                     ┃ 
    ┣━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┫
    ┃      REPOSITORY NAME                          REPOSITORY SIZE      ┃
    ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛";
  for ARG in "${ARGs[@]}"
  do
    local Api="$(echo "${ARG}" | awk '{print $1}')";
    local UriSize="$(repo.size "${ARG}" | awk '{print $1}')";
    printf  "    ┃      ${Green}%-36s${Clear}       ${Yelo}%8s${Clear}           ┃\n" "${Api}" "${UriSize}";
    echo -e "    ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛";
  done
  echo;
  setCursor on;
  return;
}

# repo.clone(apis,*dirs)
#   Used to start cloning of a repository.
# Args:
#   apis (array) > takes apis of github repo. (eg: OurCodeBase/bash-sdk)
#   dirs (array) > Optional: You can give directory path to clone to it.
repo.clone(){
  # required to run.
  inspect.is_func git;
  # function starts here
  local ARGs=("${@}");
  # printing chart.
  repo.chart "${ARGs[@]}";
  # required permission.
  if ask.case "Cloning Repository"; then
    for ARG in "${ARGs[@]}"
    do
      local Api="$(echo "${ARG}" | awk '{print $1}')";
      local Uri="$(echo "${ARG}" | awk '{print $2}')"; # Uri=Path
      local Url="https://github.com/${Api}.git";
      # spinner started.
      spinner.start "Cloning" "${Api}";
      # started cloning.
      [[ -z "${Uri}" ]] && 
      git clone --depth=1 "${Url}" 2> /dev/null ||
      git clone --depth=1 "${Url}" "${Uri}" 2> /dev/null;
      # stopped spinner.
      spinner.stop;
    done
    echo;
  fi
  return;
}
