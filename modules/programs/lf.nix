{ pkgs, ... }:

{
  programs.lf = {
    enable = true;
    settings = {
      shell = "zsh";
      icons = true;
      hidden = true;
      ignorecase = true;
      ratios = "1:2:3";
    };
    extraConfig = ''
set mouse true
    '';
    previewer.source = pkgs.writeShellScript "previewer.sh" ''
#!/usr/bin/env bash

file=$1
w=$2
h=$3
x=$4
y=$5

mime=$(file -Lb --mime-type "$file")

if [[ "$mime" =~ ^image ]]; then
  kitty +kitten icat --silent --stdin no --transfer-mode file --place "''${w}x''${h}@''${x}x''${y}" "$file" </dev/null >/dev/tty
  exit 1
fi

if [[ "$mime" =~ ^text || "$mime" = application/json || "$mime" = application/x-ndjson ]]; then
  bat --color=always --style=plain --paging=never "$file"
  exit 1
fi

if [[ "$mime" = inode/x-empty ]]; then
  printf "\033[7mempty\033[0m"
  exit 1
fi

file "$file"
    '';
  };
}
