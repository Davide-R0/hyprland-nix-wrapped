-- Usiamo ALT per evitare conflitti con il compositor ospite (che usa SUPER)
local mod = "ALT"
local term = NIX.terminal or "kitty"
local browser = NIX.browser or "firefox"

local launcher_pkg = NIX.pkgs.wofi or NIX.pkgs.rofi
local launcher = "wofi --show drun" -- fallback se non troviamo il path
if launcher_pkg then
    launcher = launcher_pkg .. "/bin/" .. (NIX.pkgs.wofi and "wofi" or "rofi") .. " --show drun"
end

-- Apertura Terminale
hl.bind({ mod = mod, key = "RETURN", dispatcher = "exec", arg = term })
-- Chiusura Finestra
hl.bind({ mod = mod .. " SHIFT", key = "Q", dispatcher = "killactive", arg = "" })

hl.bind({ mod = mod, key = "Q", dispatcher = "exec", arg = term })
hl.bind({ mod = mod, key = "B", dispatcher = "exec", arg = browser })
hl.bind({ mod = mod, key = "R", dispatcher = "exec", arg = launcher })
hl.bind({ mod = mod, key = "M", dispatcher = "exit", arg = "" })

-- Chiamata alla funzione iniettata da Nix
NIX.msg("Configurazione tasti caricata correttamente!")
