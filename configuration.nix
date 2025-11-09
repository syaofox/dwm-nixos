# configuration.nix
{ config, pkgs, ... }:

{
  # 关闭所有显示管理器
  services.xserver.displayManager.lightdm.enable = false;
  services.xserver.displayManager.gdm.enable = false;
  services.xserver.displayManager.sddm.enable = false;

  # 启用 X11 + startx 支持
  services.xserver.enable = true;
  services.xserver.displayManager.startx.enable = true;

  # 字体
  fonts.packages = with pkgs; [
    (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
  ];

  # 全局软件包
  environment.systemPackages = with pkgs; [
    rofi alacritty picom feh maim slop xclip
    xfce.xfce4-clipman brave nemo
    dwm slstatus slock
    xorg.xinit  # startx 命令
  ];

  nixpkgs.config.allowUnfree = true;

  users.users.syaofox = {
    isNormalUser = true;
    extraGroups = [ "wheel" "video" "audio" ];
    shell = pkgs.zsh;
  };

  system.stateVersion = "24.05";
}