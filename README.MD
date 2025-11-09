## 部署

```bash
# 1. 克隆你的原始仓库（或直接复制）
git clone https://github.com/syaofox/dwm-arch.git
cd dwm-arch

# 2. 创建新目录并迁移源码
mkdir -p ~/dwm-nixos/src
cp -r dwm ~/dwm-nixos/src/
cp -r slstatus ~/dwm-nixos/src/
cp -r slock ~/dwm-nixos/src/
cp -r dotfiles wallpaper ~/dwm-nixos/

# 3. 进入新项目
cd ~/dwm-nixos

# 4. 粘贴上面所有文件（flake.nix, configuration.nix, home.nix）

# 5. 部署
sudo nixos-rebuild switch --flake .#myhost
```

## 更新

```bash
# 修改 config.h
nvim src/dwm/config.h

# 重新编译 + 应用
sudo nixos-rebuild switch --flake .#myhost

# 或者只重启 DWM
killall dwm   # 自动重启

```

# 进入 TTY1
Ctrl + Alt + F1

# 登录
syaofox
******

# 手动启动
startx