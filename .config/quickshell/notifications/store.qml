pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Services.Notifications

Singleton {
  id: store

  readonly property int historyMax: 5
  readonly property var server: srv
  property var history: []

  function push(n): void {
    history = [{ summary: n.summary, body: n.body, urgency: n.urgency }, ...history]
      .slice(0, historyMax)
  }

  function clear(): void {
    history = []
    for (const n of [...srv.trackedNotifications.values]) n.dismiss()
  }

  NotificationServer {
    id: srv
    onNotification: n => {
      n.tracked = true
      store.push(n)
    }
  }
}
