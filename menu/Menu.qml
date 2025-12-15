import Quickshell
import Quickshell.Wayland
import Quickshell.Hyprland
import QtQuick

import "menu.js" as MenuLogic

PanelWindow {
	id: menu
	anchors {
		top: true
	}
	WlrLayershell.layer: WlrLayer.Overlay
	exclusionMode: ExclusionMode.Ignore
	implicitWidth: 800
	implicitHeight: 600
	color: "transparent"

	HyprlandFocusGrab {
		active: root.menuOpen
		windows: [menu]

		onCleared: {
			root.menuOpen = false
		}
	}
	mask: Region {item: menu}
	Rectangle {
		id: rect
		implicitWidth: menu.width
		implicitHeight: childrenRect.height+10
		color: "#000000"
		bottomLeftRadius: 20
		bottomRightRadius: 20

		property real scale: 0.
		transform: Scale {
			origin.y: 0
			yScale: rect.scale
		}
		states: [
			State {
				name: "inactive"
				when: !root.menuOpen
				PropertyChanges {target: rect; scale: 0.}
			},
			State {
				name: "active"
				when: root.menuOpen
				PropertyChanges {target: rect; scale: 1.}
				StateChangeScript {
					script: {
						input.text = ""
					}
				}
			}
		]
		transitions: Transition {
			NumberAnimation {properties: "scale"; duration: 80}
		}
		property var results: MenuLogic.items(input.text)
		property int selected: 0
		Column {
			bottomPadding: rect.results.length>0?10:0
			TextInput {
				id: input
				activeFocusOnPress: false
				color: "#ffffff"
				font.bold: true
				font.pixelSize: 15
				topPadding: 20
				leftPadding: 40
				rightPadding: 40
				bottomPadding: 20
				text: ""
				focus: true
				Keys.onEscapePressed: {
					root.menuOpen = false
				}
				onAccepted: {
					MenuLogic.act(text, rect.results[rect.selected].obj)
					root.menuOpen = false
				}
				onTextEdited: {
					rect.selected = 0
				}
				Keys.onUpPressed: {
					rect.selected = Math.max(0,rect.selected-1)
				}
				Keys.onDownPressed: {
					rect.selected = Math.min(rect.results.length-1,rect.selected+1)
				}
			}
			Repeater {
				model: rect.results
				Rectangle {
					required property int index
					required property var modelData
					color: index==rect.selected?"#585b70":"transparent"
					x: 20
					implicitWidth: rect.width-40
					implicitHeight: 40
					radius: 20
					Text {
						x: 20
						text: modelData.str
						color: "#ffffff"
						anchors.verticalCenter: parent.verticalCenter
					}
				}
			}
		}
	}
}
