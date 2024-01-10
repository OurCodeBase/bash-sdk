#!/bin/bash

if (( 1<2 )); then
# dir of current file.
Dir="$(dirname "${BASH_SOURCE[0]}")";
fi

source "${Dir}"/os.sh
source "${Dir}"/say.sh
source "${Dir}"/string.sh

# source os.sh
# source say.sh
# source string.sh

# Stores object that you selected.
askChoice='';
# Stores position of object that you selected.
askReply='';

# ask.case(title) -> bool
#   This takes case ( yes or no ) for any work.
# Args:
#   title (str) > takes title (eg: You're Agree).
ask.case(){
  echo -ne "\n    ${1}";
  read -p " ? [Y/n] " ARGS;
  echo;
  case "${ARGS}" in
    y|Y)
      return 0;
    ;;
    n|N)
      say.error "Process Aborted.\n" &&
      exit 1;
    ;;
    *) 
      say.error "You have to enter only\n \t\t'Y' for Yes &\n \t\t'n' for No.\n" &&
      exit 1;
    ;;
  esac 
}

# ask.choice(title,list) -> var
#   This creates a simple menu.
# Args:
#   title (str) > takes title (eg: Choose One).
#   list (array) > takes array as arg.
# Returns:
#   object (str) > result in 'askChoice' & 'askReply' variables.
ask.choice(){
  PS3="
  ${1} > ";
  local ARGs=("${@}");
  local ARGs2=("${ARGs[@]:1}");
  echo;
  select ARG in "${ARGs2[@]}"
  do
    if ! text.isdigit "${REPLY}"; then
      say.error "You can only input 'digits'.\n";
      exit 1;
    fi
    if [[ "${REPLY}" -gt "${#ARGs2[@]}" ]]; then
      say.error "You should input correct digits.\n";
      exit 1;
    fi
    askChoice="${ARG}";
    askReply="${REPLY}";
    break;
  done
  return 0;
}

# ask.storagePermission() -> bool
#   Ask for storage permission in diffrent os.
ask.storagePermission(){
  if os.is_termux; then
    say.warn "Asking for storage permission";
    termux-setup-storage;
    say.checkStatus "${?}";
  fi
}
