# Hyprland

Follow the [Wiki](https://wiki.hyprland.org/).

## Launch

In the latest version, through `sddm` you can launch Hyprland directly.

If you want to set some environment variables, such as `GLFW_IM_MODULE=ibus` for `fcitx5`, and you don't know how to do that using Hyprland's way. You can still using the old method which is used in the old versions:
1. Write a launch script. Set some environment variables and then execute `Hyprland`.
2. Copy the `/usr/share/wayland-sessions/hyprland.desktop` as `/usr/share/wayland-sessions/hyprland-wrapped.desktop`.
3. Change the execution command to the launch script.

Of course, you can use the Hyprland's way: using `env`. But I don't know how to do that for some special variables.

## Chrome(Electron) and VScode

Follow the [fcitx5](https://fcitx-im.org/wiki/Using_Fcitx_5_on_Wayland).

> Warning: The information in this section may not be up to date to reflect upstream change, especially the default behavior when no option is changed.

Create `~/.config/electron-flags.conf` and the content is:
```
--enable-features=UseOzonePlatform
--ozone-platform=wayland
--enable-wayland-ime
```

Create `~/.config/code-flags.conf` and the content is:
```
--enable-features=UseOzonePlatform
--ozone-platform=wayland
--enable-wayland-ime
```

## `on-click` Bug

There is a bug in hyprland [waybar](https://github.com/Alexays/Waybar/issues/1850) [hyprland](https://github.com/hyprwm/Hyprland/issues/1348).

Up to now, this bug still exists. So try to add a delay `sleep 0.2` before some commands execution.
