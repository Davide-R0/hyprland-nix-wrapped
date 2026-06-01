{
  description = "Flake per Hyprland Lua Wrappato";

  nixConfig = {
    extra-substituters = [
      "https://hyprland.cachix.org"
    ];
    extra-trusted-public-keys = [
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
          hyprland = eval.config.hyprland-nix-wrapped.package;
          default = self.packages.${system}.hyprland;
        }
      );

      # Esportiamo il modulo per poterlo importare in altri file di configurazione NixOS / Home Manager
      nixosModules.default = ./module.nix;

      devShells = forAllSystems (
        system:
        let
          pkgs = import nixpkgs { inherit system; };
          hyprland-wrapped = self.packages.${system}.hyprland;
        in
        {
          default = pkgs.mkShell {
            buildInputs = with pkgs; [ entr ];
            shellHook = ''
              echo "--- Hyprland Lua DevShell ---"
              echo "Use 'hypr-watch' to start Hyprland with live-reload on Lua changes."
              echo ""
              hypr-watch() {
                # Trova tutti i file lua e usa entr per riavviare hyprland
                # Nota: In un ambiente reale, potresti voler usare 'hyprctl reload' 
                # ma se la config è passata via flag -c, il riavvio è più sicuro per i test.
                find . -name "*.lua" | entr -r ${hyprland-wrapped}/bin/Hyprland
              }
            '';
          };
        }
      );
    };
}
