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

	SystemClock {
		id: clock
		precision: SystemClock.Seconds
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
		signal unlock
		readonly property PamContext pam: PamContext {}
		LockScreen {}
	}
	Process {
		command: ["gdbus", "monitor", "--system", "--dest", "org.freedesktop.login1"]
		running: true
		stdout: SplitParser {
			splitMarker: "\n"
			onRead: line => {
				if (line.includes("org.freedesktop.login1.Session.Lock")){
					lock.locked = true
					lock.pam.start()
				} else if (line.includes("org.freedesktop.login1.Session.Unlock")) lock.unlock()
			}
		}
	}
}
