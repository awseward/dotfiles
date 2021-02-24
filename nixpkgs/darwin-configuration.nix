{ config, pkgs, ... }:

{
  # Added on advice from the following warning:
  #
  #   warning: Detected old style nixbld users
  #   These can cause migration problems when upgrading to certain macOS versions
  #   Running the installer again will remove and recreate the users in a way that avoids these problems
  #
  #   $ darwin-install
  #
  #   or enable to automatically manage the users
  #
  #       users.nix.configureBuildUsers = true;
  #
  users.nix.configureBuildUsers = true;

  launchd.user.agents.foobar = (import ./foo);

  system.defaults.NSGlobalDomain.AppleEnableSwipeNavigateWithScrolls = false;
  system.defaults.NSGlobalDomain.AppleEnableMouseSwipeNavigateWithScrolls = false;

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
  system.defaults.NSGlobalDomain.PMPrintingExpandedStateForPrint = true;
  system.defaults.NSGlobalDomain.PMPrintingExpandedStateForPrint2 = true;

  system.defaults.dock.enable-spring-load-actions-on-all-items = true;
  system.defaults.dock.mouse-over-hilite-stack = true;
  system.defaults.dock.mru-spaces = false;
  system.defaults.dock.show-recents = false;
  system.defaults.dock.showhidden = true;

  system.defaults.finder._FXShowPosixPathInTitle = true;
  system.defaults.finder.AppleShowAllExtensions = true;
  system.defaults.finder.FXEnableExtensionChangeWarning = false;
  system.defaults.finder.QuitMenuItem = true;

  system.defaults.trackpad.Clicking = true;

  # TODO: Something like this:
  # defaults write com.apple.menuextra.battery ShowPercent -string "NO"
  # defaults write com.apple.menuextra.battery ShowTime -string "YES"

  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = with pkgs; [
    config.programs.vim.package

    ag
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
    hadolint
    htop
    jq
    redis
    ripgrep
    shellcheck
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

  programs.vim.package = pkgs.vim_configurable.override {
    darwinSupport = true;
    guiSupport = "no";
    python = pkgs.python3;
  };

  # Create /etc/zshrc that loads the nix-darwin environment.
  programs.zsh.enable = true;  # default shell on catalina

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;
}
