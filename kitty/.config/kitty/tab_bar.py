# Powerline tabs on the left, a status area on the right, styled after the nord tmux theme: a hard
# cap where the background changes, a thin separator where it does not.

import os
import socket
from typing import cast

from kitty.boss import get_boss
from kitty.fast_data_types import Screen
from kitty.tab_bar import (
    DrawData,
    ExtraData,
    TabAccessor,
    TabBarData,
    as_rgb,
    color_as_int,
    draw_tab_with_powerline,
    wcswidth,
)

# (hard, thin) powerline separators, mirrored for the right hand edge.
SEPARATORS = {"angled": ("", ""), "slanted": ("", "╲"), "round": ("", "")}
HOSTNAME = socket.gethostname().split(".")[0]

# Nord Frost and Aurora — https://www.nordtheme.com/docs/colors-and-palettes
FROST_TEAL, FROST_CYAN, FROST_BLUE, FROST_DEEP = 0x8FBCBB, 0x88C0D0, 0x81A1C1, 0x5E81AC
RED, ORANGE, YELLOW, GREEN, PURPLE = 0xBF616A, 0xD08770, 0xEBCB8B, 0xA3BE8C, 0xB48EAD
POLAR_NIGHT_0, POLAR_NIGHT_1, POLAR_NIGHT_2 = 0x2E3440, 0x3B4252, 0x434C5E
SNOW_STORM_1, SNOW_STORM_3 = 0xD8DEE9, 0xECEFF4

# These terminal apps publish useful, self-managed titles. Match their full
# foreground command lines so Node-based wrappers are included as well.
TITLE_OWNING_PROGRAMS = frozenset({"yazi", "claude", "codex"})

# A hue per layout, so the active one is recognisable by colour alone.
# No entry uses FROST_CYAN, PURPLE or RED: those mean active tab, activity and
# bell. "vertical" is left out deliberately and falls back to the inactive grey.
LAYOUT_COLORS = {
    "splits": FROST_BLUE,
    "stack": ORANGE,
    "tall": GREEN,
    "fat": YELLOW,
    "grid": FROST_DEEP,
    "horizontal": FROST_TEAL,
}
ACTIVITY_BG = PURPLE  # unfocused tab produced output
ATTENTION_BG = RED  # unfocused tab rang the bell

_layout = ""  # active tab's layout and pane count, refreshed on every repaint
_groups = 0
_tab_states: dict[int, str] = {}


def _sgr_foreground(color: int) -> str:
    """Return an SGR sequence for a Nord RGB colour."""
    return f"\x1b[38;2;{color >> 16};{color >> 8 & 0xFF};{color & 0xFF}m"


def _project_name(cwd: str) -> str:
    """Keep a working directory useful in a narrow tab title."""
    home = os.path.expanduser("~")
    if cwd == home:
        return "~"
    if cwd.startswith(f"{home}/"):
        parts = [part for part in cwd[len(home) + 1 :].rstrip("/").split("/") if part]
        if len(parts) <= 2:
            return f"~/{'/'.join(parts)}"
        return "/".join(parts[-2:])
    parts = [part for part in cwd.rstrip("/").split("/") if part]
    if not parts:
        return "/" if cwd else ""
    return "/".join(parts[-2:])


def _uses_own_title(tab_id: int) -> bool:
    tab = get_boss().tab_for_id(tab_id)
    window = tab.active_window if tab is not None else None
    if window is None:
        return False
    cmdline = " ".join(window.child.foreground_cmdline).casefold()
    return any(program in cmdline for program in TITLE_OWNING_PROGRAMS)


def _title_colors(state: str | None) -> tuple[int, int, int, int]:
    if state in {"active", "activity", "attention"}:
        return POLAR_NIGHT_0, POLAR_NIGHT_2, POLAR_NIGHT_1, POLAR_NIGHT_1
    return SNOW_STORM_3, FROST_CYAN, SNOW_STORM_1, GREEN


