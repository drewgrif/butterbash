# 🧈 ButterBash

A smooth, modular Bash configuration framework that makes your shell experience butter-smooth.

## ✨ Features

- **Modular Design**: Clean separation of concerns with individual files for aliases, functions, and configurations
- **Smart Note Taking**: Built-in note system with clipboard integration
- **Task Management**: Todo list functionality with emoji indicators
- **FZF Integration**: Fuzzy finding for files and processes
- **Git-Aware Prompt**: Shows current branch in your prompt
- **Extensive Aliases**: Productivity shortcuts for common tasks
- **Archive Extraction**: Universal `extract` command for all archive types
- **System Functions**: Quick system info, colored man pages, and more

## 📦 Installation

### Recommended: Install via ButterScripts

The easiest way to install ButterBash is through the ButterScripts optional installer:

```bash
# Clone and run butterscripts installer
git clone https://github.com/drewgrif/butterscripts.git
cd butterscripts/setup
./optional_tools.sh
# Select option 1: ButterBash ⭐
```

### Quick Install (Direct)

```bash
curl -sSL https://raw.githubusercontent.com/drewgrif/butterbash/main/install.sh | bash
```

### Manual Install

1. Clone the repository:
```bash
git clone https://github.com/drewgrif/butterbash.git ~/GitHub/butterbash
cd ~/GitHub/butterbash
```

> **Note**: This project will be transitioning to Codeberg in the future. Watch for updates!

2. Run the install script:
```bash
./install.sh
```

3. Reload your shell:
```bash
source ~/.bashrc
```

> **Important**: ButterBash will backup your existing `.bashrc` and replace it with a modular configuration. This is the intended behavior for the full ButterBash experience.

## 🗂️ Structure

```
~/.config/bash/
├── aliases.bash        # Command shortcuts
├── prompt.bash         # Custom prompt with git branch
├── keybinds.bash       # Keyboard shortcuts
├── fzf.bash           # FZF configuration
└── functions/
    ├── note.bash      # Note-taking system
    ├── todo.bash      # Task management
    ├── system.bash    # System utilities
    └── utils.bash     # General utilities
```

## 🎯 Core Functions

### Note Taking
```bash
note                    # List all notes numbered by entry
note "Remember this"    # Add a note with timestamp
note clip              # Save clipboard content as note
note rm 3              # Remove note #3
note rm 1-5            # Remove notes 1 through 5
note rm 1 3 5          # Remove multiple specific notes
note edit              # Open notes in editor
note clear             # Delete all notes (with confirmation)
```

### Todo Management
```bash
todo                   # List active tasks (completed shown struck-through)
todo "Write docs"      # Add a new task
todo done 1           # Mark task #1 as complete (strikethrough)
todo rm 2             # Delete task #2 completely
todo clear            # Remove struck-through completed tasks
```

### Utility Functions
```bash
mkcd directory        # Create and enter directory
extract file.tar.gz   # Extract any archive type
backup file.txt       # Create timestamped backup
calc 2+2             # Quick calculations
sysinfo              # Display system information
```

## ⚙️ Configuration

### Customization

Add your own customizations by creating files in `~/.config/bash/`:

1. Create a new module: `~/.config/bash/custom.bash`
2. It will be automatically loaded on next shell start

### Local Overrides

For machine-specific settings, create `~/.bashrc.local`:
```bash
# ~/.bashrc.local
export CUSTOM_VAR="value"
alias myalias="command"

# Custom notes/tasks directory (for cloud sync)
export BUTTERBASH_NOTES_DIR="$HOME/Nextcloud"
# or export BUTTERBASH_NOTES_DIR="$HOME/Dropbox"
# Files will be: $BUTTERBASH_NOTES_DIR/.notes and $BUTTERBASH_NOTES_DIR/.tasks
```

## 🚀 Key Bindings

- **Ctrl+L**: Clear screen
- **↑/↓**: Search command history
- **Ctrl+R**: Reverse history search (with FZF if available)

## 📋 Requirements

- Bash 4.0+
- Optional but recommended:
  - `fzf` - Fuzzy finder
  - `ripgrep` - Fast grep alternative
  - `eza` or `exa` - Modern ls replacement
  - `xclip` - Clipboard integration (X11)
  - `wl-clipboard` - Clipboard integration (Wayland)

Install optional dependencies:
```bash
install_tools  # Built-in function to install fzf and ripgrep
```

## 🤝 Contributing

Pull requests are welcome! For major changes, please open an issue first.

## 📝 License

MIT

## 🙏 Acknowledgments

- Inspired by various dotfile repositories
- Built with love for the Bash community

---

Made with 🧈 by [JustAGuyLinux](https://www.youtube.com/@justaguylinux)