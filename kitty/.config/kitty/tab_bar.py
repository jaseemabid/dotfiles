# vim:ft=python
# Powerline tabs on the left, a status area on the right, styled after the nord
# tmux theme: a hard cap where the background changes, a thin separator where it
# does not.

import socket

from kitty.fast_data_types import Screen
from kitty.tab_bar import (
    DrawData,
    ExtraData,
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
