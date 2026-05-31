local NIX = require("nix-env")

hl.config({
    exec_once = {
        NIX.dmsPath .. " run",
        -- ATTENZIONE: Questi comandi sono stati disabilitati per il testing nested.
        -- Se eseguiti in una finestra, sovrascrivono il WAYLAND_DISPLAY del tuo sistema host
        -- e rompono la sessione principale (causando i blocchi IPC).
        -- "dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP",
        -- "systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP",
        -- "systemctl --user start hyprland-session.target",
        -- "/usr/libexec/polkit-gnome-authentication-agent-1" 
    },
    
    env = {
        "SSH_AUTH_SOCK,$XDG_RUNTIME_DIR/gcr/ssh"
    },

    input = {
        kb_layout = "it",
        kb_options = "caps:escape,shift:both_capslock",
        numlock_by_default = true,
        sensitivity = 0,
        touchpad = {
            tap_to_click = true,
            natural_scroll = true,
            disable_while_typing = true,
            clickfinger_behavior = true,
            scroll_factor = 0.5,
        }
    },

    -- Bloccato temporaneamente per testare il bug "unknown config key"
    -- gestures = {
    --     workspace_swipe = true,
    -- },

    general = {
        gaps_in = 4,
        gaps_out = 8,
        border_size = 2,
        layout = "dwindle",
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
            "workspaces, 1, 5, default"
        }
    }
})
