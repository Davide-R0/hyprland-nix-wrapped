# Hyprland lua config wrapped into nix

## Avviarlo nativamente

Aggiungere alla config nix o conf di hyprland questi comandi:

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

## Come usarlo in NixOS / Home Manager

Grazie al modulo integrato, non è più necessario aggiungere manualmente il
pacchetto alla lista dei pacchetti installati. Basta abilitare il modulo.

### 1. Aggiungere l'input al Flake principale

```nix
inputs.hyprland-nix-wrapped = {
  url = "github:Davide-Ro/hyprland-nix-wrapped";
  inputs.nixpkgs.follows = "nixpkgs";
};
```

### 2. Importare e configurare il modulo

Puoi usare questo modulo sia direttamente in **NixOS** che tramite **Home
Manager**.

#### In Home Manager

```nix
# imports = [ inputs.hyprland-nix-wrapped.homeManagerModules.default ];

hyprland-nix-wrapped = {
  enable = true; # Attiva il modulo e installa automaticamente il pacchetto

  terminal = "${pkgs.alacritty}/bin/alacritty";
  browser = "${pkgs.brave}/bin/brave";

  # Opzioni custom
  displayScale = "1.2";

  plugins = with pkgs; [
    hyprlandPlugins.hyprbars
  ];

  # Pacchetti extra inclusi nel wrapper (es. wofi, waybar, ecc...)
  extraPackages = with pkgs; [
    wofi
    grim
    slurp
  ];
};
```

#### In NixOS (System wide)

```nix
# imports = [ inputs.hyprland-nix-wrapped.nixosModules.default ];

hyprland-nix-wrapped = {
  enable = true;
  # ... stessa configurazione sopra ...
};
```

Il modulo si occuperà di creare il pacchetto Hyprland wrappato con la tua
configurazione Lua e di aggiungerlo automaticamente a `home.packages` (se usato
in Home Manager) o `environment.systemPackages` (se usato in NixOS).
