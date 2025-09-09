#!/usr/bin/env nu

# A script to logout from Hyprland and niri
def main [] {
    if $env.XDG_CURRENT_DESKTOP == "niri" {
        niri msg action quit -s
    } else if $env.XDG_CURRENT_DESKTOP == "Hyprland" {
        hyprctl dispatch exit
    } else {
        notify-send -u critical $"Not supported desktop: ($env.XDG_CURRENT_DESKTOP)"
    }
}
