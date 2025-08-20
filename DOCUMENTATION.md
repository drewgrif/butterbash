# ButterBash Complete Documentation

## What Was Done - Session Summary

### Initial State
- Started with a monolithic 600+ line `.bashrc` file
- Functions, aliases, and configurations all mixed together
- Difficult to maintain and modify

### Transformation Process

1. **Backed up original `.bashrc`**
   - Created timestamped backup before any changes

2. **Created modular structure** at `~/.config/bash/`
   - Split configuration into logical, maintainable files
   - Each file has a single responsibility

3. **Enhanced existing functions**
   - Added emoji indicators to `note()` function
   - Added clipboard support to notes: `note clip`
   - Added multi-line clipboard handling
   - Added batch removal for notes: `note rm 1-5`
   - Added help system for both `note` and `todo`

4. **Improved function design**
   - Fixed note numbering to treat each timestamped entry as single note
   - Added strikethrough for completed tasks in todo system
   - Changed removal commands to `rm` to avoid conflicts with task names
   - Added sync directory support via `BUTTERBASH_NOTES_DIR`
   - Changed todo storage from `.txt` to `.md` for consistency

5. **Created GitHub project structure**
   - Organized for easy distribution and installation
   - Added comprehensive README with examples
   - Created automated installer script
   - Added `.gitignore` for common files

## Complete File Structure

```
~/.config/bash/
├── aliases.bash          # All command shortcuts
├── prompt.bash           # Git-aware prompt configuration  
├── keybinds.bash         # Keyboard shortcuts
├── fzf.bash             # FZF fuzzy finder setup
└── functions/
    ├── note.bash        # Note-taking system
    ├── todo.bash        # Task management
    ├── system.bash      # System utilities
    └── utils.bash       # General utilities
```

## All Available Commands

### Aliases

#### Navigation
- `..` - Go up one directory
- `...` - Go up two directories
- `....` - Go up three directories
- `~` - Go to home directory
- `-` - Go to previous directory

#### File Listing (with eza/exa fallback)
- `l` - Detailed list
- `ls` - List with icons
- `ll` - Long list with all files
- `la` - List all including hidden
- `lt` - Tree view (2 levels)
- `lh` - List by modification time

#### File Operations
- `cp` - Copy with confirmation
- `mv` - Move with confirmation
- `rm` - Remove with confirmation
- `mkdir` - Create directory with parents

#### System Info
- `df` - Disk free (human readable)
- `du` - Disk usage (human readable)
- `free` - Memory info (human readable)
- `ps` - Process tree
- `psg` - Process grep
- `top` - Uses btop/htop if available
- `mem` - Top 5 memory consumers
- `cpu` - Top 5 CPU consumers

#### Network
- `myip` - Show local and external IP
- `ports` - Show open ports
- `listening` - Show listening services

#### Package Management (Debian/Ubuntu)
- `install` - apt install shortcut
- `search` - apt search shortcut
- `update` - apt update
- `upgrade` - Full system upgrade
- `remove` - apt remove
- `autoremove` - Clean unused packages

#### Git Shortcuts
- `g` - git
- `gs` - git status
- `ga` - git add
- `gaa` - git add all
- `gc` - git commit
- `gcm` - git commit with message
- `gp` - git push
- `gpu` - git push upstream main
- `gpl` - git pull
- `gco` - git checkout
- `gb` - git branch
- `gd` - git diff
- `gl` - git log (decorated)
- `gclone` - git clone

#### Editors
- `v` - nvim
- `vv` - nvim current directory
- `e` - micro editor
- `n` - nano

#### Config Files
- `bashrc` - Edit .bashrc
- `reload` - Reload .bashrc
- `zshrc` - Edit .zshrc
- `vimrc` - Edit .vimrc
- `nvimrc` - Edit nvim config
- `tmuxconf` - Edit tmux config

#### Directory Shortcuts
- `g.` - Go to ~/.config
- `gd` - Go to Downloads
- `gD` - Go to Documents
- `gv` - Go to Videos
- `gdw` - Go to DWM config
- `gds` - Go to slstatus config
- `remake` - Rebuild DWM/suckless tools

#### Utilities
- `x` - exit
- `c` - clear
- `h` - history
- `j` - jobs list
- `which` - type -a
- `now` - Current datetime
- `week` - Week number
- `grep/egrep/fgrep` - With color
- `biggest` - Largest directories
- `k9` - kill -9
- `killall` - verbose killall
- `untar` - Extract tar
- `ungz` - Extract tar.gz
- `unbz2` - Extract tar.bz2
- `weather` - Weather for Thonotosassa
- `ff` - fastfetch/neofetch

### Functions

#### Note Management (`note`)
```bash
note                    # List all notes numbered by entry
note "text"            # Add timestamped note
note clip              # Save clipboard as note (multi-line safe)
note rm 3              # Remove note #3
note rm 1-5            # Remove notes 1 through 5
note rm 1 3 5          # Remove multiple specific notes
note edit              # Open notes in editor
note clear             # Delete all notes (confirms)
note help              # Show help
```

