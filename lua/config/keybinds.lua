-- Possiamo accedere alle variabili iniettate tramite la tabella globale NIX
local term = NIX.terminal or "kitty"
local browser = NIX.browser or "firefox"

hl.bind({ mod = "SUPER", key = "Q", dispatcher = "exec", arg = term })
hl.bind({ mod = "SUPER", key = "B", dispatcher = "exec", arg = browser })
hl.bind({ mod = "SUPER", key = "M", dispatcher = "exit", arg = "" })
