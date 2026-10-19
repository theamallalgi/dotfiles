import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Hyprland
import Quickshell.Wayland
import Quickshell.Bluetooth
import Quickshell.Services.UPower
import Quickshell.Services.Notifications
import ".."
import "../notifications"
import "../fx"

PanelWindow {
  id: root
  visible: openFx.shown
  property alias open: openFx.open
  anchors { top: true; right: true }
  margins { top: root.marginTop; right: root.marginRight }
  implicitWidth: root.panelW
  implicitHeight: panel.height
  color: "transparent"
  exclusionMode: ExclusionMode.Ignore
  WlrLayershell.layer: WlrLayer.Overlay

  // FOCUS FIX: brief Exclusive prime on open so the menu gets the keyboard,
  // then OnDemand so click-outside still works through the focus grab.
  property bool prime: false
  WlrLayershell.keyboardFocus: !open ? WlrKeyboardFocus.None
    : prime ? WlrKeyboardFocus.Exclusive
    : WlrKeyboardFocus.OnDemand

  // colors: all from Theme
  readonly property color bgMain: Theme.panelBg
  readonly property color bgAlt: Theme.panelBgAlt
  readonly property color edge: Theme.panelEdge
  readonly property color dim: Theme.textDim
  readonly property color dim2: Theme.textDim2
  readonly property color txt: Theme.textMain
  readonly property color sel: Theme.textSel
  readonly property color bad: Theme.bad

  // tone table: maps a tone NAME to its colors.
  // The ({ ... }) parentheses matter: without them QML reads the braces as a
  // code block instead of an object literal.
  readonly property var tones: ({
    normal: { top: Theme.btnTop,  bg: Theme.btnBg,  fg: Theme.btnFg,  hi: Theme.btnHi },
    ok:     { top: Theme.okTop,   bg: Theme.okBg,   fg: Theme.okFg,   hi: Theme.okHi },
    warn:   { top: Theme.warnTop, bg: Theme.warnBg, fg: Theme.warnFg, hi: Theme.warnHi },
    bad:    { top: Theme.badTop,  bg: Theme.badBg,  fg: Theme.badFg,  hi: Theme.badHi }
  })

  // layout
  readonly property int panelW: 420
  readonly property int marginTop: 36
  readonly property int marginRight: 9
  readonly property int pad: 16
  readonly property int gap: 6
  readonly property int sectionGap: 32
  readonly property int headGap: 10
  readonly property int btnH: 34
  readonly property int btnPad: 6
  readonly property int tilePad: 8     // notification cards
  readonly property int tileInset: 10   // square tiles
  readonly property int lineGap: 2
  readonly property int bw: 2
  readonly property int panelBw: 3
  readonly property int barW: 4
  readonly property int clearW: 100
  readonly property int powerCols: 3
  readonly property int tileCols: 3
  readonly property int padBottomExtra: 16

  // type
  readonly property int textPt: 11
  readonly property int headPt: 11
  readonly property int tilePt: 10
  readonly property int iconPt: 20

  // motion: all timings live here, like every other number in this file.
  // Rule of thumb: under ~100ms feels instant, 100-150ms feels smooth but
  // quick, over 250ms starts to feel slow for UI that reacts to the cursor.
  // Set animMs and pressMs to 0 to turn the color and press animations off.
  // The open/close animation is OpenFx: set its `duration` to 0 to disable it.
  readonly property int animMs: 120      // hover/focus color fades
  readonly property int pressMs: 70      // press squish (shorter = snappier)

  // behavior
  readonly property int closeGuardMs: 300
  readonly property int primeMs: 100     // FOCUS FIX: how long the Exclusive prime lasts
  readonly property string sambaUnit: "smb"
  // readonly property var wifiCmd: ["networkmanager_dmenu"]
  readonly property var wifiCmd: ["qs", "ipc", "call", "wifimenu", "toggle"]
  // readonly property var btCmd: ["bzmenu", "-l", "rofi"]
  readonly property var btCmd: ["qs", "ipc", "call", "btmenu", "toggle"]
  readonly property var powerItems: [
    { label: "SHUTDOWN", cmd: ["systemctl", "poweroff"] },
    { label: "REBOOT",   cmd: ["systemctl", "reboot"] },
    { label: "LOG OUT",  cmd: ["bash", "-c", "loginctl terminate-user $USER"] },
    { label: "SLEEP",    cmd: ["systemctl", "suspend"] },
    { label: "LOCK",     cmd: ["hyprlock"] }
  ]
  // PowerProfiles is a singleton from Quickshell.Services.UPower.
  // It talks to power-profiles-daemon, so that daemon must be running.
  readonly property var profileItems: [
    { label: "POWER SAVER",  profile: PowerProfile.PowerSaver },
    { label: "BALANCED",     profile: PowerProfile.Balanced },
    { label: "PERFORMANCE",  profile: PowerProfile.Performance }
  ]

  // keyboard focus indices: one flat number line through every focusable item.
  // power: 0..4, tiles: 5..7, profile segments: 8..10, clear button: 11
  readonly property int powerCount: powerItems.length
  readonly property int profileCount: profileItems.length
  readonly property int wifiIdx: powerCount
  readonly property int btIdx: powerCount + 1
  readonly property int sambaIdx: powerCount + 2
  readonly property int profileIdx: powerCount + tileCols
  readonly property int clearIdx: profileIdx + profileCount
  readonly property int count: clearIdx + (Store.history.length > 0 ? 1 : 0)
  property int cur: 0

  // raw state: plain strings straight from the commands.
  property string wifiRadio: ""     // "enabled" | "disabled" | "error" | "" (not checked yet)
  property string sambaState: ""    // output of `systemctl is-active`
  property string conn: ""
  property double closedAt: 0

  readonly property bool sambaOn: sambaState === "active"

  // view models: each is { tone, text }, which is all a Tile needs.
  readonly property var wifiView: {
    if (wifiRadio === "") return { tone: "normal", text: "..." }
    if (wifiRadio === "disabled") return { tone: "normal", text: "Off" }
    if (wifiRadio !== "enabled") return { tone: "bad", text: "Error" }
    return conn !== ""
      ? { tone: "ok", text: conn }
      : { tone: "warn", text: "Disconnected" }
  }

  readonly property var btView: {
    const a = Bluetooth.defaultAdapter
    if (!a) return { tone: "bad", text: "Unavailable" }
    if (!a.enabled) return { tone: "normal", text: "Off" }
    const dev = a.devices.values.find(x => x.connected)
    return dev
      ? { tone: "ok", text: dev.name }
      : { tone: "warn", text: "Disconnected" }
  }

  readonly property var sambaStates: ({
    "":           { tone: "normal", text: "..." },
    active:       { tone: "ok",     text: "On" },
    inactive:     { tone: "normal", text: "Off" },
    activating:   { tone: "warn",   text: "Starting" },
    deactivating: { tone: "warn",   text: "Stopping" },
    failed:       { tone: "bad",    text: "Failed" }
  })
  readonly property var sambaView: sambaStates[sambaState] ?? { tone: "bad", text: "Missing" }

  function run(cmd: var): void {
    Quickshell.execDetached(cmd)
    open = false
  }

  function refresh(): void {
    sambaCheck.running = true
    wifiCheck.running = true
    connCheck.running = true
  }

  function setSamba(on: bool): void {
    sambaSet.command = ["systemctl", on ? "start" : "stop", sambaUnit]
    sambaSet.running = true
  }

  function clearAll(): void {
    Store.clear()
    cur = Math.min(cur, count - 1)
  }

  function setProfile(p: var): void {
    if (p === PowerProfile.Performance && !PowerProfiles.hasPerformanceProfile) return
    PowerProfiles.profile = p
  }

  function activate(i: int): void {
    if (i < powerCount) run(powerItems[i].cmd)
    else if (i === wifiIdx) run(wifiCmd)
    else if (i === btIdx) run(btCmd)
    else if (i === sambaIdx) setSamba(!sambaOn)
    else if (i >= profileIdx && i < clearIdx) setProfile(profileItems[i - profileIdx].profile)
    else if (i === clearIdx) clearAll()
  }

  function move(dx: int, dy: int): void {
    let i = cur
    const lastRowStart = Math.floor((powerCount - 1) / powerCols) * powerCols

    if (dx !== 0) {
      i += dx
    } else if (dy > 0) {
      if (i < powerCount)
        i = i + powerCols < powerCount ? i + powerCols : wifiIdx + (i % powerCols)
      else if (i < profileIdx)
        i = profileIdx + (i - wifiIdx)
      else if (i < clearIdx && count > clearIdx)
        i = clearIdx
    } else if (dy < 0) {
      if (i === clearIdx) i = profileIdx + 1
      else if (i >= profileIdx) i = wifiIdx + (i - profileIdx)
      else if (i >= wifiIdx) i = Math.min(powerCount - 1, lastRowStart + (i - wifiIdx))
      else i -= powerCols
    }
    cur = Math.max(0, Math.min(count - 1, i))
  }

  onOpenChanged: {
    if (!open) { closedAt = Date.now(); return }
    cur = 0
    refresh()
  }
  onVisibleChanged: if (visible) Qt.callLater(() => keys.forceActiveFocus())

  // FOCUS FIX: separate handler so onOpenChanged above stays untouched
  Connections {
    target: root
    function onOpenChanged(): void {
      root.prime = root.open
      if (root.open) primeTimer.restart()
      else primeTimer.stop()
    }
  }
  Timer { id: primeTimer; interval: root.primeMs; onTriggered: root.prime = false }

  // Fade: our own animation type, a ColorAnimation with our timing baked in.
  // Behaviors below use it, so changing the feel of every color fade is a
  // one-line edit here. `component X: Y` makes a reusable copy of Y with
  // your settings, the same trick as Box, Tile and Head.
  // OutCubic = starts fast and settles gently, which feels natural for UI.
  component Fade: ColorAnimation {
    duration: root.animMs
    easing.type: Easing.OutCubic
  }

  IpcHandler {
    target: "controlcenter"
    function toggle(): void {
      if (!root.open && Date.now() - root.closedAt < root.closeGuardMs) return
      root.open = !root.open
    }
  }

  // FOCUS FIX: grab waits for the prime to end so the two never overlap
  HyprlandFocusGrab {
    windows: [root]
    active: root.open && root.visible && !root.prime
    onCleared: root.open = false
  }

  Process {
    id: sambaCheck
    command: ["systemctl", "is-active", root.sambaUnit]
    stdout: StdioCollector { onStreamFinished: root.sambaState = text.trim() }
  }
  Process { id: sambaSet; onExited: sambaCheck.running = true }

  Process {
    id: wifiCheck
    command: ["nmcli", "radio", "wifi"]
    stdout: StdioCollector {
      onStreamFinished: if (text.trim() !== "") root.wifiRadio = text.trim()
    }
    onExited: code => { if (code !== 0) root.wifiRadio = "error" }
  }
  Process {
    id: connCheck
    command: ["nmcli", "-g", "GENERAL.CONNECTION", "dev", "show", "wlan0"]
    stdout: StdioCollector {
      onStreamFinished: root.conn = text.trim() === "--" ? "" : text.trim()
    }
  }

  // Box: a focusable, clickable rectangle.
  // Idle: bg fill, fg text, border same color as bg (invisible).
  // Hover/selected: border and text switch to hi.
  component Box: Rectangle {
    id: box
    property string label: ""
    property int idx: -1
    property string tone: "normal"
    // how far the box shrinks while pressed (1 = no squish). Segments that
    // touch each other, like the profile bar, set this to 1 so no gap opens.
    property real pressScale: 0.97
    readonly property bool focused: idx >= 0 && root.cur === idx

    readonly property var pal: root.tones[tone]
    readonly property color fg: focused ? pal.hi : pal.fg
    signal clicked

    implicitHeight: root.btnH
    color: pal.bg
    border { width: root.bw; color: focused ? pal.hi : pal.bg }

    // A Behavior says: "whenever this property changes, animate to the new
    // value instead of jumping." The binding above still decides the TARGET
    // color. The Behavior only decides how to get there. That is why the
    // logic stays in one place and the motion in another.
    // `border.color` is a grouped property, so it is written with the dot.
    // Because it watches the property and not the cause, it also smooths
    // tone changes (wifi connecting, a new power profile) for free.
    Behavior on color { Fade {} }
    Behavior on border.color { Fade {} }

    // press squish: scale shrinks a hair while the mouse button is down.
    // scale grows/shrinks around the item's center by default.
    scale: area.pressed ? pressScale : 1
    Behavior on scale { NumberAnimation { duration: root.pressMs; easing.type: Easing.OutCubic } }

    Text {
      visible: box.label !== ""
      anchors { fill: parent; leftMargin: root.btnPad; rightMargin: root.btnPad }
      horizontalAlignment: Text.AlignHCenter
      verticalAlignment: Text.AlignVCenter
      text: box.label
      elide: Text.ElideRight
      color: box.fg
      // box.fg is readonly, and Behaviors cannot attach to read-only
      // properties. So the Behavior goes on this Text's own `color`, which
      // is writable and just happens to be bound to box.fg.
      Behavior on color { Fade {} }
      font { family: Theme.font; pointSize: root.textPt; bold: true }
    }
    MouseArea {
      id: area
      anchors.fill: parent
      hoverEnabled: true
      cursorShape: Qt.PointingHandCursor
      onClicked: box.clicked()
      // hovering moves the keyboard cursor, so mouse and keys always agree
      onContainsMouseChanged: if (containsMouse && box.idx >= 0) root.cur = box.idx
    }
  }

  // Tile: a square Box with an icon top-left and title + status bottom-left.
  // `component Tile: Box` means "everything Box has, plus what I add".
  component Tile: Box {
    id: tile
    property string icon: ""
    property string title: ""
    property string status: ""

    height: width   // square: height follows whatever width the Grid gives it

    gradient: Gradient {
      GradientStop { position: 0.0; color: tile.pal.top; Behavior on color { Fade {} } }
      GradientStop { position: 1.0; color: tile.pal.bg;  Behavior on color { Fade {} } }
    }

    // Nerd Font glyph. Code points above U+FFFF are written as a surrogate pair.
    // Look up glyphs at nerdfonts.com/cheat-sheet.
    Text {
      anchors { left: parent.left; top: parent.top; margins: root.tileInset }
      text: tile.icon
      color: tile.fg
      Behavior on color { Fade {} }
      font { family: Theme.font; pixelSize: root.iconPt * 1.33 }
    }

    Column {
      anchors { left: parent.left; bottom: parent.bottom; margins: root.tileInset }
      width: parent.width - root.tileInset * 2
      spacing: root.lineGap

      Text {
        width: parent.width
        text: tile.title
        elide: Text.ElideRight
        color: tile.fg
        Behavior on color { Fade {} }
        opacity: 0.7   // dimmer than the status without needing a second color
        font { family: Theme.font; pointSize: root.tilePt; bold: true; capitalization: Font.AllUppercase }
      }
      Text {
        width: parent.width
        text: tile.status
        elide: Text.ElideRight
        color: tile.fg
        Behavior on color { Fade {} }
        font { family: Theme.font; pointSize: root.tilePt; bold: true }
      }
    }
  }

  component Head: Text {
    color: root.dim
    font { family: Theme.font; pointSize: root.headPt; bold: true; capitalization: Font.AllUppercase }
  }

  Rectangle {
    id: panel
    width: parent.width
    height: col.implicitHeight + root.pad * 2 + root.padBottomExtra
    // color: root.bgMain
    border { width: root.panelBw; color: root.edge }
    gradient: Gradient {
      GradientStop { position: 0.0; color: "#021746" }
      GradientStop { position: 1.0; color: "#011033" }
    }

    Item {
      id: keys
      focus: true
      Keys.onPressed: e => {
        switch (e.key) {
        case Qt.Key_Escape:
        case Qt.Key_Q:
          root.open = false; break
        case Qt.Key_J: case Qt.Key_Down: case Qt.Key_Tab:
          root.move(0, 1); break
        case Qt.Key_K: case Qt.Key_Up: case Qt.Key_Backtab:
          root.move(0, -1); break
        case Qt.Key_H: case Qt.Key_Left:
          root.move(-1, 0); break
        case Qt.Key_L: case Qt.Key_Right:
          root.move(1, 0); break
        case Qt.Key_Return: case Qt.Key_Enter: case Qt.Key_Space:
          root.activate(root.cur); break
        default:
          return
        }
        e.accepted = true
      }
    }

    Column {
      id: col
      x: root.pad
      y: root.pad
      width: parent.width - root.pad * 2
      spacing: root.sectionGap

      // section 1: power
      Column {
        width: parent.width
        spacing: root.headGap

        Head { text: "Power" }
        Grid {
          width: parent.width
          columns: root.powerCols
          spacing: root.gap
          readonly property real cell: (width - root.gap * (columns - 1)) / columns

          Repeater {
            model: root.powerItems
            Box {
              required property var modelData
              required property int index
              idx: index
              width: parent.cell
              label: modelData.label
              onClicked: root.activate(index)
            }
          }
        }
      }

      // section 2: network, three square tiles in one row
      Column {
        width: parent.width
        spacing: root.headGap

        Head { text: "Network" }
        Grid {
          width: parent.width
          columns: root.tileCols
          spacing: root.gap
          readonly property real cell: (width - root.gap * (columns - 1)) / columns

          Tile {
            idx: root.wifiIdx
            width: parent.cell
            icon: "\udb81\udda9 "
            title: "Wifi"
            status: root.wifiView.text
            tone: root.wifiView.tone
            onClicked: root.activate(idx)
          }
          Tile {
            idx: root.btIdx
            width: parent.cell
            icon: "\udb80\udcaf"
            title: "Bluetooth"
            status: root.btView.text
            tone: root.btView.tone
            onClicked: root.activate(idx)
          }
          Tile {
            idx: root.sambaIdx
            width: parent.cell
            icon: "\ue62a"
            title: "Samba"
            status: root.sambaView.text
            tone: root.sambaView.tone
            onClicked: root.activate(idx)
          }
        }
      }

      // section 3: power profile, one bar made of three touching segments
      Column {
        width: parent.width
        spacing: root.headGap

        Head { text: "Power Profile" }
        Row {
          width: parent.width
          spacing: 0
          readonly property int cell: Math.floor(width / root.profileItems.length)

          Repeater {
            model: root.profileItems
            Box {
              required property var modelData
              required property int index
              idx: root.profileIdx + index
              label: modelData.label
              width: index === root.profileItems.length - 1
                ? parent.width - parent.cell * index
                : parent.cell
              // no squish here: the segments touch, so shrinking one would
              // briefly open a gap between it and its neighbor.
              pressScale: 1
              // The selected segment changes tone when the daemon's profile
              // changes, and the Behaviors inside Box fade it. So the green
              // slides from one segment to the next instead of snapping.
              tone: PowerProfiles.profile === modelData.profile ? "ok" : "normal"
              onClicked: root.activate(idx)
            }
          }
        }
      }

      // section 4: notifications
      Column {
        width: parent.width
        spacing: root.headGap

        Item {
          width: parent.width
          height: clearBtn.visible ? clearBtn.height : headLabel.implicitHeight

          Head {
            id: headLabel
            anchors.verticalCenter: parent.verticalCenter
            text: "Recent Notifications"
          }
          Box {
            id: clearBtn
            visible: Store.history.length > 0
            idx: root.clearIdx
            anchors.right: parent.right
            width: root.clearW
            label: "clear all"
            onClicked: root.activate(idx)
          }
        }

        Column {
          width: parent.width
          spacing: root.gap

          Text {
            visible: Store.history.length === 0
            text: "no notifications"
            color: root.dim2
            font { family: Theme.font; pointSize: root.textPt; bold: true }
          }

          Repeater {
            model: Store.history

            Rectangle {
              id: card
              required property var modelData
              readonly property bool crit: modelData.urgency === NotificationUrgency.Critical
              width: parent.width
              height: cardCol.implicitHeight + root.tilePad * 2
              color: crit ? Theme.badBg : root.bgAlt

              Rectangle {
                width: root.barW
                height: parent.height
                color: card.crit ? root.bad : root.edge
              }

              Column {
                id: cardCol
                x: root.barW + root.tilePad
                y: root.tilePad
                width: parent.width - root.barW - root.tilePad * 2
                spacing: root.lineGap

                Text {
                  width: parent.width
                  text: card.modelData.summary
                  elide: Text.ElideRight
                  color: root.dim
                  font { family: Theme.font; pointSize: 12; bold: true }
                }
                Text {
                  visible: text !== ""
                  width: parent.width
                  text: card.modelData.body
                  elide: Text.ElideRight
                  maximumLineCount: 1
                  color: root.dim
                  font { family: Theme.font; pointSize: 10; bold: true }
                }
              }
            }
          }
        }
      }
    }
  }

  OpenFx { id: openFx; target: panel; name: "controlcenter"; origin: Item.TopRight }
}
