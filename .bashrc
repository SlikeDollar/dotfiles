alias ..='cd ..'
alias ls='exa --icons -l'
alias ll='ls -a'
alias grep='grep --colour=auto'
alias cp="cp -i"
alias df='df -h'
alias free='free -m'
alias nrs="sudo nixos-rebuild switch -I nixos-config=/home/slikedollar/.dotfiles-nix/configuration.nix"
alias ngc="sudo nix-collect-garbage --delete-old"
alias !="sudo"
alias tsp="ts"
alias yt="yt-dlp"
alias yta="yt-dlp --config-locations=~/.config/yt-dlp/audioconfig"

alias mpv="devour mpv"
alias zathura="devour zathura"
alias feh="devour feh"

# Configs
alias config-xmonad="nvim ~/.config/xmonad/xmonad.hs"
alias config-nvim="nvim ~/.config/nvim/"
alias config-nixos="sudo nvim /etc/nixos/configuration.nix"

# Parametr aliases
brightness() {
  percent=$1
  brightness=$((percent * 1515 / 100))
  sudo bash -c "echo $brightness > /sys/class/backlight/intel_backlight/brightness"
}

export PATH="/home/slikedollar/.local/bin:$PATH"
