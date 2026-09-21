local M = {}

function M.apply(nixInfo)
    -- WARN: le direttive-keyword di hyprlang (monitor, exec-once,
    -- env, windowrule, workspace, source) NON sono chiavi valide di
    -- hl.config: passate li' vengono ignorate IN SILENZIO (config ok
    -- ma nessun effetto — successo il 21/09/2026 con scala monitor e
    -- autostart). In Lua si usano le funzioni dedicate: hl.monitor,
    -- hl.on('hyprland.start'), hl.env, hl.window_rule,
    -- hl.workspace_rule.

    -- Avvio automatico (exec-once)
    hl.on('hyprland.start', function()
        hl.exec_cmd("dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP")
        hl.exec_cmd("systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP")
        hl.exec_cmd("systemctl --user start hyprland-session.target")
        for _, cmd in ipairs(nixInfo({}, "extraExecOnce")) do
            hl.exec_cmd(cmd)
        end
    end)

    -- Variabili d'ambiente della sessione
    hl.env("SSH_AUTH_SOCK", "$XDG_RUNTIME_DIR/gcr/ssh")

    -- Monitor: stringhe in formato hyprlang "NOME, MODE, POS, SCALA"
    -- tradotte in chiamate hl.monitor()
    for _, mon in ipairs(nixInfo({ ",preferred,auto,1" }, "monitors")) do
        local fields = {}
        for f in mon:gmatch("([^,]*)") do
            fields[#fields + 1] = f:match("^%s*(.-)%s*$")
        end
        hl.monitor({
            output   = fields[1] or "",
            mode     = (fields[2] ~= "" and fields[2]) or "preferred",
            position = (fields[3] ~= "" and fields[3]) or "auto",
            scale    = tonumber(fields[4]) or fields[4] or 1,
        })
    end

    -- Workspace rules: "ID, chiave:valore, ..." -> hl.workspace_rule
    -- Le chiavi hyprlang che in Lua hanno un nome diverso vengono
    -- tradotte; una chiave sconosciuta fa fallire il verify-config
    -- ad alta voce (meglio di un'opzione ignorata in silenzio).
    local ws_key_alias = {
        gapsin = "gaps_in",
        gapsout = "gaps_out",
        bordersize = "border_size",
        ["on-created-empty"] = "on_created_empty",
    }
    for _, ws in ipairs(nixInfo({}, "workspaces")) do
        local rule = {}
        local first = true
        for raw in ws:gmatch("([^,]+)") do
            local f = raw:match("^%s*(.-)%s*$")
            if first then
                rule.workspace = f
                first = false
            else
                local k, v = f:match("^([%w_%-]+)%s*:%s*(.+)$")
                if k then
                    k = ws_key_alias[k] or k
                    if v == "true" then
                        rule[k] = true
                    elseif v == "false" then
                        rule[k] = false
                    else
                        rule[k] = tonumber(v) or v
                    end
                end
            end
        end
        if rule.workspace then hl.workspace_rule(rule) end
    end

    -- Window rules (in hyprlang erano le stringhe windowrule)
    hl.window_rule({
        name    = "no-anim-quickshell",
        match   = { class = "^(org.quickshell)$" },
        no_anim = true,
    })
    for _, class in ipairs({
        "^(xdg-desktop-portal)(.*)$",
        "^(steam)$",
        "^(org.quickshell)$",
        "^(blueman-manager)$",
        "^(zoom)$",
    }) do
        hl.window_rule({
            name  = "float-" .. class:gsub("%W", ""),
            match = { class = class },
            float = true,
        })
    end

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

        -- NOTE: monitor/workspace/exec-once/env/windowrule/source NON
        -- vanno qui: vedi il WARN in testa a M.apply.
        xwayland = {
            force_zero_scaling = true,
        },
        master = {
            mfact = 0.5, -- ???
            --new_status = "master", -- nella doc ufficiale c'è questo...
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
            kb_layout          = nixInfo("it", "kb_layout"),
            kb_variant         = "",
            kb_model           = "",
            kb_rules           = "",
            --follow_mouse = 1, -- ???
            kb_options         = (function()
                local opts = { "caps:escape", "shift:both_capslock" }
                for _, opt in ipairs(nixInfo({}, "extraKbOptions")) do
                    table.insert(opts, opt)
                end
                return table.concat(opts, ",")
            end)(),
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

    -- Config per-device passate da Nix (settings.extraDevices)
    -- See https://wiki.hypr.land/Configuring/Advanced-and-Cool/Devices/ for more
    for _, dev in ipairs(nixInfo({}, "extraDevices")) do
        hl.device(dev)
    end

    -- Colori dei bordi da un colors.conf esterno (es. matugen).
    -- Il file e' hyprlang: qui leggiamo solo le variabili
    -- "$nome = valore" e le applichiamo. Letto ad ogni avvio o
    -- `hyprctl reload`; se manca o e' malformato, si ignora.
    local colors_file = nixInfo("", "colorsConfFile")
    if colors_file ~= "" then
        pcall(function()
            local f = io.open(colors_file, "r")
            if not f then return end
            local vars = {}
            for line in f:lines() do
                local name, val = line:match("^%s*%$([%w_]+)%s*=%s*(.-)%s*$")
                if name and val and val ~= "" then vars[name] = val end
            end
            f:close()
            if vars.primary and vars.outline then
                hl.config({
                    general = {
                        col = {
                            active_border = vars.primary,
                            inactive_border = vars.outline,
                        },
                    },
                    group = {
                        col = {
                            border_active = vars.primary,
                            border_inactive = vars.outline,
                            border_locked_active = vars.error or vars.primary,
                            border_locked_inactive = vars.outline,
                        },
                        groupbar = {
                            col = {
                                active = vars.primary,
                                inactive = vars.outline,
                                locked_active = vars.error or vars.primary,
                                locked_inactive = vars.outline,
                            },
                        },
                    },
                })
            end
        end)
    end
end

return M
