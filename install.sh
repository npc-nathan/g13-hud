#!/bin/bash
# Puts the Cyberpunk 2077 mod in the game, and the matching applet on the Linux side.
#
#   ./install.sh                       (default game: ~/Games/Heroic/Cyberpunk 2077)
#   ./install.sh "/path/to/Cyberpunk 2077"
#   ./install.sh --remove              takes both away again
#
# This is the user's own installer and the only thing here that touches a game folder. The g13
# package does not run it, does not install the mod, and does not install the applet.
#
# It copies init.lua into the game's CET mods folder as g13-hud/, and puts the matching pad screen
# in place: the applet itself lives in its own repository (logitech-g13-applets), so it is fetched
# from there and its {GAME} placeholder filled in with wherever the game actually is. If there is no
# network, the mod still goes in and the applet is left to you - the message says how.
# Nothing is overwritten outside those places, and re-running it is how to update.
set -u

HERE="$(cd "$(dirname "$0")" && pwd)"
CONFIG_DIR="${G13_CONFIG_DIR:-${XDG_CONFIG_HOME:-$HOME/.config}/g13}"
APPLETS_DIR="$CONFIG_DIR/applets"
VISUALS_FILE="$CONFIG_DIR/visuals.json"
APPLET_NAME="cp2077-hud.json"
APPLET_URL="${G13_HUD_APPLET_URL:-https://raw.githubusercontent.com/npc-nathan/logitech-g13-applets/main/applets/cp2077-hud.json}"
APPLET_REPO="https://github.com/npc-nathan/logitech-g13-applets"
MOD_NAME="g13-hud"

# Where the game usually is, in the order to try. A Wine/Proton prefix puts the game under
# drive_c, so pass that path explicitly if the game lives inside one.
CANDIDATES=(
    "$HOME/Games/Heroic/Cyberpunk 2077"
    "$HOME/.local/share/Steam/steamapps/common/Cyberpunk 2077"
    "$HOME/.steam/steam/steamapps/common/Cyberpunk 2077"
    "$HOME/GOG Games/Cyberpunk 2077"
    "$HOME/Games/Cyberpunk 2077"
)

find_game() {
    for candidate in "${CANDIDATES[@]}"; do
        if [ -d "$candidate" ]; then
            printf '%s' "$candidate"
            return 0
        fi
    done
    return 1
}

REMOVE=0
if [ "${1:-}" = "--remove" ]; then
    REMOVE=1
    GAME="${2:-$(find_game || printf '%s' "${CANDIDATES[0]}")}"
elif [ -n "${1:-}" ]; then
    GAME="$1"
else
    if ! GAME="$(find_game)"; then
        echo "no Cyberpunk 2077 installation found in the usual places:"
        for candidate in "${CANDIDATES[@]}"; do
            echo "  $candidate"
        done
        echo
        echo "pass the path: $0 \"/path/to/Cyberpunk 2077\""
        exit 1
    fi
    echo "using the game at: $GAME"
fi

MODS_DIR="$GAME/bin/x64/plugins/cyber_engine_tweaks/mods"

# The pad cycles through the visuals listed in visuals.json, so a newly installed applet has to
# be added there or it can only be found by opening the config tool. Done here, undone by
# --remove, and it leaves everything else in that file alone. The window's Menu tab does the same
# thing by hand - either way ends up in this file.
update_visuals() {
    VISUALS_FILE="$VISUALS_FILE" python3 - "$1" "$APPLETS_DIR/$APPLET_NAME" <<'PY'
import json
import os
import sys

action, applet = sys.argv[1], sys.argv[2]
name = "applet:" + os.path.basename(applet)[: -len(".json")]
path = os.path.expanduser(os.environ.get("VISUALS_FILE", "~/.config/g13/visuals.json"))

try:
    with open(path) as handle:
        config = json.load(handle)
except (OSError, ValueError):
    config = {}

enabled = [item for item in (config.get("enabled") or []) if item != name]
if action == "add":
    enabled.append(name)
config["enabled"] = enabled
config.setdefault("cycle", False)
config.setdefault("cycle_seconds", 10.0)

# Whoever was showing: if it was the applet being removed, move to something that is enabled.
if config.get("active") not in enabled:
    config["active"] = enabled[0] if enabled else config.get("active", "clock")

os.makedirs(os.path.dirname(path), exist_ok=True)
with open(path, "w") as handle:
    json.dump(config, handle, indent=2)
    handle.write("\n")

print("  pad visuals: %s %s" % (name, "added" if action == "add" else "removed"))
PY
}

