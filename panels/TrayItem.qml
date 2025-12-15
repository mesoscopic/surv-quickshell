import Quickshell
import Quickshell.Widgets
import Quickshell.Services.SystemTray
import QtQuick

WrapperMouseArea {
	leftMargin: 3
	rightMargin: 3
	required property var modelData

	IconImage {
		source: parent.modelData.icon
		implicitSize: 22
	}

	acceptedButtons: Qt.LeftButton | Qt.RightButton | Qt.MiddleButton
	onPressed: mouse => {
		if (mouse.button == Qt.LeftButton) modelData.activate()
		else if (mouse.button == Qt.RightButton)
			modelData.display(panel, panel.itemPosition(this).x, panel.itemPosition(this).y+30)
	}
}
