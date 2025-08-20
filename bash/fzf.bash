#!/usr/bin/env bash
# FZF configuration and functions

if command -v fzf >/dev/null 2>&1; then
    # Open file in editor with fzf
    vf() {
        local file
        file=$(fzf --preview "bat --color=always {} 2>/dev/null || cat {}") && ${EDITOR:-vim} "$file"
    }
    
    # Kill process with fzf
    fkill() {
        local pid
        pid=$(ps -ef | sed 1d | fzf -m | awk '{print $2}')
        if [ "x$pid" != "x" ]; then
            echo "$pid" | xargs kill -${1:-9}
        fi
    }
    
    # FZF default options
    export FZF_DEFAULT_OPTS="--height 40% --layout=reverse --border --info=inline"
    
    # Use fd if available for faster searching
    if command -v fd >/dev/null 2>&1; then
        export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
        export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
        export FZF_ALT_C_COMMAND='fd --type d --hidden --follow --exclude .git'
    fi
    
    # Source fzf key bindings if available
    [ -f /usr/share/fzf/key-bindings.bash ] && source /usr/share/fzf/key-bindings.bash
    [ -f /usr/share/fzf/completion.bash ] && source /usr/share/fzf/completion.bash
    [ -f ~/.fzf.bash ] && source ~/.fzf.bash
fi