#!/usr/bin/env bash
# Bash aliases

# ============================================================================
# NAVIGATION
# ============================================================================
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias ~='cd ~'
alias -- -='cd -'

# ============================================================================
# LS VARIANTS
# ============================================================================
if command -v eza >/dev/null 2>&1; then
    alias l='eza -ll --color=always --group-directories-first'
    alias ls='eza -al --header --icons --group-directories-first'
    alias ll='eza -la --icons --group-directories-first'
    alias la='eza -la --icons --group-directories-first'
    alias lt='eza --tree --level=2 --icons'
    alias lh='eza -la --sort=modified --reverse'
elif command -v exa >/dev/null 2>&1; then
    alias l='exa -l --color=always --group-directories-first'
    alias ls='exa -a --icons --group-directories-first'
    alias ll='exa -la --icons --group-directories-first'
    alias la='exa -la --icons --group-directories-first'
    alias lt='exa --tree --level=2 --icons'
    alias lh='exa -la --sort=modified --reverse'
else
    alias l='ls -lF'
    alias ll='ls -laF'
    alias la='ls -A'
    alias lt='tree -L 2'
    alias lh='ls -lath'
fi

# ============================================================================
# FILE OPERATIONS
# ============================================================================
alias cp='cp -iv'
alias mv='mv -iv'
alias rm='rm -Iv'
alias mkdir='mkdir -pv'

# ============================================================================
# SYSTEM INFO
# ============================================================================
alias df='df -h'
alias du='du -h'
alias free='free -h'
alias ps='ps auxf'
alias psg='ps aux | grep -v grep | grep -i -e VSZ -e'
alias top='btop || htop || top'
alias mem='free -h && echo && ps aux | head -1 && ps aux | sort -rnk 4 | head -5'
alias cpu='ps aux | head -1 && ps aux | sort -rnk 3 | head -5'

# ============================================================================
# NETWORK
# ============================================================================
alias myip="hostname -I | awk '{print \$1}' && echo -n 'External: ' && curl -s ifconfig.me && echo"
alias ports='netstat -tulanp'
alias listening='lsof -P -i -n'

# ============================================================================
# PACKAGE MANAGEMENT
# ============================================================================
alias install='sudo apt install'
alias search='apt search'
alias update='sudo apt update'
alias upgrade='sudo apt update && sudo apt upgrade'
alias remove='sudo apt remove'
alias autoremove='sudo apt autoremove --purge'

# ============================================================================
# GIT
# ============================================================================
alias g='git'
alias gs='git status'
alias ga='git add'
alias gaa='git add -A'
alias gc='git commit'
alias gcm='git commit -m'
alias gp='git push'
alias gpu='git push -u origin main'
alias gpl='git pull'
alias gco='git checkout'
alias gb='git branch'
alias gd='git diff'
alias gl='git log --oneline --graph --decorate'
alias gclone='git clone'

# ============================================================================
# EDITORS AND CONFIG
# ============================================================================
alias v='nvim'
alias vv='nvim .'
alias e='micro'
alias n='nano'

# Config files
alias bashrc='${EDITOR} ~/.bashrc'
alias reload='source ~/.bashrc && echo "Reloaded .bashrc"'
alias zshrc='${EDITOR} ~/.zshrc'
alias vimrc='${EDITOR} ~/.vimrc'
alias nvimrc='${EDITOR} ~/.config/nvim/init.vim'
alias tmuxconf='${EDITOR} ~/.tmux.conf'

# ============================================================================
# DIRECTORY SHORTCUTS
# ============================================================================
alias g.='cd ~/.config'
alias gd='cd ~/Downloads'
alias gD='cd ~/Documents'
alias gv='cd ~/Videos'

# DWM aliases
alias gdw='cd ~/.config/suckless/dwm'
alias gds='cd ~/.config/suckless/slstatus'
alias remake='rm config.h && make && sudo make clean install'

# ============================================================================
# UTILITIES
# ============================================================================
alias x='exit'
alias c='clear'
alias h='history'
alias j='jobs -l'
alias which='type -a'
alias now='date +"%Y-%m-%d %T"'
alias week='date +%V'

# File search and grep
alias grep='grep --color=auto'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'

# Disk usage
alias biggest='du -h --max-depth=1 | sort -h'

# Process management
alias k9='kill -9'
alias killall='killall -v'

# Archive extraction
alias untar='tar -xvf'
alias ungz='tar -xzvf'
alias unbz2='tar -xjvf'

# Misc
alias weather='curl wttr.in/thonotosassa?u'
alias ff='fastfetch || neofetch'