def draw_title(data: dict[str, object]) -> str:
    """Render the active pane as project · task · progress."""
    tab_id = cast(int, data["tab_id"])
    if _uses_own_title(tab_id):
        return str(data["title"])

    tab = cast(TabAccessor, data["tab"])
    cwd = tab.active_wd
    project = _project_name(cwd)
    task = str(data["title"]).strip()
    project_leaf = project.rsplit("/", 1)[-1]
    if project and task.endswith(project_leaf) and task.startswith(("~", "/", "…/")):
        task = ""

    project_color, separator_color, task_color, progress_color = _title_colors(
        _tab_states.get(tab_id)
    )

    segments: list[str] = []
    if project:
        segments.append(f"{_sgr_foreground(project_color)}\x1b[1m{project}\x1b[22m")
    if task:
        segments.append(f"{_sgr_foreground(task_color)}{task}")
    title = f"{_sgr_foreground(separator_color)} · ".join(segments)

    progress = tab.last_focused_progress_percent.strip()
    if progress:
        title += f"{_sgr_foreground(progress_color)} · {progress}"
    return title


def _tint(tab: TabBarData) -> int | None:
    """Background for an unfocused tab's state, or None to keep the theme's."""
    if tab.is_active:
        return None
    if tab.needs_attention:
        return ATTENTION_BG
    if tab.has_activity_since_last_focus:
        return ACTIVITY_BG
    return None


def _draw_right_status(draw_data: DrawData, screen: Screen) -> None:
    hard, thin = SEPARATORS.get(draw_data.powerline_style, SEPARATORS["angled"])
    cells: list[tuple[str, int, int, bool]] = []
    if _layout:
        hue = LAYOUT_COLORS.get(_layout)
        fg = color_as_int(draw_data.active_fg if hue else draw_data.inactive_fg)
        bg = hue or color_as_int(draw_data.inactive_bg)
        cells.append((f"{_layout} {_groups}", fg, bg, False))
    host_bg = color_as_int(draw_data.active_bg)
    cells.append((HOSTNAME, color_as_int(draw_data.active_fg), host_bg, True))

    width = sum(wcswidth(text) + wcswidth(hard) + 2 for text, *_ in cells)
    x = screen.columns - width
    if x <= screen.cursor.x:
        return
    screen.cursor.x = x
    prev_bg = color_as_int(draw_data.default_bg)
    for text, fg, bg, bold in cells:
        capped = bg != prev_bg
        screen.cursor.bold = False
        screen.cursor.fg = as_rgb(bg if capped else fg)
        screen.cursor.bg = as_rgb(prev_bg)
        screen.draw(hard if capped else thin)
        screen.cursor.fg, screen.cursor.bg = as_rgb(fg), as_rgb(bg)
        screen.cursor.bold = bold
        screen.draw(f" {text} ")
        prev_bg = bg
    screen.cursor.bold = False


def draw_tab(
    draw_data: DrawData,
    screen: Screen,
    tab: TabBarData,
    before: int,
    max_tab_length: int,
    index: int,
    is_last: bool,
    extra_data: ExtraData,
) -> int:
    global _layout, _groups
    if tab.is_active:
        _tab_states[tab.tab_id] = "active"
    elif tab.needs_attention:
        _tab_states[tab.tab_id] = "attention"
    elif tab.has_activity_since_last_focus:
        _tab_states[tab.tab_id] = "activity"
    else:
        _tab_states[tab.tab_id] = "inactive"
    if tab.is_active:
        _layout, _groups = tab.layout_name, tab.num_window_groups
    tint = _tint(tab)
    if tint is not None:
        screen.cursor.bg = as_rgb(tint)
    # Kitty picks hard cap vs thin separator by comparing this tab's background to
    # the next one's, taken from the theme; show it the neighbour's tint too.
    nxt = extra_data.next_tab
    if nxt is not None and (nxt_tint := _tint(nxt)) is not None:
        extra_data.next_tab = nxt._replace(inactive_bg=nxt_tint)
    end = draw_tab_with_powerline(
        draw_data, screen, tab, before, max_tab_length, index, is_last, extra_data
    )
    if is_last and not extra_data.for_layout:
        _draw_right_status(draw_data, screen)
    return end
