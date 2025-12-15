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
		id: notif_area
		margin: 20;
		Row {
			spacing: 15
			Image {
				id: notif_icon
				visible: source!=""
				source: notif.modelData.image||notif.modelData.appIcon
				width: 75
				fillMode: Image.PreserveAspectFit
			}
			Column {
				width: notif.width - 2*notif_area.margin - parent.spacing - notif_icon.width
				Text {
					color: "#ffffff"
					font.bold: true
					font.pixelSize: 16
					text: notif.modelData.summary
					wrapMode: Text.Wrap
					width: parent.width
				}
				Text {
					color: "#ffffff"
					font.pixelSize: 13
					text: notif.modelData.body
					wrapMode: Text.Wrap
					width: parent.width
				}
			}
		}

		onPressed: {
			notif.modelData.actions[0].invoke()
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
