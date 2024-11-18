#!/usr/bin/env python

import sys
import ast


def main():
    args = sys.argv[1:]
    if len(args) > 0:
        ex = " ".join(args)
        print(ex)
        ret = ast.literal_eval(ex)
        print(ret)
        print(f"\0message\x1f{ret}")


if __name__ == "__main__":
    # main()
    ex = "1+2"
    ret = eval(ex)
    print(ret)
