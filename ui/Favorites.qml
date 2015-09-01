import QtQuick 2.0
import Ubuntu.Components 1.2

Page{
    id:favoritesPage
    title: i18n.tr("Tranvia Zgz Favoritos")

    property color green1: "#558855";
    property color green2: "#228822";
    property color grey: "lightgrey";

    UbuntuListView  {
        id:favoritesList
        anchors.fill:parent
        clip:true
        model: favoritesQuery
        delegate: ListItem{
            height: units.gu(5)
            Icon{
                id:icono
                anchors {
                    left: parent.left
                    top: parent.top
                    bottom: parent.bottom
                }
                width: parent.height
				source: {
					var source;
					if (contents.type==="BIZI"){
						source = "../img/bizi.png";
					} else if (contents.type==="TRAM"){
						source = "../img/tram.png"
					} else if (contents.type==="BUS"){
						source = "../img/bus.jpeg"
					}
					return source;
				}
            }
            Label{
                anchors {
                    verticalCenter: parent.verticalCenter
                    left: icono.right
                    right: parent.right
                }
                text: contents.name
                fontSize:"medium"
            }
            leadingActions: ListItemActions {
                actions: [
                    Action {
                        iconName: "delete"
                        onTriggered:{
                            deleteFavorite(docId);
                        }
                    }
                ]
            }
            onClicked: {
                setFavorite(contents.type, contents.stationId, contents.name)
            }
        }
    }

}