Notes are stored in: `${BUTTERBASH_NOTES_DIR:-~/.notes}`

#### Todo Management (`todo`)
```bash
todo                   # List active tasks (completed shown struck-through)
todo "task"           # Add new task
todo done 1           # Mark task #1 complete (strikethrough)
todo rm 2             # Delete task #2 completely
todo clear            # Remove struck-through completed tasks
todo help             # Show help
```

Tasks are stored in: `${BUTTERBASH_NOTES_DIR:-~/.tasks}`

#### Utility Functions

**Directory Operations:**
- `mkcd <dir>` - Create directory and enter it

**Backup:**
- `backup <file>` - Create timestamped backup

**Archive Extraction:**
- `extract <file>` - Universal extractor for:
  - tar.bz2, tar.gz, tar.xz
  - bz2, rar, gz, tar
  - tbz2, tgz, zip, Z, 7z

**Search:**
- `hgrep <term>` - Search command history

**Info:**
- `dirsize [dir]` - Get directory size
- `calc <expr>` - Quick calculator
- `path` - Show PATH formatted
- `sysinfo` - System information summary

**Tools:**
- `command_exists <cmd>` - Check if command exists
- `install_tools` - Install fzf and ripgrep

**FZF Functions (if installed):**
- `vf` - Find and edit file with preview
- `fkill` - Kill process interactively

**Enhanced:**
- `man` - Colored man pages

## Shell Options

The configuration enables:
- `histappend` - Append to history file
- `checkwinsize` - Update LINES/COLUMNS
- `cdspell` - Correct cd typos
- `dirspell` - Correct directory typos
- `autocd` - cd by typing directory name
- `globstar` - ** recursive matching
- `nocaseglob` - Case-insensitive globbing
- `extglob` - Extended pattern matching

## History Configuration

- Size: 10,000 commands in memory
- File: 20,000 commands saved
- Ignores duplicates and common commands
- Timestamps on all history entries
- Immediate history writing

## Environment Variables

- `PATH` - Includes ~/scripts, ~/.local/bin, Go, Cargo
- `EDITOR` - Smart detection (nvim > vim > micro > nano)
- `LESS` - Better defaults with color support
- `LANG/LC_ALL` - UTF-8 encoding

## Key Bindings

- **Ctrl+L** - Clear screen
- **↑/↓** - Search command history
- **Ctrl+R** - Reverse search (enhanced with FZF)

## Prompt Features

- Shows current time
- Username (red "-ssh" indicator for SSH sessions)
- Hostname
- Current directory
- Git branch (when in git repo)
- Colored components for readability

## Installation

The installer (`install.sh`) performs:
1. Backs up existing configuration
2. Creates directory structure
3. Copies all module files
4. Creates data directories for notes/todos
5. Optionally installs recommended tools
6. Supports multiple package managers (apt, dnf, pacman, brew)

## Customization

### Adding Custom Modules
Create new `.bash` files in `~/.config/bash/` - they're auto-loaded

### Machine-Specific Settings
Create `~/.bashrc.local` for local overrides

### Modify Existing Functions
Edit individual files in `~/.config/bash/functions/`

## Project Info

- **Author**: JustAGuyLinux (YouTube)
- **Repository**: https://github.com/drewgrif/butterbash
- **Future Home**: Will transition to Codeberg
- **License**: MIT

## Technical Details

### Requirements
- Bash 4.0+ (for associative arrays and modern features)
- Linux/Unix-like system
- Optional: fzf, ripgrep, eza/exa, xclip/wl-clipboard

### Compatibility
- Debian/Ubuntu (primary target)
- Should work on most Linux distributions
- macOS compatible with minor adjustments
- WSL compatible

### Performance
- Modular loading (~100ms typical startup)
- Lazy loading for optional features
- Efficient history management
- Minimal external dependencies

## Troubleshooting

### If bashrc doesn't load
```bash
source ~/.bashrc
```

### If commands not found
Check PATH includes config directory:
```bash
echo $PATH
```

### To restore original config
Backups are created with timestamps:
```bash
ls ~/.bashrc.backup.*
ls ~/.config/bash.backup.*
```

### To uninstall
```bash
rm -rf ~/.config/bash
cp ~/.bashrc.backup.[timestamp] ~/.bashrc
source ~/.bashrc
```

## What Makes ButterBash Special

1. **Modular** - Easy to maintain and extend
2. **Non-destructive** - Always backs up existing config
3. **Smart defaults** - Works out of the box
4. **Feature-rich** - Includes note-taking and todo management
5. **Well-documented** - Clear examples and help
6. **Community-focused** - Built for sharing and customization

---

This documentation serves as a complete reference for ButterBash functionality and can be used to continue development even in a new session.