if [ "$REMOVE" = "1" ]; then
    rm -rf "$MODS_DIR/$MOD_NAME"
    rm -f "$APPLETS_DIR/$APPLET_NAME"
    update_visuals remove
    echo "removed:"
    echo "  $MODS_DIR/$MOD_NAME"
    echo "  $APPLETS_DIR/$APPLET_NAME"
    exit 0
fi

if [ ! -d "$GAME" ]; then
    echo "no game at: $GAME"
    echo "pass the path: $0 \"/path/to/Cyberpunk 2077\""
    exit 1
fi

if [ ! -d "$GAME/bin/x64/plugins/cyber_engine_tweaks" ]; then
    echo "Cyber Engine Tweaks is not installed in that game:"
    echo "  expected $GAME/bin/x64/plugins/cyber_engine_tweaks"
    echo "Install CET first (nexusmods.com/cyberpunk2077/mods/107), then run this again."
    exit 1
fi

install -d "$MODS_DIR/$MOD_NAME"
install -m 644 "$HERE/init.lua" "$MODS_DIR/$MOD_NAME/init.lua"
install -m 644 "$HERE/README.md" "$MODS_DIR/$MOD_NAME/README.md"

echo "installed:"
echo "  mod:    $MODS_DIR/$MOD_NAME/init.lua"

# The applet ships with the game path left as a placeholder, so the copy going into a config has
# to have it substituted - otherwise it would read a folder that does not exist. It is fetched
# rather than carried here so that it can be updated without a new release of the game mod.
applet_temp="$APPLETS_DIR/$APPLET_NAME.tmp.$$"
applet_installed=0
if command -v curl >/dev/null 2>&1 && curl -fsSL "$APPLET_URL" -o "$applet_temp" 2>/dev/null; then
    if grep -q '{GAME}' "$applet_temp"; then
        install -d "$APPLETS_DIR"
        sed "s|{GAME}|$GAME|g" "$applet_temp" > "$APPLETS_DIR/$APPLET_NAME"
        applet_installed=1
        update_visuals add
        echo "  applet: $APPLETS_DIR/$APPLET_NAME  (fetched from $APPLET_REPO)"
    else
        echo "the applet fetched from $APPLET_REPO has no {GAME} placeholder to fill in" >&2
    fi
fi
rm -f "$applet_temp"

if [ "$applet_installed" = "0" ]; then
    echo
    echo "the pad screen was not installed - either curl is missing or there is no network."
    echo "the mod itself is in and the game will write its numbers regardless. To add the screen:"
    echo "  curl -fsSL $APPLET_URL \\"
    echo "    | sed \"s|{GAME}|$GAME|g\" > ~/.config/g13/applets/$APPLET_NAME"
    echo "(the applet lives in $APPLET_REPO, which explains what it needs)"
fi

echo
echo "Next:"
echo "  1. start the game. Once it is running, hud.json in the mod's folder fills in about five"
echo "     times a second, and stops when you close the game - the file is the only thing they"
echo "     share, so nothing here can break the game or the driver"
echo "  2. put it on the pad: Menu tab in the g13 window, tick 'on the pad' for cp2077-hud, then"
echo "     walk to it with LR"
echo "  3. in the CET console, G13Probe() lists what this build answers (useful if ammo is blank)"
