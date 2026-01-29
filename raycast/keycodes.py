#!/usr/bin/env -S uv run --script
# /// script
# requires-python = ">=3.11"
# dependencies = []
# ///
"""Extract and decode keybindings from Raycast JSON (reads from stdin).
Uses macOS Virtual Key Code mapping (NSEvent.h)."""

import json
import re
import sys

# macOS Virtual Key Code mapping
KEYCODES = {
    0: "A",
    1: "S",
    2: "D",
    3: "F",
    4: "H",
    5: "G",
    6: "Z",
    7: "X",
    8: "C",
    9: "V",
    11: "B",
    12: "Q",
    13: "W",
    14: "E",
    15: "R",
    16: "Y",
    17: "T",
    18: "1",
    19: "2",
    20: "3",
    21: "4",
    22: "6",
    23: "5",
    24: "=",
    25: "9",
    26: "7",
    27: "-",
    28: "8",
    29: "0",
    30: "]",
    31: "O",
    32: "U",
    33: "[",
    34: "I",
    35: "P",
    36: "Return",
    37: "L",
    38: "J",
    39: "'",
    40: "K",
    41: ";",
    42: "\\",
    43: ",",
    44: "/",
    45: "N",
    46: "M",
    47: ".",
    48: "Tab",
    49: "Space",
    50: "`",
    51: "Delete",
    53: "Escape",
    65: "Keypad.",
    67: "Keypad*",
    69: "Keypad+",
    71: "KeypadClear",
    75: "Keypad/",
    76: "KeypadEnter",
    78: "Keypad-",
    81: "Keypad=",
    82: "Keypad0",
    83: "Keypad1",
    84: "Keypad2",
    85: "Keypad3",
    86: "Keypad4",
    87: "Keypad5",
    88: "Keypad6",
    89: "Keypad7",
    91: "Keypad8",
    92: "Keypad9",
    96: "F5",
    97: "F6",
    98: "F7",
    99: "F3",
    100: "F8",
    101: "F9",
    103: "F11",
    105: "F13",
    106: "F16",
    107: "F14",
    109: "F10",
    111: "F12",
    113: "F15",
    114: "Help",
    115: "Home",
    116: "PageUp",
    117: "ForwardDelete",
    118: "F4",
    119: "End",
    120: "F2",
    121: "PageDown",
    122: "F1",
    123: "Left",
    124: "Right",
    125: "Down",
    126: "Up",
}


def decode_keycode(hotkey: str) -> str:
    return re.sub(
        r"-(\d+)$",
        lambda m: f"-{KEYCODES.get(int(m.group(1)), f'Key{m.group(1)}')}",
        hotkey,
    )


def extract_keybindings(obj):
    if isinstance(obj, dict):
        if "hotkey" in obj:
            yield {
                "hotkey": obj["hotkey"],
                "key": obj.get("key") or obj.get("alias"),
            }
        for value in obj.values():
            yield from extract_keybindings(value)
    elif isinstance(obj, list):
        for item in obj:
            yield from extract_keybindings(item)


def main() -> int:
    try:
        data = json.load(sys.stdin)
    except (json.JSONDecodeError, ValueError):
        return 1
    bindings = sorted(extract_keybindings(data), key=lambda x: x["hotkey"])
    for binding in bindings:
        decoded_hotkey = decode_keycode(binding["hotkey"])
        print(f"{decoded_hotkey}\t{binding['key']}")
    return 0


if __name__ == "__main__":
    sys.exit(main())
