//@ pragma UseQApplication

import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import QtQuick

import "panels"
import "notif"
import "menu"

Scope {
	id: root
	property bool menuOpen: false

	IpcHandler {
		target: "menu"
		function toggle() {
			root.menuOpen = !root.menuOpen
		}
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
}
