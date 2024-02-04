#!/bin/bash

# screen.cols() ~ int
# Gives you current columns count in terminal.
screen.cols(){
  # current columns in terminal.
  stty size | awk '{print $2}'
}

# screen.lines() ~ int
# Gives you current lines count in terminal.
screen.lines(){
  # current lines in terminal.
  stty size | awk '{print $1}'
}

# screen.isSize(cols,lines) ~ bool
# Checks that screen has atleast given lines and columns.
# 
# Args:
# - cols (int): takes columns as int.
# - lines (int): takes lines as int.
screen.isSize(){
  local ARGCols=${1};
  local ARGLines=${2};
  local CurrentCols="$(screen.cols)";
  local CurrentLines="$(screen.lines)";
  (( CurrentCols >= ARGCols && CurrentLines >= ARGLines ));
}