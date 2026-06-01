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
                # 1. Creiamo un entrypoint locale temporaneo per evitare di puntare al Nix Store
                # Questo permette di modificare i file .lua e vedere i cambiamenti al volo.
                cat <<EOF > .dev-entrypoint.lua
                  package.path = "./?.lua;./lua/config/?.lua;" .. package.path
                  -- Mock nix-env per il development locale se necessario, 
                  -- o usa quello generato dal wrapper (ma qui è più semplice puntare al locale)
                  require("init")
EOF

                echo "Avvio Hyprland in modalità dev..."
                ${hyprland-wrapped}/bin/Hyprland -c ./.dev-entrypoint.lua &
                HYPR_PID=\$!
                
                # 2. Aspettiamo che si avvii e poi usiamo entr per mandare il reload
                # Senza '-r', entr non uccide il processo ma esegue solo il comando.
                # Usiamo 'hyprctl reload' per il hot-reload senza chiudere la finestra.
                sleep 2
                find . -name "*.lua" | entr hyprctl reload
                
                # Cleanup al termine
                kill \$HYPR_PID
                rm .dev-entrypoint.lua
              }
            '';
          };
        }
      );
    };
}
