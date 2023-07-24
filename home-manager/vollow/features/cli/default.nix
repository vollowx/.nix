{ pkgs, ... }: {
  imports = [
    ./bash.nix
    ./fish.nix
    ./git.nix
    ./neovim.nix
    ./pfetch.nix
    ./ranger.nix
    ./starship.nix
    ./zoxide.nix
  ];

  home.packages = with pkgs; [
    comma # Install and run programs by sticking a , before them
    distrobox # Nice escape hatch, integrates docker images with my environment

    bc # Calculator
    bottom # System viewer
    ncdu # TUI disk usage
    exa # Better ls
    ripgrep # Better grep
    fd # Better find
    httpie # Better curl
    diffsitter # Better diff
    jq # JSON pretty printer and manipulator

    nil # Nix LSP
    nixfmt # Nix formatter

    ltex-ls # Spell checking LSP
  ];
}
