import Quickshell
import Quickshell.Widgets
import QtQuick

Rectangle {
	default property var sectionContents
	color: "#90000000"
	radius: 20
	implicitHeight: parent.height
	implicitWidth: childrenRect.width

	WrapperItem {
		leftMargin: 20
		rightMargin: 20
		anchors.verticalCenter: parent.verticalCenter
		data: parent.sectionContents
	}
}
