{
  description = "awseward nix-darwin system";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    nix-darwin = {
      url = "github:nix-darwin/nix-darwin/nix-darwin-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, nix-darwin }:
    let
      # Single arch for now; add a second darwinConfigurations entry if an
      # x86_64-darwin machine ever shares this config.
      system = "aarch64-darwin";

      # The package set for `unstable.*` in darwin-configuration.nix.
      unstable = import nixpkgs-unstable {
        inherit system;
        config.allowUnfree = true;
      };
    in {
      # Named `macos` (not by hostname) so one config is shared across machines.
      # The per-machine username comes from the git-ignored ./primary-user.nix.
      # Switch with:
      #   sudo darwin-rebuild switch --flake "path:$HOME/.config/nix-darwin#macos"
      darwinConfigurations.macos = nix-darwin.lib.darwinSystem {
        inherit system;
        specialArgs = { inherit unstable; };
        modules = [ ./darwin-configuration.nix ];
      };
    };
}
