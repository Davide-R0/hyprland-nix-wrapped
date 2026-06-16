local M = {}

function M.apply(nixInfo)
    local mod = "ALT"
    local terminal = nixInfo("kitty", "terminal")

    -- Basic
    hl.bind(mod .. " + Return", hl.dsp.exec_cmd(terminal))
    hl.bind("SUPER + W", hl.dsp.exec_cmd("brave"))
    hl.bind("SUPER + P", hl.dsp.exec_cmd("keepassxc"))
    hl.bind("SUPER + F", hl.dsp.exec_cmd(terminal .. " -e bash -ic 'y; exec bash'"))

    -- DMS IPC Calls
    hl.bind("SUPER + SUPER_L", hl.dsp.exec_cmd("dms ipc call spotlight toggle"))
    hl.bind(mod .. " + D", hl.dsp.exec_cmd("dms ipc call spotlight toggle"))
    hl.bind(mod .. " + B", hl.dsp.exec_cmd("dms ipc call notepad toggle"))
    hl.bind(mod .. " + V", hl.dsp.exec_cmd("dms ipc call clipboard toggle"))
    hl.bind(mod .. " + comma", hl.dsp.exec_cmd("dms ipc call settings focusOrToggle"))
    hl.bind(mod .. " + N", hl.dsp.exec_cmd("dms ipc call notifications toggle"))
    hl.bind(mod .. " + TAB", hl.dsp.exec_cmd("dms ipc call hl toggleOverview"))
    hl.bind(mod .. " + M", hl.dsp.exec_cmd("dms ipc call widget toggle music"))

    hl.bind("SUPER + K", hl.dsp.exec_cmd("dms ipc call keybinds toggle hlland"))
    hl.bind(mod .. " + SHIFT + M", hl.dsp.exec_cmd("dms ipc call processlist focusOrToggle"))
    hl.bind(mod .. " + SHIFT + P", hl.dsp.exec_cmd("dms ipc call powermenu toggle"))
    hl.bind(mod .. " + SHIFT + N", hl.dsp.exec_cmd("dms ipc call night toggle"))
    hl.bind(mod .. " + SHIFT + G", hl.dsp.exec_cmd(terminal .. " -e dgop"))

    -- Operazioni di Sistema Hyprland
    hl.bind(mod .. " + SHIFT + E", hl.dsp.exit())
    hl.bind(mod .. " + SHIFT + O", hl.dsp.dpms("toggle"))
    hl.bind(mod .. " + SHIFT + R", hl.dsp.exec_cmd("hlctl reload"))

    -- Toggle e UI
    --hl.bind(mod .. " + E", hl.dsp.exec_cmd(NIX.toggleNetSpeed))
    hl.bind(mod .. " + SHIFT + B", hl.dsp.exec_cmd("dms ipc call bar toggleAutoHide index 0"))
    --hl.bind(mod .. " + SHIFT + V", hl.dsp.exec_cmd(NIX.toggleBarPosition))

    -- Gestione Finestre (Window Management)
    hl.bind(mod .. " + SHIFT + Q", hl.dsp.window.close())
    --hl.bind(mod .. " + F", hl.dsp.fullscreen("0"))
    hl.bind(mod .. " + SHIFT + F",
        hl.dsp.exec_cmd(
            'hlctl --batch "dispatch togglefloating; dispatch resizeactive exact 40% 40%; dispatch moveactive exact 59% 58%"'))
    --hl.bind(mod .. " + T", hl.dsp.layoutmsg("togglesplit"))
    --hl.bind(mod .. " + P", hl.dsp.pin())
    hl.bind(mod .. " + O", hl.dsp.exec_cmd("hlctl setprop active opaque toggle"))

    -- Screenshot
    hl.bind("Print", hl.dsp.exec_cmd("dms screenshot"))
    hl.bind("CTRL + Print", hl.dsp.exec_cmd("dms screenshot full"))
    hl.bind("ALT + Print", hl.dsp.exec_cmd("dms screenshot window"))

    -- Spostamento Focus
    hl.bind(mod .. " + H", hl.dsp.focus({ direction = "left" }))
    hl.bind(mod .. " + L", hl.dsp.focus({ direction = "right" }))
    hl.bind(mod .. " + K", hl.dsp.focus({ direction = "up" }))
    hl.bind(mod .. " + J", hl.dsp.focus({ direction = "down" }))

    ---- Spostamento Finestre
    --hl.bind(mod .. " + SHIFT + H", hl.dsp.movewindow("l"))
    --hl.bind(mod .. " + SHIFT + L", hl.dsp.movewindow("r"))
    --hl.bind(mod .. " + SHIFT + K", hl.dsp.movewindow("u"))
    --hl.bind(mod .. " + SHIFT + J", hl.dsp.movewindow("d"))

    ---- Gestione Monitor
    --hl.bind(mod .. " + CTRL + left", hl.dsp.focusmonitor("l"))
    --hl.bind(mod .. " + CTRL + right", hl.dsp.focusmonitor("r"))
    --hl.bind(mod .. " + CTRL + H", hl.dsp.focusmonitor("l"))
    --hl.bind(mod .. " + CTRL + L", hl.dsp.focusmonitor("r"))
    --hl.bind(mod .. " + CTRL + K", hl.dsp.focusmonitor("u"))
    --hl.bind(mod .. " + CTRL + J", hl.dsp.focusmonitor("d"))

    ---- Spostamento Finestre su Monitor Differenti
    --hl.bind(mod .. " + SHIFT + CTRL + H", hl.dsp.movewindow("mon:l"))
    --hl.bind(mod .. " + SHIFT + CTRL + L", hl.dsp.movewindow("mon:r"))
    --hl.bind(mod .. " + SHIFT + CTRL + K", hl.dsp.movewindow("mon:u"))
    --hl.bind(mod .. " + SHIFT + CTRL + J", hl.dsp.movewindow("mon:d"))

    ---- Navigazione Workspaces (Relativa)
    --hl.bind(mod .. " + Page_Down", hl.dsp.workspace("e+1"))
    --hl.bind(mod .. " + Page_Up", hl.dsp.workspace("e-1"))
    --hl.bind(mod .. " + U", hl.dsp.workspace("e+1"))
    --hl.bind(mod .. " + I", hl.dsp.workspace("e-1"))

    ---- Spostamento Finestre su Workspaces (Relativa)
    --hl.bind(mod .. " + CTRL + down", hl.dsp.movetoworkspace("e+1"))
    --hl.bind(mod .. " + CTRL + up", hl.dsp.movetoworkspace("e-1"))
    --hl.bind(mod .. " + CTRL + U", hl.dsp.movetoworkspace("e+1"))
    --hl.bind(mod .. " + CTRL + I", hl.dsp.movetoworkspace("e-1"))

    --hl.bind(mod .. " + SHIFT + Page_Down", hl.dsp.movetoworkspace("e+1"))
    --hl.bind(mod .. " + SHIFT + Page_Up", hl.dsp.movetoworkspace("e-1"))
    --hl.bind(mod .. " + SHIFT + U", hl.dsp.movetoworkspace("e+1"))
    --hl.bind(mod .. " + SHIFT + I", hl.dsp.movetoworkspace("e-1"))

    ---- Navigazione tramite Mouse
    --hl.bind(mod .. " + mouse_down", hl.dsp.workspace("e+1"))
    --hl.bind(mod .. " + mouse_up", hl.dsp.workspace("e-1"))
    --hl.bind(mod .. " + CTRL + mouse_down", hl.dsp.movetoworkspace("e+1"))
    --hl.bind(mod .. " + CTRL + mouse_up", hl.dsp.movetoworkspace("e-1"))

    for i = 1, 10 do
        local key = i % 10 -- 10 maps to key 0
        hl.bind(mod .. " + " .. key, hl.dsp.focus({ workspace = i }))
        hl.bind(mod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
    end

    ---- Master Layout e Focus Avanzato
    --hl.bind(mod .. " + bracketleft", hl.dsp.layoutmsg("preselect l"))
    --hl.bind(mod .. " + bracketright", hl.dsp.layoutmsg("preselect r"))
    --hl.bind(mod .. " + Home", hl.dsp.focuswindow("first"))
    --hl.bind(mod .. " + End", hl.dsp.focuswindow("last"))

    ---- Special Workspaces (Scratchpad)
    --hl.bind(mod .. " + SHIFT + S",
    --    hl.dsp.exec_cmd(
    --        'hlctl --batch "dispatch setfloating; dispatch resizeactive exact 60% 60%; dispatch centerwindow; dispatch movetoworkspace special:scratch"'))
    --hl.bind(mod .. " + SHIFT + D",
    --    hl.dsp.exec_cmd('hlctl --batch "dispatch movetoworkspace +0; dispatch settiled"'))
    --hl.bind(mod .. " + S", hl.dsp.togglespecialworkspace("scratch"))

    -- Laptop multimedia keys for volume and LCD brightness
    hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"),
        { locked = true, repeating = true })
    hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),
        { locked = true, repeating = true })
    hl.bind("XF86AudioMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),
        { locked = true, repeating = true })
    hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),
        { locked = true, repeating = true })
    hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+"), { locked = true, repeating = true })
    hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%-"),
        { locked = true, repeating = true })

    -- Requires playerctl
    hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })
    hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
    hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
    hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })
end

return M
