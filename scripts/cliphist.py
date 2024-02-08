#!/bin/python

import sys
import subprocess


def chain(cmds: list[list[str]], input=None, ) -> subprocess.Popen[bytes]:
    if len(cmds) == 0:
        raise ValueError("Empty commands.")
    
    cmd0 = cmds[0]
    p1 = subprocess.Popen(cmd0, stdin=input, stdout=subprocess.PIPE)

    for cmd1 in cmds[1:]:
        p0 = p1
        p1 = subprocess.Popen(
                cmd1, 
                stdin=p0.stdout, 
                stdout=subprocess.PIPE)
    return p1


args = sys.argv

selector_dict = {
    "fzf":  ["fzf",  "--prompt"],
    "wofi": ["wofi", "--dmenu","-p"],
    "tofi": ["tofi", "--prompt-text"], 
}

selector = "tofi"

if len(args) == 1:
    raise ValueError("Need at least one argument!")
elif len(args) == 3:
    selector = args[2]
    if selector not in selector_dict:
        print("Invalid selector. Now only support: ")
        for key in selector_dict.keys():
            print(key)
        raise ValueError("Invalid selector!")


if args[1] == "clear":
    if selector in ["fzf"]:
        prompt = "Are you sure to clear all history ? (Y/N) "
        answer = input(prompt)
        while answer not in ["Y", "y", "N", "n"]:
            answer = input(prompt)
        if answer in ["Y", "y"]:
            subprocess.run(["cliphist", "wipe"])
    else:
        cmd = selector_dict[selector]
        cmd.append("Clear all history ?")
        result = subprocess.run(
            cmd,
            stdout=subprocess.PIPE,
            input=b"Yes\nNo",
            )
        if result.stdout.strip() == b"Yes":
            subprocess.run(["cliphist", "wipe"])
            
elif args[1] == "delete":
    cmd = selector_dict[selector]
    cmd.append("Delete")
    # cliphist list | tofi --prompt-text 'Delete' | cliphist delete

    # r1 = subprocess.Popen(
    #         ["cliphist", "list"],
    #         stdout=subprocess.PIPE,
    #         )
    # r2 = subprocess.Popen(
    #         cmd,
    #         stdin=r1.stdout,
    #         stdout=subprocess.PIPE,
    #         )
    r2 = chain([
        ["cliphist", "list"],
        cmd,
        ])
    out, err = r2.communicate()
    if len(out) > 0:
        r3 = subprocess.run(
                ["cliphist", "delete"],
                input=out,
                )

elif args[1] == "copy":
    cmd = selector_dict[selector]
    cmd.append("Copy")
    # cliphist list | tofi --prompt-text 'Copy' | cliphist decode | wl-copy

    # r1 = subprocess.Popen(
    #         ["cliphist", "list"],
    #         stdout=subprocess.PIPE,
    #         )
    # r2 = subprocess.Popen(
    #         cmd,
    #         stdin=r1.stdout,
    #         stdout=subprocess.PIPE,
    #         )
    # r3 = subprocess.Popen(
    #         ["cliphist", "decode"],
    #         stdin=r2.stdout,
    #         stdout=subprocess.PIPE,
    #         )
    # r4 = subprocess.Popen(
    #         "wl-copy",
    #         stdin=r3.stdout,
    #         )
    chain([
        ["cliphist", "list"],
        cmd,
        ["cliphist", "decode"],
        [ "wl-copy" ],
        ])
    
else:
    raise ValueError("Invalid input")

