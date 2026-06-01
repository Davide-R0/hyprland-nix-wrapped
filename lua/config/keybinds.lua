local NIX = require("nix-env")

local mod = "ALT"

-- Helper for DMS commands
local function dms(cmd)
    return hl.dsp.exec_cmd(NIX.dmsPath .. " " .. cmd)
end

-- Basic Binds
hl.bind(mod .. " + Return", hl.dsp.exec_cmd("alacritty"))
hl.bind("SUPER + W", hl.dsp.exec_cmd("brave"))
hl.bind("SUPER + F", hl.dsp.exec_cmd("nautilus"))
hl.bind("SUPER + B", dms("ipc call notepad toggle"))
hl.bind("SUPER + C", dms("ipc call clipboard toggle"))
hl.bind("SUPER + P", hl.dsp.exec_cmd("keepassxc"))
hl.bind("SUPER + SUPER_L", dms("ipc call spotlight toggle"))
hl.bind(mod .. " + D", dms("ipc call spotlight toggle"))
hl.bind(mod .. " + M", dms("ipc call processlist focusOrToggle"))
hl.bind(mod .. " + comma", dms("ipc call settings focusOrToggle"))
hl.bind(mod .. " + N", dms("ipc call notifications toggle"))
hl.bind(mod .. " + Y", dms("ipc call dankdash wallpaper"))
hl.bind(mod .. " + TAB", dms("ipc call hypr toggleOverview"))
hl.bind("SUPER + K", dms("ipc call keybinds toggle hyprland"))
hl.bind(mod .. " + SHIFT + P", dms("ipc call powermenu toggle"))

-- System & Session
hl.bind(mod .. " + SHIFT + E", hl.dsp.exit())
hl.bind(mod .. " + SHIFT + O", hl.dsp.dpms("toggle"))
hl.bind(mod .. " + SHIFT + Q", hl.dsp.window.close())
hl.bind(mod .. " + C", hl.dsp.window.close())
hl.bind(mod .. " + F", hl.dsp.window.fullscreen())
hl.bind(mod .. " + SHIFT + F", hl.dsp.exec_cmd("hyprctl --batch dispatch togglefloating; dispatch resizeactive exact 40% 40%; dispatch moveactive exact 59% 58%"))
hl.bind(mod .. " + T", hl.dsp.layout("togglesplit"))
hl.bind(mod .. " + P", hl.dsp.window.pin())
hl.bind(mod .. " + O", hl.dsp.exec_cmd("hyprctl setprop active opaque toggle"))

-- Screenshot
hl.bind("Print", dms("screenshot"))
hl.bind("CTRL + Print", dms("screenshot full"))
hl.bind("ALT + Print", dms("screenshot window"))

-- Focus & Movement
hl.bind(mod .. " + H", hl.dsp.focus({ direction = "l" }))
hl.bind(mod .. " + L", hl.dsp.focus({ direction = "r" }))
hl.bind(mod .. " + K", hl.dsp.focus({ direction = "u" }))
hl.bind(mod .. " + J", hl.dsp.focus({ direction = "d" }))

-- Window Moving
hl.bind(mod .. " + SHIFT + H", hl.dsp.window.move({ direction = "l" }))
hl.bind(mod .. " + SHIFT + L", hl.dsp.window.move({ direction = "r" }))
hl.bind(mod .. " + SHIFT + K", hl.dsp.window.move({ direction = "u" }))
hl.bind(mod .. " + SHIFT + J", hl.dsp.window.move({ direction = "d" }))

-- Monitors
hl.bind(mod .. " + CTRL + left", hl.dsp.focus({ monitor = "l" }))
hl.bind(mod .. " + CTRL + right", hl.dsp.focus({ monitor = "r" }))
hl.bind(mod .. " + CTRL + H", hl.dsp.focus({ monitor = "l" }))
hl.bind(mod .. " + CTRL + L", hl.dsp.focus({ monitor = "r" }))
hl.bind(mod .. " + CTRL + K", hl.dsp.focus({ monitor = "u" }))
hl.bind(mod .. " + CTRL + J", hl.dsp.focus({ monitor = "d" }))

-- Monitor Window Movement
hl.bind(mod .. " + SHIFT + CTRL + H", hl.dsp.window.move({ monitor = "l" }))
hl.bind(mod .. " + SHIFT + CTRL + L", hl.dsp.window.move({ monitor = "r" }))
hl.bind(mod .. " + SHIFT + CTRL + K", hl.dsp.window.move({ monitor = "u" }))
hl.bind(mod .. " + SHIFT + CTRL + J", hl.dsp.window.move({ monitor = "d" }))

