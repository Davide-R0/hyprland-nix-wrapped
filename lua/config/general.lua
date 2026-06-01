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
    -- Environment setup
    -- We use a safer way to access paths from NIX.pkgs
    local dbus_bin = (NIX.pkgs.dbus or "/usr") .. "/bin/dbus-update-activation-environment"
    hl.exec_cmd(dbus_bin .. " --systemd DISPLAY HYPRLAND_INSTANCE_SIGNATURE WAYLAND_DISPLAY XDG_CURRENT_DESKTOP XDG_SESSION_TYPE")
    hl.exec_cmd("systemctl --user stop hyprland-session.target")
    hl.exec_cmd("systemctl --user start hyprland-session.target")
    
    -- DMS and other services
    hl.exec_cmd(NIX.dmsPath .. " run")
    hl.exec_cmd("dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP")
    hl.exec_cmd("systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP")
    
    -- Authentication agent
    local polkit_agent = NIX.pkgs["polkit-gnome"] or "/usr/libexec/polkit-gnome-authentication-agent-1"
    if type(polkit_agent) == "string" and polkit_agent:sub(1,1) == "/" then
        -- If it's a nix store path, we might need to append the binary location
        if polkit_agent:find("/nix/store") then
             hl.exec_cmd(polkit_agent .. "/libexec/polkit-gnome-authentication-agent-1")
        else
             hl.exec_cmd(polkit_agent)
        end
    end
    
    hl.exec_cmd("sleep 5 && " .. NIX.dmsPath .. " ipc call plugins disable compactNetSpeedV8")
end)
