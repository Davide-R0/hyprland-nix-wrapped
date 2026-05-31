Shell grafica Lush

poi spostare il file di init da qualche altra parte, e richiamare questa
directory come `lua/`

Per integrarla con hyprland:

```lua
-- Nel /hypr/hyprland.lua
hl.bind("SUPER", "Space", function()
    -- Apre la finestra "dmenu_launcher" che hai definito prima
    os.execute("lush-ipc toggle dmenu_launcher")
end)
```
