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
        { config, pkgs, ... }:
        {
          packages.default = config.packages.hyprland;
          checks.default = import ./wrapperModules/check.nix { inherit pkgs self; }; # NOTE: per fare i checks

          # `nix develop` -> `hypr-preview`: avvia l'Hyprland wrappato dentro la
          # sessione Wayland corrente (si apre nested in una finestra).
          devShells.default = pkgs.mkShell {
            packages = [
              (pkgs.writeShellScriptBin "hypr-preview" ''
                if [ -z "$WAYLAND_DISPLAY" ] && [ -z "$DISPLAY" ]; then
                  echo "Nessuna sessione grafica attiva: la preview nested richiede Wayland (o X11) in esecuzione." >&2
                  exit 1
                fi
                exec ${config.packages.hyprland}/bin/Hyprland "$@"
              '')
            ];
            shellHook = ''
              echo "Comandi disponibili:"
              echo "  hypr-preview                 # Hyprland nested in una finestra"
              echo "  nix run . -- --verify-config # valida la config Lua"
            '';
          };
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
