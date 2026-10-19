#version 440
layout(location = 0) in vec2 qt_TexCoord0;
layout(location = 0) out vec4 fragColor;

layout(std140, binding = 0) uniform buf {
    mat4 qt_Matrix;
    float qt_Opacity;
    float amount;   // 1 = fully blurred/split, 0 = clean
    float blurPx;
    float aberrPx;
    vec2 texel;     // 1 / texture size
};
layout(binding = 1) uniform sampler2D source;

const int TAPS = 12;
const float GOLDEN = 2.399963;

void main() {
    vec2 uv = qt_TexCoord0;
    vec2 shift = (uv - 0.5) * 2.0 * aberrPx * amount * texel;
    vec2 r = blurPx * amount * texel;

    vec3 rgb = vec3(0.0);
    float a = 0.0;
    for (int i = 0; i < TAPS; i++) {
        float t = (float(i) + 0.5) / float(TAPS);
        float ang = float(i) * GOLDEN;
        vec2 o = vec2(cos(ang), sin(ang)) * sqrt(t) * r;
        vec4 sr = texture(source, uv + o + shift);
        vec4 sg = texture(source, uv + o);
        vec4 sb = texture(source, uv + o - shift);
        rgb += vec3(sr.r, sg.g, sb.b);
        a += (sr.a + sg.a + sb.a) / 3.0;
    }
    rgb /= float(TAPS);
    a /= float(TAPS);
    fragColor = vec4(min(rgb, vec3(a)), a) * qt_Opacity;
}
