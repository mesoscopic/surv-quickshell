import Quickshell
import Quickshell.Wayland
import Quickshell.Services.Pam
import QtQuick
import QtQuick.Controls
import QtQuick.Effects

import "../wall"

WlSessionLockSurface {
	id: lock_surface
	color: "transparent"
	ScreencopyView {
		id: screen
		anchors.fill: parent
		captureSource: lock_surface.screen
	}
	NumberAnimation {
		running: true
		target: content
		property: "opacity"
		to: 1
		duration: 100
	}
	NumberAnimation {
		id: unlock_anim
		running: false
		target: content
		property: "opacity"
		to: 0
		duration: 100
		onFinished: lock.locked = false
	}
	Connections {
		target: lock.pam
		function onCompleted(result) {
			if (result == PamResult.Success) {
				unlock()
			} else if (result == PamResult.Failed) {
				lock.pam.start()
			}
		}
	}
	function unlock() {
		unlock_anim.start()
		lock.pam.abort()
	}
	Rectangle {
		id: content
		color: "transparent"
		anchors.fill: parent
		opacity: 0
		Background {
			layer.enabled: true
			layer.effect: MultiEffect {
				autoPaddingEnabled: false
				blurEnabled: true
				blur: 1
				blurMax: 16
			}
		}
		Column {
			spacing: 10
			anchors.centerIn: parent
			Rectangle {
				color: "#90000000"
				radius: 20
				implicitWidth: 400
				implicitHeight: 50
				anchors.horizontalCenter: parent.horizontalCenter
				Text {
					color: "#ffffff"
					text: Qt.formatDateTime(clock.date, "yyyy.MM.dd hh:mm:ss")
					font.bold: true
					font.pixelSize: 25
					anchors.centerIn: parent
				}
			}
			Input {}
		}
	}
}
