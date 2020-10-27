{ config, pkgs, ... }:

{
  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = with pkgs; [
    config.programs.vim.package

    ag
    bat
    bats
    cloc
    cowsay
    dhall
    dhall-bash
    dhall-json
    direnv
    dive
    entr
    exa
    figlet
    htop
    jq
    redis
    ripgrep
    shellcheck
    sox
    tmate
    tree
    wget
  ];

  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;
  nix.package = pkgs.nix;

  services.redis = {
    enable = true;
    # FIXME: At the time of writing, the nix-darwin module for this does not expose
    # `extraConfig` the same way the nixpkgs one does...
    # See: https://github.com/LnL7/nix-darwin/blob/master/modules/services/redis/default.nix)
    #
    # extraConfig = ''
    #   stop-writes-on-bgsave-error no
    # '';
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
