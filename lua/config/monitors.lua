local NIX = require("nix-env")

-- Monitor Configuration
-- Note: HDMI-A-1 from hyprland.lua might be system-specific. 
-- We'll keep the logic but maybe allow fallback.

hl.monitor({
    output   = "HDMI-A-1",
    mode     = "3440x1440@100.00",
    position = "auto",
    scale    = tonumber(NIX.displayScale) or 1.25,
})

-- Fallback/Default monitor if needed
hl.monitor({
    output = "",
    mode = "preferred",
    position = "auto",
    scale = tonumber(NIX.displayScale) or 1,
})
