#!/bin/bash
# mcgillij ~/.bashrc

set -o vi # vi mode

export CHROOT=$HOME/chroot # Where I build my arch packages
export MESA_WHICH_LLVM=1 # used to build mesa-git

export GTK_THEME=Dracula
export EDITOR=nvim
export FONTCONFIG_PATH=/etc/fonts


# PATH Shenanigans for my tooling
# add path to my own scripts
if [ -d "$HOME/bin" ] && (! echo "$PATH" | grep -q "$HOME/bin"); then
    export PATH="$HOME/bin:$PATH"
fi

if [ -d "$HOME/.local/bin" ] && (! echo "$PATH" | grep -q "$HOME/.local/bin"); then
    export PATH="$HOME/.local/bin:$PATH"
fi

if [ -d "$HOME/.cargo/bin" ] && (! echo "$PATH" | grep -q "$HOME/.cargo/bin"); then
    export PATH="$HOME/.cargo/bin:$PATH"
fi

if [ -d "$HOME/.pyenv/bin" ] && (! echo "$PATH" | grep -q "$HOME/.pyenv/bin"); then
    export PYENV_ROOT="$HOME/.pyenv"
    export PATH="$PYENV_ROOT/bin:$PATH"
    eval "$(pyenv init --path)"
    if command -v pyenv >/dev/null; then eval "$(pyenv init -)"; fi
fi

# History Settings to make fzf more useful
export HISTCONTROL=ignoredups
export HISTSIZE=-1 # unlimited
export HISTFILESIZE=-1 # unlimited

# Custom commands for setting CPU Governor
alias performance_mode='echo performance | sudo tee /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor'
alias powersave_mode='echo powersave | sudo tee /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor'
alias schedutil_mode='echo schedutil | sudo tee /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor'
alias cpu_frequency_watch='watch -n.5 "cat /proc/cpuinfo | grep \"^[c]pu MHz\""'

# Regular aliases
alias more='less -r'
alias cat='bat'
alias tls='tmux ls'
alias grep='grep --color=auto'
alias diff='difft --color=auto'
alias dmesg='dmesg --color=always'
alias virsh='virsh -c qemu:///system'
alias ag='batgrep' # just muscle memory
alias ls='exa --icons'
alias ll='exa --long --git --header --icons'
alias lt='exa --tree --icons'
alias tmux="tmux -2"
alias discord='discord-canary'

# To make my tmux behave with colors
export TERM="xterm-256color"
# fzf settings
export FZF_TMUX=1

# Arch make
nprocs=$(nproc)
export MAKEFLAGS="-j$nprocs"
export PAGER='less -r'

# setup ssh agent
eval $(ssh-agent -s) > /dev/null 2>&1
ssh-add ~/.ssh/id_ed25519 > /dev/null 2>&1

# Dracula man page theme
man() {
    env LESS_TERMCAP_mb=$'[01;31m' \
        LESS_TERMCAP_md=$'[01;33;5;74m' \
        LESS_TERMCAP_me=$'[0m' \
        LESS_TERMCAP_se=$'[0m' \
        LESS_TERMCAP_so=$'[38;5;246m' \
        LESS_TERMCAP_ue=$'[0m' \
        LESS_TERMCAP_us=$'[04;39;5;146m' \
        man "$@"
    }

##-----------------------------------------------------
## synth-shell-greeter.sh
if [ -f /home/j/.config/synth-shell/synth-shell-greeter.sh ] && [ -n "$( echo $- | grep i )" ]; then
    source /home/j/.config/synth-shell/synth-shell-greeter.sh
fi

##-----------------------------------------------------
## synth-shell-prompt.sh
if [ -f /home/j/.config/synth-shell/synth-shell-prompt.sh ] && [ -n "$( echo $- | grep i )" ]; then
    source /home/j/.config/synth-shell/synth-shell-prompt.sh
fi

# Dracula in my fzf
#
export FZF_DEFAULT_OPTS='--color=fg:#f8f8f2,bg:#282a36,hl:#bd93f9 --color=fg+:#f8f8f2,bg+:#44475a,hl+:#bd93f9 --color=info:#ffb86c,prompt:#50fa7b,pointer:#ff79c6 --color=marker:#ff79c6,spinner:#ffb86c,header:#6272a4'

export FZF_CTRL_T_OPTS="--preview '[[ \$(file --mime {}) =~ binary ]] &&
    echo {} is a binary file ||
    (bat --style=numbers --color=always {} ||
    highlight -O ansi -l {} ||
    cat {}) 2> /dev/null | head -500' --preview-window=right:60%"
export FZF_CTRL_R_OPTS="--preview 'bat --style=numbers --color=always --line-range :500 {}' --preview-window down:3:hidden:wrap --bind '?:toggle-preview'"
export FZF_ALT_C_OPTS="--preview 'tree -C {} | head -200'"

# FZF to replace CTRL-R and add Alt-C and Ctrl-T
[ -r /usr/share/fzf/key-bindings.bash ] && source /usr/share/fzf/key-bindings.bash
[ -r /usr/share/fzf/completion.bash ] && source /usr/share/fzf/completion.bash
[ -r /home/j/gits/fzf-tab-completion/bash/fzf-bash-completion.sh ] && source /home/j/gits/fzf-tab-completion/bash/fzf-bash-completion.sh

bind -x '"\t": fzf_bash_completion'

_fzf_compgen_path() {
    fd --hidden --follow --exclude ".git" . "$1"
}

# Use fd to generate the list for directory completion
_fzf_compgen_dir() {
    fd --type d --hidden --follow --exclude ".git" . "$1"
}

# load all the bash completions
[ -r /usr/share/bash-completion/bash_completion   ] && source /usr/share/bash-completion/bash_completion

# git completion
[ -r /usr/share/git/completion/git-completion.bash ] && source /usr/share/git/completion/git-completion.bash


# docker alias for rocm/pytorch
alias drun='sudo docker run -it --network=host --device=/dev/kfd --device=/dev/dri --group-add=video --ipc=host --cap-add=SYS_PTRACE --security-opt seccomp=unconfined -v $HOME/dockerx:/dockerx'
