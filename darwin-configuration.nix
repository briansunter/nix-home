{ config,  pkgs, ... }:
let
  pureZshSrc = pkgs.fetchFromGitHub {
    owner = "sindresorhus";
    repo = "pure";
    rev = "ac72ba4eb274e7181b7db677838409adb190266e";
    sha256 = "0zjgnlw01ri0brx108n6miw4y0cxd6al1bh28m8v8ygshm94p1zx";
  };
  pureZsh = pkgs.stdenv.mkDerivation rec {
    name = "pure-zsh-${version}";
    version = "2017-03-04";
    src = pureZshSrc;
    installPhase = ''
      mkdir -p $out/share/zsh/site-functions
      cp pure.zsh $out/share/zsh/site-functions/prompt_pure_setup
      cp async.zsh $out/share/zsh/site-functions/async
    '';
  };
in
{
  imports = [ <home-manager/nix-darwin> ];
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.android_sdk.accept_license = true;

  # $ nix-env -qaP | grep wget
  environment.systemPackages =
    with pkgs; [
      ansible
      fasd
      antibody
      lastpass-cli
      aria2
      aws
      burpsuite
      cabal-install
      cargo
      emacs
      fortune
      fzf
      go
      ghc
      gnupg
      gradle
      htop
      jq
      keybase
      boot
      leiningen
      minikube
      neovim
      nnn
      nodePackages.node2nix
      nodejs-12_x
      openjdk
      pandoc
      pkgs.nodePackages.eslint
      pkgs.nodePackages.javascript-typescript-langserver
      pkgs.nodePackages.prettier
      pydf
      ripgrep
      rustc
      rustfmt
      rustracer
      stack
      streamlink
      terraform_0_12
      darwin.apple_sdk.frameworks.Cocoa
      darwin.apple_sdk.frameworks.Carbon
      go
      unzip
      vim
      wget
      pureZsh
      youtube-dl
    ];

  system.defaults = {
    dock = {
      autohide = false;
      orientation = "bottom";
      showhidden = true;
      mineffect = "scale";
      launchanim = false;
      show-process-indicators = true;
      tilesize = 48;
      static-only = true;
      mru-spaces = false;
    };
    finder = {
      AppleShowAllExtensions = true;
      FXEnableExtensionChangeWarning = false;
    };
    trackpad = {
      Clicking = true;
      TrackpadThreeFingerDrag = true;
    };
    NSGlobalDomain = {
      AppleKeyboardUIMode = 3;
      ApplePressAndHoldEnabled = false;
      InitialKeyRepeat = 25;
      KeyRepeat = 6;
      NSAutomaticCapitalizationEnabled = false;
      NSAutomaticDashSubstitutionEnabled = false;
      NSAutomaticPeriodSubstitutionEnabled = false;
      NSAutomaticQuoteSubstitutionEnabled = false;
      NSAutomaticSpellingCorrectionEnabled = false;
      NSNavPanelExpandedStateForSaveMode = true;
      NSNavPanelExpandedStateForSaveMode2 = true;
    };
  };

  system.keyboard = {
    enableKeyMapping = true;
    remapCapsLockToEscape= true;
  };

  networking.knownNetworkServices = ["Wi-Fi" "Bluetooth PAN" "Thunderbolt Bridge"];
  networking.dns = ["8.8.8.8" "8.8.8.4"];

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    enableBashCompletion = true;
    enableFzfHistory = true;
    enableSyntaxHighlighting = true;
    enableFzfGit = true;
    promptInit=''
    fpath+=( "${pureZsh.out}/share/zsh/site-functions" $fpath )
    autoload -U promptinit && promptinit
    prompt pure
    '';
    shellInit = ''
      export PATH="''$PATH:${pkgs.go}/bin";
      export PATH="''$PATH:${pkgs.boot}/bin";
      '';
  };

  services.emacs.enable = true;
  environment.variables = {
    # General
    HOME = "/Users/bsunter";
    RUST_SRC_PATH="${pkgs.rustPlatform.rustcSrc}";

    # History
    HISTSIZE = "1000";
    SAVEHIST = "1000";
    HISTFILE = "$HOME/.history";

    # Terminfo
    TERMINFO = "/usr/share/terminfo/";
  };

  users.users.bsunter.name = "Brian Sunter";
  home-manager.users.bsunter= { pkgs, ... }: {
    programs.neovim = {
      enable = true;
      configure = {
        packages.myVimPackage = with pkgs.vimPlugins; {
          # see examples below how to use custom packages
          start = [ fugitive vim-polyglot vim-markdown vim-gitgutter];
          opt = [ ];
        };
      };
    };
    home.file = {
      ".vimrc".text = (builtins.readFile ./.vimrc);
      ".zsh_plugins.txt".text = (builtins.readFile ./.zsh_plugins.txt);
      ".spacemacs".text = (builtins.readFile ./.spacemacs);
      ".zshrc".text = (builtins.readFile ./.zshrc);
      ".emacs.d" = {
        source = pkgs.fetchFromGitHub {
          owner = "syl20bnr";
          repo = "spacemacs";
          rev = "582f9aa";
          sha256 = "0m634adqnwqvi8d7qkq7nh8ivfz6cx90idvwd2wiylg4w1hly252";
        };
        recursive = true;
      };
    };
  };

  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = false;
  nix.package = pkgs.nix;
  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;
  # You should generally set this to the total number of logical cores in your system.
  # $ sysctl -n hw.ncpu
  nix.maxJobs = 1;
  nix.buildCores = 12;
}
