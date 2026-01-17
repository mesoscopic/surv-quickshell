import Quickshell
import QtQuick

Rectangle {
	color: "#90000000"
	radius: 20
	border.width: 2
	border.color: col
	implicitWidth: 800
	implicitHeight: 60
	clip: true

	property bool submitted: false
	property string entry: "ye"
	readonly property bool showMessage: !lock.pam.responseRequired || entry.length == 0
	readonly property var col: showMessage?(lock.pam.messageIsError?"#f38ba8":"#aaaaaa"):(submitted?"#f9e2af":"#ffffff")

	focus: true
	onActiveFocusChanged: {if (!activeFocus) forceActiveFocus()}
	Keys.onPressed: event => {
		if (lock.pam.active && lock.pam.responseRequired && !submitted) {
			// mostly stolen from caelestia
			if (event.key == Qt.Key_Enter || event.key == Qt.Key_Return) {
				lock.pam.respond(entry)
				submitted = true
			} else if (event.key == Qt.Key_Backspace) {
				if (event.modifiers & Qt.ControlModifier) entry = "";
				else entry = entry.slice(0, -1);
			} else if (" abcdefghijklmnopqrstuvwxyz1234567890`~!@#$%^&*()-_=+[{]}\\|;:'\",<.>/?".includes(event.text.toLowerCase())) {
				entry += event.text
			}
		}
	}

	Connections {
		target: lock.pam
		function onMessageChanged() {
			entry = ""
		}
		function onActiveChanged() {
			submitted = false
		}
	}

	Text {
		id: input_text
		anchors.centerIn: parent
		color: col
		font.bold: true
		font.pixelSize: 20
		text: showMessage?lock.pam.message:(lock.pam.responseVisible?entry:entry.replace(/./g, "•"))
	}
}
