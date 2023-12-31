{ pkgs, ... }: {
  programs.qutebrowser = {
    enable = true;
    settings = {
      auto_save.session = true;
      colors.webpage.preferred_color_scheme = "dark";
      content.autoplay = false;
      scrolling.smooth = true;
    };
    extraConfig = builtins.readFile ../../../../../conf/qutebrowser/config.py;
  };

  xdg.configFile."qutebrowser/catppuccin".source = pkgs.fetchFromGitHub {
    owner = "catppuccin";
    repo = "qutebrowser";
    rev = "main";
    sha256 = "sha256-lp7HWYuD4aUyX1nRipldEojZVIvQmsxjYATdyHWph0g=";
  };
}
