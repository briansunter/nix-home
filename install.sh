#!/usr/bin/env bash

sh <(curl https://nixos.org/nix/install)
mkdir -p ~/.config/nixpkgs
ln -s "$(pwd)/home.nix" ~/.config/nixpkgs/home.nix
. ~/.nix-profile/etc/profile.d/nix.sh
export NIX_PATH=~/.nix-defexpr/channels${NIX_PATH:+:}$NIX_PATH

nix-channel --add https://github.com/rycee/home-manager/archive/release-19.03.tar.gz home-manager
nix-channel --add https://nixos.org/channels/nixpkgs-unstable
nix-channel --update
nix-shell '<home-manager>' -A install
