#!/bin/bash

# os.is_userland() ~ bool
# OS is userland or not ?
os.is_userland(){
  ls '/host-rootfs/data/data/tech.ula/files/home' &> /dev/null;
}

# os.is_termux() ~ bool
# OS is termux or not ?
os.is_termux(){
  ls '/data/data/com.termux/files/' &> /dev/null;
}

# os.is_windows() ~ bool
# OS is windows or not ?
os.is_windows(){
  [[ "$(uname -a)" == *"windows"* ]]
}

# os.is_shell.zsh() ~ bool
# Using z-shell or not ?
os.is_shell.zsh(){
  if os.is_userland; then
    [[ "$(OurCodeBase-CShell)" == "zsh: "* ]];
  else
    [[ "${SHELL}" == *"zsh" ]];
  fi
}

# os.is_func(function) ~ bool
# Checks that function is exist or not.
# 
# ARGS:
# - function (str): takes function as string.
os.is_func(){
  command -v "${1}" &> /dev/null;
}
