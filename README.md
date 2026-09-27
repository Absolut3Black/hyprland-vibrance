# 🌈 hyprland-vibrance

> Hardware-accelerated color saturation & digital vibrance for **Hyprland** on Linux.
> Bring dull, washed-out laptop displays and SDR monitors to life!

---

## 💡 Why this exists

On Windows, laptop users with Intel or NVIDIA GPUs rely on the **Intel Graphics Command Center** or **NVIDIA Control Panel** to bump the **Color Saturation / Digital Vibrance** slider to make screens (especially budget laptop displays with ~45% NTSC gamut) look rich, colorful, and vibrant.

On Linux running **Wayland / Hyprland**, no native Intel/NVIDIA saturation control panel exists, and older X11 tools like `xrandr` do not work.

**`hyprland-vibrance`** solves this cleanly using Hyprland's native OpenGL screen shader pipeline:
- ⚡ **0% CPU Overhead:** Runs entirely on your GPU (e.g. Intel HD/UHD graphics, AMD, NVIDIA) as a fast fragment shader.
- 🔋 **Zero Battery Penalty:** Simple 10-line math per pixel; no background daemons or polling processes.
- 🎨 **Smart Saturation + Vibrance:** Boosts dull/muted colors while protecting skin tones and already-vibrant elements from clipping.
- ⌨️ **Instant Hotkey Toggle:** Turn it on or off anytime with <kbd>Super</kbd> + <kbd>Alt</kbd> + <kbd>V</kbd>.
- 🔔 **Desktop Notifications:** Visual feedback with custom multi-color gradient vibrance status icons.
- 🐧 **Universal Compatibility:** Works seamlessly with **Omarchy Linux** (Lua-based Hyprland config) and standard Hyprland (`hyprland.conf`).

---

## 🚀 Quick Install

Open your terminal and run:

```bash
git clone https://github.com/Absolut3Black/hyprland-vibrance.git
cd hyprland-vibrance
./install.sh
```

*(Or if you already downloaded the repo, simply execute `./install.sh`)*

The installer will:
1. Copy the GLSL shader to `~/.config/hypr/shaders/saturation.glsl`.
2. Install the `toggle-saturation` CLI helper to `~/.local/bin/`.
3. Install high-res multi-color gradient notification icons to `~/.config/hypr/icons/`.
4. Automatically configure your Hyprland configuration (`looknfeel.lua` or `hyprland.conf`).
5. Register the <kbd>Super</kbd> + <kbd>Alt</kbd> + <kbd>V</kbd> keybinding.
6. Immediately activate the shader so you can see the difference!

---

## 🎮 Usage

### Keyboard Shortcut
Press <kbd>Super</kbd> + <kbd>Alt</kbd> + <kbd>V</kbd> to toggle the vibrancy boost on and off.

### Command Line
You can also control the shader from the terminal or your custom scripts:

```bash
toggle-saturation         # Toggle on/off
toggle-saturation on      # Force enable
toggle-saturation off     # Force disable
toggle-saturation status  # Show current status (JSON)
```

---

## 🛠️ Tuning Saturation & Vibrance

Everyone's display panel and eyes are different! You can customize the strength to your exact preference.

Edit `~/.config/hypr/shaders/saturation.glsl`:

```glsl
/*
 * ADJUSTMENT SETTINGS:
 */
const float SATURATION = 1.30; // Linear boost (1.0 = normal, 1.2 = mild, 1.3 = rich, 1.45 = intense)
const float VIBRANCE   = 0.30; // Smart boost (0.0 = off, 0.2 = natural, 0.3 = lively, 0.5 = punchy)
```

- **`SATURATION`**: Uniformly boosts all color channels away from grayscale.
- **`VIBRANCE`**: Intelligently boosts muted/pale colors more than already saturated colors, preventing oversaturation of skin tones and bright UI elements.

After saving the file, press <kbd>Super</kbd> + <kbd>Alt</kbd> + <kbd>V</kbd> twice (or run `hyprctl reload`) to see your changes immediately.

---

## 🗑️ Uninstallation

If you ever want to remove it:

```bash
cd hyprland-vibrance
./uninstall.sh
```

---

## 📄 License

MIT License. Feel free to use, modify, and share!
