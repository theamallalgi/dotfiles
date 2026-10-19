import QtQuick

Item {
  id: fx

  required property Item target
  property string name: ""            // set it to join the one-popup-at-a-time group
  property bool open: false           // the logical state: write this, not window.visible
  property bool shown: false          // bind the window's `visible` to this

  property int duration: 260
  property int closeDuration: 150
  property real fromScale: 0.92
  property real closeScale: 0.96
  property real maxBlur: 100
  property real maxAberr: 80
  property int origin: Item.TopRight

  property bool active: false

  // Hide the window one tick AFTER the effect detaches from the panel.
  // Same ordering that fixed the re-open crash.
  function hide(): void {
    active = false
    Qt.callLater(finishHide)
  }
  function finishHide(): void { if (!open) shown = false }

  onOpenChanged: {
    if (open) {
      if (name !== "") Popups.current = name
      shown = true
      closeAnim.stop()
      if (duration <= 0) { active = false; return }
      active = true
      openAnim.restart()
    } else {
      if (name !== "" && Popups.current === name) Popups.current = ""
      if (!shown) return
      openAnim.stop()
      if (closeDuration <= 0) { hide(); return }
      active = true
      closeAnim.restart()
    }
  }

  Connections {
    target: Popups
    function onCurrentChanged(): void {
      if (fx.name !== "" && fx.open && Popups.current !== fx.name) fx.open = false
    }
  }

  x: target.x; y: target.y
  width: target.width; height: target.height
  visible: active

  ShaderEffectSource {
    id: src
    sourceItem: fx.active ? fx.target : null
    hideSource: fx.active
    live: fx.active
    visible: false
  }

  ShaderEffect {
    id: eff
    anchors.fill: parent
    transformOrigin: fx.origin

    property variant source: src
    property real amount: 0
    property real blurPx: fx.maxBlur
    property real aberrPx: fx.maxAberr
    property vector2d texel: Qt.vector2d(1 / Math.max(1, width), 1 / Math.max(1, height))

    fragmentShader: Qt.resolvedUrl("openfx.frag.qsb")
  }

  ParallelAnimation {
    id: openAnim
    onFinished: fx.active = false
    NumberAnimation { target: eff; property: "amount"; from: 1; to: 0
      duration: fx.duration; easing.type: Easing.OutExpo }
    NumberAnimation { target: eff; property: "scale"; from: fx.fromScale; to: 1
      duration: fx.duration; easing.type: Easing.OutBack; easing.overshoot: 1.1 }
    NumberAnimation { target: eff; property: "opacity"; from: 0; to: 1
      duration: fx.duration * 0.35; easing.type: Easing.OutCubic }
  }

  // close: starts from the clean panel and blurs/splits/fades out, faster than the open
  ParallelAnimation {
    id: closeAnim
    onFinished: fx.hide()
    NumberAnimation { target: eff; property: "amount"; to: 1
      duration: fx.closeDuration; easing.type: Easing.InCubic }
    NumberAnimation { target: eff; property: "scale"; to: fx.closeScale
      duration: fx.closeDuration; easing.type: Easing.InCubic }
    NumberAnimation { target: eff; property: "opacity"; to: 0
      duration: fx.closeDuration; easing.type: Easing.InQuad }
  }
}
