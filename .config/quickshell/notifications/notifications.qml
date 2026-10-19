import QtQuick
import Quickshell
import Quickshell.Services.Notifications
import ".."

Scope {
  id: root

  // colors: swaync palette, exact values
  readonly property color edge: "#a1a3a8"
  readonly property color bg: "#001851"
  readonly property color text: "#c0c9c3"
  readonly property color critEdge: "#e4384c"
  readonly property color critBg: "#481219"
  readonly property color critText: "#e4384c"
  readonly property color closeIdle: "#828997"
  readonly property color closeHot: "#e4465d"

  // timing (ms), from swaync: timeout 4, timeout-low 2, timeout-critical 6
  readonly property int lowMs: 2000
  readonly property int normalMs: 4000
  readonly property int critMs: 6000

  // motion
  readonly property int slideMs: 200       // swaync transition-time
  readonly property int collapseMs: 160    // neighbours close the gap after the card has left
  readonly property int fadeMs: 120

  // layout, from the swaync css
  readonly property int winW: 400          // notification-window-width
  readonly property int rowMargin: 9       // .notification-row margin
  readonly property int cardW: winW - rowMargin * 2
  readonly property int strip: 12          // border-left
  readonly property int border: 2          // border-top / right / bottom
  readonly property int padLeft: 6 + 10    // .notification padding + .notification-content padding
  readonly property int padRight: 6 + 10
  readonly property int padTop: 2 + 5      // same, vertical
  readonly property int padBottom: 2 + 5
  readonly property int lineGap: 4         // .body margin-top: 0.25rem
  readonly property int closeSize: 26      // 16px glyph + 5px padding each side

  // type, from the swaync css
  readonly property string bodyFont: pick(["Michroma"])
  readonly property string titleFont: pick(["Microgramma D Extended"])
  readonly property int titlePx: 14
  readonly property int bodyPx: 12

  function pick(names: var): string {
    const installed = Qt.fontFamilies()

    for (const f of names)
      if (installed.includes(f)) return f

    return Theme.font
  }

  function lifeFor(n): int {
    if (n.expireTimeout > 0) return n.expireTimeout * 1000
    if (n.urgency === NotificationUrgency.Critical) return critMs
    if (n.urgency === NotificationUrgency.Low) return lowMs
    return normalMs
  }

  component Fade: ColorAnimation {
    duration: root.fadeMs
    easing.type: Easing.OutCubic
  }

  // The window is full height and never resizes, so animations cannot make it
  // stutter. The mask makes everything outside the cards click-through.
  PanelWindow {
    visible: Store.server.trackedNotifications.values.length > 0
    anchors { top: true; bottom: true; right: true }
    exclusionMode: ExclusionMode.Ignore
    implicitWidth: root.winW
    color: "transparent"

    mask: Region { item: column }

    Column {
      id: column

      anchors.bottom: parent.bottom
      width: parent.width

      Repeater {
        model: Store.server.trackedNotifications

        // slot: owns the lifetime and the animations of one card
        Item {
          id: slot

          required property var modelData

          readonly property bool crit:
            modelData.urgency === NotificationUrgency.Critical

          property real slide: 0   // 0 = off screen on the right, 1 = in place
          property real space: 0   // 0 = takes no room, 1 = full height
          property bool leaving: false
          property bool closing: false // true when the user pressed close

          width: column.width
          height: (card.height + root.rowMargin) * space
          clip: true

          function leave(byUser: bool): void {
            if (leaving) return
            closing = byUser
            leaving = true
            enterAnim.stop()
            leaveAnim.start()
          }

          Component.onCompleted: enterAnim.start()

          // in: slide from the right edge while the space opens
          ParallelAnimation {
            id: enterAnim

            NumberAnimation {
              target: slot
              property: "slide"
              to: 1
              duration: root.slideMs
              easing.type: Easing.OutCubic
            }

            NumberAnimation {
              target: slot
              property: "space"
              to: 1
              duration: root.slideMs
              easing.type: Easing.OutCubic
            }
          }

          // out: slide off to the right first, then close the gap
          SequentialAnimation {
            id: leaveAnim

            NumberAnimation {
              target: slot
              property: "slide"
              to: 0
              duration: root.slideMs
              easing.type: Easing.InCubic
            }

            NumberAnimation {
              target: slot
              property: "space"
              to: 0
              duration: root.collapseMs
              easing.type: Easing.InOutCubic
            }

            ScriptAction {
              script: {
                if (slot.closing) slot.modelData.dismiss()
                else slot.modelData.expire()
              }
            }
          }

          // expiry: waits while the mouse is over the card, then starts over
          Timer {
            interval: root.lifeFor(slot.modelData)
            running: !hover.hovered && !slot.leaving
            onTriggered: slot.leave(false)
          }

          Rectangle {
            id: card

            width: root.cardW
            height: content.implicitHeight + root.padTop + root.padBottom

            // rowMargin when in place, travels the full window width to leave
            x: root.rowMargin + (1 - slot.slide) * (root.winW - root.rowMargin)
            opacity: slot.slide

            // outer color doubles as the 12px left edge and the 2px border
            color: slot.crit ? root.critEdge : root.edge

            HoverHandler { id: hover }

            Rectangle {
              anchors {
                fill: parent
                leftMargin: root.strip
                topMargin: root.border
                rightMargin: root.border
                bottomMargin: root.border
              }

              color: slot.crit ? root.critBg : root.bg
            }

            Column {
              id: content

              anchors {
                left: parent.left
                right: parent.right
                top: parent.top
                leftMargin: root.strip + root.padLeft
                rightMargin: root.border + root.padRight
                topMargin: root.padTop
              }

              spacing: root.lineGap

              Text {
                // leave room for the close button
                width: parent.width - 22

                text: slot.modelData.summary
                color: slot.crit ? root.critText : root.text
                elide: Text.ElideRight

                font {
                  family: root.titleFont
                  pixelSize: root.titlePx
                  bold: true
                  letterSpacing: 1
                  capitalization: Font.AllUppercase
                }
              }

              Text {
                width: parent.width

                visible: text !== ""
                text: slot.modelData.body
                color: slot.crit ? root.critText : root.text
                wrapMode: Text.Wrap
                maximumLineCount: 4
                elide: Text.ElideRight

                font {
                  family: root.bodyFont
                  pixelSize: root.bodyPx
                  bold: true
                }
              }
            }

            // close button: drawn, so it does not depend on any font glyph
            Item {
              id: closeBtn

              readonly property bool hot: closeArea.containsMouse

              width: root.closeSize
              height: root.closeSize

              anchors {
                top: parent.top
                right: parent.right
                topMargin: root.border + 2
                rightMargin: root.border + 4
              }

              Repeater {
                model: [45, -45]

                Rectangle {
                  required property int modelData

                  anchors.centerIn: parent
                  width: 12
                  height: 2
                  rotation: modelData
                  antialiasing: true
                  color: closeBtn.hot
                    ? (slot.crit ? root.critText : root.closeHot)
                    : (slot.crit ? "#9a2a36" : root.closeIdle)
                  Behavior on color { Fade {} }
                }
              }

              MouseArea {
                id: closeArea

                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor

                onClicked: slot.leave(true)
              }
            }
          }
        }
      }
    }
  }
}
