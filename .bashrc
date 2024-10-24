#   ▄▄▄▄·  ▄▄▄· .▄▄ ·  ▄ .▄▄▄▄   ▄▄· 
#   ▐█ ▀█▪▐█ ▀█ ▐█ ▀. ██▪▐█▀▄ █·▐█ ▌▪
#   ▐█▀▀█▄▄█▀▀█ ▄▀▀▀█▄██▀▐█▐▀▀▄ ██ ▄▄
#   ██▄▪▐█▐█ ▪▐▌▐█▄▪▐███▌▐▀▐█•█▌▐███▌
# ▀ ·▀▀▀▀  ▀  ▀  ▀▀▀▀ ▀▀▀ ·.▀  ▀·▀▀▀ 

# # Aliases
alias cl="clear && colorscript" # clear command with colorscripts
alias colorscript="~/Colorscripts/colorscripts.sh" # colorscripts setup
alias c="clear && ~/Colorscripts/Scripts/./script-\(9\)" # color script reset
alias watch="sass --style compressed --watch" # watches and compiles sass in real time
alias sb="clear && source ~/.bashrc" # clears and sources the bashrc file
alias vim="neovide" # neovide
alias vi="nvim" # neovim
alias cat="bat" # better cat command
alias la="ls -al" # lists everything
alias lt="lsd --tree" # tree list view but with lsd
alias pc="clear && py" # clears the terminal and opens python
alias ..="cd ../" # goes back one level
# alias cd="z" # setsup zoxide as the cd command (must have it installed)

# # Git Aliases
alias gc="git clone"
alias gw="git commit -m"
alias ga="git add"
alias gs="git status"
alias gp="git push"

# # Location Aliases
alias home='cd /f/amal/'
alias dt="cd /f/amal/desktop"
alias dv="cd /f/amal/desktop/dev"
alias doc="cd /f/amal/documents"
alias dwn="cd /f/amal/downloads"
alias prj="cd /f/amal/documents/programming/my\ projects"
alias d="cd /f/amal/desktop && c"

# Fuzzy Finder Aliases
# alias fc='cd $(fzf --preview='bat')'
# alias vif='vi $(fzf --preview='bat')'
# alias vimf='vim $(fzf --preview='bat')'

# # Startup
# colorscript # display random colorscript each time
~/Colorscripts/Scripts/./script-\(9\) # display the 9th colorscript

# # Directory AutoCorrection
# # shopt -s cdspell

# # Directory Path Trim
export PROMPT_DIRTRIM=3

# # Enable the ** globstar recursive pattern in file and directory expansions.
# # For example, ls **/*.txt will list all text files in the current directory hierarchy.
# # shopt -s globstar

# # Ignore lines which begin with a <space> and match previous entries.
# # Erase duplicate entries in history file.
# HISTCONTROL=ignoreboth:erasedups

# # Ignore saving short- and other listed commands to the history file.
# # HISTIGNORE=?:??:history

# # The maximum number of lines in the history file.
# HISTFILESIZE=99999

# # The number of entries to save in the history file.
# HISTSIZE=99999

# # Set Bash to save each command to history, right after it has been executed.
PROMPT_COMMAND='history -a'

# # Save multi-line commands in one history entry.
# shopt -s cmdhist

# # Append commands to the history file, instead of overwriting it.
# # History substitution are not immediately passed to the shell parser.
# shopt -s histappend histverify

# export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
# [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # loads nvm bash_completion

# Prompt
PROMPT_DIRTRIM=1                            # Shorten deep paths in the prompt

export PS1='\[\033]0;Terminal\007\]'               # set window title

# PS1="$PS1"'\n'                            # new line

export PS1="$PS1"'\[\033[32m\]amal'                # green text (name)
PS1="$PS1"'\[\033[35m\] ϟ '                 # purple text (➜ symbol)
# Change symbols relative to last command
# export PS1="$PS1""\`if [ \$? = 0 ]; then echo '\[\033[35m\] ϟ '; else echo '\[\033[31m\] ϕ '; fi\`"
export PS1="$PS1"'\[\033[33m\][ '			        # yellow text (bracket)
export PS1="$PS1"'\[\033[31m\]\w'                  # red text (working directory)
export PS1="$PS1"'\[\033[33m\] ]'			        # yellow text (bracket)

if test -z "$WINELOADERNOEXEC"
then
    GIT_EXEC_PATH="$(git --exec-path 2>/dev/null)"
    COMPLETION_PATH="${GIT_EXEC_PATH%/libexec/git-core}"
    COMPLETION_PATH="${COMPLETION_PATH%/lib/git-core}"
    COMPLETION_PATH="$COMPLETION_PATH/share/git/completion"
    if test -f "$COMPLETION_PATH/git-prompt.sh"
    then
        . "$COMPLETION_PATH/git-completion.bash"
        . "$COMPLETION_PATH/git-prompt.sh"
        PS1="$PS1"'\[\033[36m\]'            # cyan text
        PS1="$PS1"'`__git_ps1`'             # bash function
    fi
fi
export PS1="$PS1"'\[\033[0m\]'                     # change color
# export PS1="$PS1"'\[\033[32m\] : '                 # prompt: ($, :)
export PS1="$PS1""\`if [ \$? = 0 ]; then echo '\[\033[32m\] : '; else echo '\[\033[31m\] : '; fi\`"
export PS1="$PS1"'\[\033[32m\]'                    # white text (default text) \[\033[37m\]

# Git status options
# Shows * or + for unstaged and staged changes, respectively.
export GIT_PS1_SHOWSTASHSTATE=true

# shows $ if there are any stashes.
export GIT_PS1_SHOWDIRTYSTATE=true

# Shows % if there are any untracked files.
export GIT_PS1_SHOWUNTRACKEDFILES=true

# shows <, >, <>, or = when your branch is behind, ahead, diverged from,
# or in sync with the upstream branch, respectively.
export GIT_PS1_SHOWUPSTREAM="auto"

# setup zoxide
eval "$(zoxide init bash)"

# Set up fzf key bindings and fuzzy completion
eval "$(fzf --bash)"

# initialize zsh at startup
# if [ -t 1 ]; then
#   exec zsh
# fi

# setup oh my posh
eval "$(oh-my-posh init bash --config $HOME/.config/ohmyposh/frozenembers.toml)"

. "$HOME/.cargo/env"
