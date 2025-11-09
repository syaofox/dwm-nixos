# home.nix
{ pkgs, dwm, slstatus, slock, ... }:

{
  home.username = "syaofox";
  home.homeDirectory = "/home/syaofox";
  home.stateVersion = "24.05";

  # === ~/.xinitrc ===
  home.file.".xinitrc".text = ''
    eval $(gnome-keyring-daemon --start --components=pkcs11,secrets,ssh)
    export SSH_AUTH_SOCK

    sh ${./dotfiles/autostart.sh}

    exec ${dwm}/bin/dwm
  '';

  # === 自动 startx（关键！）===
  home.file.".zprofile".text = ''
    if [[ -z $DISPLAY ]] && [[ $(tty) = /dev/tty1 ]]; then
      exec startx
    fi
  '';

  # === 其他配置文件 ===
  home.file = {
    ".config/rofi/config.rasi".source = ./dotfiles/rofi.rasi;
    "Pictures/wallpaper/eva.jpg".source = ./wallpaper/eva.jpg;
  };

  # === slstatus 自启 ===
  systemd.user.services.slstatus = {
    description = "slstatus";
    wantedBy = [ "graphical-session.target" ];
    serviceConfig.ExecStart = "${slstatus}/bin/slstatus";
    serviceConfig.Restart = "always";
  };

  # === picom ===
  services.picom = {
    enable = true;
    backend = "glx";           # 性能好，默认也是 glx
    vSync = true;             # 防撕裂，默认就是 true

    # 只开这俩就够了！其余默认就是高性能模式
    fade = true;
    fadeDelta = 4;            # 推荐 4~6，动画流畅不卡顿

    # 可选：轻量透明规则（只对终端）
    opacityRules = [ "90:class_g = 'Alacritty'" ];
  };

  programs.alacritty = {
    enable = true;
    settings.font.normal.family = "JetBrainsMono Nerd Font";
  };

  programs.zsh.enable = true;
}