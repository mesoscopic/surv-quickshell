import Quickshell
import Quickshell.Widgets
import Quickshell.Services.SystemTray
import QtQuick

WrapperMouseArea {
	id: tray_item
	leftMargin: 3
	rightMargin: 3
	required property var modelData
		property bool selected: section_tray.selectedItem == this

	Rectangle {
		implicitWidth: 26
		implicitHeight: 26
		color: "transparent"
		radius: 5
		border.color: selected?"#ffffff":"transparent"
		border.width: 2
		IconImage {
			anchors.centerIn: parent
			source: tray_item.modelData.icon
			implicitSize: 22
		}
	}

	QsMenuAnchor {
		id: item_menu
		menu: tray_item.modelData.menu
		anchor.item: tray_item
		anchor.edges: Edges.Bottom | Edges.Left

		onClosed: {
			if(selected) section_tray.selected = -1
		}
	}

	acceptedButtons: Qt.LeftButton | Qt.RightButton | Qt.MiddleButton
	onPressed: mouse => {
		if (mouse.button == Qt.LeftButton) modelData.activate()
		else if (mouse.button == Qt.RightButton) showMenu()
	}

	function showMenu() {
		item_menu.open()
	}
}
