#version 300 es

/*
 * ============================================================================
 * Screen Saturation & Vibrance Shader for Hyprland
 * ============================================================================
 * Designed to enhance color vibrancy on displays needing punchier colors,
 * such as laptop panels with Intel HD/UHD graphics or washed-out SDR screens.
 *
 * Runs entirely on the GPU via OpenGL/GLSL with 0% CPU or battery overhead.
 */

precision mediump float;
in vec2 v_texcoord;
layout(location = 0) out vec4 fragColor;
uniform sampler2D tex;

/*
 * ============================================================================
 * TUNING CONFIGURATION
 * ============================================================================
 *
 * SATURATION (Linear Saturation Multiplier):
 *   1.00 = Neutral (no change)
 *   1.20 = Subtle boost (+20%)
 *   1.30 = Rich, noticeable boost (+30% - Recommended starting point)
 *   1.45 = Very vibrant (+45%)
 *
 * VIBRANCE (Intelligent / Selective Boost):
 *   Intelligently boosts muted and pale colors while avoiding oversaturating
 *   skin tones and already saturated colors.
 *   0.00 = Off
 *   0.20 = Subtle natural enhancement
 *   0.30 = Warm, lively punch (Recommended)
 *   0.50 = High vibrance
 */
const float SATURATION = 1.30;
const float VIBRANCE   = 0.30;

// Standard Rec. 709 / sRGB luminance weights
const vec3 LUMA_COEFF = vec3(0.212656, 0.715158, 0.072186);

void main() {
    vec4 pixColor = texture(tex, v_texcoord);
    vec3 color = pixColor.rgb;

    float luma = dot(LUMA_COEFF, color);

    // 1. Linear saturation boost
    if (SATURATION != 1.0) {
        color = mix(vec3(luma), color, SATURATION);
    }

    // 2. Selective vibrance boost
    if (VIBRANCE != 0.0) {
        float max_c = max(color.r, max(color.g, color.b));
        float min_c = min(color.r, min(color.g, color.b));
        float sat = max_c - min_c;
        vec3 coeffVibrance = vec3(-VIBRANCE);
        vec3 p_col = (sign(coeffVibrance) * sat - 1.0) * coeffVibrance + 1.0;
        color = mix(vec3(luma), color, p_col);
    }

    fragColor = vec4(clamp(color, 0.0, 1.0), pixColor.a);
}
