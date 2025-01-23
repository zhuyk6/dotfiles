#!/usr/bin/env nu
use std/log

let WALLPAPER_DIR: string = "~/Pictures/wallpaper" | path expand
let CURRENT_WALLPAPER: string = "~/.cache/current_wallpaper" | path expand
let BLURRED_WALLPAPER: string = "~/.cache/blurred_wallpaper.png" | path expand
let SQUARE_WALLPAPER: string = "~/.cache/square_wallpaper.png" | path expand

def postprocess [] {
    # restart waybar
    systemctl --user restart waybar.service

    # Blur the wallpaper
    magick $CURRENT_WALLPAPER -scale 10% -blur 0x5 -resize 1000% $BLURRED_WALLPAPER

    # Generate square wallpaper
    magick ~/.cache/current_wallpaper -gravity Center -extent 1:1 $SQUARE_WALLPAPER
}

def main [] {}

def "main select" [filename: string] {
    log info $"filename: ($filename)" 

    let wallpaper: string = $WALLPAPER_DIR | path join $filename | path expand
    log info $"wallpaper: ($wallpaper)"

    if ($wallpaper | path exists) {
        # pywal
        wal -q -i $wallpaper

        # Set wallpaper
        cp $wallpaper $CURRENT_WALLPAPER

        # Restart swaybg
        systemctl --user restart swaybg.service

        log info $"Wallpaper set to ($filename)"

        postprocess
    } else {
        log error $"File '$($filename)' not found"
    }
}