#!/usr/bin/env -S uv run -s
# /// script
# requires-python = ">=3.13"
# dependencies = [
#     "simpleeval",
# ]
# ///

from csv import Error
import sys
import os
from simpleeval import simple_eval

COPY_COMMAND = "Copy result"


def main() -> None:
    args = sys.argv[1:]
    if len(args) > 0:
        if args == [COPY_COMMAND]:
            ret = os.environ["ROFI_DATA"]
            os.system(f"wl-copy {ret}")
        else:
            try:
                ex = " ".join(args)
                ret = simple_eval(ex)
                print(f"\0message\x1fResult: {ret}")
                print(f"\0data\x1f{ret}")
                print(COPY_COMMAND)
            except Exception as e:
                print(e)


if __name__ == "__main__":
    main()
