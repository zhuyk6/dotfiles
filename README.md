# Dotfiles

## Wallpaper



## Keybindings

Using [`keyd`](https://github.com/rvaiya/keyd) to map CapsLock 
to escape when pressed and control when held.

```
# in /etc/keyd/default.conf
[ids]

*

[main]

# Maps capslock to escape when pressed and control when held.
capslock = overload(control, esc)
```

Therefore, there is no need to use `jk` to exit normal mode when using 
vim mode in some programs.