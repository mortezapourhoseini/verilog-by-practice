#!/usr/bin/env python3
"""check_links.py - check that every relative link in the Markdown files exists.

Usage:  python3 scripts/check_links.py
Exits with status 1 if a link points to a missing file or folder.
External links (http, https, mailto) and pure anchors (#...) are skipped.
"""
import os
import re
import sys

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
LINK = re.compile(r"\[[^\]]*\]\(([^)\s]+)\)")
FENCE = re.compile(r"^\s*```")

bad = 0
checked = 0
for folder, dirs, files in os.walk(ROOT):
    dirs[:] = [d for d in dirs if not d.startswith(".") and d != "build"]
    for name in files:
        if not name.endswith(".md"):
            continue
        path = os.path.join(folder, name)
        in_code = False
        with open(path, encoding="utf-8") as f:
            for number, line in enumerate(f, 1):
                if FENCE.match(line):
                    in_code = not in_code
                    continue
                if in_code:
                    continue
                for target in LINK.findall(line):
                    if target.startswith(("http://", "https://", "mailto:", "#")):
                        continue
                    target = target.split("#")[0]
                    full = os.path.normpath(os.path.join(folder, target))
                    checked += 1
                    if not os.path.exists(full):
                        print("BROKEN %s:%d -> %s" % (os.path.relpath(path, ROOT), number, target))
                        bad += 1

print("%d relative links checked, %d broken" % (checked, bad))
sys.exit(1 if bad else 0)
