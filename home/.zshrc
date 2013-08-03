HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
bindkey -e

autoload -Uz colors && colors
autoload -Uz compinit && compinit
autoload -Uz select-word-style && select-word-style bash

zstyle ':completion:*' verbose yes
zstyle ':completion:*:descriptions' format '%B%d%b'
zstyle ':completion:*:messages' format '%d'
zstyle ':completion:*:warnings' format 'No matches for: %d'
zstyle ':completion:*' group-name ''
#zstyle ':completion:*' menu select

setopt auto_cd        # cd by just specifying directory name.
setopt auto_pushd     # Every cd does pushd
setopt pushd_silent   # Don't show directory stack after pushd/popd.
setopt pushd_to_home  # Blank pushd goes home.
unsetopt listambiguous

zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}' # Case-insensitive tab completion.

alias ls="ls --color -h"
alias ll="ls -l"
alias la="ls -a"
alias lla="ls -la"
alias lsr="ls -R"
alias llr="ll -R"
alias lar="la -R"
alias llar="lla -R"
alias dir="ls"
alias l="ls"
alias lr="l -R"
alias vim="gvim"
alias start="nautilus"

clone() {
  gnome-terminal --working-directory=`pwd` >/dev/null 2>&1
}

# Ctrl+Delete: delete word after cursor
bindkey -M emacs '^[[3;5~' kill-word

# Ctrl+Backspace: delete word before cursor
bindkey '^?' backward-kill-word

# Ctrl+Arrows: move by word
bindkey ';5D' emacs-backward-word
bindkey ';5C' emacs-forward-word

# Ctrl+R: reverse history search
bindkey '^R' history-incremental-search-backward

# Ctrl+H: popd
cd_pop() {
  BUFFER='popd >/dev/null 2>&1'
  zle accept-line
}
zle -N cd_pop
bindkey "" cd_pop

# Set terminal title to user and directory.
function precmd {
  print -Pn "\e]0;%n@%m: %~\a"
}

source ~/.zsh/git-prompt/zshrc.sh
#ZSH_THEME_GIT_PROMPT_BRANCH="%{$fg[blue]%}"
#ZSH_THEME_GIT_PROMPT_CHANGED="%{$fg[blue]%}+"
git_super_status() {
  precmd_update_git_vars
  if [ -n "$__CURRENT_GIT_STATUS" ]; then
    STATUS="%{$fg[gray]%}:%{$fg[blue]%}$GIT_BRANCH%{$reset_color%}"
    #STATUS="$GIT_BRANCH"
	  if [ -n "$GIT_REMOTE" ]; then
		  STATUS="$STATUS%{$fg[green]%}+$GIT_REMOTE%{$reset_color%}"
	  fi
    if [ "$GIT_CLEAN" -ne "1" ]; then
      STATUS="$STATUS%{$fg_bold[green]%}⭑%{$reset_color%}"
    fi
    echo "$STATUS"
  fi
}

# SSH host tab completion.
h=()
if [[ -r ~/.ssh/config ]]; then
  h=($h ${${${(@M)${(f)"$(cat ~/.ssh/config)"}:#Host *}#Host }:#*[*?]*})
fi
if [[ -r ~/.ssh/known_hosts ]]; then
  h=($h ${${${(f)"$(cat ~/.ssh/known_hosts{,2} || true)"}%%\ *}%%,*}) 2>/dev/null
fi
if [[ $#h -gt 0 ]]; then
  zstyle ':completion:*:ssh:*' hosts $h
  zstyle ':completion:*:slogin:*' hosts $h
fi

# Sigils: ∙∘⋅⊕⊗⊙⊚▸⤷⤏⬩⬪⬫⬝⬞∫∻≈∼⋆→∶⦁᚛⠴ᣛ↬→⨯∞∊∝᛭᜶↣•⚬፥➟⤳§»¤@⌁
export PROMPT='%{$fg[yellow]%}%~%f%b$(git_super_status)%{$fg[white]%}⌁ %{$reset_color%}'
export EDITOR=vim

# Sublime Text-style Ctrl-T file editing
#------------------------------------------------------------------------
zmodload zsh/complist
bindkey -M menuselect '^M' .accept-line

_matcher_complete() {
  integer i=1
  (git ls-files 2>/dev/null || find .) | /usr/local/bin/matcher --limit 20 ${words[CURRENT]} | while read line; do
    if [[ "$EDITOR" = "" ]]; then
      compadd -U -2 -V $i -- "$line"
    else
      compadd -U -2 -P "$EDITOR " -V $i -- "$line"
    fi
    i=$((i+1))
  done
  compstate[insert]=menu
}

zle -C matcher-complete complete-word _generic
zstyle ':completion:matcher-complete:*' completer _matcher_complete
zstyle ':completion:matcher-complete:*' menu select interactive
zstyle ':completion:matcher-complete:*' matcher-list 'm:{a-z}={A-Z}'

bindkey '^T' matcher-complete
#------------------------------------------------------------------------
