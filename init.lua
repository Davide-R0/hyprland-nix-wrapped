-- Hyprland Lua Configuration
local nixInfo = require('nix-info')

-- Aggiungiamo la nostra directory ./lua al package.path in modo da poter usare require
local lua_dir = nixInfo(nil, "lua_dir")
if lua_dir then
    package.path = package.path .. ";" .. lua_dir .. "/?.lua;" .. lua_dir .. "/?/init.lua"
end

-- Esempio di utilizzo API Hyprland Lua (>=0.55)
-- Hyprland potrebbe esporre un modulo nativo 'hyprland'. Se non presente, usiamo una tabella locale.
local hypr = { config = {} }
pcall(function() hypr = require('hyprland') end)
if not hypr.config then hypr.config = {} end

-- Estraiamo i nostri valori da Nix
local terminal = nixInfo("kitty", "terminal")
local launcher = nixInfo("wofi --show drun", "launcher")
local mod = nixInfo("SUPER", "mod")
local gaps_in = nixInfo(5, "gaps", "i")
local gaps_out = nixInfo(20, "gaps", "o")
local active_border = nixInfo("rgba(33ccffee)", "colors", "active_border")

-- Configurazioni Generali
hypr.config.general = {
    gaps_in = gaps_in,
    gaps_out = gaps_out,
    border_size = 2,
    ["col.active_border"] = active_border,
    ["col.inactive_border"] = "rgba(595959aa)",
    layout = "dwindle",
}

-- Configurazioni Decorazioni
hypr.config.decoration = {
    rounding = 10,
    blur = {
        enabled = true,
        size = 3,
        passes = 1,
    },
    drop_shadow = true,
}

-- Monitor (Auto setup)
hypr.config.monitor = {
    ",preferred,auto,1"
}

-- Keybindings
local binds = {
    -- Terminal e Launcher
    { mod,         "Q",      "exec",          terminal },
    { "ALT",       "Return", "exec",          terminal },
    { mod,         "R",      "exec",          launcher },
    { mod,         "C",      "killactive" },
    { "ALT_SHIFT", "Q",      "killactive" },
    { mod,         "M",      "exit" },
    { mod,         "V",      "togglefloating" },

    -- Navigazione Focus
    { mod,         "left",   "movefocus",     "l" },
    { mod,         "right",  "movefocus",     "r" },
    { mod,         "up",     "movefocus",     "u" },
    { mod,         "down",   "movefocus",     "d" },
}

-- Registrazione bind in loop (Simulato per l'API Lua di Hyprland)
-- FIXME: non penso funzioni così, es giusti:
--hl.bind(mod .. " + Return", hl.dsp.exec_cmd(NIX.terminal))
--hl.bind("SUPER + W", hl.dsp.exec_cmd(NIX.browser))
--hl.bind("SUPER + F", hl.dsp.exec_cmd("nautilus"))
if type(hypr.bind) == "function" then
    for _, bind in ipairs(binds) do
        hypr.bind(bind[1], bind[2], bind[3], bind[4])
    end
end

-- Avvio automatico (Exec-once)
if type(hypr.exec_once) == "function" then
    hypr.exec_once("waybar")
end

return hypr.config
