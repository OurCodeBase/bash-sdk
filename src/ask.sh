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
    y|Y) return 0;;
    n|N) { say.error "Process Aborted.\n" && exit 1; };;
    *) { say.error "You have to enter only\n\t\t'Y' for Yes &\n\t\t'n' for No.\n" && exit 1; };;
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
  # leave first variable of array for title.
  local ARGs2=("${ARGs[@]:1}");
  echo;
  select ARG in "${ARGs2[@]}"
  do
    text.isdigit "${REPLY}" || {
      say.error "You can only input 'digits'.\n" && exit 1;
    };
    [[ "${REPLY}" -gt "${#ARGs2[@]}" ]] &&
    say.error "You should input correct digits.\n" && exit 1;
    askChoice="${ARG}";
    askReply="${REPLY}";
    break;
  done
}