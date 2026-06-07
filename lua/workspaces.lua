local NIX = require("nix-env")

-- Apply workspaces from Nix config
if NIX.workspaces and #NIX.workspaces > 0 then
    for _, w in ipairs(NIX.workspaces) do
        hl.exec_cmd("hyprctl keyword workspace " .. w)
    end
end
