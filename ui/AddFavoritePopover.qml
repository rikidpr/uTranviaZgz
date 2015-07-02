import QtQuick 2.0
import Ubuntu.Components 1.1
import Ubuntu.Components.ListItems 1.0 as ListItem
import Ubuntu.Components.Popups 1.0

Component {
    id: popoverComponent
    Popover {
        id:popoverobj
        y: units.gu(15)
        anchors {//lo colocamos en medio
            left: parent.left
            right: parent.right
            margins: {
                leftMargin: units.gu(2)
                rightMargin: units.gu(2)
            }
            //horizontalCenter: parent.horizontalCenter
            //verticalCenter: parent.verticalCenter
        }

        MouseArea {
            anchors.fill: parent
            onPressed: popoverobj.hide();
        }

        Text {
            id:txt
            anchors {
                horizontalCenter: parent.horizontalCenter
                verticalCenter: parent.verticalCenter
            }
            text: "Add favorite succesful"
        }
        Icon{
            id:icono
            width: units.gu(6)
            height: units.gu(6)
            anchors {
                left: txt.right
                verticalCenter: parent.verticalCenter
            }
            name:"favorite-selected"
        }
    }
}
