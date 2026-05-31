-- In Lua, 'require' cerca i file basandosi su package.path
require("monitors")
require("keybinds")

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
