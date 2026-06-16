local M = {}

function M.apply(nixInfo)
    -- Avvio automatico (Exec-once)
    hl.on("hyprland.start", function()
        --hl.exec_cmd(terminal)
        --hl.exec_cmd("nm-applet")
        --hl.exec_cmd("waybar & hyprpaper & firefox") -- Execute waybar, hyprpaper, firefox
    end)

    -- Configs
    hl.config({
        general = {
            gaps_in = nixInfo(5, "gaps", "i"),
            gaps_out = nixInfo(20, "gaps", "o"),
            border_size = 2,
            -- Set to true to enable resizing windows by clicking and dragging on borders and gaps
            resize_on_border = false,
            --col = {
            --    active_border   = { colors = { "rgba(33ccffee)", "rgba(00ff99ee)" }, angle = 45 },
            --    inactive_border = "rgba(595959aa)",
            --},
            -- Please see https://wiki.hypr.land/Configuring/Advanced-and-Cool/Tearing/ before you turn this on
            allow_tearing = false,
            layout = "dwindle",
        },
        dwindle = {
            --pseudotile = true, # Deprecated
            preserve_split = true,
        },
        decoration = {
            rounding = nixInfo(12, "rounding"),
            --rounding_power = 2, -- ???
            active_opacity = nixInfo(0.95, "activeOpacity"),
            inactive_opacity = nixInfo(0.8, "inactiveOpacity"),
            shadow = {
                enabled = true, -- settarlo da nix?
                range = 30,
                render_power = 5,
                --offset = "0 5",
                color = 0xee1a1a1a, --"rgba(00000070)",
            },
            blur = {
                enabled = true,
                size = 3,
                passes = 3,
                --vibrancy  = 0.1696, --???
                new_optimizations = true, -- NOTE: serve ancora o ora è di default??
            },
        },
        animations = {
            enabled = true,
            --animation = {
            --    "windowsIn, 1, 2, default",
            --    "windowsOut, 1, 2, default",
            --    "windowsMove, 1, 3, default",
            --    "fade, 1, 2, default",
            --    "border, 1, 2, default",
            --    "workspaces, 1, 5, default",
            --},
        },

        --source = "./dms/colors.conf", -- TODO:
        --monitor = cfg.monitors, -- TODO: settarlo con nix
        monitor = {
            ",preferred,auto,1",
        },
        workspace = nixInfo({}, "workspaces"),
        -- TODO: agiugnerle con nix
        exec_once = {
            --"ghostty --class=ghostty-prewarm",
            "dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP",
            "systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP",
            "systemctl --user start hyprland-session.target",
            --#"${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1",
        },
        --++ cfg.extraExecOnce;
        env = { "SSH_AUTH_SOCK,$XDG_RUNTIME_DIR/gcr/ssh" },



        xwayland = {
            force_zero_scaling = true,
        },
        master = {
            mfact = 0.5, -- ???
            --new_status = "master", -- nella doc ufficiale c'è questo...
        },


        windowrule = {
            "no_anim class:^(org.quickshell)$",
            "float class:^(xdg-desktop-portal)(.*)$",
            "float class:^(steam)$",
            "float class:^(org.quickshell)$",
            "float class:^(blueman-manager)$",
            "float class:^(zoom)$",
        },

        -- NOTE: per farlo diventare come niri
        -- See https://wiki.hypr.land/Configuring/Layouts/Scrolling-Layout/ for more
        --scrolling = {
        --    fullscreen_on_one_column = true,
        --},

        misc = {
            force_default_wallpaper = 0,
            disable_hyprland_logo = true,
            disable_splash_rendering = true,
            vrr = 0,
            --vfr = true; # Deprecated
        },

        input = {
            kb_layout          = "it",
            kb_variant         = "",
            kb_model           = "",
            kb_options         = "",
            kb_rules           = "",
            --follow_mouse = 1, -- ???
            -- TODO:
            --kb_options = lib.concatStringsSep "," (
            --  [
            --    "caps:escape"
            --    "shift:both_capslock"
            --  ]
            --  ++ cfg.extraKbOptions
            --);
            --#kb_options = "caps:escape,shift:both_capslock"; # numpad:mac
            numlock_by_default = true,
            sensitivity        = 0,
            touchpad           = {
                natural_scroll = true,
                tap_to_click = true,
                disable_while_typing = true,
                clickfinger_behavior = true,
                scroll_factor = 0.5,
            },
        },
    })

    -- Default curves and animations, see https://wiki.hypr.land/Configuring/Advanced-and-Cool/Animations/
    hl.curve("easeOutQuint", { type = "bezier", points = { { 0.23, 1 }, { 0.32, 1 } } })
    hl.curve("easeInOutCubic", { type = "bezier", points = { { 0.65, 0.05 }, { 0.36, 1 } } })
    hl.curve("linear", { type = "bezier", points = { { 0, 0 }, { 1, 1 } } })
    hl.curve("almostLinear", { type = "bezier", points = { { 0.5, 0.5 }, { 0.75, 1 } } })
    hl.curve("quick", { type = "bezier", points = { { 0.15, 0 }, { 0.1, 1 } } })

    -- Default springs
    hl.curve("easy", { type = "spring", mass = 1, stiffness = 71.2633, dampening = 15.8273644 })

    hl.animation({ leaf = "global", enabled = true, speed = 10, bezier = "default" })
    hl.animation({ leaf = "border", enabled = true, speed = 5.39, bezier = "easeOutQuint" })
    hl.animation({ leaf = "windows", enabled = true, speed = 4.79, spring = "easy" })
    hl.animation({ leaf = "windowsIn", enabled = true, speed = 4.1, spring = "easy", style = "popin 87%" })
    hl.animation({ leaf = "windowsOut", enabled = true, speed = 1.49, bezier = "linear", style = "popin 87%" })
    hl.animation({ leaf = "fadeIn", enabled = true, speed = 1.73, bezier = "almostLinear" })
    hl.animation({ leaf = "fadeOut", enabled = true, speed = 1.46, bezier = "almostLinear" })
    hl.animation({ leaf = "fade", enabled = true, speed = 3.03, bezier = "quick" })
    hl.animation({ leaf = "layers", enabled = true, speed = 3.81, bezier = "easeOutQuint" })
    hl.animation({ leaf = "layersIn", enabled = true, speed = 4, bezier = "easeOutQuint", style = "fade" })
    hl.animation({ leaf = "layersOut", enabled = true, speed = 1.5, bezier = "linear", style = "fade" })
    hl.animation({ leaf = "fadeLayersIn", enabled = true, speed = 1.79, bezier = "almostLinear" })
    hl.animation({ leaf = "fadeLayersOut", enabled = true, speed = 1.39, bezier = "almostLinear" })
    hl.animation({ leaf = "workspaces", enabled = true, speed = 1.94, bezier = "almostLinear", style = "fade" })
    hl.animation({ leaf = "workspacesIn", enabled = true, speed = 1.21, bezier = "almostLinear", style = "fade" })
    hl.animation({ leaf = "workspacesOut", enabled = true, speed = 1.94, bezier = "almostLinear", style = "fade" })
    hl.animation({ leaf = "zoomFactor", enabled = true, speed = 7, bezier = "quick" })

    -- Gestures
    hl.gesture({
        fingers = 3,
        direction = "horizontal",
        action = "workspace"
    })
    --gesture = {
    --    "3, horizontal, workspace",
    --    --"3, up, mod: SUPER, scale: 1.5, fullscreen"
    --    -- 3, down, mod: ALT, close
    --    -- 3, left, scale: 1.5, float
    --},

    -- Example per-device config
    -- See https://wiki.hypr.land/Configuring/Advanced-and-Cool/Devices/ for more
    --hl.device({
    --    name        = "epic-mouse-v1",
    --    sensitivity = -0.5,
    --})
end

return M
