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
alias yt="yt-dlp"
alias yta="yt-dlp --config-locations=~/.config/yt-dlp/audioconfig"
alias clus="rm -r ~/.config/cmus/playlists/*"
alias 800x600="xrandr --output HDMI-A-0 --mode 800x600"
alias 1920x1080="xrandr --output HDMI-A-0 --mode 1920x1080"

alias mpvd="devour mpv"
alias zathura="devour zathura"
alias feh="devour feh"

# Path Aliases
alias config-xmonad="nvim ~/.config/xmonad/xmonad.hs"
alias config-nvim="nvim ~/.config/nvim/"
alias config-nixos="sudo nvim /etc/nixos/configuration.nix"
alias sc="cd ~/.local/bin/ ; ls"
alias bk="cd ~/.local/share/bookmarks/ ; ls"

#
brightness() {
  percent=$1
  brightness=$((percent * 1515 / 100))
  sudo bash -c "echo $brightness > /sys/class/backlight/intel_backlight/brightness"
}

export EDITOR="nvim"
export PATH="/home/slikedollar/.local/bin:$PATH"
