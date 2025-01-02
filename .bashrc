#   ▄▄▄▄·  ▄▄▄· .▄▄ ·  ▄ .▄▄▄▄   ▄▄·
#   ▐█ ▀█▪▐█ ▀█ ▐█ ▀. ██▪▐█▀▄ █·▐█ ▌▪
#   ▐█▀▀█▄▄█▀▀█ ▄▀▀▀█▄██▀▐█▐▀▀▄ ██ ▄▄
#   ██▄▪▐█▐█ ▪▐▌▐█▄▪▐███▌▐▀▐█•█▌▐███▌
# ▀ ·▀▀▀▀  ▀  ▀  ▀▀▀▀ ▀▀▀ ·.▀  ▀·▀▀▀

# Aliases
alias cl="clear && colorscript -r"            # clear command with colorscripts
alias c="clear && colorscript -e zwaves"      # color script reset (zwaves)
alias watch="sass --style compressed --watch" # watches and compiles sass in real time
alias sb="clear && source ~/.bashrc"          # clears and sources the bashrc file
alias vim="neovide"                           # neovide
alias vi="nvim"                               # neovim
alias cat="bat"                               # better cat command
alias pc="clear && py"                        # clears the terminal and opens python
alias ..="cd ../"                             # goes back one level
alias x="exit"                                # well you can read can't you?
alias ex="explorer ."                         # opens the windows explorer
alias len="ls -1 | wc -l"                     # prints the count of elements in current folder
# alias la="ls -al"                           # lists everything
# alias lt="lsd --tree"                       # tree list view but with lsd
# alias cd="z"                                # setsup zoxide as the cd command (must have it installed)

# Git Aliases
alias gc="git clone"     # clones a git repo
alias gw="git commit -m" # commits a change
alias ga="git add"       # staches changes
alias gs="git status"    # shows the local status
alias gp="git push"      # pushes the staged changes
alias gP="git pull"      # pulls from the repo
alias gg="lazygit"       # opens lazygit

# Location Aliases
alias home='cd /f/amal/'                                  # home folder
alias dt="cd /f/amal/desktop"                             # desktop folder
alias dv="cd /f/amal/desktop/dev"                         # developer folder
alias doc="cd /f/amal/documents"                          # documents folder
alias dwn="cd /f/amal/downloads"                          # downloads folder
alias prj="cd /f/amal/documents/programming/my\ projects" # personal projects folder
alias d="dt && c"                                         # cds to desktop and clears the window

# Fuzzy Finder Aliases
# alias fc='cd $(fzf --preview='bat')'
# alias vif='vi $(fzf --preview='bat')'
# alias vimf='vim $(fzf --preview='bat')'

# Custom Location variables
export ad="$HOME/AppData"
export nv="$ad/Local/nvim/"
export ds="/f/amal/desktop"
export dot="/f/amal/desktop/dev/dotfiles"
export bs="$HOME/.bashrc"

# Directory AutoCorrection
shopt -s cdspell

# Directory Path Trim
export PROMPT_DIRTRIM=3

# Enable the ** globstar recursive pattern in file and directory expansions.
# For example, ls **/*.txt will list all text files in the current directory hierarchy.
shopt -s globstar

# Ignore saving short- and other listed commands to the history file.
# HISTIGNORE=?:??:history

# The maximum number of lines in the history file.
HISTFILESIZE=99999

# The number of entries to save in the history file.
HISTSIZE=99999

# # Set Bash to save each command to history, right after it has been executed.
PROMPT_COMMAND='history -a'

# Save multi-line commands in one history entry.
shopt -s cmdhist

# export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm
# [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # loads nvm bash_completion

# Prompt
PROMPT_DIRTRIM=1                     # Shorten deep paths in the prompt
export PS1='\[\033]0;Terminal\007\]' # set window title
export PS1="$PS1"'\[\033[32m\]amal'  # green text (name)
PS1="$PS1"'\[\033[35m\] ϟ '          # purple text (➜ symbol)
export PS1="$PS1"'\[\033[33m\][ '    # yellow text (bracket)
export PS1="$PS1"'\[\033[31m\]\w'    # red text (working directory)
export PS1="$PS1"'\[\033[33m\] ]'    # yellow text (bracket)

