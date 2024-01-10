#!/bin/bash

if (( 1<2 )); then
# dir of current file.
Dir="$(dirname "${BASH_SOURCE[0]}")";
fi

source "${Dir}"/inspect.sh
source "${Dir}"/cursor.sh
source "${Dir}"/ask.sh
source "${Dir}"/spinner.sh
source "${Dir}"/os.sh

# source inspect.sh
# source cursor.sh
# source spinner.sh
# source os.sh
# source ask.sh

# pkg.sizeDL(pkg) -> str
#   Used to get dl size of a package.
# Args:
#   pkg (str) > takes package as arg. (eg: python, nodejs)
# Returns:
#   Gives you file size in MB. (eg: 30 MB)
pkg.sizeDL(){
  # assigning database variable.
  local SizeDB="$(apt show "${1}" 2> /dev/null | grep Download-Size:)";
  # assigning size variable.
  local Size="$(echo "${SizeDB}" | awk '{print $2}')";
  # assigning SizeUnit variable.
  local SizeUnit="$(echo "${SizeDB}" | awk '{print $3}')";
  # checking unit of package.
  if [[ "${SizeUnit}" == "kB" ]]; then
    # converting decimals to integers.
    local Size="${Size%%.*}";
    # gives size in MB.
    echo "$(( Size/1024 )) MB";
  elif [[ "${SizeUnit}" == "B" ]]; then
    # converting decimals to integers.
    local Size="${Size%%.*}";
    # gives size in MB.
    echo "$(( Size/1048576 )) MB";
  else
    # converting decimals to integers.
    local Size="${Size%%.*}"
    # gives already MB packages size.
    echo "${Size} ${SizeUnit}";
  fi
  # return function.
  return;
}

# pkg.sizeIN(pkg) -> str
#   Used to get in size of a package.
# Args:
#   pkg (str) > takes package as arg. (eg: python, nodejs)
# Returns:
#   Gives you file size in MB. (eg: 30 MB)
pkg.sizeIN(){
  # assigning database variable.
  local SizeDB="$(apt show "${1}" 2> /dev/null | grep Installed-Size:)";
  # assigning size variable.
  local Size="$(echo "${SizeDB}" | awk '{print $2}')";
  # assigning SizeUnit variable.
  local SizeUnit="$(echo "${SizeDB}" | awk '{print $3}')";
  # checking unit of package.
  if [[ "${SizeUnit}" == "kB" ]]; then
    # converting decimals to integers.
    local Size="${Size%%.*}";
    # gives size in kB.
    echo "$(( Size/1048576 )) MB";
  elif [[ "${SizeUnit}" == "B" ]]; then
    # converting decimals to integers.
    local Size="${Size%%.*}";
    # gives size in kB.
    echo "$(( Size/2048 )) MB";
  else
    # converting decimals to integers.
    local Size="${Size%%.*}"
    # gives already kB packages size.
    echo "${Size} ${SizeUnit}";
  fi
  # return function.
  return;
}

# pkg.chart(pkgs)
#   Use to view chart of packages.
# Args:
#   pkgs (array) > takes array of packages.
pkg.chart(){
  inspect.ScreenSize 96 12;
  # this takes all packages as arg.
  local ARGs=("${@}");
  # total download size of all packages.
  local UriSizeDL=0;
  # total installed size of all packages.
  local UriSizeIN=0;
  setCursor off;
  echo;
  say.success "📦 Getting Information Packages";
  echo -e "
    ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
    ┃                                 INFORMATION PACKAGES                                ┃
    ┣━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┫
    ┃      PACKAGE NAME              VERSION             DOWNLOAD           INSTALLED     ┃
    ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛";
  for ARG in "${ARGs[@]}"
  do
    # assigning database variable.
    local Uri="$(apt show "${ARG}" 2> /dev/null)";
    # assign pkg name variable.
    local Id="$(echo "${Uri}" | grep Package: | awk '{print $2}')";
    # assign pkg version variable.
    local Build="$(echo "${Uri}" | grep Version: | awk '{print $2}')";
    # assign pkg download size variable.
    local SizeDL="$(pkg.sizeDL "${ARG}" | awk '{print $1}')";
    # assign pkg installed size variable.
    local SizeIN="$(pkg.sizeIN "${ARG}" | awk '{print $1}')";
      printf  "    ┃      ${Green}%-13s${Clear}          ${Yelo}%10s${Clear}              ${Yelo}%-4s${Clear} %-2s             ${Yelo}%-4s${Clear} %-2s     ┃\n" "${Id}" "${Build}" "${SizeDL}" "MB" "${SizeIN}" "MB";
      echo -e "    ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛";
    # Adding dl sizes of all packages.
    local UriSizeDL=$(( UriSizeDL + SizeDL ));
    # Adding ins sizes of all packages.
    local UriSizeIN=$(( UriSizeIN + SizeIN ));
  done
    # print total data.
    printf    "    ┃     [ ${Yelo}%5s${Clear} ]  ─────────────────────────────────> ${Yelo}%6s${Clear} %-2s           ${Yelo}%6s${Clear} %-2s     ┃" "TOTAL" "${UriSizeDL}" "MB" "${UriSizeIN}" "MB"
    echo -e "\n    ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛";
  echo;
  setCursor on;
  return;
}

# pkg.install(packages)
#   Used to install packages with good ui.
# Args:
#   packages (array) > takes packages as args. (eg: python nodejs neovim)
pkg.install(){
  # function starts here.
  local ARGs=("${@}");
  # printing chart.
  pkg.chart "${ARGs[@]}";
  # required permission.
  if ask.case "Install Packages"; then
    for APP in "${ARGs[@]}"
    do
      spinner.start "Installing" "${APP}";
      # started installing.
      if os.is_termux; then
        apt-get install -qq "${APP}" > /dev/null;
      elif os.is_shell.zsh && os.is_userland; then
        apt-get install -qq "${APP}" > /dev/null;
      elif os.is_userland; then
        sudo apt-get install -qq "${APP}" > /dev/null;
      else
        sudo apt-get install -qq "${APP}" > /dev/null;
      fi
      # stopped installation.
      spinner.stop;
    done
  fi
  echo;
  return;
}
