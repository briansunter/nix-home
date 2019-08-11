{ pkgs, ... }:
with import <nixpkgs> {};

{
  nixpkgs.config.allowUnfree = true;

  programs.zsh.enable = true;

  home.sessionVariables = {
   RUST_SRC_PATH="${pkgs.rustPlatform.rustcSrc}";
   PS1 = "🐟";
  };

  home.packages = [
     # pkgs.firefox
    # pkgs.texlive.combined.scheme-tetex
    # pkgs.vscode
    # pkgs.anki
    pkgs.fzf
    pkgs.pydf
    pkgs.rustracer
    pkgs.aria2
    pkgs.nnn
    pkgs.streamlink
    pkgs.antibody
    pkgs.burpsuite
    pkgs.cargo
    pkgs.emacs
    pkgs.fortune
    pkgs.nodejs-12_x
    pkgs.gcc
    pkgs.ghc pkgs.cabal-install pkgs.stack
    pkgs.gnupg
    pkgs.go
    pkgs.gradle
    pkgs.htop
    pkgs.jq
    pkgs.leiningen
    pkgs.openjdk
    pkgs.pandoc
    pkgs.ripgrep
    pkgs.rustc
    pkgs.rustfmt
    pkgs.unzip
    pkgs.wget
    pkgs.youtube-dl
  ];

  home.file = {
    ".emacs.d" = {
      source = fetchFromGitHub {
        owner = "syl20bnr";
        repo = "spacemacs";
        rev = "1f93c05";
        sha256 = "1x0s5xlwhajgnlnb9mk0mnabhvhsf97xk05x79rdcxwmf041h3fd";
      };
      recursive = true;
    };
  };
  programs.home-manager = {
    enable = true;
    path = https://github.com/rycee/home-manager/archive/release-19.03.tar.gz;
  };
  programs.git = {
    enable = true;
    userName = "bsunter";
    userEmail = "public@briansunter.com";
  };
 programs.zsh.initExtra= ''
    if [ -e $HOME/.nix-profile/etc/profile.d/nix.sh ]; then . $HOME/.nix-profile/etc/profile.d/nix.sh; fi
'';
}