if test -z "$WINELOADERNOEXEC"; then
	GIT_EXEC_PATH="$(git --exec-path 2>/dev/null)"
	COMPLETION_PATH="${GIT_EXEC_PATH%/libexec/git-core}"
	COMPLETION_PATH="${COMPLETION_PATH%/lib/git-core}"
	COMPLETION_PATH="$COMPLETION_PATH/share/git/completion"
	if test -f "$COMPLETION_PATH/git-prompt.sh"; then
		. "$COMPLETION_PATH/git-completion.bash"
		. "$COMPLETION_PATH/git-prompt.sh"
		PS1="$PS1"'\[\033[36m\]' # cyan text
		PS1="$PS1"'`__git_ps1`'  # bash function
	fi
fi
export PS1="$PS1"'\[\033[0m\]' # change color
export PS1="$PS1""\`if [ \$? = 0 ]; then echo '\[\033[32m\] : '; else echo '\[\033[31m\] : '; fi\`"
export PS1="$PS1"'\[\033[32m\]' # white text (default text) \[\033[37m\]

# Git status options
export GIT_PS1_SHOWSTASHSTATE=true     # Shows * or + for unstaged and staged changes, respectively.
export GIT_PS1_SHOWDIRTYSTATE=true     # shows $ if there are any stashes.
export GIT_PS1_SHOWUNTRACKEDFILES=true # Shows % if there are any untracked files.
# shows <, >, <>, or = when your branch is behind, ahead, diverged from,
# or in sync with the upstream branch, respectively.
export GIT_PS1_SHOWUPSTREAM="auto"

# Setup cli tools
eval "$(zoxide init bash)"                                                       # zoxide
eval "$(fzf --bash)"                                                             # fzf key bindings and fuzzy completion
eval "$(oh-my-posh init bash --config $HOME/.config/ohmyposh/frozenembers.toml)" # oh my posh
alias cs="colorscript"                                                           # color script cli

# Config for Cli tools (ensure that fd is installed)
# fzf fuzzy find
export FZF_DEFAULT_COMMAND="fd --hidden --strip-cwd-prefix --exclude .git "
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"                                  # default fzf (folders and files)
export FZF_ALT_C_COMMAND="fd --type=d --hidden --strip-cwd-prefix --exclude .git" # fzf navigate to folders
# default fzf settings
export FZF_DEFAULT_OPTS="--height 50% --layout=reverse --border=rounded --preview-window=border-rounded --no-scrollbar --info=right --cycle --prompt='▶ ' --color=bg+:#311d42,gutter:-1,hl:#26f96b,fg:#b267e6,bg:-1,hl+:#26f96b,fg+:#b267e6,pointer:#b267e6,prompt:#f92672,border:#b267e6,query:#b267e6,info:#4e2d65,spinner:#f9a826,scrollbar:#4e2d65,scrollbar:#4e2d65,separator:#4e2d65,label:#b267e6"
export FZF_CTRL_T_OPTS="--preview 'bat --theme='aura-theme' --color=always -n --line-range :500 {}' --border-label=' fuzzy find '"
export FZF_ALT_C_OPTS="--preview 'eza --icons=always --tree --color=always {} | head -200' --border-label=' change directory '"
# eza - next level ls (dir)
# options :  --no-filesize --no-time --no-permissions --long
alias ls="eza --no-filesize --no-permissions --all --color=always --icons=never --no-user"
alias la="eza --no-filesize --long --header --group-directories-first --group --all --color=always --icons=always --no-user"
alias lt="eza --no-filesize --tree --color=always --icons=always"

# Startup
colorscript --random # displays a random colorscript on startup

# initialize zsh at startup
# if [ -t 1 ]; then
#   exec zsh
# fi

# setup env variables
. "$HOME/.cargo/env" # cargo env variables

# starship prompt
# eval "$(starship init bash)"
