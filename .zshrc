# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

#Set the directory we want to store zinit and plugins
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

# Download Zinit, if it's not there
if [ ! -d "$ZINIT_HOME" ]; then
	mkdir -p "$(dirname $ZINIT_HOME)"
	git clone https://www.github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi 


eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

# Soruce/Load Zinit
source "${ZINIT_HOME}/zinit.zsh"

# Add Powerlevel10k
zinit ice depth=1; zinit light romkatv/powerlevel10k

# Add in zsh plugins
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit light Aloxaf/fzf-tab


# Load completions 
autoload -U compinit && compinit

# Keybindings
bindkey '^p' history-search-backward
bindkey '^n' history-search-forward
bindkey "^[[1;5D" backward-word
bindkey "^[[1;5C" forward-word


# Histroy
HISTSIZE=5000
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt appendHistory
setopt shareHistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups

# Completion styling
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-Z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no

# Aliases
alias ls='ls --color'

# Shell integrations
eval "$(fzf --zsh)"

### End of Zinit's installer chunk

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
typeset -g POWERLEVEL9K_INSTANT_PROMPT=quiet

# Nvim path
export PATH="/opt/nvim-linux64/bin:$PATH"

echo " ___       __   _______   ___       ________  ________  _____ ______   _______      "
echo "|\  \     |\  \|\  ___ \ |\  \     |\   ____\|\   __  \|\   _ \  _   \|\  ___ \     "
echo "\ \  \    \ \  \ \   __/|\ \  \    \ \  \___|\ \  \|\  \ \  \\\__\ \  \ \   __/|    "
echo " \ \  \  __\ \  \ \  \_|/_\ \  \    \ \  \    \ \  \\\  \ \  \\|__| \  \ \  \_|/__  "
echo "  \ \  \|\__\_\  \ \  \_|\ \ \  \____\ \  \____\ \  \\\  \ \  \    \ \  \ \  \_|\ \ "
echo "   \ \____________\ \_______\ \_______\ \_______\ \_______\ \__\    \ \__\ \_______\ "
echo "    \|____________|\|_______|\|_______|\|_______|\|_______|\|__|     \|__|\|_______|"
echo ""
echo "You are logged in as $USER - $(date)"
