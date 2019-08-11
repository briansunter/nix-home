{ config, pkgs, ... }:
{
  imports = [ <home-manager/nix-darwin> ];

  nixpkgs.config.allowUnfree = true;
  # $ nix-env -qaP | grep wget
  environment.systemPackages =
    with pkgs; [
      vim
      neovim
      aws
      terraform_0_12
      keybase
      #anki
      ansible
      pkgs.nodePackages.javascript-typescript-langserver
      pkgs.nodePackages.eslint
      pkgs.nodePackages.prettier
      fzf
      pydf
      rustracer
      aria2
      nnn
      streamlink
      antibody
      burpsuite
      cargo
      emacs
      fortune
      nodejs-12_x
      gcc
      ghc
      cabal-install
      stack
      gnupg
      go
      gradle
      htop
      jq
      leiningen
      openjdk
      pandoc
      ripgrep
      rustc
      rustfmt
      unzip
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
    shellInit = ''
	    alias gs='git status'
	    alias gc='git commit'
            alias ga='git add'
            alias ec='emacsclient -c'
            alias ds='darwin-rebuild switch'
	    '';
promptInit = ''
    autoload -U promptinit && promptinit && prompt walters
    PS1='🐟 '
'';
  };

  system.stateVersion = 4;
  services.emacs.enable = true;
  environment.variables = {
    # General
    HOME = "/Users/bsunter";
    GOROOT = "${pkgs.go}/share/go";
    GOPATH = "$HOME/code/go";
    GOWORKSPACE = "$GOPATH/src/github.com/bsunter";
    PAGER = "less -R";
    EDITOR = "emacsclient";
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
        customRC = ''
filetype plugin indent on  " Load plugins according to detected filetype.
syntax on                  " Enable syntax highlighting.

set autoindent             " Indent according to previous line.
set expandtab              " Use spaces instead of tabs.
set softtabstop =4         " Tab key indents by 4 spaces.
set shiftwidth  =4         " >> indents by 4 spaces.
set shiftround             " >> indents to next multiple of 'shiftwidth'.

set backspace   =indent,eol,start  " Make backspace work as you would expect.
set hidden                 " Switch between buffers without having to save first.
set laststatus  =2         " Always show statusline.
set display     =lastline  " Show as much as possible of the last line.

set showmode               " Show current mode in command-line.
set showcmd                " Show already typed keys when more are expected.

set incsearch              " Highlight while searching with / or ?.
set hlsearch               " Keep matches highlighted.

set ttyfast                " Faster redrawing.
set lazyredraw             " Only redraw when necessary.

set splitbelow             " Open new windows below the current window.
set splitright             " Open new windows right of the current window.

set cursorline             " Find the current line quickly.
set wrapscan               " Searches wrap around end-of-file.
set report      =0         " Always report changed lines.
set synmaxcol   =200       " Only highlight the first 200 columns.

set list                   " Show non-printable characters.
set number                 " show line numbers
        '';
        packages.myVimPackage = with pkgs.vimPlugins; {
          # see examples below how to use custom packages
          start = [ fugitive vim-polyglot vim-markdown];
          opt = [ ];
        };      
      };
    };
    home.file = {
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
  # You should generally set this to the total number of logical cores in your system.
  # $ sysctl -n hw.ncpu
  nix.maxJobs = 1;
  nix.buildCores = 12;
}
