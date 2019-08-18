{ config, pkgs, ... }:
{
  imports = [ <home-manager/nix-darwin> ];

  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.android_sdk.accept_license = true;

  # $ nix-env -qaP | grep wget
  environment.systemPackages =
    with pkgs; [
      ansible
      antibody
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
    promptInit=''
      zstyle :prompt:pure:path color cyan
         # from https://gist.github.com/oshybystyi/2c30543cd48b2c9ecab0
      EMOJI=(🐦 🚀 🎨 🍕 🐭 ☕️ 🔬 🐷 🐼 🐶 🐧 🐳 🍔 🍻 🔮 💰 💎 💾 💜 🍪 🌞 🌍 🐌 🐓 🐏 ✈️ )
      function random_emoji {
        echo -n "$EMOJI[$RANDOM%$#EMOJI+1]"
      }
      setopt PROMPT_SUBST
      PROMPT="$(random_emoji)"
      '';
    shellInit = ''
      export PATH=$PATH:$GOPATH/bin
      alias ec='emacsclient -c'
      alias ds='darwin-rebuild switch'
      alias simple-serve='python -m SimpleHTTPServer 8000'
      source <(antibody init)
      antibody bundle < ~/.zsh_plugins.txt
      '';

  };

  services.emacs.enable = true;
  environment.variables = {
    # General
    HOME = "/Users/bsunter";
    GOROOT = "/usr/local/opt/go/libexec";
    GOPATH = "$HOME/code/go";
    GOWORKSPACE = "$GOPATH/src/github.com/bsunter";
    PAGER = "less -R";
    EDITOR = "emacsclient";
    RUST_SRC_PATH="${pkgs.rustPlatform.rustcSrc}";
    ANDROID_SDK_ROOT="/usr/local/share/android-sdk";
    ANDROID_NDK_HOME="/usr/local/share/android-ndk";

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
map <Space> <Leader> " Space to leader
set number                 " show line numbers
map <silent> <Leader>ft :NERDTreeToggle<CR>
filetype plugin indent on  " Load plugins according to detected filetype.
syntax on                  " Enable syntax highlighting.

set autoindent             " Indent according to previous line.
set expandtab              " Use spaces instead of tabs.
set softtabstop =2         " Tab key indents by 2 spaces.
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
        '';
        packages.myVimPackage = with pkgs.vimPlugins; {
          # see examples below how to use custom packages
          start = [ fugitive vim-polyglot vim-markdown vim-gitgutter];
          opt = [ ];
        };
      };
    };
    home.file = {
      ".zsh_plugins.txt".text = ''
aswitalski/oh-my-zsh-sensei-git-plugin
caarlos0/zsh-mkc
caarlos0/zsh-open-github-pr
djui/alias-tips
mafredri/zsh-async
pbar1/zsh-terraform
sindresorhus/pure
webyneter/docker-aliases
wting/autojump
zsh-users/zsh-autosuggestions
zsh-users/zsh-completions
zsh-users/zsh-history-substring-search
zsh-users/zsh-syntax-highlighting
'';
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
