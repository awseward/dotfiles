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
    # TODO: Uncomment extraConfig if this ships: https://github.com/LnL7/nix-darwin/pull/241
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
