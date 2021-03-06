#!/usr/bin/env bash

# Install nix if it doesn't exist
if [ -z "$(nix})" ]; then
  sh <(curl https://nixos.org/nix/install)
fi

# Backup your old dotfiles
sudo mv /etc/zshrc /etc/zshrc.bak
sudo mv /etc/zprofile /etc/zprofile.bak

# Symlink the configuration in this folder
mkdir -p ~/.nixpkgs
ln -s "$(pwd)/darwin-configuration.nix" ~/.nixpkgs/darwin-configuration.nix
. ~/.nix-profile/etc/profile.d/nix.sh
mkdir -p /nix/var/nix/profiles/per-user/root/channels

# Add Channels
nix-channel --add https://github.com/rycee/home-manager/archive/release-19.03.tar.gz home-manager
nix-channel --add https://nixos.org/channels/nixpkgs-unstable
nix-channel --update

# Install nix-darwin
nix-build https://github.com/LnL7/nix-darwin/archive/master.tar.gz -A installer
./result/bin/darwin-installer
