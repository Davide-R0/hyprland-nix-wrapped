-- Carichiamo la libreria bridge
_G.hl = require("hl")

-- In Lua, 'require' cerca i file basandosi su package.path
require("config.monitors")
require("config.keybinds")

-- Configurazioni generali
hl.general({
  border_size = 2,
  gaps_in = 5,
  gaps_out = 10,
  -- eccetera...
})

hl.decorations({
  rounding = 8,
})

-- Risolve problemi comuni in modalità nested/Wayland-on-Wayland
hl.raw("cursor {\n    no_hardware_cursors = true\n}")
hl.raw("env = WLR_NO_HARDWARE_CURSORS,1")
