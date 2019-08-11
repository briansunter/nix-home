#!/usr/bin/env bash

sh <(curl https://nixos.org/nix/install)
mkdir -p ~/.nixpkgs
ln -s "$(pwd)/darwin-configuration.nix" ~/.nixpkgs/darwin-configuration.nix
. ~/.nix-profile/etc/profile.d/nix.sh
mkdir -p /nix/var/nix/profiles/per-user/root/channels

nix-channel --add https://github.com/rycee/home-manager/archive/release-19.03.tar.gz home-manager

nix-channel --add https://nixos.org/channels/nixpkgs-unstable
nix-channel --update
nix-build https://github.com/LnL7/nix-darwin/archive/master.tar.gz -A installer
./result/bin/darwin-installer
