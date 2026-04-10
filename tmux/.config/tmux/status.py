#!/usr/bin/env -S uv run --script
# /// script
# requires-python = ">=3.14"
# ///
"""Claude Code status for tmux (Nord theme style)."""

import json
import os
import socket
import subprocess
import time

SEP = "\ue0b0"
FILE = "/tmp/claude-statusline.json"
HOME = os.environ.get("HOME", "/Users/j")
HOST = socket.gethostname().split(".")[0]


def block(prev_bg: str, bg: str, fg: str, content: str, close: bool = False) -> str:
    out = f"#[fg={prev_bg},bg={bg},nobold,noitalics,nounderscore]{SEP}"
    out += f"#[fg={fg},bg={bg},bold] {content} "
    if close:
        out += f"#[fg={bg},bg=black,nobold,noitalics,nounderscore]{SEP}"
    return out


def git_info(cwd: str, bg: str) -> str:
    try:
        branch = subprocess.run(
            [
                "git",
                "--no-optional-locks",
                "-C",
                cwd,
                "symbolic-ref",
                "--short",
                "HEAD",
            ],
            capture_output=True,
            text=True,
            timeout=2,
        ).stdout.strip()
        if not branch:
            return ""

        dirty = bool(
            subprocess.run(
                ["git", "--no-optional-locks", "-C", cwd, "status", "--porcelain"],
                capture_output=True,
                text=True,
                timeout=2,
            ).stdout.strip()
        )

        color = "yellow" if dirty else "green"
        return f" #[fg={color},bg={bg}]{branch}"
    except Exception:
        return ""


def read_status() -> dict | None:
    try:
        if time.time() - os.path.getmtime(FILE) >= 300:
            return None
        with open(FILE) as f:
            return json.load(f)
    except (FileNotFoundError, json.JSONDecodeError, OSError):
        return None


def main() -> None:
    data = read_status()
    bg = "black"
    out = ""

    if data:
        cwd = data.get("workspace", {}).get("current_dir") or data.get("cwd", "")
        short_cwd = cwd.replace(HOME, "~", 1) if cwd.startswith(HOME) else cwd
        model = data.get("model", {}).get("display_name", "")
        pct = int(data.get("context_window", {}).get("used_percentage") or 0)

        cwd_content = "🤖 " + short_cwd + git_info(cwd, "brightblack")

        out += block("black", "brightblack", "cyan", cwd_content, close=True)
        out += block("black", "#ebcb8b", "black", f"{model} {pct}%", close=True)

    out += block("black", "magenta", "white", HOST)
    print(out, end="")


if __name__ == "__main__":
    main()
