#!/usr/bin/env bash
# Export Claude Code status for external consumers (e.g. tmux status bar)
cat > "${XDG_RUNTIME_DIR:-/tmp}/claude-statusline.json"
tmux refresh-client -S 2>/dev/null