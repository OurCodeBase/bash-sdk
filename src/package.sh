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

# pkg.size(dnload~install,package) -> int
#   Gives you needed size of package.
# Args:
#   dnload (str) > dnload to get file size.
#   install (str) > install to get package installed size.
#   package (str) > takes package (eg: python,nodejs).
# Returns:
#   size (int) > Gives you size in MiBs.
# Usage:
#   pkg.size(dnload,package) > Gives you package file size.
#   pkg.size(install,package) > Gives you package installed size.
pkg.size(){
  # checking args given or not.
  if [[ ! ${#} -eq 2 ]]; then
    echo "error: 'missing args'";
    return 1;
  fi
  case "${1}" in
    'dnload') local SizeSource="$(apt show "${2}" 2> /dev/null | grep 'Download-Size:')";;
    'install') local SizeSource="$(apt show "${2}" 2> /dev/null | grep 'Installed-Size:')";;
  esac
  local Size="$(echo "${SizeSource}" | awk '{print $2}')";
  local SizeUnit="$(echo "${SizeSource}" | awk '{print $3}')";
  # convert decimals to integers.
  local Size="${Size%%.*}";
  # check unit of package.
  case "${SizeUnit}" in
    'MB') echo "${Size}";;
    'kB') echo "$(( Size/1024 ))";;
    'B') echo "$(( Size/1048576 ))";;
  esac 
  # return function.
  return;
}

# pkg.chart(pkgs)
#   Use to view chart of packages.
# Args:
#   pkgs (array) > takes array of packages.
pkg.chart(){
  inspect.ScreenSize '62' '12';
  # this takes all packages as arg.
  local ARGs=("${@}");
  # total content file size of all packages.
  local PuraSizeDL=0;
  # total installed size of all packages.
  local PuraSizeIN=0;
  # turn off cursor.
  setCursor off;
    echo -e "
  ╭─ Packages ─────────────────────────────────────────────╮";
    echo -e "  │                                                        │";
    printf "  │  %-25s %-10s %-7s %-7s  │\n" 'Package' 'Version' 'DLSize' 'INSize';
    printf "  │  %-25s %-10s %-7s %-7s  │\n" '─────────────────────────' '──────────' '───────' '───────';
  for ARG in "${ARGs[@]}"
  do
    # declare database variable.
    local PackageSource="$(apt show "${ARG}" 2> /dev/null)";
    # declare package variable.
    local PackageVar="$(echo "${PackageSource}" | grep 'Package:' | awk '{print $2}')";
    # declare package version variable.
    local PackageVersion="$(echo "${PackageSource}" | grep 'Version:' | awk '{print $2}' | awk -F'-' '{print $1}')";
    # declare package file size variable.
    local PackageSizeDL="$(pkg.size 'dnload' "${ARG}")";
    # declare package installed size variable.
    local PackageSizeIN="$(pkg.size 'install' "${ARG}")";
      printf "  │  ${Green}%-25s${Clear} ${Yelo}%-10s${Clear} ${Yelo}%3s${Clear} %-3s ${Yelo}%3s${Clear} %-3s  │\n" "${PackageVar}" "${PackageVersion}" "${PackageSizeDL}" 'MiB' "${PackageSizeIN}" 'MiB';
    # Adding dl sizes of all packages.
    local PuraSizeDL=$(( PuraSizeDL + PackageSizeDL ));
    # Adding ins sizes of all packages.
    local PuraSizeIN=$(( PuraSizeIN + PackageSizeIN ));
  done
    echo -e "  │                                                        │";
    echo -e "  ╰────────────────────────────────────────────────────────╯\n";
    echo -e "  ╭─ TOTAL ────────────────────╮";
  printf "  │  %14s: ${Green}%4s${Clear} %3s  │\n" "Download Size" "${PuraSizeDL}" 'MiB';
  printf "  │  %14s: ${Yelo}%4s${Clear} %3s  │\n" "Installed Size" "${PuraSizeIN}" 'MiB';
  echo -e "  ╰────────────────────────────╯";
  # turn on cursor.
  setCursor on;
  # return function.
  return;
}

# pkg.install(packages)
#   Used to install packages with good ui.
# Args:
#   packages (array) > takes packages as args. (eg: python nodejs neovim)
pkg.install(){
  # function starts here.
  local ARGs=("${@}");
  # execution chart.
  pkg.chart "${ARGs[@]}";
  # request permission.
  if ask.case 'Install Packages'; then
    for ARG in "${ARGs[@]}"
    do
      spinner.start 'Installing' "${ARG}";
      # started installation.
      if os.is_termux; then
        apt-get install -qq "${ARG}" > /dev/null;
      elif os.is_shell.zsh; then
        apt-get install -qq "${ARG}" > /dev/null;
      else
        sudo apt-get install -qq "${ARG}" > /dev/null;
      fi
      # stopped installation.
      spinner.stop;
    done
  fi
  echo;
  return;
}