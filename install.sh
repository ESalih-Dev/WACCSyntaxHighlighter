#!/bin/bash

# Standard file names.
vimrc=".vimrc"
vimfile="wacc.vim"

# Path to vim syntax folder to contain WACC highlighter.
vimsyntax="$HOME/.vim/syntax/"

# Check for a wacc.vim file in the vim folder.
# If one does not exist look for a highlighter file and move it into the 
# required folder.
if [ ! -d "$vimsyntax" ]
then
  if [ ! -f "$vimsyntax$vimfile" ] 
  then
    # Search for "wacc.vim". Stop after first occurrence.
    # Do not search in hidden folders.
    highlighter=$(find ~/ -not -path '*/\.*' -type f -name $vimfile 2>/dev/null -print -quit)
    if [ ! $highlighter ]
    then
      echo "Highlighter not found. Please download it."
      exit
    else
      eval "rsync -a --ignore-errors $highlighter $vimsyntax"
    fi
  fi
fi

# Look for the .vimrc file.
# We suppress any error messages caused by inadequate permissions to search
# protected folders.
path=$(find ~/ -name $vimrc 2>/dev/null)

# If we don't find a .vimrc file we create one in the home directory.
if [ ! $path ]
then
  path="$HOME/$vimrc"
  eval "touch $path"
  echo "Did not find a $vimrc file, have created one in $path."
fi

echo "au BufRead,BufNewFile *.wacc set filetype=wacc" >> $path

