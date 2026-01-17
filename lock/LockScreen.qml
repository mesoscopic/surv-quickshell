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
	Background {
		id: content
		opacity: 0
		Column {
			anchors.centerIn: parent
			Input {}
		}
	}
}
