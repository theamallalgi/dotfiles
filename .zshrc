# ~/.zshrc - configuration file for zsh sessions

# Paths
export PATH="$HOME/.local/bin:$PATH"

# Aliases
alias cl="clear && colorscript -r"            # clear command with colorscripts
alias c="clear && colorscript -e blocks1"     # color script reset (zwaves)
alias watch="sass --style compressed --watch" # watches and compiles sass in real time
alias sb="clear && source ~/.zshrc"           # clears and sources the zshrc file
alias vi="nvim"                               # neovim
alias cat="bat"                               # better cat command
alias py="python"                             # sets python
alias pc="clear && py"                        # clears the terminal and opens python
alias ..="cd ../"                             # goes back one level
alias x="exit"                                # well you can read can't you?
alias len="ls -1 | wc -l"                     # prints the count of elements in current folder
alias rmcr="sed -i 's/\r//g'"                 # removes windows crlf in a file
alias ac="ani-cli"                            # an alias for the ani-cli client
alias exp="nautilus"                          # opens explorer (windows only), append with '.' or path
alias cs="colorscript"                        # color script cli

# Git Aliases
alias gc="git clone"                                                                                 # clones a git repo
alias gw="git commit -m"                                                                             # commits a change
alias ga="git add"                                                                                   # prepare files for staging
alias gs="git status"                                                                                # shows the local status
alias gp="git push"                                                                                  # pushes the staged changes
alias gP="git pull"                                                                                  # pulls from the repo
alias gg="lazygit"                                                                                   # opens lazygit
alias gl="git log --all --graph --pretty=format:'%C(magenta)%h %C(white)%an  %ar%C(auto)  %D%n%s%n'" # fancier git log

# Custom Location variables
export ad="$HOME/AppData"
export nv="$ad/Local/nvim/"
export ds="$HOME/Desktop/"
export dot="$HOME/dotfiles"
export bs="$HOME/.zshrc"
export td="$HOME/.config/todo/todo.txt"

# Fuzzy Finder Aliases
# alias fc='cd $(fzf --preview='bat')'
# alias vif='vi $(fzf --preview='bat')'
# alias vimf='vim $(fzf --preview='bat')'

# Location Aliases
alias home='cd ~'                     # home folder
alias dt="cd $ds"                     # desktop folder
alias doc="cd ~/Documents"            # documents folder
alias dev="cd ~/Documents/Developer/" # developer folder
alias d="cd $ds && c"                 # cds to desktop and clears the window
# alias dwn="cd /f/amal/downloads"                          # downloads folder
# alias prj="cd /f/amal/documents/programming/my\ projects" # personal projects folder

# Extentions and Misc
alias bws='bw login && export BW_SESSION="$(bw unlock --raw)"'

# ZSH-specific settings
setopt AUTO_CD              # Change directory without cd command
setopt GLOB_DOTS            # Include hidden files in globbing
setopt EXTENDED_GLOB        # Extended globbing (similar to bash's globstar)
setopt CORRECT              # Command correction (similar to bash's cdspell)
setopt HIST_IGNORE_DUPS     # Don't record duplicate commands
setopt HIST_FIND_NO_DUPS    # Don't show duplicates in search
setopt SHARE_HISTORY        # Share history between sessions
setopt APPEND_HISTORY       # Append to history file
setopt INC_APPEND_HISTORY   # Add commands as they are typed

# ZSH Completion System
autoload -Uz compinit
compinit

# Enable completion menu selection with highlighting
zstyle ':completion:*' menu select
zstyle ':completion:*' list-colors 'ma=48;5;235;38;5;99;1'  # Custom highlight: #272045 bg, #8543e4 fg, bold

# Highlight current selection in completion menu
zstyle ':completion:*:*:*:*:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' # Case insensitive completion

# Enable completion caching
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.zsh/cache

# Use arrow keys to navigate completion menu
# bindkey -M menuselect '^[[Z' reverse-menu-complete  # Shift+Tab to go backwards
# bindkey -M menuselect '^M' accept-line              # Enter to accept

# History Configuration
HISTFILE=~/.zsh_history
HISTSIZE=99999
SAVEHIST=99999

