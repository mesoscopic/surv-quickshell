import Quickshell
import Quickshell.Widgets
import QtQuick

Rectangle {
	id: workspace
	required property var modelData
	implicitWidth: modelData.focused?50:30
	implicitHeight: panel.height/2
	radius: 20
	color: modelData.focused?"#ffffff":"transparent"
	Text {
		id: workspace_name
		text: modelData.name=="special:special"?"":modelData.name
		anchors.centerIn: parent
		color: modelData.focused?"#000000":"#ffffff"
		font.bold: true
		font.pixelSize: 13
	}
	states: State {
		name: "focused"
		when: modelData.focused
		PropertyChanges {
			target: workspace
			implicitWidth: 50
		}
	}
	transitions: Transition {
		NumberAnimation {properties: "implicitWidth"; duration: 100}
	}
}
