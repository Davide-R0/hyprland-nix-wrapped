local NIX = require("nix-env")

local rules = {
    "no_anim class:^(org.quickshell)$",
    "float class:^(xdg-desktop-portal)(.*)$",
    "float class:^(steam)$",
    "float class:^(org.quickshell)$",
    "float class:^(blueman-manager)$",
    "float class:^(zoom)$"
}

if NIX.extraWindowRule then
    local extraRules = {
        "opacity 0.93 0.8, class:^(brave-browser)$",
        "opacity 0.93 0.8, class:^(librewolf)$",
        "opacity 1.0 0.8, class:^(imv)$",
        "opacity 1.0 1.0, class:^(mpv)$",

        "opacity 1.0 1.0, class:^(play-video|com.github.rafostar.Clapper)$",
        "float class:^(play-video|com.github.rafostar.Clapper)$",
        "size 40% 40%, class:^(play-video|com.github.rafostar.Clapper)$",
        "move 59% 58%, class:^(play-video|com.github.rafostar.Clapper)$",
        "no_initial_focus class:^(play-video|com.github.rafostar.Clapper)$",

        "opacity 0.8 0.1, class:^(play-audio)$",
        "float, class:^(play-audio)$",
        "size 40% 40%, class:^(play-audio$)",
        "move 59% 58%, class:^(play-audio)$",
        "no_initial_focus class:^(play-audio)$"
    }
    
    -- Uniamo le tabelle
    for _, v in ipairs(extraRules) do
        table.insert(rules, v)
    end
end

hl.config({
    windowrule = rules
})
