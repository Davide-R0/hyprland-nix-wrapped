inputs:
{
  config,
  lib,
  pkgs,
  options,
  ...
}:
let
  # 1. Copiamo la nostra cartella lua locale nel Nix Store in modo che sia immutabile
  luaConfigDir = ./lua;

  # 2. Generiamo l'entrypoint che Hyprland andrà a leggere
  bootstrapLua = pkgs.writeText "hyprland-bootstrap.lua" ''
    -- ==== NIX BOOTSTRAP ==== --

    -- Diciamo al motore Lua di Hyprland dove trovare i nostri file
    -- Aggiungiamo la cartella importata nel Nix Store al package.path
    package.path = package.path .. ";${luaConfigDir}/?.lua;./init.lua"

    -- Creiamo una tabella globale per passare i pacchetti Nix ai nostri script Lua
    _G.NIX = {
      terminal = "${config.my-hyprland.terminal}",
      browser = "${config.my-hyprland.browser}",
    }

    -- Carichiamo i plugin compilati da Nix
    ${lib.concatMapStringsSep "\n" (
      p: "hl.plugin('${p}/lib/lib${p.pname}.so')"
    ) config.my-hyprland.plugins}

    -- ==== AVVIO CONFIGURAZIONE REALE ==== --
    -- Ora che l'ambiente è pronto, carichiamo il nostro lua/init.lua
    require("init")
  '';

in
{
  # Definiamo le nostre opzioni
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
      default = [ ]; # Aggiungi qui pkgs.hyprlandPlugins.* se necessario
    };
  };

  # Configuriamo il wrapper
  config = {
    package = pkgs.hyprland;

    # Diciamo ad Hyprland di usare il nostro file generato
    addFlags = [
      "-c"
      "${bootstrapLua}"
    ];
  };
}
