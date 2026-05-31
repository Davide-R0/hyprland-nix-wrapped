-- Configurazioni per i plugin caricati
-- Bloccato temporaneamente per testare il bug "unknown config key"

--[[ 
hl.config({
    plugin = {
        hyprbars = {
            bar_height = 20,
            bar_color = "rgba(1a1a1acc)",
            col_text = "rgba(ffffffcc)",
            bar_text_size = 10,
            bar_text_font = "Sans",
            bar_button_padding = 10,
            bar_padding = 10,
            bar_precedence_over_border = true,
        }
    }
})
]]--

-- Le animazioni o i bottoni custom si possono aggiungere con comandi grezzi se il plugin 
-- non ha ancora pieno supporto dict Lua:
-- hl.dispatch(hl.dsp.exec_cmd("hyprctl keyword plugin:hyprbars:hyprbars-button rgba(ff3131cc),15,X,hyprctl dispatch killactive"))
