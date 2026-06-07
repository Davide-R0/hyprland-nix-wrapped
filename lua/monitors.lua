local NIX = require("nix-env")

-- Apply monitors from Nix config
if NIX.monitors and #NIX.monitors > 0 then
    for _, m in ipairs(NIX.monitors) do
        hl.exec_cmd("hyprctl keyword monitor " .. m)
    end
else
    -- Fallback/Default monitor if none provided
    hl.monitor({
        output = "",
        mode = "preferred",
        position = "auto",
        scale = tonumber(NIX.displayScale) or 1,
    })
end
