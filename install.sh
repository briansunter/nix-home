#!/usr/bin/env bash

mkdir -m 0755 -p /nix/var/nix/{profiles,gcroots}/per-user/$USER

which nix || sh <(curl https://nixos.org/nix/install) --daemon
ln -s  $ZSH/nixos/home.nix ~/.config/nixpkgs/home.nix
nix-channel --add https://github.com/rycee/home-manager/archive/master.tar.gz home-manager
nix-channel --add https://nixos.org/channels/nixpkgs-unstable
sudo nix-channel --update
nix-shell '<home-manager>' -A install
