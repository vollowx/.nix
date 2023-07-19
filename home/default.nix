{ pkgs, lib, config, ... }:

{
  imports = [
    ./cli/bat.nix
    ./cli/git.nix
    ./cli/neovim.nix
    ./cli/lazygit.nix
    ./cli/zsh.nix
    ./cli/starship.nix
    ./cli/zoxide.nix

    ./desktop/gtk.nix
    ./desktop/dunst.nix
    ./desktop/fcitx5.nix
    ./desktop/sway.nix
    ./desktop/kitty.nix
    ./desktop/firefox.nix
  ];
  home.stateVersion = "21.11";
  home.packages = with pkgs; [
    file
    unzip
    curl
    wget
    exa
    duf
    fd
    ripgrep
    fzy

    nodejs
    nodePackages.pnpm
    openjdk

    lf
    neofetch
    system-config-printer
  ];

  xdg.userDirs = {
    enable = true;
    createDirectories = true;
  };

  xdg.configFile."lf" = {
    source = config.lib.file.mkOutOfStoreSymlink "/home/vollow/.nix/conf/lf";
    recursive = true;
  };
}
