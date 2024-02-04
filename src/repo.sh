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

# repo.size(api) ~ int
# Used to get size of a repo.
# 
# Args:
# - api (str): takes api of github repo. (eg: "OurCodeBase/bash-sdk")
# 
# Returns:
# - size (int): gives you file size in MiB. (eg: 30)
repo.size(){
  inspect.is_func 'curl';
  local Api="$(echo "${1}" | awk '{print $1}')";
  local ApiSize=$(curl "https://api.github.com/repos/${Api}" 2> /dev/null | grep size | head -1 | tr -dc '[:digit:]');
  echo $(( ApiSize/1024 ));
}

# repo.chart(apis)
# Used to view info of given repositories.
# 
# Args:
# - apis (array): takes array of repository api.
repo.chart(){
  inspect.ScreenSize '50' '12';
  local ARGs=("${@}");
  local PuraSize=0;
  setCursor off;
    echo -e "
  ╭─ Clone ──────────────────────────────────────╮";
    echo -e "  │                                              │";
    printf "  │  %-34s %-7s  │\n" 'Repository' 'Size';
    printf "  │  %-34s %-7s  │\n" '──────────────────────────────────' '───────';
  for ARG in "${ARGs[@]}"
  do
    local Api="$(echo "${ARG}" | awk '{print $1}')";
    local ApiSize="$(repo.size "${ARG}")";
      printf "  │  ${Green}%-34s${Clear} ${Yelo}%3s${Clear} %-3s  │\n" "${Api}" "${ApiSize}" 'MiB';
    local PuraSize=$(( PuraSize+ApiSize ));
  done
    echo -e "  │                                              │";
    echo -e "  ╰──────────────────────────────────────────────╯\n";
    echo -e "  ╭─ TOTAL ────────────────────╮";
  printf "  │  %14s: ${Green}%4s${Clear} %3s  │\n" "Cloning Size" "${PuraSize}" 'MiB';
  echo -e "  ╰────────────────────────────╯";
  setCursor on;
  return 0;
}

# repo.clone(apis,@dirs)
# Used to start cloning of a repository.
# 
# Args:
# - apis (array): takes apis of github repo. (eg: OurCodeBase/bash-sdk)
# - dirs (array,optional): You can give directory path to clone to it.
repo.clone(){
  # required to run.
  inspect.is_func 'git';
  # function starts here
  local ARGs=("${@}");
  # printing chart.
  repo.chart "${ARGs[@]}";
  # required permission.
  if ask.case "Cloning Repository"; then
    for ARG in "${ARGs[@]}"
    do
      local Api="$(echo "${ARG}" | awk '{print $1}')";
      local ApiPath="$(echo "${ARG}" | awk '{print $2}')";
      local Url="https://github.com/${Api}.git";
      # spinner started.
      spinner.start "Cloning" "${Api}";
      # started cloning.
      [[ -z "${ApiPath}" ]] && 
      git clone --depth=1 "${Url}" 2> /dev/null ||
      git clone --depth=1 "${Url}" "${ApiPath}" 2> /dev/null;
      # stopped spinner.
      spinner.stop;
    done
    echo;
  fi
  return;
}
