{
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
  options.hyprland-nix-wrapped = {
    enable = lib.mkEnableOption "Hyprland Nix Wrapped";
    # ... rest of options ...

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
      default = [ ];
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
    extraInit = lib.mkOption {
      type = lib.types.lines;
      default = "";
      description = "Comandi extra da eseguire all'avvio (es. dms run)";
    };
    package = lib.mkOption {
      type = lib.types.package;
      readOnly = true;
    };
  };

  config =
    let
      cfg = config.hyprland-nix-wrapped;
      baseDir = ./.;

      configFiles = builtins.attrNames (builtins.readDir ./lua);
      luaModules = builtins.filter (lib.hasSuffix ".lua") configFiles;
      moduleNames = map (lib.removeSuffix ".lua") luaModules;

      nixEnvDir = pkgs.writeTextDir "nix-env.lua" ''
        local NIX = {
          terminal = "${cfg.terminal}",
          browser = "${cfg.browser}",
          dmsPath = "${cfg.dmsPath}",
          enableHyprbars = ${if cfg.enableHyprbars then "true" else "false"},
          extraWindowRule = ${if cfg.extraWindowRule then "true" else "false"},
          displayScale = "${cfg.displayScale}",
          extraInit = [[
            ${cfg.extraInit}
          ]],
          
          pkgs = {
            ${lib.concatMapStringsSep ",\n            " (
              p: "${p.pname or "unknown"} = '${p}'"
            ) cfg.extraPackages}
          },
          
          plugins = {
            ${lib.concatMapStringsSep ",\n            " (
              p: "'${p}/lib/hyprland/lib${p.pname}.so'"
            ) cfg.plugins}
          },
          
          configModules = {
            ${lib.concatMapStringsSep ",\n            " (m: "'${m}'") moduleNames}
          }
        }
        return NIX
      '';

      entrypointLua = pkgs.writeText "hyprland-entrypoint.lua" ''
        -- Iniettiamo i path di Nix e del progetto nel motore Lua
        package.path = "${nixEnvDir}/?.lua;${baseDir}/?.lua;${luaConfigDir}/?.lua;" .. package.path

        -- Passiamo il controllo al file di configurazione dell'utente
        require("init")
      '';

      wrappedPackage =
        (pkgs.symlinkJoin {
          name = "hyprland-nix-wrapped";
          paths = [ pkgs.hyprland ] ++ cfg.extraPackages;
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
    in
    lib.mkIf cfg.enable (lib.mkMerge [
      {
        hyprland-nix-wrapped.package = wrappedPackage;
      }
      (lib.mkIf (lib.hasAttrByPath [ "home" "packages" ] options) {
        home.packages = [ wrappedPackage ];
      })
      (lib.mkIf (lib.hasAttrByPath [ "environment" "systemPackages" ] options) {
        environment.systemPackages = [ wrappedPackage ];
      })
    ]);
}
