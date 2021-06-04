# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;31m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# some more ls aliases
alias ll='ls -alF --color--group-directories-first'
alias la='ls -A'
alias l='ls -CF'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

[ -f ~/.fzf.bash ] && source ~/.fzf.bash

#LS_COLORS=$LS_COLORS:'di=1;44:' ; 
LS_COLORS='di=1;31:ln=36:su=1;96'

export EDITOR=vim
export HISTCONTROL='erasedups'
export HISTIGNORE="pass:ls:ll:l"

eval "$(fasd --init auto)"
alias ccopy="xclip -selection clipboard"
alias cls="echo -ne '\033c'"
alias cpaste="xclip -selection clipboard -o"
alias calc='python -ic "from __future__ import division; from math import *; from random import *"'
alias v='f -e vim'
alias o='f -e xdg-opn'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'
alias grep='grep --colour=auto'
alias l='ls -CF'
alias la='ls -A'
alias ll='ls --color=auto -Xlh'
alias ls='ls --color=auto'
alias ?='echo -e'
alias ed_bash='vim ~/.bashrc'
alias dir="ranger"
alias dayediff="dateutils.ddiff"
alias sql="sqlite3"
alias spavaj="systemctl suspend"
alias vimenize="~/vimenize.sh"
alias viz="~/vimenize.pl"
alias backup="~/dev/B_L_R_via_sshfs/backup.sh"
alias xspell="~/xspell.sh"
alias killpid="~/selKillPID.sh"
alias uvar="~/uvar.sh"
alias tm="~/tm.sh"
alias xspaell="~/xspell.sh"

powerline-daemon -q
POWERLINE_BASH_CONTINUATION=1
POWERLINE_BASH_SELECT=1
#. /home/will/.local/lib/python2.7/site-packages/powerline/bindings/bash/powerline.sh 
#export PAGER="/bin/sh -c "unset PAGER;col -b -x | vim -R -c 'set ft=man nomod nolist' -c 'map q :q<CR>' -c 'map <SPACE> <C-D>' -c 'map b <C-U>' \
#		-c 'nmap K :Man <C-R>=expand(\\"<cword>\\")<CR><CR>' -""
xmodmap /home/will/.capless > /dev/null 2>&1
#fortune | cowsay
#cal
#Shortens long path in prompt
#export PROMPT DIRTRIM=2
#if [ $TILIX_ID ] || [ $VTE_VERSION ]; then
 #       source /etc/profile.d/vte.sh
#fi


PATH="/home/will/go/bin:/home/will/perl5/bin:${PATH}"; export PATH;
PERL5LIB="/home/will/perl5/lib/perl5${PERL5LIB:+:${PERL5LIB}}"; export PERL5LIB;
PERL_LOCAL_LIB_ROOT="/home/will/perl5${PERL_LOCAL_LIB_ROOT:+:${PERL_LOCAL_LIB_ROOT}}"; export PERL_LOCAL_LIB_ROOT;
PERL_MB_OPT="--install_base \"/home/will/perl5\""; export PERL_MB_OPT;
PERL_MM_OPT="INSTALL_BASE=/home/will/perl5"; export PERL_MM_OPT;

[ -f ~/.fzf.bash ] && source ~/.fzf.bash

csview()
{
    local file="$1"
    cat "$file" | sed -e 's/,,/, ,/g' | column -s, -t | less -#5 -N -S
}

LS_COLORS=$LS_COLORS:'di=1;36:ow=4;33:ln=1;37' ; export LS_COLORS;
export FZF_DEFAULT_COMMAND='fdfind --type f'
source "$HOME/.cargo/env"

#Remove caps lock key
setxkbmap -option ctrl:nocaps

# Set the vi editor for multi line bash commands. Activated with [ESC]+v quit with :wq!
set -o vi
defw()    { curl dict://dict.org:/d:"$@":* | less; }
cheat()   { clear && curl cheat.sh/"$1" ; }
destroy() { shred "$1" && rm "$1"; }

cheat()   { clear && curl cheat.sh/"$1" ; }
destroy() { shred "$1" && rm "$1"; }

spellcheck(){ echo "$1 $2 $3 $4" | aspell -a | sed -n '1!p'; }
bind -x 'C-l: clear;'
