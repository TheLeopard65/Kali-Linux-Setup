# ~/.bashrc: executed by bash(1) for non-login shells.

# If not running interactively, don't do anything
case $- in
    *i*) ;;
    *) return;;
esac

# Don't put duplicate lines or lines starting with space in the history
HISTCONTROL=ignoreboth

# Append to the history file, don't overwrite it
shopt -s histappend

# Set history size
HISTSIZE=1000
HISTFILESIZE=2000

# Check window size after each command and update LINES and COLUMNS
shopt -s checkwinsize

# Enable color support for ls, less, and man
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    export LS_COLORS="$LS_COLORS:ow=30;44:" # fix ls color for folders with 777 permissions
    alias ls='ls --color=auto'
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
    alias diff='diff --color=auto'
    alias ip='ip --color=auto'
fi

# Set the prompt style
force_color_prompt=yes

# Choose whether the prompt will be multi-line or single line
PROMPT_ALTERNATIVE=oneline
NEWLINE_BEFORE_PROMPT=no

# Check for terminal type and adjust the prompt
if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
        color_prompt=yes
    else
        color_prompt=
    fi
fi

# Start defining the prompt
if [ "$color_prompt" = yes ]; then
    # Color codes for the prompt
    color_reset='\[\033[00m\]'           # Resets Color Back to Normal
    prompt_color='\[\033[1;37m\]'        # White (regular prompt color)
    info_color='\[\033[1;36m\]'          # Cyan (info color)
    user_color='\[\033[1;34m\]'          # Blue (user info color)
    host_color='\[\033[1;31m\]'          # Red (host color)
    path_color='\[\033[1;32m\]'          # Green (path color)
    bold_color='\[\033[0;1m\]'           # Makes Text Bold or Bright
    prompt_symbol='🔒'                   # Prompt Symbol for Normal User

    # If the user is root, change prompt colors and set different symbol
    if [ "$EUID" -eq 0 ]; then
        prompt_color='\[\033[1;31m\]'   # Red for root
        info_color='\[\033[1;31m\]'     # Red for root info
        prompt_symbol="💀"              # Skull emoji for root
    fi

    # Set the prompt for a one-line or multi-line style
    case "$PROMPT_ALTERNATIVE" in
        twoline)
        	PS1=$prompt_color'┌──${debian_chroot:+($debian_chroot)──}${VIRTUAL_ENV:+('$bold_color'$(basename $VIRTUAL_ENV)'$prompt_color')}('$user_color'\u'$host_symbol'\h'$prompt_color')-['$path_color'\w'$prompt_color']'$prompt_symbol'\n'$prompt_color'└─'$info_color'\$'$color_reset' ';;
        oneline)
            PS1=$prompt_color'(${VIRTUAL_ENV:+($(basename $VIRTUAL_ENV)) }${debian_chroot:+($debian_chroot)}'$user_color'\u'$info_color'@'$host_color'\h'$color_reset')-['$path_color'\w'$color_reset']$ ';;
    esac
else
    PS1='[\u@\h \w]\$ '
fi

# Set the terminal title (if supported)
case "$TERM" in
    xterm*|rxvt*|Eterm|gnome*|alacritty)
        PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
        ;;
    *)
        ;;
esac

# Enable programmable completion features
if ! shopt -oq posix; then
    if [ -f /usr/share/bash-completion/bash_completion ]; then
        . /usr/share/bash-completion/bash_completion
    elif [ -f /etc/bash_completion ]; then
        . /etc/bash_completion
    fi
fi

# Aliases
alias ll='ls -al'
alias llr='ls -alR'
alias la='ls -A'
alias l='ls -CF'
alias h='history'

# Commonly used commands
alias c='clear'
alias cd..='cd ..'
alias ..='cd ..'
alias ...='cd ../..'

# Set the color scheme for the less pager
export LESS_TERMCAP_mb=$'\E[1;31m'     # begin blink
export LESS_TERMCAP_md=$'\E[1;36m'     # begin bold
export LESS_TERMCAP_me=$'\E[0m'        # reset bold/blink
export LESS_TERMCAP_so=$'\E[01;33m'    # begin reverse video
export LESS_TERMCAP_se=$'\E[0m'        # reset reverse video
export LESS_TERMCAP_us=$'\E[1;32m'     # begin underline
export LESS_TERMCAP_ue=$'\E[0m'        # reset underline

# Set the default editor
export EDITOR=nano

# Make history more useful
shopt -s histappend        # Append to history file
export HISTCONTROL=ignoreboth  # Don't record duplicate commands
export HISTSIZE=1000        # Max number of history entries to keep
export HISTFILESIZE=2000    # Max number of history entries in the history file

# Adding some useful environment variables
export PATH=$PATH:/usr/local/bin:/opt/homebrew/bin

# Check if this is WSL2 and set the WSL-related environment
if grep -qEi "(Microsoft|WSL)" /proc/version &>/dev/null; then
    export WSL2=true
    # Custom WSL prompt modification (if any)
fi

# Check if the .bashrc_aliases file exists and source it if it does
if [ -f "$HOME/.bashrc_aliases" ]; then
    source "$HOME/.bashrc_aliases"
fi
