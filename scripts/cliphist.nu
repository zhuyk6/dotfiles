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


# A script that using tofi to manage clipboard
def main [] {
    let mode: string = (echo "Copy\nDelete\nClear" | tofi --prompt-text 'Choose a mode:' | str trim)
    match $mode {
        Copy => (main copy)
        Delete => (main delete)
        Clear => (main clear)
        _ => ()
    }
}

# Copy one item from clipboard
def "main copy" [] {
    let choose: string = (cliphist list | tofi --prompt-text 'Copy:')
    if ($choose | str length) > 0 {
        $choose | cliphist decode | wl-copy
    } else {
        echo "Nothing to do"
    }
}

# Delete one item from clipboard
def "main delete" [] {
    let choose: string = (cliphist list | tofi --prompt-text 'Delete:')
    if ($choose | str length) > 0 {
        $choose | cliphist delete
    } else {
        echo "Nothing to do"
    }
}

# Clear clipboard
def "main clear" [] {
    if (echo "Yes\nNo" | tofi --prompt-text 'Clear?' | str trim) == "Yes" {
        cliphist wipe
    } else {
        echo "Nothing to do"
    }
}