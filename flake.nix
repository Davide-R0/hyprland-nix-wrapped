{
  description = "Flake per Hyprland Lua Wrappato";

  nixConfig = {
    extra-substituters = [
      #"https://cache.nixos.org"
      #"https://nix-community.cachix.org"
      "https://hyprland.cachix.org"
    ];
    extra-trusted-public-keys = [
      #"nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
    ];
  };

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

  outputs =
    { self, nixpkgs }@inputs:
    let
      forAllSystems = nixpkgs.lib.genAttrs nixpkgs.lib.platforms.all;
    in
    {
      packages = forAllSystems (
        system:
        let
          pkgs = import nixpkgs { inherit system; };

          # Valutiamo il modulo passando 'pkgs' fin dal primo istante
          eval = nixpkgs.lib.evalModules {
            modules = [ ./module.nix ];
            specialArgs = { inherit inputs pkgs; };
          };
        in
        {
          # Estraiamo il pacchetto compilato dalle nostre opzioni
          hyprland = eval.config.my-hyprland.package;
          default = self.packages.${system}.hyprland;
        }
      );
    };
}
