{
  config,
  lib,
  pkgs,
  ...
}:
let
  luaConfigDir = ./lua;
in
{
  options.hyprland-nix-wrapped = {
    terminal = lib.mkOption {
      type = lib.types.str;
      default = "${pkgs.alacritty}/bin/alacritty";
    };
    browser = lib.mkOption {
      type = lib.types.str;
      default = "${pkgs.firefox}/bin/firefox";
    };
    dmsPath = lib.mkOption {
      type = lib.types.str;
      default = "dms";
      description = "Path per l'eseguibile dms";
    };
    enableHyprbars = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Abilita il plugin hyprbars";
    };
    extraWindowRule = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Abilita le regole extra delle finestre";
    };
    plugins = lib.mkOption {
      type = lib.types.listOf lib.types.package;
      default = [ pkgs.hyprlandPlugins.hyprbars ];
    };
    extraPackages = lib.mkOption {
      type = lib.types.listOf lib.types.package;
      default = [ pkgs.alacritty ];
    };
    displayScale = lib.mkOption {
      type = lib.types.str;
      default = "1";
      description = "Fattore di scaling globale del monitor (es. 1, 1.5, 2)";
    };
    # Aggiungiamo un'opzione di sola lettura per esporre il pacchetto finale
    package = lib.mkOption {
      type = lib.types.package;
      readOnly = true;
    };
  };

  config = {
    hyprland-nix-wrapped.package =
      let
        baseDir = ./.;

        # Troviamo tutti i file .lua in lua/config
        configFiles = builtins.attrNames (builtins.readDir ./lua/config);
        luaModules = builtins.filter (lib.hasSuffix ".lua") configFiles;
        moduleNames = map (lib.removeSuffix ".lua") luaModules;

        # Generiamo una directory contenente nix-env.lua
        nixEnvDir = pkgs.writeTextDir "nix-env.lua" ''
          local NIX = {
            terminal = "${config.hyprland-nix-wrapped.terminal}",
            browser = "${config.hyprland-nix-wrapped.browser}",
            dmsPath = "${config.hyprland-nix-wrapped.dmsPath}",
            enableHyprbars = ${if config.hyprland-nix-wrapped.enableHyprbars then "true" else "false"},
            extraWindowRule = ${if config.hyprland-nix-wrapped.extraWindowRule then "true" else "false"},
            displayScale = "${config.hyprland-nix-wrapped.displayScale}",
            
            pkgs = {
              ${lib.concatMapStringsSep ",\n              " (
                p: "${p.pname or "unknown"} = '${p}'"
              ) config.hyprland-nix-wrapped.extraPackages}
            },
            
            plugins = {
              ${lib.concatMapStringsSep ",\n              " (
                p: "'${p}/lib/hyprland/lib${p.pname}.so'"
              ) config.hyprland-nix-wrapped.plugins}
            },
            
            configModules = {
              ${lib.concatMapStringsSep ",\n              " (m: "'${m}'") moduleNames}
            }
          }
          return NIX
        '';

        # Il motore interno Lua di Hyprland potrebbe ignorare la variabile d'ambiente LUA_PATH.
        # Creiamo un file di entrypoint che configura i path manualmente e poi carica init.lua.
        entrypointLua = pkgs.writeText "hyprland-entrypoint.lua" ''
          -- Iniettiamo i path di Nix e del progetto nel motore Lua
          package.path = "${nixEnvDir}/?.lua;${baseDir}/?.lua;${luaConfigDir}/?.lua;" .. package.path

          -- Passiamo il controllo al file di configurazione dell'utente
          require("init")
        '';

      in
      # Creiamo il wrapper finale
      (pkgs.symlinkJoin {
        name = "hyprland-nix-wrapped";
        paths = [ pkgs.hyprland ] ++ config.hyprland-nix-wrapped.extraPackages;
        buildInputs = [ pkgs.makeWrapper ];
        postBuild = ''
          wrapProgram $out/bin/Hyprland \
            --add-flags "-c ${entrypointLua}"
        '';
      }).overrideAttrs
        (old: {
          meta = (old.meta or { }) // {
            mainProgram = "Hyprland";
          };
        });
  };
}
