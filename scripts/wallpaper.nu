#!/usr/bin/env nu
use std/log

const WALLPAPER_DIR: string = "~/Pictures/wallpaper" | path expand
const CACHE_DIR: string = "~/.cache" | path expand
const CURRENT_WALLPAPER: string = "~/.cache/current_wallpaper" | path expand
const BLURRED_WALLPAPER: string = "~/.cache/blurred_wallpaper.png" | path expand
const SQUARE_WALLPAPER: string = "~/.cache/square_wallpaper.png" | path expand

def postprocess [filepath: string] {
    # pywal
    wal -q -i $filepath

    # update mako's theme
    ~/.config/mako/update-theme.sh

    # restart waybar
    systemctl --user restart waybar.service

    # run preprocess
    let ret = preprocess $filepath

    # set symlinks
    $ret | each { |it| $it | path expand | ln -sf $in $CACHE_DIR }

    # $ret | get 0 | path expand | cp $in $BLURRED_WALLPAPER
    # $ret | get 1 | path expand | cp $in $SQUARE_WALLPAPER

    notify-send "Wallpaper" $"Wallpaper set to ($filepath | path basename)"
}

def main [] {}

def "main select" [filename: string] {
    log info $"filename: ($filename)" 

    let wallpaper: string = $WALLPAPER_DIR | path join $filename | path expand
    log info $"wallpaper: ($wallpaper)"

    if ($wallpaper | path exists) {
        # Set wallpaper
        cp $wallpaper $CURRENT_WALLPAPER 

        # Restart swaybg
        systemctl --user restart swaybg.service

        log info $"Wallpaper set to ($filename)"

        postprocess $wallpaper
    } else {
        log error $"File '($filename)' not found"
    }
}

def preprocess [filepath: string] {
    log info $"preprocess ($filepath)"

    # get the filename
    let filename: string = $filepath | path basename

    # get the name of the file without the file type
    let name: string = if ( $filename | str contains "." ) {
        $filename | parse "{name}.{ext}" | get name | first
    } else {
        $filename
    }

    log info $"name: ($name)"

    # make dir if not exists
    mkdir ($WALLPAPER_DIR | path join $name)

    # generate blurred wallpaper if not exists
    let blurred_: string = $WALLPAPER_DIR | path join $name | path join "blurred_wallpaper.png"
    if not ($blurred_ | path exists) {
        magick $filepath -scale 10% -blur 0x5 -resize 1000% $blurred_

        log info $"generate: ($blurred_)"
    }

    # generate square wallpaper if not exists
    let square_: string = $WALLPAPER_DIR | path join $name | path join "square_wallpaper.png"
    if not ($square_ | path exists) {
        magick $filepath -gravity Center -extent 1:1 $square_

        log info $"generate: ($square_)"
    }

    [$blurred_, $square_]
}

def "main preprocess" [] {
    ls $WALLPAPER_DIR 
        | filter { |it| $it.type == file }
        | each { |it| preprocess $it.name }

    print "preprocess done"
}