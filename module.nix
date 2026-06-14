{
  config,
  lib,
  pkgs,
  options,
  ...
}:
{
  options.hyprland-nix-wrapped = {
    enable = lib.mkEnableOption "Hyprland Nix Wrapped";
    terminal = lib.mkOption {
      type = lib.types.str;
      default = "${pkgs.ghostty}/bin/ghostty";
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
      default = [
        pkgs.ghostty
        pkgs.dbus
      ];
    };
    displayScale = lib.mkOption {
      type = lib.types.str;
      default = "1";
      description = "Fattore di scaling globale del monitor (es. 1, 1.5, 2)";
    };
    monitors = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ", preferred, auto, 1" ];
      description = "Lista di monitor da configurare.";
    };
    workspaces = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      description = "Lista di workspace da configurare.";
    };
    extraBind = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      description = "Lista di keybindings extra (formato stringa hyprland).";
    };
    extraExecOnce = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      description = "Lista di comandi da eseguire all'avvio (in aggiunta a quelli base).";
    };
    extraInit = lib.mkOption {
      type = lib.types.lines;
      default = "";
      description = "Comandi extra da eseguire all'avvio (es. dms run)";
    };
    upstreamPackage = lib.mkOption {
      type = lib.types.package;
      default = pkgs.hyprland;
      description = "Il pacchetto originale di Hyprland da wrappare.";
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
      luaConfigDir = ./lua;

      nixEnvDir = pkgs.writeTextDir "nix-env.lua" ''
        local NIX = {
          terminal = "${cfg.terminal}",
          browser = "${cfg.browser}",
          dmsPath = "${cfg.dmsPath}",
          enableHyprbars = ${if cfg.enableHyprbars then "true" else "false"},
          extraWindowRule = ${if cfg.extraWindowRule then "true" else "false"},
          displayScale = "${cfg.displayScale}",
          monitors = {
            ${lib.concatMapStringsSep ",\n            " (m: "'${m}'") cfg.monitors}
          },
          workspaces = {
            ${lib.concatMapStringsSep ",\n            " (w: "'${w}'") cfg.workspaces}
          },
          extraBind = {
            ${lib.concatMapStringsSep ",\n            " (b: "'${b}'") cfg.extraBind}
          },
          extraExecOnce = {
            ${lib.concatMapStringsSep ",\n            " (e: "'${e}'") cfg.extraExecOnce}
          },
          extraInit = [[
            ${cfg.extraInit}
          ]],

          pkgs = {
            ${lib.concatMapStringsSep ",\n            " (
              p: "[\"${if p ? pname then p.pname else "unknown"}\"] = '${p}'"
            ) cfg.extraPackages}
          },
          
          plugins = {
            ${lib.concatMapStringsSep ",\n            " (
              p: "'${p}/lib/hyprland/lib${if p ? pname then p.pname else "unknown"}.so'"
            ) cfg.plugins}
          },
          
          configModules = {
            ${lib.concatMapStringsSep ",\n            " (m: "'${m}'") moduleNames}
          }
        }
        return NIX
      '';

      entrypointLua = pkgs.writeText "hyprland-entrypoint.lua" ''
        -- Setup path
        package.path = "${nixEnvDir}/?.lua;" .. package.path
        package.path = "${baseDir}/?.lua;" .. package.path
        package.path = "${luaConfigDir}/?.lua;" .. package.path

        -- Caricamento
        local ok, err = pcall(require, "init")
        if not ok then
            print("[Hyprland-Lua] ERRORE CRITICO: Impossibile caricare init.lua: " .. err)
        end
      '';

      wrappedPackage =
        (pkgs.symlinkJoin {
          name = "hyprland-nix-wrapped";
          paths = [ cfg.upstreamPackage ] ++ cfg.extraPackages;
          buildInputs = [ pkgs.makeWrapper ];
          postBuild = ''
            wrapProgram $out/bin/Hyprland \
              --add-flags "-c ${entrypointLua}"
          '';
        }).overrideAttrs
          (old: {
            passthru = (cfg.upstreamPackage.passthru or {}) // {
              providedSessions = [ "hyprland" ];
            };
            meta = (cfg.upstreamPackage.meta or { }) // {
              mainProgram = "Hyprland";
            };
          });
    in
    lib.mkIf cfg.enable (
      lib.mkMerge [
        {
          hyprland-nix-wrapped.package = wrappedPackage;
        }

        # Integrazione NixOS
        # Usiamo optionalAttrs per nascondere completamente la chiave 'environment' a Home Manager
        (lib.optionalAttrs (options ? environment && !(options ? home.file)) {
          environment.systemPackages = [ wrappedPackage ];
          programs.hyprland.package = lib.mkForce wrappedPackage;
        })

        # Integrazione Home Manager
        # Usiamo optionalAttrs per nascondere 'home' e 'wayland' a NixOS
        (lib.optionalAttrs (options ? home.file) {
          home.packages = [ wrappedPackage ];
          wayland.windowManager.hyprland.package = lib.mkForce wrappedPackage;
        })
      ]
    );
}
