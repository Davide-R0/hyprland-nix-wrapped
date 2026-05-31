Per vedere la tty attuale:

## Avivarlo nativamente

agigungere alla config nix o conf di hyprland questi comandi:

```conf
# -----------------------------------------------
# PASSTHROUGH SUBMAP (per testare VM o Nested Wayland)
# -----------------------------------------------
# Attiva la modalità passthrough con CTRL + ALT + G (stile QEMU)
bind = CTRL ALT, G, submap, passthru
# Entriamo nella submap. Qui DENTRO, l'unica scorciatoia
# riconosciuta dal sistema principale sarà quella per uscirne.
submap = passthru
# Premi di nuovo CTRL + ALT + G per sbloccare il sistema principale
bind = CTRL ALT, G, submap, reset
submap = reset
```

nella config di nix aggiungerli al `wayland.windowManager.hyprland.extraConfig`,
ementre se si ha hyprland.conf metterli semplicemnte li dentro.

a questo punto si può avivare:

```bash
nix run .#hyprland
```

quando si è con il cursore dentro a quella finestra premere `Ctrl + Alt + G` per
fare in modo che essa catturi i tasti premuti (altrimenti li catutra il tuo os
di base) e testare quello che si vuole.

poi quanod is ha finito rimuovere la cattura premendo nuovamente
`Ctrl + Alt + G` e chiudere la finestra.

## Avivarlo tramite tty

apri u'altra tty che non sia la tua: `Ctrl + Alt + FN`, con N un numero tra 1 e
7 che non sia la tua tty attuale. per sapere la tty attuale:

```bash
w -h | grep "$USER" | awk '{print $2}' | grep "tty" || echo "Probabilmente tty1 o tty7"
```

una volta entrata in quelal tty, fare il login utente, posi spostarsi nella home
del progetto ed avviarlo:

```bash
nix run .#hyprland
```

ora potria muoverti tra le tty aperte con il comando di sopra.

## Con VM

è consiglaito avere almeno 2 core liberi e 4gb di ram liberi.

```bash
nix run .#nixosConfigurations.test-vm.config.system.build.vm
```

poi quando si è dentro si puù usare `Ctrl + Alt + G` per catturare e decatturare
i tasti dall'interno (senza questo non funziona aprire le finestre all'interno)