-- Workspaces
hl.bind(mod .. " + Page_Down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mod .. " + Page_Up", hl.dsp.focus({ workspace = "e-1" }))
hl.bind(mod .. " + U", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mod .. " + I", hl.dsp.focus({ workspace = "e-1" }))

hl.bind(mod .. " + CTRL + down", hl.dsp.window.move({ workspace = "e+1" }))
hl.bind(mod .. " + CTRL + up", hl.dsp.window.move({ workspace = "e-1" }))
hl.bind(mod .. " + CTRL + U", hl.dsp.window.move({ workspace = "e+1" }))
hl.bind(mod .. " + CTRL + I", hl.dsp.window.move({ workspace = "e-1" }))

hl.bind(mod .. " + SHIFT + Page_Down", hl.dsp.window.move({ workspace = "e+1" }))
hl.bind(mod .. " + SHIFT + Page_Up", hl.dsp.window.move({ workspace = "e-1" }))
hl.bind(mod .. " + SHIFT + U", hl.dsp.window.move({ workspace = "e+1" }))
hl.bind(mod .. " + SHIFT + I", hl.dsp.window.move({ workspace = "e-1" }))

-- Mouse Binds
hl.bind(mod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mod .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }))
hl.bind(mod .. " + CTRL + mouse_down", hl.dsp.window.move({ workspace = "e+1" }))
hl.bind(mod .. " + CTRL + mouse_up", hl.dsp.window.move({ workspace = "e-1" }))

-- Numbered Workspaces
for i = 1, 9 do
    hl.bind(mod .. " + " .. i, hl.dsp.focus({ workspace = i }))
    hl.bind(mod .. " + SHIFT + " .. i, hl.dsp.window.move({ workspace = i }))
end

-- Layout & Scratchpad
hl.bind(mod .. " + bracketleft", hl.dsp.layout("preselect l"))
hl.bind(mod .. " + bracketright", hl.dsp.layout("preselect r"))
hl.bind(mod .. " + Home", hl.dsp.focus({ window = "first" }))
hl.bind(mod .. " + End", hl.dsp.focus({ window = "last" }))

hl.bind(mod .. " + SHIFT + S", hl.dsp.exec_cmd("hyprctl --batch dispatch setfloating; dispatch resizeactive exact 60% 60%; dispatch centerwindow; dispatch movetoworkspace special:scratch"))
hl.bind(mod .. " + SHIFT + D", hl.dsp.exec_cmd("hyprctl --batch dispatch movetoworkspace +0; dispatch settiled"))
hl.bind(mod .. " + S", hl.dsp.workspace.toggle_special("scratch"))

-- Media Keys
hl.bind("XF86AudioRaiseVolume", dms("ipc call audio increment 3"), { locked = true })
hl.bind("XF86AudioLowerVolume", dms("ipc call audio decrement 3"), { locked = true })
hl.bind("XF86MonBrightnessUp", dms("ipc call brightness increment 5"), { locked = true })
hl.bind("XF86MonBrightnessDown", dms("ipc call brightness decrement 5"), { locked = true })
hl.bind("XF86AudioMute", dms("ipc call audio mute"), { locked = true })
hl.bind("XF86AudioPlay", dms("ipc call mpris playPause"), { locked = true })
hl.bind("XF86AudioNext", dms("ipc call mpris next"), { locked = true })
hl.bind("XF86AudioPrev", dms("ipc call mpris previous"), { locked = true })

-- Mouse Drag/Resize
hl.bind(mod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-------------------------------------------------
-- SUBMAPS
-------------------------------------------------

-- Resize Submap
hl.bind(mod .. " + R", hl.dsp.submap("resize"))
hl.define_submap("resize", function()
    hl.bind("l", hl.dsp.exec_cmd("hyprctl dispatch resizeactive 100 0"), { repeating = true })
    hl.bind("h", hl.dsp.exec_cmd("hyprctl dispatch resizeactive -100 0"), { repeating = true })
    hl.bind("k", hl.dsp.exec_cmd("hyprctl dispatch resizeactive 0 -100"), { repeating = true })
    hl.bind("j", hl.dsp.exec_cmd("hyprctl dispatch resizeactive 0 100"), { repeating = true })
    hl.bind("escape", hl.dsp.submap("reset"))
    hl.bind("return", hl.dsp.submap("reset"))
end)

-- Passthrough Submap
hl.bind("CTRL + ALT + G", hl.dsp.submap("passthru"))
hl.define_submap("passthru", function()
    hl.bind("CTRL + ALT + G", hl.dsp.submap("reset"))
end)
