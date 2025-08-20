#!/usr/bin/env bash
# Prompt configuration

# Color definitions
RED="\[\e[1;31m\]"
GREEN="\[\e[1;32m\]"
YELLOW="\[\e[1;33m\]"
BLUE="\[\e[1;34m\]"
MAGENTA="\[\e[1;35m\]"
CYAN="\[\e[1;36m\]"
WHITE="\[\e[1;37m\]"
GRAY="\[\e[1;90m\]"
ENDC="\[\e[0m\]"

# Git prompt function
parse_git_branch() {
    git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}

# Set prompt with git branch
if [[ -n "$SSH_CLIENT" ]]; then 
    ssh_message="${RED}-ssh${ENDC}"
else
    ssh_message=""
fi

# Enhanced prompt with git branch
PS1="${GRAY}\t ${GREEN}\u${ssh_message} ${WHITE}at ${YELLOW}\h ${WHITE}in ${BLUE}\w${CYAN}\$(parse_git_branch)\n${CYAN}\$${ENDC} "