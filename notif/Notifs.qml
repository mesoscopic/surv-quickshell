import Quickshell
import Quickshell.Wayland
import Quickshell.Services.Notifications
import QtQuick

PanelWindow {
	required property var modelData
	screen: modelData
	id: notifs

	anchors {
		top: true
		right: true
	}
	margins {
		top: 15
		right: 30
	}
	color: "transparent"
	implicitWidth: 400
	implicitHeight: 600
	
	WlrLayershell.layer: WlrLayer.Overlay

	NotificationServer {
		id: notif_server
		onNotification: notif => {
			notif.tracked = true
		}
	}

	mask: Region {item: notiflist}
	Column {
		id: notiflist
		Repeater {
			model: notif_server.trackedNotifications
			Notif {}
		}
		spacing: 10
	}
}
