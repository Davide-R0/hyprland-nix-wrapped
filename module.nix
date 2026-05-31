{
  inputs,
  config,
  lib,
  pkgs,
  options,
  ...
}:
let
  luaConfigDir = ./lua;
in
{
  # 1. Definiamo le opzioni per il nostro modulo
  options.my-hyprland = {
    terminal = lib.mkOption {
      type = lib.types.str;
      default = "${pkgs.kitty}/bin/kitty";
    };
    browser = lib.mkOption {
      type = lib.types.str;
      default = "${pkgs.firefox}/bin/firefox";
    };
    plugins = lib.mkOption {
      type = lib.types.listOf lib.types.package;
      default = [ ];
    };
    extraPackages = lib.mkOption {
      type = lib.types.listOf lib.types.package;
      default = [ ];
    };
    # Aggiungiamo un'opzione di sola lettura per esporre il pacchetto finale
    package = lib.mkOption {
      type = lib.types.package;
      readOnly = true;
    };
  };

  # 2. Assegniamo i valori.
  config = {
    my-hyprland.package =
      let
        baseDir = ./.;
        # Script Lua che genera il file hyprland.conf finale
        generatorLua = pkgs.writeText "hyprland-generator.lua" ''
          package.path = "${baseDir}/?.lua;${luaConfigDir}/?.lua;" .. package.path

          -- Iniezione Variabili Nix
          _G.NIX = {
            terminal = "${config.my-hyprland.terminal}",
            browser = "${config.my-hyprland.browser}",
            -- Mappa dei pacchetti extra (nome -> path)
            pkgs = {
              ${lib.concatMapStringsSep ",\n              " (
                p: "${p.pname or "unknown"} = '${p}'"
              ) config.my-hyprland.extraPackages}
            },
            -- Esempio di "funzione" iniettata da Nix
            msg = function(text)
              print("-- NIX MESSAGE: " .. text)
            end
          }

          -- Caricamento bridge e configurazione utente
          local hl = require("hl")

          -- Iniezione Plugin tramite Nix
          ${lib.concatMapStringsSep "\n" (
            p: "hl.plugin('${p}/lib/hyprland/lib${p.pname}.so')"
          ) config.my-hyprland.plugins}

          require("init")

          -- Output della configurazione compilata
          print(hl.compile())
        '';

        # Generiamo il file .conf effettivo usando Lua in fase di build
        hyprlandConf =
          pkgs.runCommand "hyprland.conf"
            {
              nativeBuildInputs = [ pkgs.lua ];
            }
            ''
              lua ${generatorLua} > $out
            '';
      in
      # Creiamo il wrapper finale
      (pkgs.symlinkJoin {
        name = "hyprland-nix-wrapped";
        paths = [ pkgs.hyprland ] ++ config.my-hyprland.extraPackages;
        buildInputs = [ pkgs.makeWrapper ];
        postBuild = ''
          wrapProgram $out/bin/Hyprland \
            --add-flags "-c ${hyprlandConf}"
        '';
      }).overrideAttrs
        (old: {
          meta = (old.meta or { }) // {
            mainProgram = "Hyprland";
          };
        });
  };
}
