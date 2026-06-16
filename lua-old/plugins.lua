local NIX = require("nix-env")

-- NOTE: Hyprbars sembra non riconoscere le chiavi standard in questa versione di Hyprland Lua.

--[[
hl.config({
    plugin = {
        hyprbars = {
            bar_height = 20,
            bar_color = "rgba(1a1a1acc)",
            bar_text_size = 10,
        }
    }
})
]] --

-- Messaggio di debug per confermare il caricamento del file
print("[Hyprland] plugins.lua loaded (hyprbars config disabled temporarily)")
