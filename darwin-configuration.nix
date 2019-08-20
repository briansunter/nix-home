{ config, pkgs, ... }:
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
      gcc
      ghc
      gnupg
      gradle
      htop
      jq
      keybase
      leiningen
      minikube
      neovim
      nnn
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
      unzip
      vim
      wget
      youtube-dl
    ];

  system.defaults = {
    dock = {
      autohide = true;
      orientation = "right";
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
    promptInit='''';
  };

  services.emacs.enable = true;
  environment.variables = {
    # General
    HOME = "/Users/bsunter";
    GOROOT = "/usr/local/opt/go/libexec";
    GOPATH = "$HOME/code/go";
    GOWORKSPACE = "$GOPATH/src/github.com/bsunter";
    PAGER = "less -R";
    EDITOR = "nvim";
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
          rev = "1f93c05";
          sha256 = "1x0s5xlwhajgnlnb9mk0mnabhvhsf97xk05x79rdcxwmf041h3fd";
        };
        recursive = true;
      };
    };
  };

  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;
  nix.package = pkgs.nix;
  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;
  # You should generally set this to the total number of logical cores in your system.
  # $ sysctl -n hw.ncpu
  nix.maxJobs = 1;
  nix.buildCores = 12;
}
