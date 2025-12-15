import Quickshell
import Quickshell.Services.Notifications
import Quickshell.Widgets
import QtQuick

Rectangle {
	id: notif
	required property var modelData
	implicitWidth: notifs.width
	implicitHeight: childrenRect.height
	color: "#000000"
	border.color: "#88888844"
	border.width: 2
	radius: 18

	WrapperMouseArea {
		margin: 20;
		Row {
			spacing: 15
			Image {
				visible: source!=""
				source: notif.modelData.image||notif.modelData.appIcon
				width: 50
				height: 50
			}
			Column {
				Text {
					color: "#ffffff"
					font.bold: true
					font.pixelSize: 16
					text: notif.modelData.summary
				}
				Text {
					color: "#ffffff"
					font.pixelSize: 13
					text: notif.modelData.body
				}
			}
		}

		onPressed: {
			notif.modelData.dismiss()
		}
	}

	Timer {
		id: expiretime
		interval: notif.modelData.expireTimeout<0?5000:Math.min(5000,notif.modelData.expireTimeout)
		running: true
		onTriggered: {
			notif.modelData.expire()
		}
	}
}
