-- ~/.config/lush/init.lua
local lush = require("lush")

-- Carica i moduli che abbiamo appena creato
local bar = require("bar")
-- Il menu inizialmente lo teniamo "nascosto", lo evocherai tramite una scorciatoia in Hyprland
-- local menu = require("menu")

-- Registra le finestre nel motore di Lush
lush.ui.windows({
    bar
    -- menu (se lo inserisci qui si aprirà all'avvio)
})

-- Carica il foglio di stile
lush.ui.load_css("./lua/style.css")
