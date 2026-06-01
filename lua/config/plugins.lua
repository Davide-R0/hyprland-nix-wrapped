local NIX = require("nix-env")

-- Configurazione Plugins
-- NOTA: Hyprbars sembra non riconoscere le chiavi standard in questa versione di Hyprland Lua.
-- Commentiamo la configurazione per evitare errori al lancio finché non viene risolto il build dei plugin.

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
]]--

-- Messaggio di debug per confermare il caricamento del file
print("[Hyprland] plugins.lua loaded (hyprbars config disabled temporarily)")
