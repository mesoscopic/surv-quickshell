//@ pragma UseQApplication

import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import Quickshell.Services.Pam
import QtQuick

import "panels"
import "notif"
import "menu"
import "lock"
import "wall"

Scope {
	id: root
	property bool menuOpen: false

	IpcHandler {
		target: "menu"
		function toggle() {
			root.menuOpen = !root.menuOpen
		}
	}
	IpcHandler {
		target: "lock"
		function lock() {
			lock.pam.start()
			lock.locked = true
		}
	}

	Variants {
		model: Quickshell.screens
		Wallpaper {}
	}
	Variants {
		model: Quickshell.screens
		TopPanel {}
	}
	Variants {
		model: Quickshell.screens
		Notifs {}
	}
	Menu {}

	WlSessionLock {
		id: lock
		readonly property PamContext pam: PamContext {}
		LockScreen {}
	}
}