# Note: Vi mode in zsh
# bindkey -v  # Uncomment to enable vi mode
# bindkey '^l' clear-screen  # Ctrl+L to clear screen (already default in zsh)

# Directory Path Trim (zsh uses PROMPT truncation differently - handled in prompt section)

# Git Prompt Configuration (for vcs_info)
autoload -Uz vcs_info
precmd() { vcs_info }

# Git status options (zsh uses vcs_info instead of __git_ps1)
zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:*' unstagedstr '*'
zstyle ':vcs_info:*' stagedstr '+'
zstyle ':vcs_info:git:*' formats ' %F{cyan}(%b%u%c)%f'
zstyle ':vcs_info:git:*' actionformats ' %F{cyan}(%b|%a%u%c)%f'

# Custom Prompt (translating your bash PS1)
# Enable prompt substitution
setopt PROMPT_SUBST

# Note: In zsh, %~ automatically trims path. %1~ shows only last directory (like PROMPT_DIRTRIM=1)
PROMPT='%F{green}amal%f'           # green text (name)
PROMPT="$PROMPT%F{magenta} ϟ %f"   # magenta text (symbol)
PROMPT="$PROMPT%F{yellow}[ %f"     # yellow text (bracket)
PROMPT="$PROMPT%F{red}%1~%f"       # red text (working directory, trimmed to 1 level)
PROMPT="$PROMPT%F{yellow} ]%f"     # yellow text (bracket)
PROMPT="$PROMPT\$vcs_info_msg_0_"  # git info (cyan)
PROMPT="$PROMPT%(?.%F{green}.%F{red}) : %f"  # green : if success, red : if failure
PROMPT="$PROMPT%F{green}"          # default green text

# Window title
precmd() {
    vcs_info
    print -Pn "\e]0;Terminal\a"
}

# Setup cli tools
eval "$(zoxide init zsh)" # zoxide
eval "$(fzf --zsh)"       # fzf key bindings and fuzzy completion for zsh

# Config for Cli tools (ensure that fd is installed)
export BAT_THEME="base16" # Setup Default Bat Theme

# fzf fuzzy find
export FZF_DEFAULT_COMMAND="fd --hidden --strip-cwd-prefix --exclude .git "
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"                                  # default fzf (folders and files)
export FZF_ALT_C_COMMAND="fd --type=d --hidden --strip-cwd-prefix --exclude .git" # fzf navigate to folders

# default fzf settings
export FZF_DEFAULT_OPTS="--height 50% --layout=reverse --border=rounded --preview-window=border-rounded --info=right --cycle --prompt='▶ ' --color=bg+:#311d42,gutter:#272045,hl:#26f96b,fg:#b267e6,bg:-1,hl+:#26f96b,fg+:#b267e6,pointer:#b267e6,prompt:#f92672,border:#b267e6,query:#b267e6,info:#272045,spinner:#f9a826,scrollbar:#b267e6,separator:#272045,label:#b267e6"
export FZF_CTRL_T_OPTS="--preview 'bat --theme='base16' --color=always -n --line-range :500 {}' --border-label=' fuzzy find '"
export FZF_ALT_C_OPTS="--preview 'eza --icons=always --tree --color=always {} | head -200' --border-label=' change directory '"

# eza - next level ls (dir)
alias ls="eza --no-filesize --no-permissions --all --color=always --icons=never --no-user"
alias la="eza --long --group-directories-first --group --all --color=always --icons=never --no-user"
alias lt="&& eza --no-filesize --tree --color=always --icons=never"
alias ll="eza --no-filesize --color=always --icons=never --width 1"
alias ld="eza --only-dirs"
alias lf="eza --only-files"

# NVM Configuration (commented out - uncomment if needed)
# export NVM_DIR="$HOME/.nvm"
# [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm
# [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/nvm.sh" # loads nvm bash_completion (zsh uses different completion)

# Prompt Setup (oh-my-posh or starship)
eval "$(oh-my-posh init zsh --config $HOME/.config/ohmyposh/zitchdog.toml)" # oh my posh
# eval "$(starship init zsh)" # Initialize starship

# Note: If using oh-my-posh or starship, they will override the custom PROMPT set above
# Comment out the custom PROMPT section if you want to use oh-my-posh/starship exclusively

# Startup
# colorscript -e blocks1 # displays a random colorscript on startup
