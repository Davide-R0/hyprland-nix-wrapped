local NIX = require("nix-env")

-- General Configuration
hl.config({
    general = {
        border_size = 2,
        gaps_in = 4,
        gaps_out = 8,
        layout = "dwindle",
    },

    input = {
        kb_layout = "it",
        kb_options = "caps:escape,shift:both_capslock",
        numlock_by_default = true,
        sensitivity = 0,
        touchpad = {
            clickfinger_behavior = true,
            disable_while_typing = true,
            natural_scroll = true,
            scroll_factor = 0.5,
            tap_to_click = true,
        },
    },

    decoration = {
        rounding = 12,
        active_opacity = 0.95,
        inactive_opacity = 0.8,
        blur = {
            enabled = true,
            size = 3,
            passes = 3,
            new_optimizations = true,
        },
        shadow = {
            enabled = false,
            range = 30,
            render_power = 5,
            offset = "0 5",
            color = "rgba(00000070)",
        }
    },

    animations = {
        enabled = true,
        animation = {
            "windowsIn, 1, 2, default",
            "windowsOut, 1, 2, default",
            "windowsMove, 1, 3, default",
            "fade, 1, 2, default",
            "border, 1, 2, default",
            "workspaces, 1, 5, default",
        },
    },

    dwindle = {
        preserve_split = true,
    },

    master = {
        mfact = 0.5,
    },

    misc = {
        disable_hyprland_logo = true,
        disable_splash_rendering = true,
        vrr = 0,
    },
})

-- Environment Variables
hl.env("SSH_AUTH_SOCK", "$XDG_RUNTIME_DIR/gcr/ssh")

-- Autostart
hl.on("hyprland.start", function()
    -- Check if we are running nested (inside another Wayland/X11 session)
    -- local is_nested = os.getenv("WAYLAND_DISPLAY") ~= nil or os.getenv("DISPLAY") ~= nil

    -- if is_nested then
    --     print("[Hyprland] Nested session detected. Skipping autostart to protect host.")
    --     return
    -- end

    -- Environment setup (Only for main session)
    local dbus_pkg = NIX.pkgs["dbus"]
    local dbus_bin = dbus_pkg and (dbus_pkg .. "/bin/dbus-update-activation-environment") or
        "dbus-update-activation-environment"
    hl.exec_cmd(dbus_bin ..
        " --systemd DISPLAY HYPRLAND_INSTANCE_SIGNATURE WAYLAND_DISPLAY XDG_CURRENT_DESKTOP XDG_SESSION_TYPE")

    --hl.exec_cmd("systemctl --user stop hyprland-session.target")
    hl.exec_cmd("systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP")
    hl.exec_cmd("systemctl --user start hyprland-session.target || systemctl --user start graphical-session.target")

    -- Execute commands from Nix extraExecOnce option
    if NIX.extraExecOnce and #NIX.extraExecOnce > 0 then
        for _, cmd in ipairs(NIX.extraExecOnce) do
            hl.exec_cmd(cmd)
        end
    end

    -- Execute commands from Nix extraInit option
    if NIX.extraInit and NIX.extraInit ~= "" then
        -- We might need to split by lines if exec_cmd only takes one command
        for line in NIX.extraInit:gmatch("[^\r\n]+") do
            if line:match("%S") then
                hl.exec_cmd(line)
            end
        end
    end
end)
