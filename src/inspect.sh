#!/bin/bash

if (( 1<2 )); then
# dir of current file.
Dir="$(dirname "${BASH_SOURCE[0]}")";
fi

source "${Dir}"/screen.sh
source "${Dir}"/say.sh
source "${Dir}"/os.sh

# source screen.sh
# source say.sh
# source os.sh

# inspect.ScreenSize(cols,lines) -> str
#   Checks that screen size is sufficient to project.
# Args:
#   cols (int) > takes columns as arg.
#   lines (int) > takes lines as arg.
inspect.ScreenSize(){
  local ARGCols="${1}";
  local ARGRou="${2}";
  screen.isSize "${ARGCols}" "${ARGRou}" || {
    say.warn "Your Screen Size\n
    \t\tColumns: '$(screen.cols)'\n
    \t\tLines: '$(screen.lines)'";
    say.success "Require Screen Size\n
    \t\tColumns: '${ARGCols}'\n
    \t\tLines: '${ARGRou}'";
    say.error "Please 'ZoomOut' your Terminal\n
    \t\tThen run again.";
    exit 1;
  };
}

# inspect.is_func(function) -> str
#   An extension of os.is_func.
inspect.is_func(){
  os.is_func "${1}" || {
    say.error "There is no '${1}'\n
    \t\tShould to install it on your OS.";
    exit 1;
  };
}