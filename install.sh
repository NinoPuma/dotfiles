#!/usr/bin/env bash
set -euo pipefail

echo "Instalando dotfiles..."

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_DIR="$HOME/.config"
BACKUP_DIR="$HOME/dotfiles-backup-$(date +%Y%m%d-%H%M%S)"
MAKE_ZSH_DEFAULT=false

# --- Flags ---
for arg in "${@:-}"; do
  case "$arg" in
    --make-zsh-default) MAKE_ZSH_DEFAULT=true ;;
  esac
done

mkdir -p "$CONFIG_DIR" "$BACKUP_DIR"

# --- Helper para backup + symlink ---
backup_and_link() {
  local src=$1 dst=$2
  if [ -e "$dst" ] || [ -L "$dst" ]; then
    echo "Backup de $dst -> $BACKUP_DIR/"
    mv "$dst" "$BACKUP_DIR/"
  fi
  ln -sfn "$src" "$dst"
  echo "Enlazado $dst -> $src"
}

# --- Submódulos (plugins de zsh dentro del repo) ---
if command -v git >/dev/null 2>&1; then
  echo "Actualizando submódulos..."
  git -C "$REPO_DIR" submodule update --init --recursive
fi

# --- Starship ---
if ! command -v starship >/dev/null 2>&1; then
  echo "Instalando Starship..."
  curl -sS https://starship.rs/install.sh | sh -s -- -y
else
  echo "Starship ya está instalado."
fi

# --- Crear symlinks ---
[ -d "$REPO_DIR/kitty" ]  && backup_and_link "$REPO_DIR/kitty"  "$CONFIG_DIR/kitty"
[ -d "$REPO_DIR/nvim" ]   && backup_and_link "$REPO_DIR/nvim"   "$CONFIG_DIR/nvim"
[ -f "$REPO_DIR/zsh/.zshrc" ] && backup_and_link "$REPO_DIR/zsh/.zshrc" "$HOME/.zshrc"
[ -f "$REPO_DIR/starship/starship.toml" ] && backup_and_link "$REPO_DIR/starship/starship.toml" "$CONFIG_DIR/starship.toml"

echo "Backups guardados en: $BACKUP_DIR"

# --- Zsh por defecto (opcional) ---
if $MAKE_ZSH_DEFAULT; then
  if command -v zsh >/dev/null 2>&1; then
    if [ "${SHELL:-}" != "$(command -v zsh)" ]; then
      echo "Cambiando shell por defecto a zsh..."
      chsh -s "$(command -v zsh)" || echo "No se pudo cambiar el shell (quizá requiera reingreso)."
    fi
  else
    echo "zsh no está instalado. Instálalo con: sudo apt install -y zsh"
  fi
fi

echo "Instalación completa."
