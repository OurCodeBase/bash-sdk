#!/bin/bash

# setCursor(on~off)
#   Switch terminal cursor easily.
setCursor(){
  setterm -cursor "${1}";
}