import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Bluetooth
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

  readonly property color bgMain: Theme.panelBg
  readonly property color edge: Theme.panelEdge
  readonly property color dim: Theme.textDim
  readonly property color dim2: Theme.textDim2

  readonly property var tones: ({
    normal: { top: Theme.btnTop,  bg: Theme.btnBg,  fg: Theme.btnFg,  hi: Theme.btnHi },
    ok:     { top: Theme.okTop,   bg: Theme.okBg,   fg: Theme.okFg,   hi: Theme.okHi },
    warn:   { top: Theme.warnTop, bg: Theme.warnBg, fg: Theme.warnFg, hi: Theme.warnHi },
    bad:    { top: Theme.badTop,  bg: Theme.badBg,  fg: Theme.badFg,  hi: Theme.badHi }
  })

  // ICONS: everything comes from here. Keys of iconByType are BlueZ icon names.
  readonly property string iconDefault: "\udb80\udcaf"
  readonly property string iconConnected: "\udb80\udcb1"
  readonly property string iconPaired: "\udb80\udcc0"
  readonly property string iconTrusted: "\udb81\udc98"
  readonly property var iconByType: ({
    "audio-headset": "\udb80\udece", "audio-headphones": "\udb80\udecb", "audio-card": "\udb81\udcc3",
    "audio-speakers": "\udb81\udcc3", "input-keyboard": "\udb80\udf0c", "input-mouse": "\udb80\udf7d",
    "input-gaming": "\udb80\udeb4", "input-tablet": "\udb81\udcf6", "phone": "\udb80\udff2",
    "computer": "\udb81\udfc0", "camera-photo": "\udb80\udd00", "printer": "\udb81\udc2a"
  })

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
  readonly property int tilePad: 16
  readonly property int tileInset: 10
  readonly property int rowInset: 12
  readonly property int rowGap: 8
  readonly property int lineGap: 2
  readonly property int iconW: 22
  readonly property int maxRows: 6
  readonly property int bw: 2
  readonly property int panelBw: 3

  // type
  readonly property int textPt: 11
  readonly property int headPt: 11
  readonly property int iconPt: 12

  // motion
  readonly property int animMs: 120
  readonly property int pressMs: 70

  // behavior
  readonly property int closeGuardMs: 300
  readonly property int primeMs: 100         // FOCUS FIX: how long the Exclusive prime lasts
  readonly property int scanMs: 30000        // auto-stop scanning (saves battery)
  readonly property int opTimeoutMs: 30000   // give up on a pair/connect
  readonly property bool closeOnConnect: true
  readonly property var managerCmd: ["blueman-manager"]  // or ["kitty", "-e", "bluetuith"]
  readonly property var controlCmd: ["qs", "ipc", "call", "controlcenter", "toggle"]
  readonly property var macLike: /^([0-9a-f]{2}[-:]){5}[0-9a-f]{2}$/i

  // state
  property string view: "devices"   // "devices" | "paired"
  property string status: ""
  property string statusTone: "normal"
  property double closedAt: 0
  property var watch: null           // device with a pair/connect in flight
  property string watchOp: ""        // "pair" | "connect"
  property bool sawConnecting: false
  property string forgetAddr: ""     // armed by the first F press
  property string focusAddr: ""

  property int zone: 1               // 0 toggle, 1 list, 2 actions
  property int pos: 0

  readonly property var adapter: Bluetooth.defaultAdapter
  readonly property bool hasAdapter: adapter !== null
  readonly property bool powered: adapter?.enabled ?? false
  readonly property bool scanning: adapter?.discovering ?? false
  readonly property bool discoverable: adapter?.discoverable ?? false
  readonly property var devs: adapter ? adapter.devices.values : []
  readonly property var connected: devs.filter(d => d.connected)
  readonly property bool busy: devs.some(d => d.pairing
    || d.state === BluetoothDeviceState.Connecting
    || d.state === BluetoothDeviceState.Disconnecting)

  readonly property var btView: {
    if (!hasAdapter) return { tone: "bad", text: "Unavailable" }
    if (!powered) return { tone: "normal", text: "Off" }
    if (busy) return { tone: "warn", text: "Working..." }
    return connected.length > 0
      ? { tone: "ok", text: "Connected" }
      : { tone: "warn", text: "Disconnected" }
  }

  // unnamed devices (name == MAC) are noise, hide them. Connected first, then paired, then A-Z.
  readonly property var rows: {
    if (!powered) return []
    return devs
      .filter(d => d.name && !macLike.test(d.name) && (view !== "paired" || d.paired))
      .sort((a, b) => (b.connected - a.connected) || (b.paired - a.paired)
        || a.name.localeCompare(b.name))
  }
  readonly property int listH: {
    const n = Math.min(rows.length, maxRows)
    return n > 0 ? n * btnH + (n - 1) * rowGap : 0
  }
  readonly property string sec2Title: view === "paired" ? "Paired devices" : "Devices"
  readonly property string emptyText: !hasAdapter ? "No bluetooth adapter"
    : !powered ? "Bluetooth is off"
    : view === "paired" ? "No paired devices"
    : scanning ? "Searching..." : "No devices found"

  readonly property var actions: [
    { key: "manager", label: "LAUNCH BLUETOOTH MANAGER" },
    { key: "scan",    label: scanning ? "STOP SCANNING" : "SCAN FOR DEVICES" },
    { key: "visible", label: discoverable ? "HIDE THIS COMPUTER" : "MAKE THIS COMPUTER VISIBLE" },
    { key: "paired",  label: view === "paired" ? "SHOW ALL DEVICES" : "SHOW PAIRED DEVICES" }
  ]

  function iconFor(d: var): string { return iconByType[d.icon] ?? iconDefault }
  function batText(d: var): string {
    return d.batteryAvailable ? Math.round(d.battery * 100) + "%" : ""
  }
  function setStatus(tone: string, text: string): void { statusTone = tone; status = text }

  function run(cmd: var): void { Quickshell.execDetached(cmd); open = false }
  function backToControl(): void {
    Quickshell.execDetached(controlCmd)
    open = false
  }

  // scanning
  function startScan(): void {
    if (!powered) return
    adapter.discovering = true
    scanTimer.restart()
  }
  function stopScan(): void {
    if (adapter) adapter.discovering = false
    scanTimer.stop()
  }
  function toggleScan(): void { scanning ? stopScan() : startScan() }

  // focus
  function setFocus(z: int, p: int): void {
    zone = z; pos = p
    focusAddr = z === 1 ? (rows[p]?.address ?? "") : ""
    forgetAddr = ""
  }
  function toLin(): int {
    return zone === 0 ? 0 : zone === 1 ? 1 + pos : 1 + rows.length + pos
  }
  function move(d: int): void {
    const total = 1 + rows.length + actions.length
    const i = Math.max(0, Math.min(total - 1, toLin() + d))
    if (i === 0) setFocus(0, 0)
    else if (i <= rows.length) setFocus(1, i - 1)
    else setFocus(2, i - 1 - rows.length)
  }
  function focusedDev(): var { return zone === 1 ? rows[pos] : undefined }

  function activate(): void {
    if (zone === 0) toggleRadio()
    else if (zone === 1) activateRow(pos)
    else runAction(pos)
  }

  function toggleRadio(): void {
    if (!adapter) return
    adapter.enabled = !adapter.enabled
    setStatus("normal", "")
  }

  // Enter on a row: connected -> disconnect, paired -> connect, new -> pair
  function activateRow(i: int): void {
    const d = rows[i]
    if (!d || d.pairing || d.state === BluetoothDeviceState.Connecting) return
    if (d.connected) { disconnectDev(d); return }
    if (d.paired) { beginConnect(d); return }
    beginPair(d)
  }

  function beginConnect(d: var): void {
    watch = d; watchOp = "connect"; sawConnecting = false
    stopScan()   // BlueZ connects faster and more reliably with discovery off
    d.connect()
    setStatus("normal", "Connecting to " + d.name + "...")
    opTimer.restart()
  }
  function beginPair(d: var): void {
    watch = d; watchOp = "pair"
    stopScan()
    d.pair()
    setStatus("normal", "Pairing with " + d.name + "...")
    opTimer.restart()
  }
  function disconnectDev(d: var): void {
    if (!d || !d.connected) return
    d.disconnect()
    setStatus("normal", "Disconnecting " + d.name + "...")
  }
  function toggleTrust(d: var): void {
    if (!d || !d.paired) { setStatus("warn", "Pair the device first"); return }
    const t = !d.trusted
    d.trusted = t
    setStatus("ok", d.name + (t ? " is trusted" : " is no longer trusted"))
  }
  // two presses on the same device, so one stray key can't delete a pairing
  function forgetDev(d: var): void {
    if (!d || !d.paired) { setStatus("warn", "Not paired"); return }
    if (forgetAddr !== d.address) {
      forgetAddr = d.address
      setStatus("warn", "Press F again to forget " + d.name)
      return
    }
    forgetAddr = ""
    d.forget()
    setStatus("ok", "Forgot " + d.name)
  }

  function runAction(i: int): void {
    switch (actions[i].key) {
    case "manager": run(managerCmd); break
    case "scan": toggleScan(); break
    case "visible": if (adapter) adapter.discoverable = !adapter.discoverable; break
    case "paired":
      view = view === "paired" ? "devices" : "paired"
      setStatus("normal", "")
      break
    }
  }

  // BlueZ gives no error text, so success and failure are read from device state
  function handlePair(): void {
    const d = watch
    if (!d || watchOp !== "pair" || d.pairing) return
    if (d.paired) {
      d.trusted = true   // so it reconnects on its own next time
      watchOp = "connect"; sawConnecting = false
      d.connect()
      setStatus("normal", "Paired. Connecting to " + d.name + "...")
    } else {
      watch = null
      setStatus("bad", "Pairing failed. Devices that ask for a PIN need a BlueZ agent")
    }
  }
  function handleState(): void {
    const d = watch
    if (!d || watchOp !== "connect") return
    if (d.state === BluetoothDeviceState.Connecting) sawConnecting = true
    else if (d.state === BluetoothDeviceState.Connected) {
      watch = null
      setStatus("ok", "Connected to " + d.name)
      if (closeOnConnect) open = false
    } else if (d.state === BluetoothDeviceState.Disconnected && sawConnecting) {
      watch = null
      setStatus("bad", "Could not connect to " + d.name)
    }
  }

  onRowsChanged: {
    if (zone !== 1 || rows.length === 0) return
    const i = rows.findIndex(d => d.address === focusAddr)
    if (i >= 0) pos = i
    else if (pos >= rows.length) pos = rows.length - 1
  }
  onPoweredChanged: if (open) { if (powered) startScan(); else watch = null }

  onOpenChanged: {
    if (!open) {
      closedAt = Date.now()
      stopScan()
      if (watch && watchOp === "pair") watch.cancelPair()
      watch = null
      return
    }
    view = "devices"
    status = ""
    setFocus(1, 0)
    startScan()
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

  component Fade: ColorAnimation {
    duration: root.animMs
    easing.type: Easing.OutCubic
  }

  Connections {
    target: root.watch
    ignoreUnknownSignals: true
    function onPairingChanged(): void { root.handlePair() }
    function onStateChanged(): void { root.handleState() }
  }

  Timer {
    id: scanTimer
    interval: root.scanMs
    onTriggered: root.stopScan()
  }
  Timer {
    id: opTimer
    interval: root.opTimeoutMs
    onTriggered: if (root.watch) {
      if (root.watchOp === "pair") root.watch.cancelPair()
      root.setStatus("bad", "Timed out")
      root.watch = null
    }
  }

  IpcHandler {
    target: "btmenu"
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
      onContainsMouseChanged: if (containsMouse && box.zid >= 0) root.setFocus(box.zid, box.slot)
    }
  }

  // [icon] name ........ [battery] [trusted] [paired/connected]
  component ListRow: Box {
    id: lr
    property string icon: ""
    property string name: ""
    property string extra: ""
    property string trustIcon: ""
    property string stateIcon: ""

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
      visible: lr.extra !== "" || lr.trustIcon !== "" || lr.stateIcon !== ""
      anchors { right: parent.right; rightMargin: root.rowInset; verticalCenter: parent.verticalCenter }
      spacing: 8
      Text {
        visible: lr.extra !== ""
        text: lr.extra
        color: lr.fg
        Behavior on color { Fade {} }
        font { family: Theme.font; pointSize: root.textPt; bold: true }
      }
      Text {
        width: root.iconW
        horizontalAlignment: Text.AlignHCenter
        text: lr.trustIcon
        color: lr.fg
        Behavior on color { Fade {} }
        font { family: Theme.font; pointSize: root.iconPt }
      }
      Text {
        width: root.iconW
        horizontalAlignment: Text.AlignHCenter
        text: lr.stateIcon
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
        //   if (root.view !== "devices") { root.view = "devices"; root.setFocus(1, 0) }
        //   else root.open = false
        //   break
        case Qt.Key_Escape:
          if (root.view !== "devices") { root.view = "devices"; root.setFocus(1, 0) }
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
        case Qt.Key_D: root.disconnectDev(root.focusedDev()); break
        case Qt.Key_T: root.toggleTrust(root.focusedDev()); break
        case Qt.Key_F: root.forgetDev(root.focusedDev()); break
        case Qt.Key_S: case Qt.Key_R: root.toggleScan(); break
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

      // section 1: power toggle
      Box {
        id: toggleBox
        zid: 0
        width: parent.width
        tone: root.btView.tone
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
              text: "Bluetooth"
              color: toggleBox.fg
              opacity: 0.7
              Behavior on color { Fade {} }
              font { family: Theme.font; pointSize: root.headPt; bold: true; capitalization: Font.AllUppercase }
            }
            Text {
              id: statusT
              anchors.right: parent.right
              text: root.btView.text
              color: toggleBox.fg
              Behavior on color { Fade {} }
              font { family: Theme.font; pointSize: root.textPt; bold: true }
            }
          }
          Text {
            visible: root.connected.length > 0 && root.powered
            width: parent.width
            text: {
              const d = root.connected[0]
              if (!d) return ""
              const b = root.batText(d)
              const more = root.connected.length > 1 ? "  +" + (root.connected.length - 1) : ""
              return d.name + (b !== "" ? "  " + b : "") + more
            }
            elide: Text.ElideRight
            color: toggleBox.fg
            Behavior on color { Fade {} }
            font { family: Theme.font; pointSize: root.textPt; bold: true }
          }
        }
      }

      // section 2: devices
      Column {
        width: parent.width
        spacing: root.headGap

        Item {
          width: parent.width
          height: sec2Head.implicitHeight

          Head { id: sec2Head; text: root.sec2Title }
          Head {
            visible: root.scanning
            anchors.right: parent.right
            text: "Scanning..."
            color: root.dim2
          }
        }

        ListView {
          id: list
          visible: root.rows.length > 0
          width: parent.width
          height: root.listH
          model: root.rows
          spacing: root.rowGap
          clip: true
          boundsBehavior: Flickable.StopAtBounds
          interactive: contentHeight > height
          currentIndex: root.zone === 1 ? root.pos : -1

          delegate: ListRow {
            required property var modelData
            required property int index
            readonly property bool working: modelData.pairing
              || modelData.state === BluetoothDeviceState.Connecting
              || modelData.state === BluetoothDeviceState.Disconnecting
            width: list.width
            zid: 1
            slot: index
            tone: modelData.connected ? "ok" : working ? "warn" : "normal"
            icon: root.iconFor(modelData)
            name: modelData.name
            extra: working ? "..." : root.batText(modelData)
            trustIcon: modelData.trusted ? root.iconTrusted : ""
            stateIcon: modelData.connected ? root.iconConnected
              : modelData.paired ? root.iconPaired : ""
            onClicked: root.activateRow(index)
          }
        }

        Text {
          visible: root.rows.length === 0
          text: root.emptyText
          color: root.dim2
          font { family: Theme.font; pointSize: root.textPt; bold: true }
        }
        Text {
          visible: root.rows.length > 0
          text: "ENTER connect   D disconnect   T trust   F forget"
          color: root.dim2
          font { family: Theme.font; pointSize: root.textPt - 1; bold: true }
        }
      }

      // section 3: actions
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

      // status line
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

  OpenFx { id: openFx; target: panel; name: "btmenu" }
}
