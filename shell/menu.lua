local lush = require("lush")
local ui = lush.ui

local app_menu = ui.window({
    name = "dmenu_launcher",
    position = "center",
    layer = "overlay",                    -- Disegna sopra tutte le finestre di Hyprland
    keyboard_interactivity = "exclusive", -- Essenziale per catturare quello che scrivi

    -- Usiamo una "Vertical Box" (vbox) per avere la ricerca sopra e i risultati sotto
    root = ui.vbox({
        class = "menu-wrapper",
        spacing = 10,

        children = {
            -- La barra di ricerca
            ui.entry({
                class = "search-box",
                placeholder = "Cerca un'applicazione o comando...",

                -- Callback quando digiti qualcosa
                on_change = function(text)
                    -- Qui potresti chiamare una funzione Lua che filtra
                    -- un array di file .desktop nella tua /usr/share/applications/
                    print("L'utente sta cercando: " .. text)
                end,

                -- Callback quando premi Invio
                on_submit = function(text)
                    -- Eseguiamo il comando in background
                    os.execute(text .. " &")

                    -- Chiudiamo il menu dinamicamente sfruttando l'IPC di Lush
                    lush.ipc.close_window("dmenu_launcher")
                end
            }),

            -- Lista dei risultati (Qui messi statici per l'esempio,
            -- ma in una config reale li genereresti tramite un ciclo for in Lua)
            ui.vbox({
                spacing = 2,
                children = {
                    ui.button({
                        label = "  Firefox",
                        on_click = function()
                            os.execute("firefox &"); lush.ipc.close_window("dmenu_launcher")
                        end
                    }),
                    ui.button({
                        label = "  Kitty Terminal",
                        on_click = function()
                            os.execute("kitty &"); lush.ipc.close_window("dmenu_launcher")
                        end
                    }),
                }
            })
        }
    })
})

return app_menu
