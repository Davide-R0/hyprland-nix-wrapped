{
  pkgs,
  self,
  ...
}:

let
  wrapped =
    (self.wrappers.hyprland.apply {
      inherit pkgs;
    }).wrapper;
in
pkgs.runCommand "hyprland-test" { } ''
  # Hyprland --help returns exit code 0 if successful
  ${wrapped}/bin/Hyprland --help > /dev/null
  touch $out
''
