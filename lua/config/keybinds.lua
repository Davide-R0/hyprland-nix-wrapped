-- Possiamo accedere alle variabili iniettate tramite la tabella globale NIX
local term = NIX.terminal or "kitty"
local browser = NIX.browser or "firefox"

-- Esempio di utilizzo di un pacchetto iniettato tramite extraPackages
-- Se abbiamo aggiunto 'wofi' in Nix, lo troviamo in NIX.pkgs.wofi
local launcher = (NIX.pkgs.wofi or "rofi") .. "/bin/wofi --show drun"

hl.bind({ mod = "SUPER", key = "Q", dispatcher = "exec", arg = term })
hl.bind({ mod = "SUPER", key = "B", dispatcher = "exec", arg = browser })
hl.bind({ mod = "SUPER", key = "R", dispatcher = "exec", arg = launcher })
hl.bind({ mod = "SUPER", key = "M", dispatcher = "exit", arg = "" })

-- Chiamata alla funzione iniettata da Nix
NIX.msg("Configurazione tasti caricata correttamente!")
