local NIX = require("nix-env")

local mod = "ALT"

-- Utility functions for cleaner code
local function exec(cmd) return hl.dsp.exec_cmd(cmd) end
local function dispatcher(cmd) return hl.dsp.exec_cmd("hyprctl dispatch " .. cmd) end

-- Binds base
hl.bind(mod .. " + RETURN", exec("alacritty"))
hl.bind("SUPER + W", exec("brave"))
hl.bind("SUPER + F", exec("nautilus"))
hl.bind("SUPER + B", exec(NIX.dmsPath .. " ipc call notepad toggle"))
hl.bind("SUPER + C", exec(NIX.dmsPath .. " ipc call clipboard toggle"))
hl.bind("SUPER + P", exec("keepassxc"))

hl.bind("SUPER + SUPER_L", exec(NIX.dmsPath .. " ipc call spotlight toggle"))
hl.bind(mod .. " + D", exec(NIX.dmsPath .. " ipc call spotlight toggle"))
hl.bind(mod .. " + M", exec(NIX.dmsPath .. " ipc call processlist focusOrToggle"))
hl.bind(mod .. " + comma", exec(NIX.dmsPath .. " ipc call settings focusOrToggle"))
hl.bind(mod .. " + N", exec(NIX.dmsPath .. " ipc call notifications toggle"))
hl.bind(mod .. " + Y", exec(NIX.dmsPath .. " ipc call dankdash wallpaper"))
hl.bind(mod .. " + TAB", exec(NIX.dmsPath .. " ipc call hypr toggleOverview"))

hl.bind("SUPER + K", exec(NIX.dmsPath .. " ipc call keybinds toggle hyprland"))
hl.bind(mod .. " + SHIFT + P", exec(NIX.dmsPath .. " ipc call powermenu toggle"))
hl.bind(mod .. " + SHIFT + E", hl.dsp.exit())
hl.bind(mod .. " + SHIFT + O", exec("hyprctl dispatch dpms toggle"))

hl.bind(mod .. " + SHIFT + Q", hl.dsp.window.close())
hl.bind(mod .. " + C", hl.dsp.window.close())
hl.bind(mod .. " + F", hl.dsp.window.fullscreen(0))
hl.bind(mod .. " + SHIFT + F", dispatcher("togglefloating; dispatch resizeactive exact 40% 40%; dispatch moveactive exact 59% 58%"))
hl.bind(mod .. " + T", dispatcher("togglesplit"))
hl.bind(mod .. " + P", dispatcher("pin"))
hl.bind(mod .. " + O", exec("hyprctl setprop active opaque toggle"))

-- Binds senza modificatori
hl.bind("Print", exec(NIX.dmsPath .. " screenshot"))
hl.bind("CTRL + Print", exec(NIX.dmsPath .. " screenshot full"))
hl.bind("ALT + Print", exec(NIX.dmsPath .. " screenshot window"))

-- Movement
hl.bind(mod .. " + H", dispatcher("movefocus l"))
hl.bind(mod .. " + L", dispatcher("movefocus r"))
hl.bind(mod .. " + K", dispatcher("movefocus u"))
hl.bind(mod .. " + J", dispatcher("movefocus d"))

hl.bind(mod .. " + SHIFT + H", dispatcher("movewindow l"))
hl.bind(mod .. " + SHIFT + L", dispatcher("movewindow r"))
hl.bind(mod .. " + SHIFT + K", dispatcher("movewindow u"))
hl.bind(mod .. " + SHIFT + J", dispatcher("movewindow d"))

-- Monitors
hl.bind(mod .. " + CTRL + left", dispatcher("focusmonitor l"))
hl.bind(mod .. " + CTRL + right", dispatcher("focusmonitor r"))
hl.bind(mod .. " + CTRL + H", dispatcher("focusmonitor l"))
hl.bind(mod .. " + CTRL + L", dispatcher("focusmonitor r"))
hl.bind(mod .. " + CTRL + K", dispatcher("focusmonitor u"))
hl.bind(mod .. " + CTRL + J", dispatcher("focusmonitor d"))

hl.bind(mod .. " + SHIFT + CTRL + H", dispatcher("movewindow mon:l"))
hl.bind(mod .. " + SHIFT + CTRL + L", dispatcher("movewindow mon:r"))
hl.bind(mod .. " + SHIFT + CTRL + K", dispatcher("movewindow mon:u"))
hl.bind(mod .. " + SHIFT + CTRL + J", dispatcher("movewindow mon:d"))

-- Workspaces
hl.bind(mod .. " + Page_Down", dispatcher("workspace e+1"))
hl.bind(mod .. " + Page_Up", dispatcher("workspace e-1"))
hl.bind(mod .. " + U", dispatcher("workspace e+1"))
hl.bind(mod .. " + I", dispatcher("workspace e-1"))

hl.bind(mod .. " + CTRL + down", dispatcher("movetoworkspace e+1"))
hl.bind(mod .. " + CTRL + up", dispatcher("movetoworkspace e-1"))
hl.bind(mod .. " + CTRL + U", dispatcher("movetoworkspace e+1"))
hl.bind(mod .. " + CTRL + I", dispatcher("movetoworkspace e-1"))

