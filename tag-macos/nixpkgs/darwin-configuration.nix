{ config, lib, pkgs, ... }:

let
  unstable = import <nixos-unstable> { config = { allowUnfree = true; }; };
in {
  # nix-darwin 25.11: system activation now runs as root; per-user options
  # (defaults, redis, darwinConfig, …) apply to system.primaryUser instead.
  # The username lives in a git-ignored local file (see .gitignore) so this
  # shared config carries no machine-specific username. Each machine must
  # create its own ./primary-user.nix; a missing file fails eval loudly.
  system.primaryUser = import ./primary-user.nix;

  system.defaults.NSGlobalDomain = {
    AppleEnableMouseSwipeNavigateWithScrolls = false;
    AppleEnableSwipeNavigateWithScrolls = false;
    AppleICUForce24HourTime = true;
    AppleInterfaceStyleSwitchesAutomatically = true;
    AppleKeyboardUIMode = 3;
    ApplePressAndHoldEnabled = true;
    AppleShowAllExtensions = true;
    AppleShowScrollBars = "Always";
    InitialKeyRepeat = 11;
    KeyRepeat = 2;
    NSAutomaticCapitalizationEnabled = false;
    NSAutomaticDashSubstitutionEnabled = false;
    NSAutomaticPeriodSubstitutionEnabled = false;
    NSAutomaticQuoteSubstitutionEnabled = false;
    NSAutomaticSpellingCorrectionEnabled = false;
    NSAutomaticWindowAnimationsEnabled = false;
    NSDocumentSaveNewDocumentsToCloud = false;
    NSNavPanelExpandedStateForSaveMode = true;
    NSNavPanelExpandedStateForSaveMode2 = true;
    NSTableViewDefaultSizeMode = 1;
    NSUseAnimatedFocusRing = false;
    NSWindowResizeTime = 0.01;
    PMPrintingExpandedStateForPrint = true;
    PMPrintingExpandedStateForPrint2 = true;

    "com.apple.sound.beep.feedback" = 1;
  };

  # The old `system.defaults.alf` options were removed in nix-darwin 26.05;
  # `networking.applicationFirewall` is the only way to manage the firewall now.
  # On MDM-managed Macs the firewall is owned by the MDM profile, so each
  # socketfilterfw call during activation prints "Firewall settings cannot be
  # modified from command line on managed Mac computers". That message is
  # harmless noise: socketfilterfw still exits 0, so the rebuild succeeds. On
  # non-MDM machines (what this shared config is really for) it takes effect.
  # (TODO: split MDM vs non-MDM config instead of tolerating the noise.)
  networking.applicationFirewall = {
    enable = true;
    blockAllIncoming = false;
    enableStealthMode = true;
  };

  system.defaults.dock = {
    autohide = false;
    enable-spring-load-actions-on-all-items = true;
    largesize = 128;
    launchanim = false;
    mouse-over-hilite-stack = true;
    mru-spaces = false;
    show-recents = false;
    showhidden = true;
    tilesize = 8;
  };

  system.defaults.finder = {
    _FXShowPosixPathInTitle = true;
    _FXSortFoldersFirst = true;
    _FXSortFoldersFirstOnDesktop = true;
    AppleShowAllExtensions = true;
    AppleShowAllFiles = true;
    FXDefaultSearchScope = "SCcf"; # Current folder
    FXEnableExtensionChangeWarning = false;
    FXPreferredViewStyle = "Nlsv"; # List view
    FXRemoveOldTrashItems = true;
    QuitMenuItem = true;
    ShowMountedServersOnDesktop = true;
    ShowPathbar = true;
  };

  system.defaults.menuExtraClock = {
    Show24Hour = true;
    ShowDate = 1;
    ShowDayOfMonth = true;
    ShowDayOfWeek = true;
    ShowSeconds = true;
  };

  system.defaults.trackpad.Clicking = true;

  # Added in https://github.com/LnL7/nix-darwin/pull/557
  system.defaults.CustomUserPreferences = {
    # Based on https://github.com/mathiasbynens/dotfiles/issues/701#issuecomment-1205951860
    #
    # > defaults -currentHost write com.apple.controlcenter.plist BatteryShowPercentage -bool true
    # > defaults -currentHost write com.apple.controlcenter.plist BatteryShowPercentage -bool false
    #
    # TODO: Figure out why this doesn't work; might have something to do with
    # https://github.com/nix-community/home-manager/commit/572f348a10826b2207caaf394e9ad2e9ffc6ffa7
    #
    "com.apple.controlcenter.plist" = { "BatteryShowPercentage" = false; };
  };
  system.defaults.controlcenter.BatteryShowPercentage = true;

  # TODO: Something like this:
  # defaults write com.apple.menuextra.battery ShowTime -string "YES"

  # Packages installed in the system profile. To find a package name, use
  # https://search.nixos.org/packages and set the channel to 26.05 to match
  # this system. It's instant and fuzzy, and it shows the exact attribute path
  # to paste into the list below — e.g. `wget2`, or `python313Packages.wget`
  # for a sub-package. No `nixpkgs.` prefix; paste the attribute as shown.
  #
  # From the terminal (needs the experimental features enabled further down):
  #
  #   $ nix search nixpkgs/nixos-26.05 <query>
  #
  # Pin the channel as above — a bare `nixpkgs` ref resolves to unstable, a
  # different package set than what this system installs. The first run is slow
  # (~30s) while it builds the eval cache; later runs are fast. The
  # `unstable.*` entries below come from the nixos-unstable channel instead;
  # search those with `nix search nixpkgs <query>` or the unstable channel on
  # the web.

  environment.systemPackages = with pkgs; [
    bat
    bats
    bkt
    borgbackup
    btop
    cloc
    coreutils
    cowsay
    delta
    direnv
    dive
    entr
    eza
    fastfetch
    fdupes
    figlet
    findutils
    fortune
    fx
    gawk
    graphviz
    gron
    gzip
    hadolint
    htop
    hut
    iperf
    jq
    mdp
    moreutils
    mosquitto
    nmap
    pwgen
    rcm
    redis
    ripgrep
    rlwrap
    rsync # Keep rsync instead of openrsync
    shellcheck
    silver-searcher
    sox
    speedtest-cli
    sqlite
    # tmate # There are no upstream releases since 2019-11
    tree
    visidata
    wakeonlan
    watch
    wget
    qsv # drop-in successor to xsv (removed from nixpkgs); same subcommands
    yq-go

    unstable.curl
    unstable.fzf
    unstable.git
    unstable.neovim
    unstable.ncdu
    unstable.oils-for-unix
  ];

  # Auto upgrade nix package and the daemon service.
  # nix-darwin now manages nix-daemon unconditionally when nix.enable is on.
  nix.package = pkgs.nix;

  # Enable the modern `nix` CLI (`nix search`, `nix shell`, …) and flakes, so
  # package search works flagless. Also a prerequisite for a future
  # flakes-based setup.
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  services.redis = {
    enable = true;
    extraConfig = ''
      stop-writes-on-bgsave-error no
    '';
  };

  # NOTE: This is commented out; presumably there is some work required to
  #       setup the right launchagent stuff to support something like this.
  #
  #       Might be able to follow the pattern that redis uses here if it's
  #       worth doing:
  #
  #       https://github.com/LnL7/nix-darwin/blob/master/modules/services/redis/default.nix
  #
  # > error: The option `services.mosquitto' does not exist. Definition values:
  # > - In `/Users/andrew/.nixpkgs/darwin-configuration.nix':
  # >   {
  # >     enable = true;
  # >   }
  #
  # services.mosquitto.enable = true;

  # Create /etc/zshrc that loads the nix-darwin environment.
  programs.zsh.enable = true; # default shell on catalina

  programs.nix-index.enable = true;

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;

  # See: https://github.com/LnL7/nix-darwin/issues/659#issuecomment-1813204545
  system.activationScripts.preActivation = {
    enable = true;
    text = ''
      if [ ! -d "/var/lib/redis/" ]; then
        echo "creating Redis data directory..."
        sudo mkdir -m 755 -p /var/lib/redis/
      fi
    '';
  };
}
