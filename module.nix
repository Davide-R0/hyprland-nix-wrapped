{
  config,
  lib,
  pkgs,
  ...
}:
{
  # NOTE: quando i moduli saranno integrati nella libreria Nix-wrapper-modules: `wlib.wrapperModules.hyprland`
  imports = [ ./wrapperModules/module.nix ];

  options.settings = {
    terminal = lib.mkOption {
      type = lib.types.str;
      default = "kitty";
      description = "Default terminal emulator";
    };
    launcher = lib.mkOption {
      type = lib.types.str;
      default = "rofi -show drun";
      description = "Default application launcher";
    };
    mod_key = lib.mkOption {
      type = lib.types.str;
      default = "SUPER";
      description = "The main modifier key";
    };
    gaps_in = lib.mkOption {
      type = lib.types.int;
      default = 5;
      description = "Inner gaps";
    };
    gaps_out = lib.mkOption {
      type = lib.types.int;
      default = 20;
      description = "Outer gaps";
    };
    active_border_color = lib.mkOption {
      type = lib.types.str;
      default = "rgba(33ccffee)";
      description = "Color of the active border";
    };
  };

  config = {
    luaInfo = {
      terminal = config.settings.terminal;
      launcher = config.settings.launcher;
      mod = config.settings.mod_key;
      gaps = {
        i = config.settings.gaps_in;
        o = config.settings.gaps_out;
      };
      colors = {
        active_border = config.settings.active_border_color;
      };
      lua_dir = "${./lua}";
    };

    "hyprland.lua".path = ./init.lua;
    runtimePkgs = [
      pkgs.kitty
      pkgs.rofi
      pkgs.waybar
    ];
  };
}
