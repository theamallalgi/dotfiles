import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import ".."

PanelWindow {
  id: root
  visible: false
  anchors { top: true }
  margins { top: 300 }
  implicitWidth: 400
  implicitHeight: inputBox.height + 5 + maxLines * rowH + 6
  mask: Region { item: col }
  color: "transparent"
  exclusionMode: ExclusionMode.Ignore
  WlrLayershell.layer: WlrLayer.Overlay
  WlrLayershell.keyboardFocus: visible ? WlrKeyboardFocus.Exclusive : WlrKeyboardFocus.None

  readonly property color bgMain: "#02133b"
  readonly property color bgAlt: "#021542"
  readonly property color edge: "#273d70"
  readonly property color dim: "#828997"
  readonly property color sel: "#afbfbf"
  readonly property int rowH: 36
  readonly property int maxLines: 10
  readonly property string fontFamily: "KodeMono Nerd Font"
  readonly property int fontSize: 13

  property string query: ""
  readonly property var results: [...DesktopEntries.applications.values]
    .filter(a => !a.noDisplay && a.name.toLowerCase().includes(query.toLowerCase()))
    .sort((a, b) => a.name.localeCompare(b.name))

  function launch(i: int): void {
    if (i < 0 || i >= results.length) return
    results[i].execute()
    visible = false
  }

  IpcHandler {
    target: "launcher"
    function toggle(): void { root.visible = !root.visible }
  }

  onVisibleChanged: {
    if (!visible) return
    input.text = ""
    list.currentIndex = 0
    // input.forceActiveFocus()
    Qt.callLater(() => input.forceActiveFocus())
  }

  Rectangle {
    width: parent.width
    height: col.implicitHeight
    color: root.bgMain
  }

  Column {
    id: col
    width: parent.width
    spacing: 5

    // inputbar
    Rectangle {
      id: inputBox
      width: parent.width
      implicitHeight: input.implicitHeight + 26
      color: root.bgAlt
      border { width: 3; color: root.edge }

      TextInput {
        id: input
        anchors { left: parent.left; right: parent.right; verticalCenter: parent.verticalCenter; leftMargin: 15; rightMargin: 15 }
        color: "#abb2bf"
        font { family: root.fontFamily; pointSize: root.fontSize; bold: true }
        onTextChanged: { root.query = text; list.currentIndex = 0 }
        Keys.onEscapePressed: root.visible = false
        Keys.onReturnPressed: root.launch(list.currentIndex)
        Keys.onDownPressed: list.incrementCurrentIndex()
        Keys.onUpPressed: list.decrementCurrentIndex()
        Keys.onPressed: e => {
          if (e.modifiers & Qt.ControlModifier) {
            if (e.key === Qt.Key_J) { list.incrementCurrentIndex(); e.accepted = true }
            if (e.key === Qt.Key_K) { list.decrementCurrentIndex(); e.accepted = true }
          }
        }
      }

      Text {
        anchors.fill: input
        visible: input.text === ""
        text: "..."
        color: root.edge
        font: input.font
      }
    }

    // listview
    Rectangle {
      width: parent.width
      visible: height > 1
      height: root.results.length > 0 ? Math.min(root.results.length, root.maxLines) * root.rowH + 6 : 0
      color: root.bgMain
      border { width: 3; color: root.edge }

      Behavior on height {
        NumberAnimation { duration: 90; easing.type: Easing.OutCubic }
      }

      ListView {
        id: list
        anchors { fill: parent; margins: 3 }
        model: root.results
        clip: true
        interactive: false
        highlightMoveDuration: 0

        delegate: Rectangle {
          id: row
          required property var modelData
          required property int index
          readonly property bool current: ListView.isCurrentItem

          width: list.width
          height: root.rowH
          color: current ? "transparent" : (index % 2 === 1 ? root.bgAlt : root.bgMain)

          // selected border: 16px left, 3px top and bottom
          Rectangle { visible: row.current; width: 16; height: parent.height; color: root.edge }
          Rectangle { visible: row.current; width: parent.width; height: 3; color: root.edge }
          Rectangle { visible: row.current; width: parent.width; height: 3; y: parent.height - 3; color: root.edge }

          Text {
            anchors { left: parent.left; leftMargin: 28; right: parent.right; rightMargin: 12; verticalCenter: parent.verticalCenter }
            text: row.modelData.name
            elide: Text.ElideRight
            color: row.current ? root.sel : root.dim
            font { family: root.fontFamily; pointSize: root.fontSize; bold: true }
          }

          MouseArea {
            anchors.fill: parent
            onClicked: root.launch(row.index)
          }
        }
      }
    }
  }
}
