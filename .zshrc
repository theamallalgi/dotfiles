# ~/.zshrc - configuration file for zsh sessions
# NOTE: plugins are cloned into ~/.zsh/ - see the plugins section

# Environment Variables
export PATH="$HOME/.local/bin:$PATH"                 # prepend local user bin to PATH
export TMUX_CONF="$HOME/.config/tmux/tmux.conf"      # tmux config file location
export RIPGREP_CONFIG_PATH="$HOME/.config/rg/config" # ripgrep config file location
export KITTY_LISTEN_ON=unix:/tmp/mykitty             # kitty terminal remote control socket
export SUDO_EDITOR=nvim                              # set neovim as the sudo editor
export VISUAL=nvim                                   # visual editor (used by tools that open a full-screen editor)
export EDITOR=nvim                                   # default editor (used by tools that just need a line/file editor)
export BAT_THEME="base16"                            # setup default bat theme
# export MANPAGER="sh -c 'col -bx | bat -l man -p'"  # use bat pager to color less/man pages

# Custom Location Variables
export nv="$ad/Local/nvim/"
export ds="$HOME/Desktop/"
export dot="$HOME/dotfiles/"
export bs="$HOME/.zshrc"
export td="$HOME/.config/todo/todo.txt"

# Shell Options
setopt HIST_IGNORE_DUPS   # don't record duplicate commands
setopt HIST_FIND_NO_DUPS  # don't show duplicates in search
setopt SHARE_HISTORY      # share history between sessions
setopt APPEND_HISTORY     # append to history file
setopt INC_APPEND_HISTORY # add commands as they are typed
setopt AUTO_CD            # change directory without cd command
setopt GLOB_DOTS          # include hidden files in globbing
setopt EXTENDED_GLOB      # extended globbing (similar to bash's globstar)
setopt CORRECT            # command correction (similar to bash's cdspell)
setopt PROMPT_SUBST       # enable prompt substitution

# History Configuration
HISTFILE=~/.zsh_history
HISTSIZE=99999
SAVEHIST=99999

# NOTE: vi mode in zsh, you end up asking for more and install bloat.
# bindkey -v  # enable vi mode (don't)
# bindkey -e # enable emacs mode (default)

# Completion System
autoload -Uz compinit
compinit

zstyle ':completion:*' menu select                         # enable completion menu selection with highlighting
zstyle ':completion:*' list-colors 'ma=48;5;235;38;5;99;1' # custom highlight: #272045 bg, #8543e4 fg, bold
zstyle ':completion:*:*:*:*:*' menu select                 # highlight current selection in completion menu
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'  # case insensitive completion
zstyle ':completion:*' use-cache on                        # enable completion caching
zstyle ':completion:*' cache-path ~/.zsh/cache             # enable completion caching
# bindkey -M menuselect '^[[Z' reverse-menu-complete       # shift+tab to go backwards
# bindkey -M menuselect '^M' accept-line                   # enter to accept

# Aliases
alias cic='setopt nocaseglob'                 # case-insensitive globbing
alias mkdir='mkdir -pv'                       # creates directories and parents verbosely
alias cp='cp -iv'                             # interactive + verbose copy
alias mv='mv -iv'                             # interactive + verbose move
alias c="clear && colorBar"                   # color script reset (colorBar - custom)
alias watch="sass --style compressed --watch" # watches and compiles sass in real time
alias sb="clear && source ~/.zshrc"           # clears and sources the zshrc file
alias vi="nvim"                               # neovim
alias vs="sudoedit"                           # opens the sudo editor (neovim)
alias mx="tmux"                               # alias for the terminal multiplexer (tmux)
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
alias cht="$dot/scripts/cht.sh"               # cht.sh script; example - cht golang:slice
# alias help="run-help"                       # set bash like help command

# eza - next level ls (dir)
alias ls="eza --no-filesize --no-permissions --all --color=always --icons=never --no-user --group-directories-first"
alias la="eza -lagm@ --all --icons=never --no-user --group-directories-first"
alias lt="eza --no-filesize --tree --color=always --icons=never"
alias ll="eza --no-filesize --color=always --icons=never --width 1"
alias ld="eza --only-dirs"
alias lf="eza --only-files"

# Git Aliases
alias gc="git clone"                                                                                 # clones a git repo
alias gw="git commit -m"                                                                             # commits a change
alias ga="git add"                                                                                   # prepare files for staging
alias gs="git status"                                                                                # shows the local status
alias gp="git push"                                                                                  # pushes the staged changes
alias gP="git pull"                                                                                  # pulls from the repo
alias gg="lazygit"                                                                                   # opens lazygit
alias gl="git log --all --graph --pretty=format:'%C(magenta)%h %C(white)%an  %ar%C(auto)  %D%n%s%n'" # fancier git log

# Global Aliases
alias -g C='| wl-copy'         # copy output to clipboard
alias -g J='| jq'              # pipe to jq
alias -g L='| less'            # pipe to pager (less)
alias -g NE='2>/dev/null'      # redirect stderr to /dev/null
alias -g NO='>/dev/null'       # redirect stdout to /dev/null
alias -g NUL='>/dev/null 2>&1' # redirect both stdout and stderr to /dev/null

