import QtQuick
import Quickshell
import ".."

PopupWindow {
  id: root

  // inputs, driven by bar.qml
  property Item clockWindow
  property bool clockHovered: false
  property bool calendarHovered: false

  // state
  property date currentDate: new Date()
  property date todayDate: new Date()
  property bool open: false

  // colors: all from Theme
  readonly property color bgMain: Theme.panelBg
  readonly property color edge: Theme.panelEdge
  readonly property color txt: Theme.textMain
  readonly property color dim: Theme.textDim
  readonly property color dim2: Theme.textDim2
  readonly property color accent: Theme.red

  // layout
  readonly property int pad: 14
  readonly property int gap: 10
  readonly property int cellW: 30
  readonly property int cellH: 28
  readonly property int btnSize: 26
  readonly property int panelBw: 3
  readonly property int bw: 2
  readonly property int offsetY: 10       // px between clock and popup

  // type
  readonly property int textPt: 10
  readonly property int smallPt: 9

  // motion
  readonly property int openDelayMs: 350  // hover time before opening
  readonly property int closeDelayMs: 220 // grace time before closing
  readonly property int openMs: 220
  readonly property int closeMs: 140
  readonly property int fadeMs: 120
  readonly property int slidePx: 8
  readonly property real startScale: 0.96

  // the 42 days shown, starting on the Sunday of the first week
  readonly property var days: {
    const y = currentDate.getFullYear()
    const m = currentDate.getMonth()
    const first = new Date(y, m, 1)
    const start = 1 - first.getDay()

    return Array.from({ length: 42 }, (_, i) => new Date(y, m, start + i))
  }

  readonly property string todayKey: todayDate.toDateString()

  visible: open || panel.opacity > 0

  implicitWidth: cellW * 7 + (pad + panelBw) * 2
  implicitHeight: col.implicitHeight + (pad + panelBw) * 2

  color: "transparent"

  anchor {
    item: root.clockWindow

    rect.x: root.clockWindow
      ? (root.clockWindow.width - root.width) / 2
      : 0
    rect.y: root.clockWindow
      ? root.clockWindow.height + root.offsetY
      : 0

    edges: Edges.Top | Edges.Left
    gravity: Edges.Bottom | Edges.Right

    adjustment: PopupAdjustment.Slide
  }

  // API used by bar.qml
  function show(): void {
    closeTimer.stop()

    if (!open)
      openTimer.restart()
  }

  function hideLater(): void {
    openTimer.stop()
    closeTimer.restart()
  }

  function shiftMonth(delta: int): void {
    currentDate = new Date(
      currentDate.getFullYear(),
      currentDate.getMonth() + delta,
      1
    )
  }

  function reset(): void {
    todayDate = new Date()
    currentDate = new Date()
  }

  onCurrentDateChanged: gridFade.restart()

  Timer {
    id: openTimer

    interval: root.openDelayMs

    onTriggered: {
      if (root.clockHovered || root.calendarHovered) {
        root.reset()
        root.open = true
      }
    }
  }

  Timer {
    id: closeTimer

    interval: root.closeDelayMs

    onTriggered: {
      if (!root.clockHovered && !root.calendarHovered)
        root.open = false
    }
  }

  // Fade: color animation with our timing baked in
  component Fade: ColorAnimation {
    duration: root.fadeMs
    easing.type: Easing.OutCubic
  }

  // Btn: square button in the same style as the control center boxes
  component Btn: Rectangle {
    id: btn

    property string label: ""
    property int pt: root.textPt
    signal clicked

    readonly property bool hot: area.containsMouse

    color: Theme.btnBg

    border {
      width: root.bw
      color: btn.hot ? Theme.btnHi : Theme.btnBg
    }

    scale: area.pressed ? 0.94 : 1

    Behavior on border.color { Fade {} }
    Behavior on scale {
      NumberAnimation {
        duration: 70
        easing.type: Easing.OutCubic
      }
    }

    Text {
      anchors.centerIn: parent

      text: btn.label

      color: btn.hot ? Theme.btnHi : Theme.btnFg

      Behavior on color { Fade {} }

      font {
        family: Theme.font
        pointSize: btn.pt
        bold: true
      }
    }

    MouseArea {
      id: area

      anchors.fill: parent

      hoverEnabled: true
      cursorShape: Qt.PointingHandCursor

      onClicked: btn.clicked()
    }
  }

  Rectangle {
    id: panel

    width: parent.width
    height: parent.height

    color: root.bgMain

    border {
      width: root.panelBw
      color: root.edge
    }

    // open / close motion: fade, rise and a slight scale from the top
    opacity: root.open ? 1 : 0
    scale: root.open ? 1 : root.startScale
    transformOrigin: Item.Top

    transform: Translate {
      y: root.open ? 0 : -root.slidePx

      Behavior on y {
        NumberAnimation {
          duration: root.open ? root.openMs : root.closeMs
          easing.type: root.open ? Easing.OutQuint : Easing.OutCubic
        }
      }
    }

    Behavior on opacity {
      NumberAnimation {
        duration: root.open ? root.openMs : root.closeMs
        easing.type: Easing.OutCubic
      }
    }

    Behavior on scale {
      NumberAnimation {
        duration: root.open ? root.openMs : root.closeMs
        easing.type: root.open ? Easing.OutQuint : Easing.OutCubic
      }
    }

    // keeps the popup open while the mouse is over it
    HoverHandler {
      onHoveredChanged: {
        root.calendarHovered = hovered

        if (hovered) {
          closeTimer.stop()
          root.open = true
        } else {
          root.hideLater()
        }
      }
    }

    Column {
      id: col

      x: root.pad + root.panelBw
      y: root.pad + root.panelBw
      width: root.cellW * 7

      spacing: root.gap

      // header: month, year and navigation
      Item {
        width: parent.width
        height: root.btnSize

        Row {
          anchors.verticalCenter: parent.verticalCenter

          spacing: 6

          Text {
            text: Qt.formatDate(root.currentDate, "MMMM")

            color: root.txt

            font {
              family: Theme.font
              pointSize: root.textPt
              bold: true
              capitalization: Font.AllUppercase
            }
          }

          Text {
            text: Qt.formatDate(root.currentDate, "yyyy")

            color: root.dim

            font {
              family: Theme.font
              pointSize: root.textPt
              bold: true
            }
          }
        }

        Row {
          anchors {
            right: parent.right
            verticalCenter: parent.verticalCenter
          }

          spacing: 4

          Btn {
            width: root.btnSize
            height: root.btnSize

            label: "‹"
            pt: root.textPt + 2

            onClicked: root.shiftMonth(-1)
          }

          Btn {
            width: root.btnSize
            height: root.btnSize

            label: "›"
            pt: root.textPt + 2

            onClicked: root.shiftMonth(1)
          }
        }
      }

      // weekday labels
      Row {
        Repeater {
          model: ["S", "M", "T", "W", "T", "F", "S"]

          Text {
            required property string modelData

            width: root.cellW

            horizontalAlignment: Text.AlignHCenter

            text: modelData

            color: root.dim

            font {
              family: Theme.font
              pointSize: root.smallPt
              bold: true
            }
          }
        }
      }

      // days
      Grid {
        id: daysGrid

        columns: 7

        NumberAnimation {
          id: gridFade

          target: daysGrid
          property: "opacity"

          from: 0.3
          to: 1

          duration: 160
          easing.type: Easing.OutCubic
        }

        Repeater {
          model: root.days

          Item {
            id: cell

            required property date modelData

            readonly property bool inMonth:
              modelData.getMonth() === root.currentDate.getMonth()

            readonly property bool isToday:
              modelData.toDateString() === root.todayKey

            width: root.cellW
            height: root.cellH

            Rectangle {
              anchors.centerIn: parent

              width: root.cellH - 2
              height: width

              color: cell.isToday ? root.accent : "transparent"
            }

            Text {
              anchors.centerIn: parent

              text: cell.modelData.getDate()

              color: cell.isToday
                ? root.bgMain
                : cell.inMonth
                  ? root.txt
                  : root.dim2

              font {
                family: Theme.font
                pointSize: root.textPt
                bold: cell.isToday
              }
            }
          }
        }
      }

      // jump back to the current month
      Btn {
        anchors.horizontalCenter: parent.horizontalCenter

        width: 80
        height: root.btnSize

        label: "TODAY"
        pt: root.smallPt

        onClicked: root.reset()
      }
    }
  }
}
