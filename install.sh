#!/usr/bin/env bash
set -euo pipefail

# ==============================================================================
# hyprland-vibrance Installer
# ==============================================================================

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HYPR_CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/hypr"
BIN_DIR="${HOME}/.local/bin"
SHADER_DIR="${HYPR_CONFIG_DIR}/shaders"

echo "=== Installing hyprland-vibrance ==="

# 1. Ensure target directories exist
mkdir -p "$SHADER_DIR" "$BIN_DIR"

# 2. Copy shader
echo "-> Installing shader to ${SHADER_DIR}/saturation.glsl"
cp -f "${SCRIPT_DIR}/shaders/saturation.glsl" "${SHADER_DIR}/saturation.glsl"

# 3. Copy toggle scripts
echo "-> Installing CLI toggle tool to ${BIN_DIR}/toggle-saturation"
cp -f "${SCRIPT_DIR}/bin/toggle-saturation" "${BIN_DIR}/toggle-saturation"
chmod +x "${BIN_DIR}/toggle-saturation"

# Also symlink for omarchy-toggle-saturation compatibility
ln -sf "${BIN_DIR}/toggle-saturation" "${BIN_DIR}/omarchy-toggle-saturation"

# 4. Check PATH
if [[ ":$PATH:" != *":$BIN_DIR:"* ]]; then
  echo "[!] Notice: $BIN_DIR is not in your current PATH. Add it to your ~/.bashrc or ~/.zshrc."
fi

# 5. Configure Hyprland
if [[ -f "${HYPR_CONFIG_DIR}/hyprland.lua" ]]; then
  # Omarchy / Lua configuration
  echo "-> Detected Lua-based Hyprland config (Omarchy)"
  LOOKNFEEL="${HYPR_CONFIG_DIR}/looknfeel.lua"
  BINDINGS="${HYPR_CONFIG_DIR}/bindings.lua"

  if [[ -f "$LOOKNFEEL" ]]; then
    if ! grep -q "screen_shader" "$LOOKNFEEL"; then
      echo "-> Adding screen_shader to ${LOOKNFEEL}"
      cat << 'EOF' >> "$LOOKNFEEL"

-- Hyprland Vibrance / Saturation Shader
hl.config({
  decoration = {
    screen_shader = (os.getenv("HOME") or "") .. "/.config/hypr/shaders/saturation.glsl",
  },
})
EOF
    else
      echo "-> screen_shader already configured in ${LOOKNFEEL}"
    fi
  fi

  if [[ -f "$BINDINGS" ]]; then
    if ! grep -q "toggle-saturation" "$BINDINGS"; then
      echo "-> Adding keybinding (SUPER + ALT + V) to ${BINDINGS}"
      cat << 'EOF' >> "$BINDINGS"

-- Toggle color saturation boost
o.bind("SUPER + ALT + V", "Toggle color saturation boost", "toggle-saturation")
EOF
    else
      echo "-> Keybinding already configured in ${BINDINGS}"
    fi
  fi

elif [[ -f "${HYPR_CONFIG_DIR}/hyprland.conf" ]]; then
  # Standard hyprland.conf configuration
  echo "-> Detected hyprland.conf"
  CONF="${HYPR_CONFIG_DIR}/hyprland.conf"

  if ! grep -q "saturation.glsl" "$CONF"; then
    echo "-> Adding screen_shader to ${CONF}"
    cat << EOF >> "$CONF"

# Hyprland Vibrance / Saturation
decoration {
    screen_shader = ${SHADER_DIR}/saturation.glsl
}
bind = \$mainMod ALT, V, exec, toggle-saturation
EOF
  else
    echo "-> Shader already configured in ${CONF}"
  fi
fi

# 6. Reload Hyprland and enable shader
if command -v hyprctl >/dev/null 2>&1; then
  echo "-> Reloading Hyprland..."
  hyprctl reload >/dev/null 2>&1 || true
  "${BIN_DIR}/toggle-saturation" on >/dev/null 2>&1 || true
fi

echo ""
echo "=== Installation complete! ==="
echo "- Shortcut: Press SUPER + ALT + V to toggle anytime."
echo "- CLI: Run 'toggle-saturation' (or on/off/status)."
echo "- Tuning: Edit ~/.config/hypr/shaders/saturation.glsl to adjust saturation/vibrance levels."
