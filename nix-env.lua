                  local NIX = {
                    terminal = "alacritty",
                    browser = "firefox",
                    dmsPath = "dms",
                    enableHyprbars = true,
                    extraWindowRule = true,
                    displayScale = "1",
                    extraInit = "",
                    pkgs = {},
                    plugins = {},
                    configModules = { "general", "keybinds", "monitors", "plugins", "rules" }
                  }
                  return NIX
