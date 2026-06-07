# Esempi Avanzati di Configurazione Hyprland in Lua

L'integrazione di Lua in Hyprland v0.55.0 permette di trasformare la
configurazione da statica a programmatica. Ecco alcuni esempi di cosa è
possibile realizzare.

## 1. Layout Dinamici Basati sul Numero di Finestre

Cambia automaticamente il layout o i gap in base a quante finestre sono aperte
in quel momento nel workspace corrente.

```lua
hl.on("window.open", function()
    local windows = hl.get_info("workspace").windows
    if windows > 3 then
        hl.dispatch(hl.dsp.config("general:gaps_in", 2))
        hl.dispatch(hl.dsp.config("general:gaps_out", 4))
    else
        hl.dispatch(hl.dsp.config("general:gaps_in", 10))
        hl.dispatch(hl.dsp.config("general:gaps_out", 20))
    end
end)
```

## 2. Gestione Intelligente dei Monitor (Auto-Config)

Invece di avere monitor hardcoded, itera sui monitor connessi e applica regole
diverse (es. spegnere lo schermo del portatile se è collegato un monitor
esterno).

```lua
hl.on("monitor.added", function()
    local monitors = hl.get_info("monitors")
    for _, mon in ipairs(monitors) do
        -- Se eDP-1 (laptop) è connesso ma c'è anche un altro monitor, spegni il laptop
        if mon.name == "eDP-1" and #monitors > 1 then
            hl.monitor({ output = mon.name, mode = "disable" })
        end
    end
end)
```

## 3. Workspace "Ciclici" o Condizionali

Crea scorciatoie che navigano solo tra i workspace attivi, o che eseguono azioni
specifiche quando si entra in un determinato workspace.

```lua
hl.bind("ALT + TAB", function()
    local current = hl.get_info("workspace").id
    local next_ws = current + 1
    if next_ws > 10 then next_ws = 1 end

    -- Esempio: se entri nel workspace 5 (Gaming), attiva il profilo performance
    if next_ws == 5 then
        hl.exec_cmd("powerprofilesctl set performance")
    end

    hl.dispatch(hl.dsp.focus({ workspace = next_ws }))
end)
```

## 4. Toggle "Focus Mode" (Zen Mode)

Un singolo tasto per nascondere la barra, aumentare i gap e disabilitare le
decorazioni distraenti.

```lua
local zen_active = false
hl.bind("SUPER + Z", function()
    zen_active = not zen_active
    if zen_active then
        hl.dispatch(hl.dsp.config("general:gaps_out", 100))
        hl.dispatch(hl.dsp.config("decoration:blur:enabled", false))
        hl.exec_cmd("pkill -SIGUSR1 waybar") -- Nasconde waybar
    else
        hl.dispatch(hl.dsp.config("general:gaps_out", 8))
        hl.dispatch(hl.dsp.config("decoration:blur:enabled", true))
        hl.exec_cmd("pkill -SIGUSR2 waybar") -- Mostra waybar
    end
end)
```

## 5. Scratchpad Intelligente (Bring or Spawn)

Un bind che apre un terminale scratchpad: se esiste lo porta in primo piano, se
non esiste lo crea.

```lua
hl.bind("SUPER + S", function()
    -- Simulazione di logica (richiede parsing dei client attivi)
    -- Se Alacritty con classe 'scratchpad' esiste, fai il toggle
    hl.dispatch(hl.dsp.workspace.toggle_special("scratch"))

    -- In Lua potresti iterare sui client per vedere se è vuoto e, in caso, spawnarlo:
    -- hl.exec_cmd("alacritty --class scratchpad")
end)
```

## 6. Feedback Visivo sulla Batteria o sull'Orario

Modifica i colori dei bordi dinamicamente in base allo stato del sistema.

```lua
-- Richiede un timer o un evento periodico
local function check_battery()
    local handle = io.popen("cat /sys/class/power_supply/BAT0/capacity")
    local capacity = tonumber(handle:read("*a"))
    handle:close()

    if capacity < 15 then
        hl.dispatch(hl.dsp.config("general:col.active_border", "rgba(ff0000ff)"))
    else
        hl.dispatch(hl.dsp.config("general:col.active_border", "rgba(33ccffee)"))
    end
end
```

## 7. Reazioni App-Specifiche (Idle Inhibit)

Disabilita lo spegnimento dello schermo automaticamente quando apri un player
video.

```lua
hl.on("window.focus", function()
    local win = hl.get_info("window.active")
    if win.class == "vlc" or win.class == "mpv" then
        hl.exec_cmd("systemctl --user stop swayidle")
    else
        hl.exec_cmd("systemctl --user start swayidle")
    end
end)
```

## 8. "Drop-down" Terminal (Stile Quake)

Implementa un vero terminale drop-down animato calcolando le coordinate in tempo
reale in base alla risoluzione.

```lua
local dropdown_open = false
hl.bind("F12", function()
    dropdown_open = not dropdown_open
    local monitor = hl.get_info("monitor.active")

    if dropdown_open then
        hl.exec_cmd("alacritty --class dropdown_term")
        -- Usa le API Lua per forzare float, dimensioni (100% larghezza, 40% altezza) e posizionarlo in alto
    else
        -- Trova la finestra con class dropdown_term e chiudila o minimizzala
    end
end)
```

## 9. Night Mode Automatico

Cambia opacità, blur e colore dei bordi in base all'orario.

```lua
-- Pseudo-codice per l'orario
local hour = tonumber(os.date("%H"))
if hour >= 20 or hour <= 6 then
    -- Night mode
    hl.dispatch(hl.dsp.config("decoration:active_opacity", 0.8))
    hl.dispatch(hl.dsp.config("general:col.active_border", "rgba(ffaa00ff)"))
else
    -- Day mode
    hl.dispatch(hl.dsp.config("decoration:active_opacity", 1.0))
end
```
