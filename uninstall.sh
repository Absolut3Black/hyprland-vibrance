#!/usr/bin/env bash
set -euo pipefail

# ==============================================================================
# hyprland-vibrance Uninstaller
# ==============================================================================

HYPR_CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/hypr"
BIN_DIR="${HOME}/.local/bin"
SHADER_DIR="${HYPR_CONFIG_DIR}/shaders"

ICON_DIR="${HYPR_CONFIG_DIR}/icons"

echo "=== Uninstalling hyprland-vibrance ==="

# 1. Disable active shader
if [[ -x "${BIN_DIR}/toggle-saturation" ]]; then
  "${BIN_DIR}/toggle-saturation" off >/dev/null 2>&1 || true
fi

# 2. Remove files
rm -f "${SHADER_DIR}/saturation.glsl"
rm -f "${BIN_DIR}/toggle-saturation"
rm -f "${BIN_DIR}/omarchy-toggle-saturation"
rm -f "${ICON_DIR}/saturation-on.png" "${ICON_DIR}/saturation-on.svg"
rm -f "${ICON_DIR}/saturation-off.png" "${ICON_DIR}/saturation-off.svg"

echo "-> Removed shader, icons, and CLI tools."

# 3. Clean up config files if possible
LOOKNFEEL="${HYPR_CONFIG_DIR}/looknfeel.lua"
BINDINGS="${HYPR_CONFIG_DIR}/bindings.lua"
CONF="${HYPR_CONFIG_DIR}/hyprland.conf"

if [[ -f "$LOOKNFEEL" ]]; then
  sed -i '/saturation.glsl/d' "$LOOKNFEEL" 2>/dev/null || true
fi

if [[ -f "$BINDINGS" ]]; then
  sed -i '/toggle-saturation/d' "$BINDINGS" 2>/dev/null || true
fi

if [[ -f "$CONF" ]]; then
  sed -i '/saturation.glsl/d' "$CONF" 2>/dev/null || true
  sed -i '/toggle-saturation/d' "$CONF" 2>/dev/null || true
fi

# 4. Reload Hyprland
if command -v hyprctl >/dev/null 2>&1; then
  echo "-> Reloading Hyprland..."
  hyprctl reload >/dev/null 2>&1 || true
fi

echo "=== Uninstallation complete ==="
