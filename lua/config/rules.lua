local NIX = require("nix-env")

-- Window Rules
hl.window_rule({
    name  = "no_anim_quickshell",
    match = { class = ".*org.quickshell.*" },
    no_anim = true
})

hl.window_rule({
    name  = "float_portal",
    match = { class = ".*xdg-desktop-portal.*" },
    float = true
})

hl.window_rule({
    name  = "float_steam",
    match = { class = ".*steam.*" },
    float = true
})

hl.window_rule({
    name  = "float_blueman",
    match = { class = ".*blueman-manager.*" },
    float = true
})

hl.window_rule({
    name  = "float_zoom",
    match = { class = ".*zoom.*" },
    float = true
})

-- Extra Rules from NIX config
if NIX.extraWindowRule then
    hl.window_rule({
        name = "opacity_browsers",
        match = { class = ".*brave-browser.*|.*librewolf.*" },
        opacity = "0.93 0.8"
    })

    hl.window_rule({
        name = "opacity_imv",
        match = { class = ".*imv.*" },
        opacity = "1.0 0.8"
    })

    hl.window_rule({
        name = "media_player",
        match = { class = ".*play-video.*|.*com.github.rafostar.Clapper.*" },
        opacity = "1.0 1.0",
        float = true,
        size = { "40%", "40%" },
        move = { "59%", "58%" },
        no_initial_focus = true
    })
end
