# Debugging Hyprland-Nix-Wrapped (Lua Config)

Questo documento contiene tutti i comandi necessari per ispezionare, debuggare e
verificare la tua configurazione "wrappata" di Hyprland in Lua su NixOS.

## 1. Verificare se stai usando il Wrapper

Questi comandi confermano se il sistema sta effettivamente chiamando il tuo
wrapper generato da Nix invece del pacchetto standard.

```bash
# Verifica quale binario di Hyprland è in esecuzione nel path attuale
which Hyprland

# Segui i symlink per vedere il percorso reale nel Nix Store
readlink -f $(which Hyprland)

# Verifica la riga di comando esatta con cui Hyprland è attualmente in esecuzione
ps -ef | grep -i hyprland
```

## 2. Esplorare il Wrapper installato (NixOS / Home Manager)

A seconda di dove hai abilitato il modulo (a livello di sistema o utente), il
binario sarà linkato in percorsi diversi:

```bash
# Se installato tramite configurazione di sistema (Nixos Module)
ls -la /run/current-system/sw/bin/Hyprland

# Se installato tramite configurazione utente (Home Manager)
ls -la ~/.nix-profile/bin/Hyprland
# oppure
ls -la /etc/profiles/per-user/$(whoami)/bin/Hyprland
```

## 3. Leggere il contenuto del Wrapper e i file iniettati

Il wrapper Bash che abbiamo creato "nasconde" al suo interno le variabili
d'ambiente e l'iniezione del file Lua.

```bash
# Visualizza il codice del wrapper bash in esecuzione
cat $(readlink -f $(which Hyprland))
```

Dal comando precedente vedrai il percorso del file `hyprland-entrypoint.lua`.
Puoi trovare gli ultimi file generati nel Nix Store con questi comandi:

```bash
# Visualizza l'ultimo nix-env.lua generato (con le variabili iniettate)
cat $(ls -td /nix/store/*-nix-env.lua | head -n 1)/nix-env.lua

# Visualizza l'ultimo entrypoint.lua generato (che imposta il package.path)
cat $(ls -td /nix/store/*-hyprland-entrypoint.lua | head -n 1)
```

## 4. Trovare la cartella dei sorgenti Lua nel Nix Store

Il `module.nix` copia l'intera cartella della tua configurazione nel Nix Store
per renderla immutabile. Per trovare l'ultima versione copiata:

```bash
# Cerca l'ultimo sorgente flake copiato nel Nix Store e visualizzane il contenuto
ls -la $(ls -td /nix/store/*-source | grep "source$" | head -n 1)/lua
```

## 5. Leggere i Log di Hyprland e degli script Lua

Hyprland scrive i log (compresi i `print()` dei tuoi file Lua) in una cartella
temporanea specifica per la tua sessione.

```bash
# Trova l'ultimo log generato e visualizzalo con 'less'
less $(ls -td /run/user/$(id -u)/hypr/* | head -n 1)/hyprland.log

# Mostra SOLO gli output generati dai tuoi script Lua
cat $(ls -td /run/user/$(id -u)/hypr/* | head -n 1)/hyprland.log | grep "\[Lua\]"

# Controlla se la configurazione nativa Lua è stata rilevata correttamente
cat $(ls -td /run/user/$(id -u)/hypr/* | head -n 1)/hyprland.log | grep -i "Config is lua"

# Cerca eventuali errori in fase di caricamento dei moduli
cat $(ls -td /run/user/$(id -u)/hypr/* | head -n 1)/hyprland.log | grep -i "error\|errore"
```

## 6. Systemd e Servizi (Greetd / DMS)

Se usi Greetd/Tuigreet per l'avvio, eventuali errori fatali prima dell'avvio di
Hyprland finiranno nei log del display manager o di systemd.

```bash
# Visualizza i log del display manager (Greetd) dall'ultimo boot
sudo journalctl -u greetd.service -b

# Verifica lo stato del target di sessione di Hyprland
systemctl --user status hyprland-session.target

# Visualizza i log completi della sessione utente corrente
journalctl --user -b
```

## Consigli per il Debug Rapido

Se in futuro vuoi verificare "al volo" quali argomenti e file sta usando
Hyprland, il trucco più rapido è:

1. `cat $(readlink -f $(which Hyprland))` per trovare il file `.lua` di
   entrypoint.
2. Fai `cat` di quell'entrypoint per trovare il percorso del `nix-env.lua`.
3. Controlla il log con `grep "\[Lua\]"` per vedere il flusso di esecuzione che
   hai definito nel tuo `init.lua`.