hl.bind(mod .. " + SHIFT + Page_Down", dispatcher("movetoworkspace e+1"))
hl.bind(mod .. " + SHIFT + Page_Up", dispatcher("movetoworkspace e-1"))
hl.bind(mod .. " + SHIFT + U", dispatcher("movetoworkspace e+1"))
hl.bind(mod .. " + SHIFT + I", dispatcher("movetoworkspace e-1"))

-- Mouse Binds
hl.bind(mod .. " + mouse_down", dispatcher("workspace e+1"))
hl.bind(mod .. " + mouse_up", dispatcher("workspace e-1"))
hl.bind(mod .. " + CTRL + mouse_down", dispatcher("movetoworkspace e+1"))
hl.bind(mod .. " + CTRL + mouse_up", dispatcher("movetoworkspace e-1"))

-- Numbers
for i=1,9 do
    hl.bind(mod .. " + " .. i, dispatcher("workspace " .. i))
    hl.bind(mod .. " + SHIFT + " .. i, dispatcher("movetoworkspace " .. i))
end

-- Layout & Scratchpad
hl.bind(mod .. " + bracketleft", dispatcher("layoutmsg preselect l"))
hl.bind(mod .. " + bracketright", dispatcher("layoutmsg preselect r"))
hl.bind(mod .. " + Home", dispatcher("focuswindow first"))
hl.bind(mod .. " + End", dispatcher("focuswindow last"))

hl.bind(mod .. " + SHIFT + S", dispatcher("setfloating; dispatch resizeactive exact 60% 60%; dispatch centerwindow; dispatch movetoworkspace special:scratch"))
hl.bind(mod .. " + SHIFT + D", dispatcher("movetoworkspace +0; dispatch settiled"))
hl.bind(mod .. " + S", dispatcher("togglespecialworkspace scratch"))

-- Mouse Drag/Resize (Richiede il flag 'mouse' e il dispatcher appropriato)
hl.bind(mod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Binds E/L (Repeating / Locked)
-- binde = repeating, bindl = locked, bindel = sia repeating che locked
hl.bind("XF86AudioRaiseVolume", exec(NIX.dmsPath .. " ipc call audio increment 3"), { repeating = true, locked = true })
hl.bind("XF86AudioLowerVolume", exec(NIX.dmsPath .. " ipc call audio decrement 3"), { repeating = true, locked = true })
hl.bind("XF86MonBrightnessUp", exec(NIX.dmsPath .. " ipc call brightness increment 5 \"\""), { repeating = true, locked = true })
hl.bind("XF86MonBrightnessDown", exec(NIX.dmsPath .. " ipc call brightness decrement 5 \"\""), { repeating = true, locked = true })

hl.bind("XF86AudioMute", exec(NIX.dmsPath .. " ipc call audio mute"), { locked = true })
hl.bind("XF86AudioPlay", exec(NIX.dmsPath .. " ipc call mpris playPause"), { locked = true })
hl.bind("XF86AudioNext", exec(NIX.dmsPath .. " ipc call mpris next"), { locked = true })
hl.bind("XF86AudioPrev", exec(NIX.dmsPath .. " ipc call mpris previous"), { locked = true })

hl.bind(mod .. " + minus", dispatcher("resizeactive -10% 0"), { repeating = true })
hl.bind(mod .. " + equal", dispatcher("resizeactive 10% 0"), { repeating = true })
hl.bind(mod .. " + SHIFT + minus", dispatcher("resizeactive 0 -10%"), { repeating = true })
hl.bind(mod .. " + SHIFT + equal", dispatcher("resizeactive 0 10%"), { repeating = true })

-- Bindd (Description)
hl.bind(mod .. " + code:20", dispatcher("resizeactive -100 0"), { description = "Expand window left" })
hl.bind(mod .. " + code:21", dispatcher("resizeactive 100 0"), { description = "Shrink window left" })

-------------------------------------------------
-- SUBMAPS (Le submaps native in Hyprland Lua 0.55+)
-------------------------------------------------

-- Fullscreen Submap
if NIX.enableHyprbars then
    hl.bind(mod .. " + F", hl.dsp.submap("fullscreen_mode"))
    
    hl.define_submap("fullscreen_mode", function()
        hl.bind("escape", hl.dsp.window.fullscreen(0))
        hl.bind("escape", hl.dsp.submap("reset"))
        hl.bind("ALT + F", hl.dsp.window.fullscreen(0))
        hl.bind("ALT + F", hl.dsp.submap("reset"))
    end)
end

-- Resize Submap
hl.bind(mod .. " + R", hl.dsp.submap("resize"))

hl.define_submap("resize", function()
    hl.bind("l", dispatcher("resizeactive 100 0"), { repeating = true })
    hl.bind("h", dispatcher("resizeactive -100 0"), { repeating = true })
    hl.bind("k", dispatcher("resizeactive 0 -100"), { repeating = true })
    hl.bind("j", dispatcher("resizeactive 0 100"), { repeating = true })
    hl.bind("escape", hl.dsp.submap("reset"))
    hl.bind("return", hl.dsp.submap("reset"))
end)

-- Passthrough Submap
hl.bind("CTRL + ALT + G", hl.dsp.submap("passthru"))

hl.define_submap("passthru", function()
    -- Solo questo tasto è riconosciuto, il resto passa al client Wayland
    hl.bind("CTRL + ALT + G", hl.dsp.submap("reset"))
end)
