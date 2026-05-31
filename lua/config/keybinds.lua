local NIX = require("nix-env")

local mod = "ALT"
local term = NIX.terminal or "kitty"
local browser = NIX.browser or "firefox"

local launcher_pkg = NIX.pkgs.wofi or NIX.pkgs.rofi
local launcher = "wofi --show drun" -- fallback
if launcher_pkg then
    launcher = launcher_pkg .. "/bin/" .. (NIX.pkgs.wofi and "wofi" or "rofi") .. " --show drun"
end

-- In Hyprland 0.55+ hl.bind richiede 2 parametri: la stringa con modificatore e tasto, e il dispatcher
hl.bind(mod .. " + RETURN", hl.dsp.exec_cmd(term))
-- Usiamo il dispatcher nativo di Hyprland per chiudere la finestra
hl.bind(mod .. " + SHIFT + q", hl.dsp.window.close())

hl.bind(mod .. " + q", hl.dsp.exec_cmd(term))
hl.bind(mod .. " + B", hl.dsp.exec_cmd(browser))
hl.bind(mod .. " + R", hl.dsp.exec_cmd(launcher))
hl.bind(mod .. " + M", hl.dsp.exec_cmd("hyprctl dispatch exit"))

os.execute("echo 'Configurazione tasti caricata nativamente' >&2")
