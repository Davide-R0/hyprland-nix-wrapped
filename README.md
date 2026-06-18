# Hyprland Module Template

Per verificare la configurazione di hyprland:

```bash
nix run . -- --verify-config
nix flake check -v
```

---

This is a demonstration of how to configure [Hyprland](https://hyprland.org/)
using `nix-wrapper-modules`.

This template specifically leverages Hyprland's recent migration to support Lua
configuration (v0.55.0+), demonstrating how to inject Nix values dynamically
into a pure Lua configuration file.

## File Structure

- `flake.nix`: The entry point that defines inputs and outputs.
- `module.nix`: The Nix module where you define custom options, pass them to
  `luaInfo`, and specify the path to your Lua entrypoint.
- `lua/init.lua`: Your pure Lua Hyprland configuration. It pulls in the Nix
  values dynamically using `require('nix-info')`.

## Usage

To initialize this template flake into an empty directory, run:

```bash
nix flake init -t github:BirdeeHub/nix-wrapper-modules#hyprland
```

To build and run it from this directory:

```bash
nix build .
./result/bin/Hyprland
```

## Abilitazione NixOS vs Home Manager

Per usare questa versione _wrapped_ di Hyprland (con config Lua iniettata) sul
tuo sistema, segui questa strategia:

### 1. NixOS (Sistema)

In NixOS, l'opzione `programs.hyprland.enable = true` è necessaria per
configurare permessi, Portals e PAM. Devi però puntare il pacchetto alla tua
versione wrappata:

```nix
# In configuration.nix o nel tuo flake di sistema
programs.hyprland = {
  enable = true;
  # Usa il pacchetto generato da questo template
  package = inputs.tuo-flake-hyprland.packages.${system}.hyprland;
};
```

### 2. Home Manager (Utente)

In Home Manager puoi importare il modulo fornito da questo template per gestire
le opzioni personalizzate (come `myConfig.gaps_in`):

```nix
# Nel tuo file di configurazione Home Manager
imports = [
  inputs.tuo-flake-hyprland.homeModules.hyprland
];

# Ora puoi configurare le tue opzioni Nix personalizzate
wrappers.hyprland.gaps_in = 10;
wrappers.hyprland.terminal = "foot";
```

## Gestione dei Plugin

I plugin di Hyprland (file `.so`) possono essere integrati nel wrapper in due
step:

### 1. In Nix (`module.nix`)

Passa il percorso del plugin a Lua tramite `luaInfo`. Assicurati che il plugin
sia compilato per la stessa versione di Hyprland.

```nix
config.luaInfo = {
  plugins = {
    hyprspace = "${pkgs.hyprlandPlugins.hyprspace}/lib/libhyprspace.so";
  };
};
```

### 2. In Lua (`init.lua`)

Recupera il percorso e carica il plugin (ad esempio usando `hyprctl` tramite
`exec_once` se non esiste ancora un'API Lua dedicata):

```lua
local nixInfo = require('nix-info')
local hyprspace_path = nixInfo(nil, "plugins", "hyprspace")

if hyprspace_path then
    -- Caricamento tramite hyprctl (metodo standard)
    hypr.exec_once("hyprctl plugin load " .. hyprspace_path)
end
```
