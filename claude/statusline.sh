#!/bin/bash
#
# Claude Code status line.
#
# Reads the session JSON Claude Code pipes to stdin (see
# https://code.claude.com/docs/en/statusline) and prints a single status row
# flanked by blank rows for vertical breathing room:
#
#     <project> · <model> · <ctx-bar> NN% · $cost · ⏱ <duration> [· 5h NN% · 7d NN%]
#
# The 5h/7d rate-limit segments are appended only when present in the JSON
# (Claude.ai Pro/Max accounts after the first API response).
#
# Percentage colors flip green → yellow → red at the 50 % and 70 % marks
# for the context bar and for each rate-limit value.
#
# The padding rows use U+2800 (Braille pattern blank) — Claude Code strips
# ASCII whitespace-only rows, but this codepoint renders blank while
# surviving that trim.

set -u

input=$(cat)

# One jq call extracts every field we need as TSV.
IFS=$'\t' read -r PROJECT_DIR MODEL PCT COST DURATION_MS RL_5H RL_7D < <(
    jq -r '[
        .workspace.current_dir,
        .model.display_name,
        (.context_window.used_percentage // 0 | floor),
        (.cost.total_cost_usd // 0),
        (.cost.total_duration_ms // 0),
        (.rate_limits.five_hour.used_percentage // empty | floor),
        (.rate_limits.seven_day.used_percentage // empty | floor)
    ] | @tsv' <<<"$input"
)
PROJECT=${PROJECT_DIR##*/}

# Color a 0-100 value green / yellow / red at 50 / 70.
color_for_pct() {
    if   (( $1 >= 70 )); then printf '%s' "$RED"
    elif (( $1 >= 50 )); then printf '%s' "$YELLOW"
    else                      printf '%s' "$GREEN"
    fi
}

CYAN='\033[36m'; MAGENTA='\033[35m'; GREEN='\033[32m'; YELLOW='\033[33m'
RED='\033[31m'; DIM='\033[2m'; RESET='\033[0m'

if   [ "$PCT" -ge 70 ]; then BAR_COLOR="$RED"
elif [ "$PCT" -ge 50 ]; then BAR_COLOR="$YELLOW"
else                         BAR_COLOR="$GREEN"
fi

BAR_WIDTH=10
FILLED=$((PCT * BAR_WIDTH / 100))
(( FILLED > BAR_WIDTH )) && FILLED=$BAR_WIDTH
EMPTY=$((BAR_WIDTH - FILLED))
BAR=""
(( FILLED > 0 )) && printf -v FILL "%${FILLED}s" && BAR="${FILL// /█}"
(( EMPTY  > 0 )) && printf -v PAD  "%${EMPTY}s"  && BAR="${BAR}${PAD// /░}"

COST_FMT=$(printf '$%.2f' "$COST")

TOTAL_SEC=$((DURATION_MS / 1000))
HRS=$((TOTAL_SEC / 3600))
MINS=$(((TOTAL_SEC % 3600) / 60))
SECS=$((TOTAL_SEC % 60))
if (( HRS > 0 )); then
    DUR_FMT=$(printf '%dh%02dm' "$HRS" "$MINS")
else
    DUR_FMT=$(printf '%dm%02ds' "$MINS" "$SECS")
fi

RATE_FMT=""
if [ -n "$RL_5H" ]; then
    RATE_FMT+=" ${DIM}·${RESET} 5h $(color_for_pct "$RL_5H")${RL_5H}%${RESET}"
fi
if [ -n "$RL_7D" ]; then
    RATE_FMT+=" ${DIM}·${RESET} 7d $(color_for_pct "$RL_7D")${RL_7D}%${RESET}"
fi

# U+2800 (Braille pattern blank) above and below for vertical padding.
PAD_ROW=$'\xe2\xa0\x80'

printf '%s\n' "$PAD_ROW"
printf '%b\n' "${CYAN}${PROJECT}${RESET} ${DIM}·${RESET} ${MAGENTA}${MODEL}${RESET} ${DIM}·${RESET} ${BAR_COLOR}${BAR}${RESET} ${PCT}% ${DIM}·${RESET} ${YELLOW}${COST_FMT}${RESET} ${DIM}·${RESET} ⏱ ${DUR_FMT}${RATE_FMT}"
printf '%s\n' "$PAD_ROW"
