```nix
# da aggiungere al flake principale
  # Aggiungiamo una VM NixOS ultra-veloce per testare il wrapper
  nixosConfigurations.test-vm = nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    modules = [
      # 1. Importiamo il nostro modulo
      ./module.nix

      (
        { pkgs, config, ... }:
        {
          # 2. Configurazioni base
          system.stateVersion = "23.11";

          # Abilitiamo OpenGL nella VM, fondamentale per Hyprland
          hardware.opengl.enable = true;

          # Parametri QEMU per la VM (impostati nel sottomodulo corretto)
          virtualisation.vmVariant = {
            virtualisation.memorySize = 2048;
            virtualisation.cores = 2;
            virtualisation.graphics = true;
            virtualisation.qemu.options = [
              "-vga virtio"
              "-display gtk,zoom-to-fit=on"
            ];
          };

          # Aggiungiamo rofi per il test e assicuriamoci che polkit funzioni per Hyprland
          my-hyprland.extraPackages = [
            pkgs.kitty
            pkgs.rofi
          ];
          security.polkit.enable = true;

          # 3. Creiamo l'utente di test con autologin
          users.users.alice = {
            isNormalUser = true;
            password = "123";
            extraGroups = [ "wheel" ];
          };
          services.getty.autologinUser = "alice";

          # 4. Forziamo l'avvio del nostro Hyprland wrappato appena si fa il login
          environment.loginShellInit = ''
            if [ -z $DISPLAY ] && [ "$(tty)" = "/dev/tty1" ]; then
              # Forziamo il render software nel caso in cui la VM non abbia KVM o GPU pass-through
              export WLR_RENDERER_ALLOW_SOFTWARE=1

              echo "Avviando Hyprland..."
              ${config.my-hyprland.package}/bin/Hyprland || {
                echo "Hyprland e' crashato! Leggi l'errore sopra."
                sleep 15
              }
            fi
          '';
        }
      )
    ];
  };
};
```
