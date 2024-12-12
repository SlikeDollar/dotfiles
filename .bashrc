alias ..='cd ..'
alias ls='exa --icons -l'
alias l='ls -a'
alias ll='ls -a'
alias grep='grep --colour=auto'
alias cp="cp -i"
alias df='df -h'
alias free='free -m'
alias cleanup='sudo pacman -Rns $(pacman -Qtdq)'
alias yt="yt-dlp"
alias yta="yt-dlp --config-locations=~/.config/yt-dlp/audioconfig"
alias clus="rm -r ~/.config/cmus/playlists/*"
alias 800x600="xrandr --output HDMI-A-0 --mode 800x600"
alias 1920x1080="xrandr --output HDMI-A-0 --mode 1920x1080"
alias dlbuffer="xclip -selection clipboard -t image/png -o > "

alias mpvd="devour mpv"
alias zathura="devour zathura"
alias feh="devour feh"

# Path Aliases
alias config-xmonad="nvim ~/.config/xmonad/xmonad.hs"
alias config-nvim="cd ~/.config/nvim && nvim ."
alias config-nixos="sudo nvim /etc/nixos/configuration.nix"
alias sc="cd ~/.local/bin/ ; ls"
alias bk="cd ~/.local/share/bookmarks/ ; ls"

# # ex - archive extractor
# # usage: ex <file>
ex ()
{
  if [ -f $1 ] ; then
    case $1 in
      *.tar.bz2)   tar xjf $1   ;;
      *.tar.gz)    tar xzf $1   ;;
      *.bz2)       bzip2 $1   ;;
      *.rar)       unrar x $1     ;;
      *.gz)        gunzip $1    ;;
      *.tar)       tar xf $1    ;;
      *.tbz2)      tar xjf $1   ;;
      *.tgz)       tar xzf $1   ;;
      *.zip)       unzip $1     ;;
      *.Z)         uncompress $1;;
      *.7z)        7z x $1      ;;
      *)           echo "'$1' cannot be extracted via ex()" ;;
    esac
  else
    echo "'$1' is not a valid file"
  fi
}

brightness() {
  percent=$1
  brightness=$((percent * 1515 / 100))
  sudo bash -c "echo $brightness > /sys/class/backlight/intel_backlight/brightness"
}

export PS1="\[\e[32m\][\u \w]\[\e[0m\] "
export EDITOR="nvim"
export PATH="/home/slikedollar/.local/bin:$PATH"
