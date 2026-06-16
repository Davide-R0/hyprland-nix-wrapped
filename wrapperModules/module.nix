{
  config,
  wlib,
  lib,
  pkgs,
  ...
}:
{
  imports = [ wlib.modules.default ];

  options = {
    luaInfo = lib.mkOption {
      type = wlib.types.structuredValueWith {
        typeName = "lua";
        extraValueTypes = lib.types.luaInline;
      };
      default = { };
      description = ''
        Defines attributes which are converted to Lua.
        The converted values are made available to the Hyprland config as the result of calling `require('nix-info')`.
        The conversion to Lua uses `lib.generators.toLua` which accepts anything other than uncalled nix functions.
      '';
    };

    "hyprland.lua" = lib.mkOption {
      type = wlib.types.file {
        path = lib.mkOptionDefault config.constructFiles.generatedConfig.path;
        content = lib.mkOptionDefault "return require('nix-info')";
      };
      default = { };
      description = ''
        The Hyprland Lua config file.
      '';
    };
  };

  config = {
    package = lib.mkDefault pkgs.hyprland;

    constructFiles.generatedConfig = {
      relPath = "hyprland-config.lua"; # WARN: solo hyprland.lua
      content = ''
        package.preload["nix-info"] = function()
          return setmetatable(${lib.generators.toLua { } config.luaInfo}, {
            __call = function(self, default, ...)
              if select('#', ...) == 0 then return default end
              local tbl = self;
              for _, key in ipairs({...}) do
                if type(tbl) ~= "table" then return default end
                tbl = tbl[key]
              end
              return tbl
            end
          })
        end

        -- Eseguiamo il file utente Lua
        return dofile(${builtins.toJSON config."hyprland.lua".path})
      '';
    };

    # Il flag `-c` in Hyprland permette di specificare un file di configurazione arbitrario.
    flags."-c" = config.constructFiles.generatedConfig.path;

    meta.maintainers = [ ]; # Aggiungi i maintainers qui se necessario
  };
}
