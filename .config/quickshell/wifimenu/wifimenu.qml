import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Hyprland
import Quickshell.Wayland
import ".."
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
  readonly property color edge: Theme.panelEdge
  readonly property color dim: Theme.textDim
  readonly property color dim2: Theme.textDim2
  readonly property color txt: Theme.textMain

  // tone table: a tone NAME maps to its colors (same as control center)
  readonly property var tones: ({
    normal: { top: Theme.btnTop,  bg: Theme.btnBg,  fg: Theme.btnFg,  hi: Theme.btnHi },
    ok:     { top: Theme.okTop,   bg: Theme.okBg,   fg: Theme.okFg,   hi: Theme.okHi },
    warn:   { top: Theme.warnTop, bg: Theme.warnBg, fg: Theme.warnFg, hi: Theme.warnHi },
    bad:    { top: Theme.badTop,  bg: Theme.badBg,  fg: Theme.badFg,  hi: Theme.badHi }
  })

  // ICONS: this is the block to tweak. Every icon in the menu comes from here.
  // Any string works. Paste a Nerd Font glyph straight in, or write it by
  // code point. "\uf1eb" is U+F1EB. Code points above U+FFFF can't fit in
  // one \u escape, so they are written as a surrogate pair:
  // "\udb82\udd22" is U+F0922. Browse glyphs at nerdfonts.com/cheat-sheet.
  readonly property string iconNet: "\udb81\udda9 "      // left of a normal network
  readonly property string iconSaved: "\udb80\udcc0"    // left of a saved network
  readonly property string iconActive: "\udb81\udda9 "   // left of the connected one
  readonly property string iconLock: "\ue672 "     // right: secured network
  readonly property string iconOpen: ""           // right: open network ("" = nothing)
  // signal range icons, weakest to strongest. Picked by level:
  // level = ceil(signal / 25), so 0 -> [0], 1-25 -> [1], 26-50 -> [2], 51-75 -> [3], 76-100 -> [4]
  readonly property var iconSignal: [
    "\udb82\udd2f",   // none
    "\udb82\udd1f",   // weak
    "\udb82\udd22",   // ok
    "\udb82\udd25",   // good
    "\udb82\udd28"    // strong
  ]

  // layout
  readonly property int panelW: 420
  readonly property int marginTop: 36
  readonly property int marginRight: 9
  readonly property int pad: 16
  readonly property int padBottomExtra: 16
  readonly property int sectionGap: 26
  readonly property int headGap: 16
  readonly property int btnH: 34
  readonly property int btnPad: 6
  readonly property int tilePad: 16      // section 1 bar
  readonly property int tileInset: 10    // status box
  readonly property int rowInset: 12     // network rows
  readonly property int rowGap: 8        // between rows and between buttons
  readonly property int lineGap: 2
  readonly property int iconW: 22        // fixed icon slot, so names and icons line up
  readonly property int maxRows: 6       // rows shown before the list scrolls
  readonly property int bw: 2
  readonly property int panelBw: 3

  // type
  readonly property int textPt: 11
  readonly property int headPt: 11
  readonly property int iconPt: 12

  // motion (same values as the control center)
  readonly property int animMs: 120
  readonly property int pressMs: 70

  // behavior
  readonly property int closeGuardMs: 300
  readonly property int primeMs: 100     // FOCUS FIX: how long the Exclusive prime lasts
  readonly property int rescanDelayMs: 2500
  // what "Launch connection manager" runs. Swap for a terminal UI if you like,
  // e.g. ["kitty", "-e", "nmtui"]
  readonly property var managerCmd: ["nm-connection-editor"]
  readonly property var controlCmd: ["qs", "ipc", "call", "controlcenter", "toggle"]

  // state
  property string view: "networks"   // "networks" | "saved" | "password"
  property string pendingSsid: ""    // network waiting for its password
  property var networks: []
  property var saved: []             // names of saved wifi profiles
  property string radio: ""          // "enabled" | "disabled" | "error" | "" (unknown yet)
  property string conn: ""           // name of the active wifi profile
  property string status: ""
  property string statusTone: "normal"
  property bool pwShown: false
  property bool busy: false
  property bool scanning: false
  property double closedAt: 0

  // FOCUS is stored as a place, not a number: zone 0 = toggle bar, 1 = list,
  // 2 = action buttons, and pos = which item inside that zone. A single flat
  // index would shift every time the list grows or shrinks (for example after
  // a rescan) and silently move your selection onto a different button.
  property int zone: 1
  property int pos: 0

  readonly property bool radioOff: radio === "disabled"

  // section 1: what the toggle bar shows (right-hand status + color)
  readonly property var wifiView: {
    if (busy) return { tone: "warn", text: "Connecting..." }
    if (radio === "") return { tone: "normal", text: "..." }
    if (radioOff) return { tone: "normal", text: "Off" }
    if (radio !== "enabled") return { tone: "bad", text: "Error" }
    return conn !== ""
      ? { tone: "ok", text: "Connected" }
      : { tone: "warn", text: "Disconnected" }
  }

  // section 2: the rows currently in the list. Plain objects, so the delegate
  // only draws and never decides.
  readonly property var rows: {
    if (view === "saved")
      return saved.map(n => ({ kind: "saved", name: n, active: n === conn }))
    if (radioOff) return []
    return networks.map(n => ({
      kind: "net", name: n.ssid, signal: n.signal, security: n.security,
      active: n.active, saved: saved.indexOf(n.ssid) >= 0
    }))
  }
  readonly property int listH: {
    const n = Math.min(rows.length, maxRows)
    return n > 0 ? n * btnH + (n - 1) * rowGap : 0
  }
  readonly property string sec2Title: view === "saved" ? "Saved connections"
    : view === "password" ? "Password" : "Available networks"
  readonly property string emptyText: view === "saved" ? "No saved connections"
    : radioOff ? "Wifi is off" : "No networks found"

  // section 3: the action buttons. Two labels change with state.
  readonly property var actions: [
    { key: "manager",  label: "LAUNCH CONNECTION MANAGER" },
    { key: "rescan",   label: "RESCAN WIFI NETWORKS" },
    { key: "password", label: pwShown ? "HIDE WIFI PASSWORD" : "SHOW WIFI PASSWORD" },
    { key: "saved",    label: view === "saved" ? "SHOW AVAILABLE NETWORKS" : "SHOW SAVED CONNECTIONS" }
  ]

  // nmcli's terse mode (-t) separates fields with ":" and writes a literal
  // colon inside a value as "\:" (a backslash as "\\"). A plain split(":")
  // would break on SSIDs like "Cafe: Guest", so walk the line and split only
  // on colons that are not escaped.
  function splitTerse(line: string): var {
    const out = []
    let cur = ""
    for (let i = 0; i < line.length; i++) {
      const c = line[i]
      if (c === "\\" && i + 1 < line.length) cur += line[++i]
      else if (c === ":") { out.push(cur); cur = "" }
      else cur += c
    }
    out.push(cur)
    return out
  }

  // depending on the nmcli version, wifi profiles report either word
  function isWifi(type: string): bool {
    return type === "802-11-wireless" || type === "wifi"
  }

  // first line of nmcli's output, without its "Error: " prefix
  function clean(msg: string): string {
    return msg.split("\n")[0].replace(/^Error:\s*/, "")
  }

  // One router can show the same SSID several times (2.4/5 GHz, mesh nodes).
  // Keep one row per SSID: the active one, else the strongest.
  function parseNetworks(text: string): var {
    const out = []
    const at = {}   // ssid -> position in `out`
    for (const line of text.split("\n")) {
      if (line === "") continue
      const f = splitTerse(line)   // [IN-USE, SSID, SIGNAL, SECURITY]
      if (!f[1]) continue          // hidden networks have an empty SSID
      const e = {
        ssid: f[1],
        signal: parseInt(f[2]) || 0,
        security: f[3] === "--" ? "" : f[3],
        active: f[0] === "*"
      }
      const i = at[e.ssid]
      if (i === undefined) { at[e.ssid] = out.length; out.push(e) }
      else if (e.active || (!out[i].active && e.signal > out[i].signal)) out[i] = e
    }
    // booleans subtract as 0/1: active first, then strongest
    return out.sort((a, b) => (b.active - a.active) || (b.signal - a.signal))
  }

  function setStatus(tone: string, text: string): void {
    pwShown = false   // any new message replaces a revealed password
    statusTone = tone
    status = text
  }

  function run(cmd: var): void {
    Quickshell.execDetached(cmd)
    open = false
  }
  function backToControl(): void {
    Quickshell.execDetached(controlCmd)
    open = false
  }

  function refresh(): void {
    radioProc.running = true
    savedProc.running = true
    activeProc.running = true
    listProc.running = true   // instant: reads the cached scan
    rescan()                  // then ask for a fresh one
  }

  // A rescan request returns immediately but results land a moment later, so:
  // request, wait, list again. nmcli refuses a scan that comes too soon after
  // the last one; we relist either way.
  function rescan(): void {
    scanning = true
    scanProc.running = true
  }

  // focus math: convert (zone, pos) to one line number and back, ONLY while
  // moving. Between moves we store the place, never the number.
  function toLin(): int {
    return zone === 0 ? 0 : zone === 1 ? 1 + pos : 1 + rows.length + pos
  }
  function move(d: int): void {
    const total = 1 + rows.length + actions.length
    const i = Math.max(0, Math.min(total - 1, toLin() + d))
    if (i === 0) { zone = 0; pos = 0 }
    else if (i <= rows.length) { zone = 1; pos = i - 1 }
    else { zone = 2; pos = i - 1 - rows.length }
  }

  function activate(): void {
    if (zone === 0) toggleRadio()
    else if (zone === 1) activateRow(pos)
    else runAction(pos)
  }

  function toggleRadio(): void {
    if (view === "password") back()
    radioSet.command = ["nmcli", "radio", "wifi", radioOff ? "on" : "off"]
    radioSet.running = true
  }

  function activateRow(i: int): void {
    if (busy) return
    const r = rows[i]
    if (!r) return
    if (r.kind === "saved") { start(r.name, ["connection", "up", "id", r.name]); return }
    if (r.active) { setStatus("normal", "Already connected to " + r.name); return }
    if (r.saved) { start(r.name, ["connection", "up", "id", r.name]); return }
    if (r.security === "") { start(r.name, ["device", "wifi", "connect", r.name]); return }
    if (r.security.indexOf("802.1X") >= 0) {
      setStatus("bad", "Enterprise network: set it up once in nmtui")
      return
    }
    enterPassword(r.name)   // secured and not saved: ask for the password
  }

  function runAction(i: int): void {
    if (view === "password") back()
    switch (actions[i].key) {
    case "manager": run(managerCmd); break
    case "rescan": rescan(); break
    case "password": togglePassword(); break
    case "saved":
      view = view === "saved" ? "networks" : "saved"
      status = ""
      break
    }
  }

  // `-s` includes secrets, `-g` prints just the one field
  function togglePassword(): void {
    if (pwShown) { pwShown = false; status = ""; return }
    if (conn === "") { setStatus("warn", "Not connected"); return }
    pwProc.go(["-s", "-g", "802-11-wireless-security.psk", "connection", "show", "id", conn])
  }

  function start(name: string, args: var): void {
    busy = true
    setStatus("normal", "Connecting to " + name + "...")
    connProc.go(args)
  }

  function connectDone(code: int, msg: string): void {
    busy = false
    if (code === 0) { open = false; return }
    // A failed first connect leaves a half-made profile that would keep
    // reusing the wrong password. Delete it so the next try starts clean.
    if (view === "password") {
      Quickshell.execDetached(["nmcli", "connection", "delete", "id", pendingSsid])
      pwInput.text = ""
    }
    setStatus("bad", msg !== "" ? clean(msg) : "Connection failed")
  }

  function enterPassword(ssid: string): void {
    pendingSsid = ssid
    view = "password"
    status = ""
    pwInput.text = ""
    // wait one tick: the field only becomes visible after `view` changes
    Qt.callLater(() => pwInput.forceActiveFocus())
  }

  function submitPassword(): void {
    if (pwInput.text === "" || busy) return
    start(pendingSsid, ["device", "wifi", "connect", pendingSsid, "password", pwInput.text])
  }

  function back(): void {
    view = "networks"
    pendingSsid = ""
    status = ""
    keys.forceActiveFocus()   // hand keyboard control back from the password field
  }

  onOpenChanged: {
    if (!open) { closedAt = Date.now(); return }
    view = "networks"
    pendingSsid = ""
    status = ""
    pwShown = false
    busy = false
    zone = 1
    pos = 0
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

  // Fade: a ColorAnimation with our timing baked in; Behaviors below use it
  component Fade: ColorAnimation {
    duration: root.animMs
    easing.type: Easing.OutCubic
  }

  // Nm: a Process that runs nmcli and reports ONE result: done(code, message).
  // It goes through `sh -c` for two reasons. Exit code and message arrive on a
  // single stream, so there is no race between "process exited" and "output
  // finished". And the args are passed as positional parameters ("$@"), never
  // pasted into the script, so SSIDs or passwords with quotes can't break out.
  component Nm: Process {
    id: p
    signal done(int code, string msg)
    function go(args: var): void {
      if (running) return
      command = ["sh", "-c", 'out=$(nmcli "$@" 2>&1); echo "$?|$out"', "sh"].concat(args)
      running = true
    }
    stdout: StdioCollector {
      onStreamFinished: {
        const cut = text.indexOf("|")
        if (cut >= 0) p.done(parseInt(text.slice(0, cut)), text.slice(cut + 1).trim())
      }
    }
  }

  // The guard stops "click the bar to close" from reopening the menu: that
  // click first makes the focus grab close it, then the IPC toggle arrives.
  IpcHandler {
    target: "wifimenu"
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

  // data sources
  Process {
    id: listProc
    command: ["nmcli", "-t", "-f", "IN-USE,SSID,SIGNAL,SECURITY", "device", "wifi", "list", "--rescan", "no"]
    stdout: StdioCollector {
      onStreamFinished: {
        // remember the highlighted row, swap the data, then find that row
        // again, so the selection doesn't jump when the post-scan refresh lands
        const keep = root.zone === 1 ? root.rows[root.pos]?.name : undefined
        root.networks = root.parseNetworks(text)
        if (keep !== undefined) {
          const i = root.rows.findIndex(r => r.name === keep)
          if (i >= 0) root.pos = i
        }
      }
    }
  }

  // saved wifi profiles. NAME usually equals the SSID, which is how we match.
  Process {
    id: savedProc
    command: ["nmcli", "-t", "-f", "NAME,TYPE", "connection", "show"]
    stdout: StdioCollector {
      onStreamFinished: root.saved = text.split("\n")
        .map(l => root.splitTerse(l))
        .filter(f => root.isWifi(f[1]))
        .map(f => f[0])
    }
  }

  // the wifi profile that is active right now (works on any interface name)
  Process {
    id: activeProc
    command: ["nmcli", "-t", "-f", "NAME,TYPE", "connection", "show", "--active"]
    stdout: StdioCollector {
      onStreamFinished: {
        const hit = text.split("\n")
          .map(l => root.splitTerse(l))
          .find(f => root.isWifi(f[1]))
        root.conn = hit ? hit[0] : ""
      }
    }
  }

  Process {
    id: radioProc
    command: ["nmcli", "radio", "wifi"]
    stdout: StdioCollector {
      onStreamFinished: if (text.trim() !== "") root.radio = text.trim()
    }
    onExited: code => { if (code !== 0) root.radio = "error" }
  }
  Process { id: radioSet; onExited: root.refresh() }

  Process { id: scanProc; command: ["nmcli", "device", "wifi", "rescan"]; onExited: relistTimer.restart() }
  Timer {
    id: relistTimer
    interval: root.rescanDelayMs
    onTriggered: { listProc.running = true; activeProc.running = true; root.scanning = false }
  }

  Nm { id: connProc; onDone: (code, msg) => root.connectDone(code, msg) }
  Nm {
    id: pwProc
    onDone: (code, msg) => {
      if (code !== 0) { root.setStatus("bad", root.clean(msg)); return }
      root.setStatus("ok", msg !== "" ? "PASSWORD  " + msg : "No password stored (open network?)")
      root.pwShown = true   // after setStatus, which resets it
    }
  }

  // Box: a focusable, clickable rectangle. zid/slot say WHERE it sits in the
  // focus map (zone + position). It is "focused" when root.zone/pos match.
  // Idle: bg fill, invisible border. Focused: border and text switch to hi.
  component Box: Rectangle {
    id: box
    property string label: ""
    property int zid: -1
    property int slot: 0
    property string tone: "normal"
    property real pressScale: 0.97
    readonly property bool focused: zid >= 0 && root.zone === zid && root.pos === slot

    readonly property var pal: root.tones[tone]
    readonly property color fg: focused ? pal.hi : pal.fg
    signal clicked

    implicitHeight: root.btnH
    color: pal.bg
    gradient: Gradient {
      GradientStop { position: 0.0; color: box.pal.top; Behavior on color { Fade {} } }
      GradientStop { position: 1.0; color: box.pal.bg;  Behavior on color { Fade {} } }
    }
    border { width: root.bw; color: focused ? pal.hi : pal.bg }
    Behavior on color { Fade {} }
    Behavior on border.color { Fade {} }

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
      Behavior on color { Fade {} }
      font { family: Theme.font; pointSize: root.textPt; bold: true }
    }
    MouseArea {
      id: area
      anchors.fill: parent
      hoverEnabled: true
      cursorShape: Qt.PointingHandCursor
      onClicked: box.clicked()
      // hover moves the keyboard focus, so mouse and keys always agree
      onContainsMouseChanged: if (containsMouse && box.zid >= 0) { root.zone = box.zid; root.pos = box.slot }
    }
  }

  // ListRow: a Box laid out as  [icon] name ........ [lock] [signal]
  // Icons sit in fixed-width slots so every row lines up.
  component ListRow: Box {
    id: lr
    property string icon: ""
    property string name: ""
    property string lockIcon: ""
    property string sigIcon: ""

    Text {
      id: lead
      anchors { left: parent.left; leftMargin: root.rowInset; verticalCenter: parent.verticalCenter }
      width: root.iconW
      horizontalAlignment: Text.AlignHCenter
      text: lr.icon
      color: lr.fg
      Behavior on color { Fade {} }
      font { family: Theme.font; pointSize: root.iconPt }
    }
    Text {
      anchors {
        left: lead.right; leftMargin: 10
        right: tail.visible ? tail.left : parent.right
        rightMargin: tail.visible ? 10 : root.rowInset
        verticalCenter: parent.verticalCenter
      }
      text: lr.name
      elide: Text.ElideRight
      color: lr.fg
      Behavior on color { Fade {} }
      font { family: Theme.font; pointSize: root.textPt; bold: true }
    }
    Row {
      id: tail
      visible: lr.lockIcon !== "" || lr.sigIcon !== ""
      anchors { right: parent.right; rightMargin: root.rowInset; verticalCenter: parent.verticalCenter }
      spacing: 8
      Text {
        width: root.iconW
        horizontalAlignment: Text.AlignHCenter
        text: lr.lockIcon
        color: lr.fg
        Behavior on color { Fade {} }
        font { family: Theme.font; pointSize: root.iconPt }
      }
      Text {
        width: root.iconW
        horizontalAlignment: Text.AlignHCenter
        text: lr.sigIcon
        color: lr.fg
        Behavior on color { Fade {} }
        font { family: Theme.font; pointSize: root.iconPt }
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
        // case Qt.Key_Escape:
        //   if (root.view === "password") root.back()
        //   else if (root.view === "saved") { root.view = "networks"; root.zone = 1; root.pos = 0 }
        //   else root.open = false
        //   break
        case Qt.Key_Escape:
          if (root.view === "password") root.back()
          else if (root.view === "saved") { root.view = "networks"; root.zone = 1; root.pos = 0 }
          else root.backToControl()
          break
        case Qt.Key_Q:
          root.open = false; break
        case Qt.Key_J: case Qt.Key_Down: case Qt.Key_Tab:
          root.move(1); break
        case Qt.Key_K: case Qt.Key_Up: case Qt.Key_Backtab:
          root.move(-1); break
        case Qt.Key_Return: case Qt.Key_Enter: case Qt.Key_Space:
          root.activate(); break
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

      // section 1: wifi toggle, one full-width bar.
      // Title left, status right, connection name underneath (when connected).
      Box {
        id: toggleBox
        zid: 0
        width: parent.width
        tone: root.wifiView.tone
        implicitHeight: info.implicitHeight + root.tilePad * 2
        onClicked: root.toggleRadio()

        Column {
          id: info
          x: root.tilePad
          y: root.tilePad
          width: parent.width - root.tilePad * 2
          spacing: root.lineGap

          Item {
            width: parent.width
            height: Math.max(titleT.implicitHeight, statusT.implicitHeight)

            Text {
              id: titleT
              text: "Wifi"
              color: toggleBox.fg
              opacity: 0.7
              Behavior on color { Fade {} }
              font { family: Theme.font; pointSize: root.headPt; bold: true; capitalization: Font.AllUppercase }
            }
            Text {
              id: statusT
              anchors.right: parent.right
              text: root.wifiView.text
              color: toggleBox.fg
              Behavior on color { Fade {} }
              font { family: Theme.font; pointSize: root.textPt; bold: true }
            }
          }
          Text {
            visible: root.conn !== "" && !root.radioOff
            width: parent.width
            text: root.conn
            elide: Text.ElideRight
            color: toggleBox.fg
            Behavior on color { Fade {} }
            font { family: Theme.font; pointSize: root.textPt; bold: true }
          }
        }
      }

      // section 2: networks / saved connections / password prompt
      Column {
        width: parent.width
        spacing: root.headGap

        Item {
          width: parent.width
          height: sec2Head.implicitHeight

          Head { id: sec2Head; text: root.sec2Title }
          Head {
            visible: root.scanning && root.view === "networks"
            anchors.right: parent.right
            text: "Scanning..."
            color: root.dim2
          }
        }

        ListView {
          id: list
          visible: root.view !== "password" && root.rows.length > 0
          width: parent.width
          height: root.listH
          model: root.rows
          spacing: root.rowGap
          clip: true
          boundsBehavior: Flickable.StopAtBounds
          interactive: contentHeight > height
          // Follow keyboard focus. Setting currentIndex makes the view scroll
          // by itself to keep that row visible. -1 = "none" while focus is
          // in another zone.
          currentIndex: root.zone === 1 ? root.pos : -1

          delegate: ListRow {
            required property var modelData
            required property int index
            width: list.width
            zid: 1
            slot: index
            tone: modelData.active ? "ok" : "normal"
            icon: modelData.active ? root.iconActive
              : (modelData.kind === "saved" || modelData.saved) ? root.iconSaved
              : root.iconNet
            name: modelData.name
            lockIcon: modelData.kind === "net"
              ? (modelData.security !== "" ? root.iconLock : root.iconOpen)
              : ""
            sigIcon: modelData.kind === "net"
              ? root.iconSignal[Math.min(4, Math.ceil(modelData.signal / 25))]
              : ""
            onClicked: root.activateRow(index)
          }
        }

        Text {
          visible: root.view !== "password" && root.rows.length === 0
          text: root.emptyText
          color: root.dim2
          font { family: Theme.font; pointSize: root.textPt; bold: true }
        }

        // password prompt: replaces the list while view === "password"
        Column {
          visible: root.view === "password"
          width: parent.width
          spacing: root.rowGap

          Rectangle {
            width: parent.width
            height: root.btnH
            color: root.tones.normal.bg
            border { width: root.bw; color: root.tones.normal.hi }

            TextInput {
              id: pwInput
              anchors { left: parent.left; right: parent.right; verticalCenter: parent.verticalCenter; leftMargin: root.rowInset; rightMargin: root.rowInset }
              echoMode: TextInput.Password
              color: root.tones.normal.hi
              font { family: Theme.font; pointSize: root.textPt; bold: true }
              Keys.onReturnPressed: root.submitPassword()
              Keys.onEnterPressed: root.submitPassword()
              Keys.onEscapePressed: root.back()
            }
            Text {
              anchors.fill: pwInput
              visible: pwInput.text === ""
              text: "Password for " + root.pendingSsid
              elide: Text.ElideRight
              color: root.tones.normal.fg
              font: pwInput.font
            }
          }
          Text {
            text: "ENTER  connect      ESC  cancel"
            color: root.dim2
            font { family: Theme.font; pointSize: root.textPt - 1; bold: true }
          }
        }
      }

      // section 3: actions, one full-width button each
      Column {
        width: parent.width
        spacing: root.rowGap

        Repeater {
          model: root.actions

          Box {
            required property var modelData
            required property int index
            zid: 2
            slot: index
            width: parent.width
            label: modelData.label
            onClicked: root.runAction(index)
          }
        }
      }

      // status line: "Connecting...", errors, a revealed password.
      // Wraps, so long nmcli messages stay readable.
      Rectangle {
        visible: root.status !== ""
        width: parent.width
        height: statusText.implicitHeight + root.tileInset * 2
        gradient: Gradient {
          GradientStop { position: 0.0; color: root.tones[root.statusTone].top }
          GradientStop { position: 1.0; color: root.tones[root.statusTone].bg }
        }

        Text {
          id: statusText
          x: root.tileInset
          y: root.tileInset
          width: parent.width - root.tileInset * 2
          text: root.status
          wrapMode: Text.Wrap
          color: root.tones[root.statusTone].fg
          font { family: Theme.font; pointSize: root.textPt; bold: true }
        }
      }
    }
  }

  OpenFx { id: openFx; target: panel; name: "wifimenu"; origin: Item.TopRight }
}
