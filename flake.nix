{
  description = "Flake exporting a configured hyprland package with Lua config";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    wrappers = {
      url = "github:BirdeeHub/nix-wrapper-modules";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      wrappers,
      flake-parts,
      ...
    }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [ wrappers.flakeModules.wrappers ];
      systems = nixpkgs.lib.platforms.all;

      perSystem =
        { config, ... }:
        {
          packages.default = config.packages.hyprland;
        };

      flake = {
        wrappers.hyprland = ./module.nix;

        nixosModules = {
          hyprland = wrappers.lib.getInstallModule {
            name = "hyprland";
            value = self.wrapperModules.hyprland;
          };
          default = self.nixosModules.hyprland;
        };

        homeModules = {
          hyprland = wrappers.lib.getInstallModule {
            name = "hyprland";
            value = self.wrapperModules.hyprland;
          };
          default = self.homeModules.hyprland;
        };

        overlays = {
          hyprland = final: _: { hyprland = self.wrappers.hyprland.wrap { pkgs = final; }; };
          default = self.overlays.hyprland;
        };
      };
    };
}
