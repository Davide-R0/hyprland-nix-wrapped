{
  description = "Flake per Hyprland Lua Wrappato";

  nixConfig = {
    extra-substituters = [
      "https://cache.nixos.org"
      "https://nix-community.cachix.org"
      "https://hyprland.cachix.org"
    ];
    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
    ];
    extra-experimental-features = [
      "nix-command"
      "flakes"
    ];
  };

  # TODO: cambiarlo in input con un nome
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

  outputs =
    { self, nixpkgs }@inputs:
    let
      systems = [
        "x86_64-linux"
        "aarch64-linux"
      ];
      forAllSystems = nixpkgs.lib.genAttrs systems;
    in

    {
      packages = forAllSystems (
        system:
        let
          pkgs = import nixpkgs { inherit system; };

          eval = nixpkgs.lib.evalModules {
            modules = [
              ./module.nix
              {
                config = {
                  hyprland-nix-wrapped.enable = true;
                };
                options.home.packages = nixpkgs.lib.mkOption {
                  type = nixpkgs.lib.types.listOf nixpkgs.lib.types.package;
                  default = [ ];
                };
              }
            ];
            specialArgs = { inherit inputs pkgs; };
          };

        in
        {
          hyprland = eval.config.hyprland-nix-wrapped.package;
          default = self.packages.${system}.hyprland;
        }
      );

      nixosModules.default = ./module.nix;
      homeModules.default = ./module.nix;

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
                local PROJECT_ROOT=$(pwd)
                
                # 1. Generiamo un nix-env.lua locale per il dev
                cat <<EOF > nix-env.lua
                  local NIX = {
                    terminal = "alacritty",
                    browser = "firefox",
                    dmsPath = "dms",
                    enableHyprbars = true,
                    extraWindowRule = true,
                    displayScale = "1",
                    monitors = { ", preferred, auto, 1" },
                    workspaces = {},
                    extraBind = {},
                    extraExecOnce = {},
                    extraInit = "",
                    pkgs = {},
                    plugins = {},
                    configModules = { "general", "keybinds", "monitors", "plugins", "rules" }
                  }
                  return NIX
                EOF

                # 2. Entrypoint locale con path ASSOLUTI
                cat <<EOF > .dev-entrypoint.lua
                  -- Aggiungiamo la root e la cartella lua/ per i moduli
                  package.path = "$PROJECT_ROOT/?.lua;$PROJECT_ROOT/lua/?.lua;" .. package.path
                  require("init")
                EOF

                echo "Avvio Hyprland (Nestato)..."
                
                # Usiamo variabili d'ambiente per forzare un'istanza separata
                # Nota: Rimosse le backslash da $PROJECT_ROOT per permettere l'espansione corretta
                HYPRLAND_INSTANCE_SIGNATURE="nested-$RANDOM" \
                ${hyprland-wrapped}/bin/Hyprland -c "$PROJECT_ROOT/.dev-entrypoint.lua" &
                HYPR_PID=$!
                
                sleep 2
                echo "Watching for changes in $PROJECT_ROOT..."
                find . -name "*.lua" | entr hyprctl reload
                
                kill $HYPR_PID
                rm .dev-entrypoint.lua nix-env.lua
              }
            '';
          };
        }
      );
    };
}
