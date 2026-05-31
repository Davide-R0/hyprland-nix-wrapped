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
      default = "${pkgs.alacritty}/bin/alacritty";
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
      default = [ pkgs.alacritty ];
    };
    # Aggiungiamo un'opzione di sola lettura per esporre il pacchetto finale
    package = lib.mkOption {
      type = lib.types.package;
      readOnly = true;
    };
  };

  # per agigungere poi i plugins dall'esterno:
  #my-hyprland.plugins = [
  #  pkgs.hyprlandPlugins.hyprbars
  #  # altri plugin...
  #];

  # 2. Assegniamo i valori.
  config = {
    my-hyprland.package =
      let
        baseDir = ./.;
        
        # Generiamo una directory contenente nix-env.lua
        nixEnvDir = pkgs.writeTextDir "nix-env.lua" ''
          local NIX = {
            terminal = "${config.my-hyprland.terminal}",
            browser = "${config.my-hyprland.browser}",
            
            pkgs = {
              ${lib.concatMapStringsSep ",\n              " (
                p: "${p.pname or "unknown"} = '${p}'"
              ) config.my-hyprland.extraPackages}
            },
            
            plugins = {
              ${lib.concatMapStringsSep ",\n              " (
                p: "'${p}/lib/hyprland/lib${p.pname}.so'"
              ) config.my-hyprland.plugins}
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
        paths = [ pkgs.hyprland ] ++ config.my-hyprland.extraPackages;
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