# Fuzzy Finder Aliases
# alias fc='cd $(fzf --preview='bat')'
# alias vif='vi $(fzf --preview='bat')'
# alias vimf='vim $(fzf --preview='bat')'

# Key Bindings
bindkey ' ' magic-space     # expands history expressions like !! or !$ when you press space
# bindkey -s '^L' 'clear\n' # fix tmux clear screen issue

autoload -Uz edit-command-line   # open the current command in your $EDITOR
zle -N edit-command-line
bindkey '^X^E' edit-command-line # INFO: press ctrl+x followed by ctrl+e to trigger

autoload -Uz zmv            # use advanced batch rename/move
# zmv '(*).log' '$1.txt'    # rename .log to .txt
# zmv -w '*.log' '*.txt'    # same thing, simpler syntax
# zmv -n '(*).log' '$1.txt' # dry run (preview changes)
# zmv -i '(*).log' '$1.txt' # interactive mode (confirm each)

bindkey -s '^g' 'rgs\n' # search through files using ripgrep with (ctrl + g), see rgs() below

function help(){ bash -c "help $@" } # enable and setup bash help command

# Hooks
# INFO: chpwd hooks run automatically every time the working directory changes.
# using add-zsh-hook (instead of defining chpwd() directly) lets multiple
# functions listen on the same event without overwriting each other, so
# each one below can be added, removed, or reordered independently.
function auto_venv() { # auto-activate python virtual environments
	# if already in a virtualenv, do nothing
	if [[ -n "$VIRTUAL_ENV" && "$PWD" != *"${VIRTUAL_ENV:h}"* ]]; then
		deactivate
		return
	fi
	[[ -n "$VIRTUAL_ENV" ]] && return
	local dir="$PWD"
	while [[ "$dir" != "/" ]]; do
		if [[ -f "$dir/.venv/bin/activate" ]]; then
			source "$dir/.venv/bin/activate"
			return
		fi
		dir="${dir:h}"
	done
}
function auto_nix() { # auto-load nix development shells
	# if we're already in a nix develop shell, do nothing
	[[ -n "$IN_NIX_SHELL" ]] && return
	# walk up to find a flake
	local dir="$PWD"
	while [[ "$dir" != "/" ]]; do
		if [[ -f "$dir/flake.nix" ]]; then
			# if this project already has .envrc, just allow it (you can remove this if you prefer)
			if [[ ! -f "$dir/.envrc" ]]; then
				# create .envrc that loads the dev env (fast, no interactive shell)
				cat >"$dir/.envrc" <<'EOF'
# autogenerated: load flake dev environment
eval "$(nix print-dev-env)"
EOF
				command direnv allow "$dir" >/dev/null 2>&1
			fi
			command direnv reload >/dev/null 2>&1
			return
		fi
		dir="${dir:h}"
	done
}
function auto_nvm() { # auto-use correct node version with nvm
	[[ -f .nvmrc ]] && nvm use
}
# add-zsh-hook registers a function against a hook event (here: chpwd)
# without clobbering any other function already registered on it
autoload -Uz add-zsh-hook
add-zsh-hook chpwd auto_venv # activate matching .venv on cd
add-zsh-hook chpwd auto_nix  # load flake dev shell on cd
add-zsh-hook chpwd auto_nvm  # switch node version on cd

# Prompt Configuration
autoload -Uz vcs_info
zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:*' unstagedstr '*'
zstyle ':vcs_info:*' stagedstr '+'
zstyle ':vcs_info:git:*' formats ' %F{cyan}(%b%u%c)%f'
zstyle ':vcs_info:git:*' actionformats ' %F{cyan}(%b|%a%u%c)%f'

# precmd runs right before each prompt is drawn. all per-prompt work
# (git status refresh, window title) lives in this one function since
# defining precmd() again elsewhere would replace this one, not add to it
precmd() {
	vcs_info               # refresh git status options (zsh uses vcs_info instead of __git_ps1)
	print -Pn "\e]0;%1~\a" # set terminal window title to current directory, trimmed to 1 level
}

# NOTE: in zsh, %~ automatically trims path. %1~ shows only last directory (like PROMPT_DIRTRIM=1)
PROMPT='%F{green}%n%f'                      # green text (name)
PROMPT="$PROMPT%F{magenta} ϟ %f"            # magenta text (symbol)
PROMPT="$PROMPT%F{yellow}[ %f"              # yellow text (bracket)
PROMPT="$PROMPT%F{red}%1~%f"                # red text (working directory, trimmed to 1 level)
PROMPT="$PROMPT%F{yellow} ]%f"              # yellow text (bracket)
PROMPT="$PROMPT\$vcs_info_msg_0_"           # git info (cyan)
PROMPT="$PROMPT%(?.%F{green}.%F{red}) : %f" # green : if success, red : if failure
PROMPT="$PROMPT%F{green}"                   # default green text

