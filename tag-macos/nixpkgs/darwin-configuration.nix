{ config, pkgs, ... }:

{
  system.defaults.NSGlobalDomain.AppleEnableMouseSwipeNavigateWithScrolls = false;
  system.defaults.NSGlobalDomain.AppleEnableSwipeNavigateWithScrolls = false;
  system.defaults.NSGlobalDomain.AppleInterfaceStyleSwitchesAutomatically = true;
  system.defaults.NSGlobalDomain.AppleKeyboardUIMode = 3;
  system.defaults.NSGlobalDomain.ApplePressAndHoldEnabled = true;
  system.defaults.NSGlobalDomain.AppleShowScrollBars = "Always";
  system.defaults.NSGlobalDomain.InitialKeyRepeat = 11;
  system.defaults.NSGlobalDomain.KeyRepeat = 2;
  system.defaults.NSGlobalDomain.NSAutomaticCapitalizationEnabled = false;
  system.defaults.NSGlobalDomain.NSAutomaticDashSubstitutionEnabled = false;
  system.defaults.NSGlobalDomain.NSAutomaticPeriodSubstitutionEnabled = false;
  system.defaults.NSGlobalDomain.NSAutomaticQuoteSubstitutionEnabled = false;
  system.defaults.NSGlobalDomain.NSAutomaticSpellingCorrectionEnabled = false;
  system.defaults.NSGlobalDomain.NSNavPanelExpandedStateForSaveMode = true;
  system.defaults.NSGlobalDomain.NSNavPanelExpandedStateForSaveMode2 = true;
  system.defaults.NSGlobalDomain.NSTableViewDefaultSizeMode = 1;
  system.defaults.NSGlobalDomain.NSUseAnimatedFocusRing = false;
  system.defaults.NSGlobalDomain.NSWindowResizeTime = 0.01;
  system.defaults.NSGlobalDomain.PMPrintingExpandedStateForPrint = true;
  system.defaults.NSGlobalDomain.PMPrintingExpandedStateForPrint2 = true;

  system.defaults.alf.stealthenabled = 1;

  system.defaults.dock.autohide = false;
  system.defaults.dock.enable-spring-load-actions-on-all-items = true;
  system.defaults.dock.launchanim = false;
  system.defaults.dock.mouse-over-hilite-stack = true;
  system.defaults.dock.mru-spaces = false;
  system.defaults.dock.show-recents = false;
  system.defaults.dock.showhidden = true;
  system.defaults.dock.tilesize = 8;

  system.defaults.finder._FXShowPosixPathInTitle = true;
  system.defaults.finder.AppleShowAllExtensions = true;
  system.defaults.finder.AppleShowAllFiles = true;
  system.defaults.finder.FXDefaultSearchScope = "SCcf"; # Current folder
  system.defaults.finder.FXEnableExtensionChangeWarning = false;
  system.defaults.finder.FXPreferredViewStyle = "Nlsv"; # List view
  system.defaults.finder.QuitMenuItem = true;
  system.defaults.finder.ShowPathbar = true;

  system.defaults.trackpad.Clicking = true;

  # TODO: Something like this:
  # defaults write com.apple.menuextra.battery ShowPercent -string "NO"
  # defaults write com.apple.menuextra.battery ShowTime -string "YES"

  # List packages installed in system profile. To search by name, run:
  #
  #   $ nix-env -qaP | grep wget
  #
  # It's pretty slow, so it will appear to hang, but you'll eventually get
  # results back which will look something like this:
  #
  #   nixpkgs.python310Packages.wget    python3.10-wget-3.2
  #   nixpkgs.python39Packages.wget     python3.9-wget-3.2
  #   nixpkgs.wget                      wget-1.21.3
  #   nixpkgs.wget2                     wget2-2.0.0
  #   nixpkgs.wgetpaste                 wgetpaste-2.32
  #
  # The list of packages below takes values relative to `nixpkgs.` in that
  # first column. I.e.:
  #
  #   • if you want `nixpkgs.wget2`, add just `wget2`
  #
  #   • if you want `nixpkgs.python310Packages.wget`, add just
  #     `python310Packages.wget`
  #
  #   … etc.

  environment.systemPackages = with pkgs; [
    bat
    bats
    cloc
    coreutils
    cowsay
    direnv
    dive
    entr
    exa
    figlet
    graphviz
    hadolint
    htop
    jq
    neovim
    redis
    ripgrep
    shellcheck
    silver-searcher
    sox
    tmate
    tree
    visidata
    wget
  ];

  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;
  nix.package = pkgs.nix;

  services.redis = {
    enable = true;
    extraConfig = ''
      stop-writes-on-bgsave-error no
    '';
  };

  # Create /etc/zshrc that loads the nix-darwin environment.
  programs.zsh.enable = true; # default shell on catalina

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;
}
