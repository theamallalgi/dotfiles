# Custom prompt settings
PROMPT_DIRTRIM=1                            # Shorten deep paths in the prompt

PS1='\[\033]0;Terminal\007\]'               # set window title

# PS1="$PS1"'\n'                            # new line

PS1="$PS1"'\[\033[32m\]amal'                # green text (name)
PS1="$PS1"'\[\033[35m\] ϟ '                 # purple text (➜ symbol)
PS1="$PS1"'\[\033[33m\][ '			        # yellow text (bracket)
PS1="$PS1"'\[\033[31m\]\w'                  # red text (working directory)
PS1="$PS1"'\[\033[33m\] ]'			        # yellow text (bracket)

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
PS1="$PS1"'\[\033[0m\]'                     # change color
# PS1="$PS1"'\n'                            # new line
PS1="$PS1"'\[\033[32m\] : '                 # prompt: ($, :)
PS1="$PS1"'\[\033[37m\]'                    # white text (default text) 

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
