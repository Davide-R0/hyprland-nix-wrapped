local NIX = require("nix-env")

local mod = "ALT"
local term = NIX.terminal or "kitty"
local browser = NIX.browser or "firefox"

local launcher_pkg = NIX.pkgs.wofi or NIX.pkgs.rofi
local launcher = "wofi --show drun" -- fallback
if launcher_pkg then
    launcher = launcher_pkg .. "/bin/" .. (NIX.pkgs.wofi and "wofi" or "rofi") .. " --show drun"
end

-- Nuova sintassi nativa hl.bind
hl.bind(mod, "RETURN", "exec", term)
hl.bind(mod .. " SHIFT", "Q", "killactive")

hl.bind(mod, "Q", "exec", term)
hl.bind(mod, "B", "exec", browser)
hl.bind(mod, "R", "exec", launcher)
hl.bind(mod, "M", "exit")

-- Al posto di print, possiamo usare os.execute per loggare o testare
os.execute("echo 'Configurazione tasti caricata nativamente' >&2")
