local NIX = require("nix-env")
local scale = NIX.displayScale or "1"

-- Usiamo l'API hl nativa di Hyprland 0.55+
hl.config({
    monitor = {
        "WL-1, 1920x1080@60, auto, " .. scale,
        ", preferred, auto, " .. scale -- Fallback
    }
})
