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

## Come usarlo in nixos

Nel falke principale:

```nix
inputs.hyprland-nix-wrapped = {
  url = "github:Davide-Ro/hyprland-nix-wrapped";
  inputs.nixpkgs.follows = "nixpkgs";
};
```

Nel home manager:

```nix
# Importare il modulo creato
imports = [
  inputs.hyprland-nix-wrapped.nixosModules.default
];

# Per sicurezza si puù disattivare il modulo standard di hyprland
wayland.windowManager.hyprland.enable = false;

# Configurazione hyprland personalizzato
hyprland-nix-wrapped = {
  terminal = "${pkgs.alacritty}/bin/alacritty";
  browser = "${pkgs.brave}/bin/brave";

  # Opzione custom creata
  displayScale = "1.2";

  plugins = with pkgs; [
    hyprlandPlugins.hyprbars
  ];
  # Qui vanno pachcetit extra come wofi o waybar, ecc...
  extraPackages = with pkgs; [
    #wofi
    #grim
  ];
};

# Mettere il pacchetto risultante nei pacchetti di sistema
# così si può avviare dal login manager (SDDM/Tuigreet/ecc)
home.packages = [
  config.my-hyprland.package
];
```

questo si puo mettere dentro ad un modulo di flake-parts se si vuole.
