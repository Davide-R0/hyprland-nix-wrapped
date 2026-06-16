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
    monitors = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ", preferred, auto, 1" ];
      description = "Lista di monitor da configurare.";
    };

    terminal = lib.mkOption {
      type = lib.types.str;
      default = "kitty";
      description = "Il terminale predefinito per i keybindings di Hyprland.";
    };

    extraWindowRule = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "extra window roules";
    };

    plugins.hyprbars.enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "enable hyprbars plugin";
    };

    workspaces = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      description = "Lista di workspace da configurare.";
    };

    extraExecOnce = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      description = "Lista di comandi da eseguire all'avvio (in aggiunta a quelli base).";
    };

    extraBind = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      description = "Lista di keybindings extra.";
    };

    extraBindel = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      description = "Lista di keybindings extra ripetibili (es. volume, luminosità).";
    };

    extraDevices = lib.mkOption {
      type = lib.types.listOf lib.types.attrs;
      default = [ ];
      description = "Configurazioni custom per singoli device (es. touchpad).";
    };

    # Opzioni addizionali tastiera
    extraKbOptions = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      description = "Opzioni tastiera addizionali xkb.";
    };

    gapsIn = lib.mkOption {
      type = lib.types.int;
      default = 4;
      description = "Dimensione dei gap interni (gaps_in).";
    };

    gapsOut = lib.mkOption {
      type = lib.types.int;
      default = 8;
      description = "Dimensione dei gap esterni (gaps_out).";
    };

    #borderSize = lib.mkOption {
    #  type = lib.types.int;
    #  default = 2;
    #  description = "Dimensione del bordo delle finestre (border_size).";
    #};

    rounding = lib.mkOption {
      type = lib.types.int;
      default = 12;
      description = "Raggio di arrotondamento degli angoli (rounding).";
    };

    activeOpacity = lib.mkOption {
      type = lib.types.float;
      default = 0.95;
      description = "Opacità delle finestre attive (active_opacity).";
    };

    inactiveOpacity = lib.mkOption {
      type = lib.types.float;
      default = 0.8;
      description = "Opacità delle finestre inattive (inactive_opacity).";
    };

    #active_border_color = lib.mkOption {
    #  type = lib.types.str;
    #  default = "rgba(33ccffee)";
    #  description = "Color of the active border";
    #};

    #### OLD #######
    #launcher = lib.mkOption {
    #  type = lib.types.str;
    #  default = "rofi -show drun";
    #  description = "Default application launcher";
    #};
    #mod_key = lib.mkOption {
    #  type = lib.types.str;
    #  default = "SUPER";
    #  description = "The main modifier key";
    #};
    #gaps_in = lib.mkOption {
    #  type = lib.types.int;
    #  default = 5;
    #  description = "Inner gaps";
    #};
    #gaps_out = lib.mkOption {
    #  type = lib.types.int;
    #  default = 20;
    #  description = "Outer gaps";
    #};
  };

  config = {
    luaInfo = {
      terminal = config.settings.terminal;
      inactiveOpacity = config.settings.inactiveOpacity;
      activeOpacity = config.settings.activeOpacity;
      rounding = config.settings.rounding;
      extraKbOptions = config.settings.extraKbOptions;
      extraBind = config.settings.extraBind;
      extraBindel = config.settings.extraBindel;
      extraExecOnce = config.settings.extraExecOnce;
      workspaces = config.settings.workspaces;
      hyprbars.enable = config.settings.plugins.hyprbars.enable;
      extraWindowRule = config.settings.extraWindowRule;
      monitors = config.settings.monitors;
      #launcher = config.settings.launcher;
      #mod = config.settings.mod_key;
      gaps = {
        i = config.settings.gapsIn;
        o = config.settings.gapsOut;
      };
      #colors.active_border = config.settings.active_border_color;
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
