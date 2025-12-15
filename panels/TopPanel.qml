import Quickshell
import Quickshell.Wayland
import QtQuick
import Quickshell.Services.SystemTray
import Quickshell.Services.UPower
import Quickshell.Services.Pipewire
import Quickshell.Hyprland
import Quickshell.Wayland
import Quickshell.Io

import "../utils.js" as Util

PanelWindow {
	required property var modelData
	screen: modelData
	id: panel
	anchors {
		top: true
		left: true
		right: true
	}
	margins {
		top: 15
		left: 30
		right: 30
	}

	WlrLayershell.layer: WlrLayer.Top

	color: "transparent"

	implicitHeight: 40
	
	Rectangle {
		color: "transparent"
		id: inner
		implicitWidth: panel.width
		implicitHeight: panel.height

		// Workspaces
		Section {
			id: section_workspaces

			Row {
				Repeater {
					model: Hyprland.workspaces.values
					Workspace {}
				}
			}
		}

		// Volume and Brightness
		Section {
			property int brightness

			id: section_meters
			anchors.left: section_workspaces.right
			anchors.leftMargin: 20

			PwObjectTracker {
				objects: [Pipewire.defaultAudioSink]
			}

			IpcHandler {
				target: "brightness"

				function set(percent: int): void { section_meters.brightness = percent }
			}

			Row {
				Text {
					color: "#ffffff"
					font.bold: true
					font.pixelSize: 20
					text: ["󰝟","󰖀","󰕾"][Math.ceil(Pipewire.defaultAudioSink.audio.volume/0.5)] ?? "󰕾"
				}
				Text {
					anchors.verticalCenter: parent.verticalCenter
					color: "#ffffff"
					font.bold: true
					font.pixelSize: 13
					text: " "+Math.floor(Pipewire.defaultAudioSink.audio.volume*100)+"%"
				}

				Text {
					color: "#ffffff"
					font.bold: true
					font.pixelSize: 20
					text: " "+["󰃞","󰃟","󰃠"][Math.floor(section_meters.brightness/45)] ?? "󰃟"
				}
				Text {
					anchors.verticalCenter: parent.verticalCenter
					color: "#ffffff"
					font.bold: true
					font.pixelSize: 13
					text: " "+section_meters.brightness+"%"
				}
				Text {
					color: (UPower.displayDevice.percentage<.2 && UPower.displayDevice.state!=UPowerDeviceState.Charging)?"#f38ba8":"#ffffff"
					font.bold: true
					font.pixelSize: 20
					text: " "+[
						["󰁺","󰁻","󰁼","󰁽","󰁾","󰁿","󰂀","󰂁","󰂂","󰁹"],
						["󰢜","󰂆","󰂇","󰂈","󰢝","󰂉","󰢞","󰂊","󰂋","󰂅"]
					][+(UPower.displayDevice.state==UPowerDeviceState.Charging)][Math.ceil(UPower.displayDevice.percentage*10)-1] ?? "󰁹"
				}
				Text {
					anchors.verticalCenter: parent.verticalCenter
					color: (UPower.displayDevice.percentage<.2 && UPower.displayDevice.state!=UPowerDeviceState.Charging)?"#f38ba8":"#ffffff"
					font.bold: true
					font.pixelSize: 13
					text: " "+Math.ceil(UPower.displayDevice.percentage*100)+"%"
				}
			}
		}

		// Title
		Section {
			color: "transparent"
			id: section_title
			anchors.horizontalCenter: parent.horizontalCenter

			Text {
				color: "#ffffff"
				font.bold: true
				font.pixelSize: 15
				text: Util.shorten(ToplevelManager.activeToplevel.title, 70)
				visible: ToplevelManager.activeToplevel !== null && ToplevelManager.activeToplevel.activated && !root.menuOpen
			}
		}

		// System time
		Section {
			id: section_time
			anchors.right: inner.right

			SystemClock {
				id: clock
				precision: SystemClock.Seconds
			}

			Text {
				color: "#ffffff"
				font.bold: true
				font.pixelSize: 13
				text: Qt.formatDateTime(clock.date, "yyyy.MM.dd hh:mm:ss")
			}
		}

		// System tray
		Section {
			id: section_tray
			anchors.right: section_time.left
			anchors.rightMargin: 20

			property int selected: -1
			property var selectedItem: tray_items.itemAt(selected)

			IpcHandler {
				target: "tray"
				function cycle() {
					section_tray.selected = (section_tray.selected + 1) % SystemTray.items.values.length
					tray_items.itemAt(section_tray.selected).showMenu()
				}
			}

			Row {
				Repeater {
					id: tray_items
					model: SystemTray.items.values
					TrayItem {}
				}
			}
		}
	}
}
