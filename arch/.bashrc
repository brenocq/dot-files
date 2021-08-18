# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
PS1='[\u@\h \W]\$ '

alias untar='tar -xvf'

# Vulkan path
source /home/breno/Disk/Programs/Vulkan/1.2.182.0/setup-env.sh
