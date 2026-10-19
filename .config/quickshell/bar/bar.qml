import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Hyprland
import Quickshell.Bluetooth
import Quickshell.Widgets
import Quickshell.Services.Pipewire
import Quickshell.Services.SystemTray
import Quickshell.Services.UPower
import ".."

Scope {
  id: root

  property bool drawerOpen: false
  property bool altClock: false
  property string conn: ""
  property int brightness: 0

  readonly property var sink: Pipewire.defaultAudioSink
  readonly property real volume: sink?.audio?.volume ?? 0
  readonly property bool muted: sink?.audio?.muted ?? false
  readonly property var bat: UPower.displayDevice
  readonly property int batPct: Math.round(bat.percentage * 100)
  readonly property bool charging: bat.state === UPowerDeviceState.Charging
    || bat.state === UPowerDeviceState.FullyCharged

  readonly property string btStatus: {
    const a = Bluetooth.defaultAdapter
    if (!a || !a.enabled) return "off"
    const d = a.devices.values.find(x => x.connected)
    return d ? d.name : "on"
  }

  function grey(s: string): string {
    return `<font color='${Theme.grey1}'>${s}</font>`
  }

  readonly property var wsList: {
    const ids = new Set([1, 2, 3, 4, 5])
    for (const w of Hyprland.workspaces.values)
    if (w.id > 0) ids.add(w.id)
    return [...ids].sort((a, b) => a - b)
  }

  component Mod: Text {
    color: Theme.fg
    textFormat: Text.StyledText
    font {
      family: Theme.font
      pixelSize: Theme.fontSize + 1
      bold: true
      capitalization: Font.AllUppercase
    }
  }

  PwObjectTracker {
    objects: [root.sink]
  }

  Process {
    id: bright
    command: ["brightnessctl", "-m"]
    running: true

    stdout: StdioCollector {
      onStreamFinished: root.brightness = parseInt(text.split(",")[3])
    }
  }

  // Process {
  //   id: nmQuery
  //   command: ["nmcli", "-g", "GENERAL.CONNECTION", "dev", "show", "wlan0"]
  //   running: true
  //
  //   stdout: StdioCollector {
  //     onStreamFinished: root.conn = text.trim() === "--" ? "" : text.trim()
  //   }
  // }

  property bool connReady: false

  Process {
    id: nmQuery
    command: ["nmcli", "-g", "GENERAL.CONNECTION", "dev", "show", "wlan0"]
    running: true

    stdout: StdioCollector {
      onStreamFinished: {
        const next = text.trim() === "--" ? "" : text.trim()

        if (root.connReady && next !== root.conn) {
          Quickshell.execDetached([
            "notify-send", "-a", "Network",
            "-u", next ? "normal" : "critical",
            next ? "Network Connected" : "Network Disconnected",
            next ? next : root.conn
          ])
        }

        root.conn = next
        root.connReady = true
      }
    }
  }

  Process {
    running: true
    command: ["nmcli", "monitor"]

    stdout: SplitParser {
      onRead: nmQuery.running = true
    }
  }

  Variants {
    model: Quickshell.screens

    PanelWindow {
      required property var modelData

      screen: modelData

      anchors {
        top: true
        left: true
        right: true
      }

      implicitHeight: 30
      color: "#000024"

      SystemClock {
        id: clock

        precision: root.altClock
          ? SystemClock.Seconds
          : SystemClock.Minutes
      }

      // left: workspaces
      Row {
        anchors {
          left: parent.left
          leftMargin: 10
          top: parent.top
          topMargin: 8
        }

        spacing: 6

        Repeater {
          // model: 5
          model: root.wsList

          Mod {
            required property int modelData
            readonly property int num: modelData
            // required property int index
            // readonly property int num: index + 1
            readonly property var ws:
              Hyprland.workspaces.values.find(
                w => w.num === num || w.id === num
              )

            text: num

            font.pixelSize: 15

            color: Hyprland.focusedWorkspace?.id === num
              ? Theme.fg
              : ws
                ? Theme.grey0
                : Theme.bg3

            MouseArea {
              anchors.fill: parent

              onClicked:
                Hyprland.dispatch(
                  "hl.dsp.focus({ workspace = " +
                  parent.num +
                  " })"
                )

              cursorShape: Qt.PointingHandCursor
            }
          }
        }
      }

      // center: clock
      Mod {
        id: clockModule

        anchors {
          horizontalCenter: parent.horizontalCenter
          top: parent.top
          topMargin: 8
        }

        text: Qt.formatDateTime(
          clock.date,
          root.altClock
            ? "ddd MMM dd HH:mm:ss"
            : "ddd MMM dd hh:mm AP"
        )

        MouseArea {
          id: clockArea

          anchors.fill: parent

          hoverEnabled: true
          cursorShape: Qt.PointingHandCursor

          onEntered: {
            calendar.clockHovered = true
            calendar.show()
          }

          onExited: {
            calendar.clockHovered = false
            calendar.hideLater()
          }

          onClicked:
            root.altClock = !root.altClock
        }
      }

      // calendar popup
      Calendar {
        id: calendar

        clockWindow: clockModule
      }

      // right
      Row {
        anchors {
          right: parent.right
          rightMargin: 10
          top: parent.top
          topMargin: 8
        }

        spacing: 20

        // drawer contents
        Mod {
          visible: root.drawerOpen

          text:
            root.grey("BRT:") +
            " " +
            root.brightness +
            "%"

          MouseArea {
            anchors.fill: parent

            onWheel: w => {
              bright.command = [
                "brightnessctl",
                "-m",
                "set",
                w.angleDelta.y > 0 ? "+1%" : "1%-"
              ]

              bright.running = true
            }
          }
        }

        Mod {
          visible: root.drawerOpen

          text:
            root.grey("BLT:") +
            " " +
            root.btStatus

          MouseArea {
            anchors.fill: parent

            onClicked:
              Quickshell.execDetached([
                "qs",
                "ipc",
                "call",
                "btmenu",
                "toggle"
              ])
          }
        }

        Mod {
          text: "󰁎"

          font.pixelSize: 17
          y: -1

          color:
            toggleArea.containsMouse
              ? Theme.fg
              : Theme.grey0

          MouseArea {
            id: toggleArea

            anchors.fill: parent

            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor

            onClicked: {
              root.drawerOpen = !root.drawerOpen

              if (root.drawerOpen)
                bright.running = true
            }
          }
        }

        // audio
        Mod {
          color: root.muted
            ? Theme.red
            : Theme.fg

          text:
            root.muted
              ? "MUTED"
              : root.grey("V:") +
                " " +
                Math.round(root.volume * 100) +
                "%"

          MouseArea {
            anchors.fill: parent

            onClicked:
              Quickshell.execDetached(["pavucontrol"])

            cursorShape: Qt.PointingHandCursor

            onWheel: w => {
              if (!root.sink)
                return

              const step =
                w.angleDelta.y > 0
                  ? 0.02
                  : -0.02

              root.sink.audio.volume =
                Math.max(
                  0,
                  Math.min(
                    1,
                    root.volume + step
                  )
                )
            }
          }
        }

        // network
        Mod {
          color: root.conn
            ? Theme.fg
            : Theme.red

          text: root.conn
            ? root.grey("N:") +
              " " +
              root.conn
            : "No Connection"

          MouseArea {
            anchors.fill: parent

            onClicked:
              Quickshell.execDetached([
                "qs",
                "ipc",
                "call",
                "wifimenu",
                "toggle"
              ])

            cursorShape: Qt.PointingHandCursor
          }
        }

        // battery
        Mod {
          color:
            root.charging
              ? Theme.green
              : root.batPct <= 15
                ? Theme.red
                : root.batPct <= 30
                  ? Theme.yellow
                  : Theme.fg

          text:
            root.grey("B:") +
            " " +
            root.batPct +
            "%"
        }

        // power
        Mod {
          text: " "

          font.pixelSize: 16
          y: -1

          color:
            powerArea.containsMouse
              ? Theme.purple
              : Theme.fg

          MouseArea {
            id: powerArea

            anchors.fill: parent

            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor

            onClicked:
              Quickshell.execDetached([
                "qs",
                "ipc",
                "call",
                "controlcenter",
                "toggle"
              ])
          }
        }
      }
    }
  }
}