# NOTE: if using oh-my-posh or starship, they will override the custom PROMPT set above.
eval "$(oh-my-posh init zsh --config $HOME/.config/ohmyposh/zitchdog.toml)"   # oh my posh
# eval "$(oh-my-posh init zsh --config $HOME/.config/ohmyposh/blue.toml)"     # oh my posh
# eval "$(starship init zsh)"                                                 # initialize starship

# less / man page colors
export LESS_TERMCAP_mb=$'\e[1;38;5;197m'          # blinking (rarely used) -> red
export LESS_TERMCAP_md=$'\e[1;38;5;135m'          # bold headings -> purple
export LESS_TERMCAP_me=$'\e[0m'
export LESS_TERMCAP_so=$'\e[1;48;5;63;38;5;230m'  # search/highlight -> cream on blue
export LESS_TERMCAP_se=$'\e[0m'
export LESS_TERMCAP_us=$'\e[1;38;5;36m'           # underlined text -> teal
export LESS_TERMCAP_ue=$'\e[0m'
export GROFF_NO_SGR=1

# Functions
mcd() { mkdir -p -- "$1" && cd -- "$1"; } # mcd: makes new dir and jumps inside

colorBar() { # INFO: call `colorBar`: output a color-strip
	local colors=(
		"\e[48;5;135m"
		"\e[48;5;63m"
		"\e[48;5;172m"
		"\e[48;5;197m"
		"\e[48;5;36m"
		"\e[48;5;33m"
	)
	local reset="\e[0m"
	local bar=""
	local segment="  "
	for color in "${colors[@]}"; do
		bar+="${color}${segment}"
	done
	echo -e "${bar}${reset}"
	echo ''
}

p() { # INFO: call `p command; p ls`: add padding before and after output
	# NOTE: does NOT work with aliases, keep it that way, cuz eval is a seq-risk
	echo ''
	"$@"
	echo ''
}

up() { cd $(printf '%0.s../' $(seq 1 $1)); } # call `up n; up 3`; go back n number of folders

rgs() { # search through files using ripgrep with (ctrl + g)
	rg --color=always --line-number --no-heading --smart-case "${1:-.}" |
		fzf --ansi \
			--delimiter : \
			--preview 'bat --theme=base16 --color=always -n --highlight-line {2} {1}' \
			--preview-window 'right:60%:+{2}-5:border-rounded' \
			--bind 'change:reload:rg --color=always --line-number --no-heading --smart-case {q} || true' \
			--bind 'enter:become(nvim {1} +{2})'
}

# add empty line before prompt(s)
# typeset -g _omp_first_prompt=1
# _omp_blank_line() {
#   if [[ -z "$_omp_first_prompt" ]]; then
#     print ""
#   else
#     _omp_first_prompt=
#   fi
# }
# autoload -Uz add-zsh-hook
# add-zsh-hook precmd _omp_blank_line

# Plugins
source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh         # autosuggestions (completions)
source ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh # syntax highlighting
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets)                        # highlight main and bracket matching

# NOTE: Instructions to install plugins from above:
# mkdir -p ~/.zsh
# git clone https://github.com/zsh-users/zsh-autosuggestions ~/.zsh/zsh-autosuggestions
# git clone https://github.com/zsh-users/zsh-syntax-highlighting ~/.zsh/zsh-syntax-highlighting

# FZF Configuration
# TODO: ensure that fd is installed for FZF_ALT_C_COMMAND to work
export FZF_DEFAULT_COMMAND="rg --files --hidden --glob '!.git'"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="fd --type=d --hidden --strip-cwd-prefix --exclude .git"
export FZF_DEFAULT_OPTS="--height 50% --layout=reverse --border=sharp --preview-window=border-sharp --info=right --cycle --prompt='➤ ' --color=bg+:#201638,preview-border:#201638,gutter:#201638,hl:#46cda8,fg:#8443e3,bg:-1,hl+:#46cda8,fg+:#8443e3,pointer:#8443e3,prompt:#e4374b,border:#542a91,query:#8443e3,info:#e49068,spinner:#e49068,scrollbar:#542a91,separator:#272045,label:#8443e3"
export FZF_CTRL_T_OPTS="--preview 'bat --theme='base16' --color=always -n --line-range :500 {}' --border-label=' fuzzy find '"
export FZF_ALT_C_OPTS="--preview 'eza --icons=always --tree --color=always {} | head -200' --border-label=' change directory '"

# Initialize Tools
eval "$(zoxide init zsh)" # initialize zoxide - better cd
eval "$(fzf --zsh)"       # fzf key bindings and fuzzy completion for zsh

# NVM Configuration
# export NVM_DIR="$HOME/.nvm"
# [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"          # this loads nvm
# [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/nvm.sh" # loads nvm bash_completion (zsh uses different completion)

# Startup
# colorscript -e blocks1 # displays a random colorscript on startup
colorBar                 # display the colorstrip on startup
