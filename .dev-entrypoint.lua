                  -- Aggiungiamo la root e la cartella lua/ per i moduli
                  package.path = "/home/davide/04_Projects/hyprland-nix-wrapped/?.lua;/home/davide/04_Projects/hyprland-nix-wrapped/lua/?.lua;" .. package.path
                  require("init")
