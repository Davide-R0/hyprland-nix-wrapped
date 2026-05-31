local lush = require("lush")
local ui = lush.ui

-- Abilitiamo i provider di dati integrati che ci interessano
lush.data.use("cpu", { interval = 2 })
lush.data.use("battery")

local bar = ui.window({
    name = "top_bar", -- Identificativo univoco
    position = "top", -- Ancorata in alto
    exclusive = true, -- Riserva spazio sullo schermo (Hyprland non ci disegnerà finestre sopra)

    -- Usiamo una "Horizontal Box" (hbox) per allineare gli elementi
    root = ui.hbox({
        class = "bar-container", -- Utile per il CSS
        spacing = 15,

        children = {
            -- 1. Modulo Workspaces (esempio concettuale di integrazione con Hyprland)
            ui.button({
                class = "workspace-btn active",
                label = "1",
                on_click = function() os.execute("hyprctl dispatch workspace 1") end
            }),

            -- 2. Spaziatore dinamico per spingere i prossimi widget a destra
            ui.box({ expand = true }),

            -- 3. Widget CPU reattivo
            ui.label({
                class = "cpu-widget",
                -- Magia di Lush: si aggiorna da solo senza script esterni!
                bind = "data.cpu.percent",
                format = " CPU: {value}%"
            }),

            -- 4. Orologio integrato
            ui.clock({
                format = "%H:%M - %A %d %b"
            }),

            -- 5. Widget Batteria reattivo
            ui.label({
                class = "bat-widget",
                bind = "data.battery.percent",
                format = "󰁹 {value}%"
            }),
        }
    })
})

return bar
