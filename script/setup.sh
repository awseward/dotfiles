#!/bin/bash


dotfiles_to_install=$(ls -1A --ignore="hosts" --ignore="script" --ignore=".git")
echo $dotfiles_to_install

