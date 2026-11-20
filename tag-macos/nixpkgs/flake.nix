{
  description = "awseward nix-darwin system";

  # Replaces the old nix-channel setup (see ../../nix-channels). Each channel
  # becomes a flake input pinned in flake.lock; `nix flake update` is the new
  # `nix-channel --update`.
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

      # The `unstable.*` packages used in darwin-configuration.nix. Replaces the
      # old `import <nixos-unstable> { ... }` channel lookup.
      unstable = import nixpkgs-unstable {
        inherit system;
        config.allowUnfree = true;
      };
    in {
      # Named `macos` (not by hostname) so one config is shared across machines,
      # matching the pre-flake channel setup. The per-machine username still
      # comes from the git-ignored ./primary-user.nix. Switch with:
      #   sudo darwin-rebuild switch --flake path:$HOME/.dotfiles/tag-macos/nixpkgs#macos
      darwinConfigurations.macos = nix-darwin.lib.darwinSystem {
        inherit system;
        specialArgs = { inherit unstable; };
        modules = [ ./darwin-configuration.nix ];
      };
    };
}
