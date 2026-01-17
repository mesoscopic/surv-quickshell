import Quickshell
import Quickshell.Wayland
import QtQuick

PanelWindow {
	anchors {
		top: true
		left: true
		bottom: true
		right: true
	}

	WlrLayershell.layer: WlrLayer.Bottom
	exclusionMode: ExclusionMode.Ignore

	required property var modelData

	Background {}
}
