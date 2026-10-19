pragma Singleton
import QtQuick
import Quickshell

// A Singleton is created once and shared. Any file that does `import ".."`
// can read these values as Theme.something.
Singleton {
  // palette: raw colors, the only place hex values live
  readonly property color bg0: "#0b080e"
  readonly property color bgAlt: "#2c1e36"
  readonly property color bg3: "#3e4451"
  readonly property color fg: "#abb2bf"
  readonly property color grey0: "#5c6370"
  readonly property color grey1: "#828997"
  readonly property color purple: "#8543e4"
  readonly property color accent: "#8543e4"
  readonly property color green: "#46cda8"
  readonly property color red: "#e4384c"
  readonly property color yellow: "#e09066"

  readonly property color navy0: "#02133b"
  readonly property color navy1: "#021542"
  readonly property color navy2: "#273d70"
  readonly property color silver: "#afbfbf"
  readonly property color blu0: "#011033"
  readonly property color blu1: "#021A4F"
  readonly property color blu2: "#04205E"
  readonly property color blu3: "#082A75"
  readonly property color blu4: "#103890"
  readonly property color blu5: "#1745A8"
  readonly property color blu6: "#2959C1"
  readonly property color blu7: "#466FC7"
  readonly property color blu8: "#7791CA"

  // state palettes: each state needs 3 shades (dark bg, light text, lighter hover)
  // pattern: Dark = background, Light = idle text, Pale = hover border + text
  readonly property color greenDark: "#0b1618"
  readonly property color greenLight: "#46cda8"
  readonly property color greenPale: "#46cda8"

  readonly property color yellowDark: "#331b17"
  readonly property color yellowLight: "#e09066"
  readonly property color yellowPale: "#e09066"

  readonly property color redDark: "#481219"
  readonly property color redLight: "#e4384c"
  readonly property color redPale: "#e4384c"

  // semantic tokens: what modules should use
  readonly property color panelBg: blu0
  readonly property color panelBgAlt: navy1
  readonly property color panelEdge: "#021746"
  readonly property color textMain: fg
  readonly property color textDim: grey1
  readonly property color textDim2: grey0
  readonly property color textSel: navy2

  // button tones: every tone is a trio of bg / fg / hi
  //   bg = fill and idle border (so the border is invisible)
  //   fg = idle text and icon
  //   hi = border and text while hovered or selected
  readonly property color btnBg: blu1
  readonly property color btnFg: grey0
  readonly property color btnHi: grey1

  readonly property color okBg: greenDark
  readonly property color okFg: greenLight
  readonly property color okHi: greenPale

  readonly property color warnBg: yellowDark
  readonly property color warnFg: yellowLight
  readonly property color warnHi: yellowPale

  readonly property color badBg: redDark
  readonly property color badFg: redLight
  readonly property color badHi: redPale

  readonly property color greenTop: "#0a2017"
  readonly property color yellowTop: "#1f0f0b"
  readonly property color redTop: "#290a0e"   // not in your CSS, derived from warn's ratio

  readonly property color btnTop: btnBg
  readonly property color okTop: greenTop
  readonly property color warnTop: yellowTop
  readonly property color badTop: redTop

  readonly property color ok: green
  readonly property color bad: red

  readonly property string font: "KodeMono Nerd Font"
  readonly property string font2: "Orbitron"
  readonly property string font3: "Geist"
  readonly property int fontSize: 13
}
