{ config, pkgs, ... }:

{
  nixpkgs.config.allowUnfree = true;
  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages =
    with pkgs; [ 
    vim
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
  services.nix-daemon.enable = true;
programs.zsh = {
    enable = true;
    enableCompletion = true;
    enableBashCompletion = true;
    enableFzfHistory = true;
    enableSyntaxHighlighting = true;
};


  # Auto upgrade nix package and the daemon service.
  # services.nix-daemon.enable = true;
  # nix.package = pkgs.nix;

  # Create /etc/bashrc that loads the nix-darwin environment.

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;
services.emacs.enable = true;
  environment.variables = {
    # General
    HOME = "/Users/bsunter";
    GOROOT = "${pkgs.go}/share/go";
    GOPATH = "$HOME/code/go";
    GOWORKSPACE = "$GOPATH/src/github.com/cmacrae";
    PAGER = "less -R";
    EDITOR = "emacsclient";

    # History
    HISTSIZE = "1000";
    SAVEHIST = "1000";
    HISTFILE = "$HOME/.history";

    # Terminfo
    TERMINFO = "/usr/share/terminfo/";
  };

  environment.shellAliases = {
    ls = "ls -G";
    rm = "rm -i";
    cp = "cp -i";
    gows = "cd $GOWORKSPACE";
  };

  # You should generally set this to the total number of logical cores in your system.
  # $ sysctl -n hw.ncpu
  nix.maxJobs = 1;
  nix.buildCores = 12;
}
