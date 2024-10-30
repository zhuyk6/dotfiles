#!/usr/bin/env nu
#     _____ _ _       _     _     _   
#    / ____| (_)     | |   (_)   | |  
#   | |    | |_ _ __ | |__  _ ___| |_ 
#   | |    | | | '_ \| '_ \| / __| __|
#   | |____| | | |_) | | | | \__ \ |_ 
#    \_____|_|_| .__/|_| |_|_|___/\__|
#              | |                    
#              |_|                    
# By zhuyk6 

def command [promp: string] {
    # tofi --prompt-text $promp
    rofi -dmenu -config ~/.config/rofi/config-dmenu.rasi -mesg $promp -p 'Clipboard'
}

# A script that manages clipboard
def main [] {
    let mode: string = (echo "Copy\nDelete\nClear" | command 'Choose a mode:' | str trim)
    match $mode {
        Copy => (main copy)
        Delete => (main repeat-delete)
        Clear => (main clear)
        _ => ()
    }
}

# Copy one item from clipboard
def "main copy" [] {
    let choose: string = (cliphist list | command 'Copy:')
    if ($choose | str length) > 0 {
        $choose | cliphist decode | wl-copy
    } else {
        echo "Nothing to do"
    }
}

# Delete one item from clipboard
def "main delete" [] {
    let choose: string = (cliphist list | command 'Delete:')
    if ($choose | str length) > 0 {
        $choose | cliphist delete
    } else {
        echo "Nothing to do"
    }
}

def "main repeat-delete" [] {
    loop {
        let choose: string = (cliphist list | command 'Delete:')
        if ($choose | str length) > 0 {
            $choose | cliphist delete
        } else {
            break
        }
    }
}

# Clear clipboard
def "main clear" [] {
    if (echo "Yes\nNo" | command 'Clear?' | str trim) == "Yes" {
        cliphist wipe
    } else {
        echo "Nothing to do"
    }
}