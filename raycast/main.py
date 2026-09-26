#!/usr/bin/env -S uv run --script
# /// script
# requires-python = ">=3.14"
# dependencies = [
#     "typer==0.26.8",
#     "cryptography",
# ]
# ///
"""Decode a Raycast rayconfig export into JSON + keybindings.

The RAYCFG3 container: b"RAYCFG3\\n" + u32le (gzip header member size) +
gzip(header JSON: encryption.iv/salt) + AES-256-GCM(gzip(payload),
scrypt(password, salt)) ciphertext + 16-byte tag.
"""

import gzip
import hashlib
import json
import os
import re
import struct
import zlib
from pathlib import Path
from typing import Optional

import typer
from cryptography.hazmat.primitives.ciphers.aead import AESGCM

# macOS Virtual Key Code mapping (NSEvent.h)
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


def parse_hotkey(node: dict) -> Optional[str]:
    shortcut = node.get("kind", {}).get("shortcut")
    if not shortcut:
        return None
    mods = "-".join(m["modifier"] for m in shortcut["modifiers"])
    code = shortcut["key"]["code"]
    return f"{mods}-{code}" if mods else str(code)


def extract_keybindings(obj):
    if isinstance(obj, dict):
        if "hotkey" in obj:
            yield {"hotkey": obj["hotkey"], "key": obj.get("key") or obj.get("alias")}
        for hotkey_field in ("macosHotkey", "globalHotkey"):
            if hotkey_field in obj:
                hk = parse_hotkey(obj[hotkey_field])
                if hk is not None:
                    yield {"hotkey": hk, "key": obj.get("id", "global")}
        for value in obj.values():
            yield from extract_keybindings(value)
    elif isinstance(obj, list):
        for item in obj:
            yield from extract_keybindings(item)


def decrypt(file: Path, password: str) -> bytes:
    raw = file.read_bytes()
    if not raw.startswith(b"RAYCFG3\n"):
        raise ValueError(f"not a RAYCFG3 export (magic {raw[:8]!r})")

    (n,) = struct.unpack("<I", raw[8:12])
    header = json.loads(zlib.decompressobj(wbits=31).decompress(raw[12 : 12 + n]))
    enc = header["encryption"]
    salt = bytes.fromhex(enc["salt"])
    iv = bytes.fromhex(enc["iv"])
    data, tag = raw[12 + n : -16], raw[-16:]

    key = hashlib.scrypt(password.encode(), salt=salt, n=16384, r=8, p=1, dklen=32)
    plaintext = AESGCM(key).decrypt(iv, data + tag, None)
    return gzip.decompress(plaintext)


app = typer.Typer(add_completion=False)


@app.command(no_args_is_help=True)
def main(
    file: Path = typer.Option(
        Path("config.data"), "--file", help="rayconfig file to decode"
    ),
    out: Path = typer.Option(
        Path("."),
        "--out",
        help="output folder for config/keys files",
        file_okay=False,
        dir_okay=True,
        writable=True,
        exists=True,
    ),
) -> None:
    password = os.environ["PASSWORD"]
    data = json.loads(decrypt(file, password))

    # history/telemetry/chat bloat, not config
    for k in ("userActivity", "clipboardHistory", "ai", "emoji", "notes"):
        data.pop(k, None)

    # usage state, not config
    data.get("settings", {}).pop("frecency", None)
    for cmd in data.get("settings", {}).get("commands", []):
        cmd.pop("meta", None)

    (out / "config.json").write_text(json.dumps(data, indent=2) + "\n")

    bindings = sorted(extract_keybindings(data), key=lambda b: b["hotkey"])
    lines = [f"{decode_keycode(b['hotkey'])}\t{b['key']}" for b in bindings]
    (out / "keys.txt").write_text("\n".join(lines) + "\n")


if __name__ == "__main__":
    app()
