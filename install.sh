#!/usr/bin/env bash
set -e

# ❌ Prevent running as root
if [ "$EUID" -eq 0 ]; then
  echo "❌ Do not run this script with sudo or as root"
  exit 1
fi

USER_NAME="$(whoami)"
USER_HOME="$HOME"
USER_SHELL="$(getent passwd "$USER_NAME" | cut -d: -f7)"

DOTFILES="$USER_HOME/.dotfiles"
BACKUP="$USER_HOME/.dotfiles-backup/$(date +%Y%m%d-%H%M%S)"

echo "👤 Running as user: $USER_NAME"

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

echo "🐚 Setting Zsh as default shell for $USER_NAME..."
ZSH_PATH="$(command -v zsh)"

if [ "$USER_SHELL" != "$ZSH_PATH" ]; then
  chsh -s "$ZSH_PATH"
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
backup_and_link "$DOTFILES/.zshrc" "$USER_HOME/.zshrc"
backup_and_link "$DOTFILES/.p10k.zsh" "$USER_HOME/.p10k.zsh"
backup_and_link "$DOTFILES/.gitconfig" "$USER_HOME/.gitconfig"
backup_and_link "$DOTFILES/.config" "$USER_HOME/.config"

echo "🧩 Installing Oh My Zsh..."
if [ ! -d "$USER_HOME/.oh-my-zsh" ]; then
  RUNZSH=no CHSH=no sh -c \
    "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

echo "🎨 Installing Powerlevel10k..."
P10K_DIR="${ZSH_CUSTOM:-$USER_HOME/.oh-my-zsh/custom}/themes/powerlevel10k"
if [ ! -d "$P10K_DIR" ]; then
  git clone https://github.com/romkatv/powerlevel10k.git "$P10K_DIR"
fi

echo "✅ Installation complete!"
echo "➡️  Log out and log back in to start using Zsh"
