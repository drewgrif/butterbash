#!/usr/bin/env bash
# Note taking function with clipboard support

note() {
    local note_file="${BUTTERBASH_NOTES_DIR:-$HOME/.notes}"
    
    # Create directory if using custom location
    [[ "$note_file" != "$HOME/.notes" ]] && mkdir -p "$(dirname "$note_file")"
    
    if [ "$#" -eq 0 ]; then
        if [ -f "$note_file" ]; then
            echo "📝 Notes:"
            local count=1
            local in_note=false
            local note_content=""
            
            while IFS= read -r line; do
                # Check if line starts with timestamp pattern
                if [[ "$line" =~ ^\[([0-9]{4}-[0-9]{2}-[0-9]{2}\ [0-9]{2}:[0-9]{2}:[0-9]{2})\] ]]; then
                    # If we were already in a note, print it
                    if [ "$in_note" = true ] && [ -n "$note_content" ]; then
                        echo -e "  \033[1;33m[$count]\033[0m $note_content"
                        ((count++))
                    fi
                    # Start new note
                    note_content="$line"
                    in_note=true
                elif [ "$in_note" = true ]; then
                    # Continue current note (multi-line)
                    if [ -n "$line" ]; then
                        note_content="$note_content\n    $line"
                    fi
                fi
            done < "$note_file"
            
            # Print last note if exists
            if [ "$in_note" = true ] && [ -n "$note_content" ]; then
                echo -e "  \033[1;33m[$count]\033[0m $note_content"
            fi
        else
            echo "📝 No notes yet. Use 'note <text>' to add your first note."
        fi
    elif [ "$1" = "clip" ] || [ "$1" = "clipboard" ]; then
        # Get clipboard content
        local clip_content=""
        if command -v xclip >/dev/null 2>&1; then
            clip_content=$(xclip -selection clipboard -o 2>/dev/null)
        elif command -v xsel >/dev/null 2>&1; then
            clip_content=$(xsel --clipboard --output 2>/dev/null)
        elif command -v wl-paste >/dev/null 2>&1; then
            # Force text output for Wayland
            clip_content=$(wl-paste -t text 2>/dev/null || wl-paste -n 2>/dev/null)
        elif command -v pbpaste >/dev/null 2>&1; then
            clip_content=$(pbpaste 2>/dev/null)
        else
            echo "❌ No clipboard tool found. Install xclip, xsel, or wl-clipboard"
            return 1
        fi
        
        # Check if content looks like text (not binary)
        if [ -n "$clip_content" ]; then
            if [[ "$clip_content" =~ [^[:print:][:space:]] ]]; then
                echo "⚠️  Clipboard contains non-text data (image, file, etc.)"
                return 1
            fi
            
            # Check size limit (100KB)
            if [[ ${#clip_content} -gt 102400 ]]; then
                echo "⚠️  Clipboard content too large (${#clip_content} chars)"
                return 1
            fi
            
            # Handle multi-line content by indenting continuation lines
            echo "[$(date '+%Y-%m-%d %H:%M:%S')] [CLIPBOARD]" >> "$note_file"
            echo "$clip_content" | sed 's/^/  /' >> "$note_file"
            echo "" >> "$note_file"
            echo "📋 Clipboard content added to notes"
        else
            echo "⚠️  Clipboard is empty"
        fi
    elif [ "$1" = "rm" ]; then
        if [ -z "$2" ]; then
            echo "Usage: note rm <note_numbers...>"
            echo "Examples: note rm 3  |  note rm 1 3 5  |  note rm 2-5"
            return 1
        fi
        
        if [ -f "$note_file" ]; then
            local notes_to_remove=()
            shift # Remove 'remove' from arguments
            
            # Parse all note numbers/ranges
            for arg in "$@"; do
                if [[ "$arg" =~ ^([0-9]+)-([0-9]+)$ ]]; then
                    # Handle range like "2-5"
                    local start="${BASH_REMATCH[1]}"
                    local end="${BASH_REMATCH[2]}"
                    for ((i=start; i<=end; i++)); do
                        notes_to_remove+=("$i")
                    done
                elif [[ "$arg" =~ ^[0-9]+$ ]]; then
                    # Single number
                    notes_to_remove+=("$arg")
                else
                    echo "⚠️  Invalid note number or range: $arg"
                    return 1
                fi
            done
            
            # Sort and remove duplicates, then reverse order
            local sorted_notes=($(printf '%s\n' "${notes_to_remove[@]}" | sort -rnu))
            
            # Create temp file for the new content
            local temp_file="$note_file.tmp"
            > "$temp_file"
            
            # Parse notes and skip the ones to be removed
            local count=1
            local in_note=false
            local note_content=""
            local note_start_line=""
            local should_skip=false
            
            while IFS= read -r line; do
                # Check if line starts with timestamp pattern
                if [[ "$line" =~ ^\[([0-9]{4}-[0-9]{2}-[0-9]{2}\ [0-9]{2}:[0-9]{2}:[0-9]{2})\] ]]; then
                    # If we were in a note, decide whether to save it
                    if [ "$in_note" = true ] && [ -n "$note_content" ]; then
                        if [ "$should_skip" = false ]; then
                            echo -e "$note_content" >> "$temp_file"
                        else
                            echo "❌ Removed note #$count: ${note_start_line:0:50}..."
                        fi
                        ((count++))
                    fi
                    
                    # Check if this note should be removed
                    should_skip=false
                    for num in "${sorted_notes[@]}"; do
                        if [ "$count" -eq "$num" ]; then
                            should_skip=true
                            break
                        fi
                    done
                    
                    # Start new note
                    note_content="$line"
                    note_start_line="$line"
                    in_note=true
                elif [ "$in_note" = true ]; then
                    # Continue current note
                    note_content="$note_content\n$line"
                fi
            done < "$note_file"
            
            # Handle last note
            if [ "$in_note" = true ] && [ -n "$note_content" ]; then
                if [ "$should_skip" = false ]; then
                    echo -e "$note_content" >> "$temp_file"
                else
                    echo "❌ Removed note #$count: ${note_start_line:0:50}..."
                fi
            fi
            
            # Replace original file with temp file
            mv "$temp_file" "$note_file"
        else
            echo "📝 No notes file exists yet."
        fi
    elif [ "$1" = "clear" ]; then
        if [ -f "$note_file" ]; then
            echo -n "⚠️  Delete all notes? (y/N): "
            read -r confirm
            if [[ "$confirm" =~ ^[yY]$ ]]; then
                > "$note_file"
                echo "🗑️  All notes cleared"
            else
                echo "Cancelled"
            fi
        else
            echo "📝 No notes to clear"
        fi
    elif [ "$1" = "edit" ]; then
        ${EDITOR:-nano} "$note_file"
    elif [ "$1" = "help" ]; then
        echo "Usage:"
        echo "  note              - List all notes numbered by entry"
        echo "  note <text>       - Add a new note with timestamp"
        echo "  note clip         - Add clipboard content as note"
        echo "  note rm <n>       - Remove note number n"
        echo "  note rm 1-5       - Remove notes 1 through 5"
        echo "  note rm 1 3 5     - Remove multiple specific notes"
        echo "  note clear        - Delete all notes (with confirmation)"
        echo "  note edit         - Open notes file in editor"
        echo "  note help         - Show this help"
    else
        echo "[$(date '+%Y-%m-%d %H:%M:%S')] $*" >> "$note_file"
        echo "✅ Note added to $note_file"
    fi
}