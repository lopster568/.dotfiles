#!/usr/bin/env bash
set -e

DOTFILES="$HOME/.dotfiles"
BACKUP="$HOME/.dotfiles-backup/$(date +%Y%m%d-%H%M%S)"

echo "🔐 Checking sudo access..."
sudo -v

echo "📦 Updating system..."
sudo apt update

echo "📦 Installing packages..."
sudo apt install -y \
  zsh \
  git \
  curl \
  wget \
  fzf \
  ripgrep \
  bat \
  neovim \
  fonts-firacode

echo "🐚 Setting Zsh as default shell..."
if [ "$SHELL" != "$(which zsh)" ]; then
  chsh -s "$(which zsh)"
fi

echo "📁 Creating backup directory..."
mkdir -p "$BACKUP"

backup_and_link () {
  local src="$1"
  local dest="$2"

  if [ -e "$dest" ] || [ -L "$dest" ]; then
    echo "🔁 Backing up $dest"
    mv "$dest" "$BACKUP/"
  fi

  echo "🔗 Linking $src → $dest"
  ln -s "$src" "$dest"
}

echo "🔗 Linking dotfiles..."
backup_and_link "$DOTFILES/.zshrc" "$HOME/.zshrc"
backup_and_link "$DOTFILES/.p10k.zsh" "$HOME/.p10k.zsh"
backup_and_link "$DOTFILES/.gitconfig" "$HOME/.gitconfig"
backup_and_link "$DOTFILES/.config" "$HOME/.config"

echo "🧩 Installing Oh My Zsh..."
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  RUNZSH=no CHSH=no sh -c \
    "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

echo "🎨 Installing Powerlevel10k..."
P10K_DIR="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"
if [ ! -d "$P10K_DIR" ]; then
  git clone https://github.com/romkatv/powerlevel10k.git "$P10K_DIR"
fi

echo "✅ Installation complete!"
echo "➡️  Restart your shell or log out/in to use Zsh"
