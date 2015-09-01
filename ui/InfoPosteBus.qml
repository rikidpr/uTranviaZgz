import QtQuick 2.0
import Ubuntu.Components 1.2
import QtQuick.XmlListModel 2.0
import Ubuntu.Components.ListItems 0.1
import Ubuntu.Components.Popups 1.0
import "../components"

Page {
    id: infoPostePage

    title: i18n.tr("Info Poste")

	property string posteId;
	property string posteName;

    Component.onCompleted: {
        queryPosteWorker.sendMessage({'posteId': posteId})
    }

    WorkerScript {
        id: queryPosteWorker
        source: "../js/infoBuses.js"

        onMessage: {
            //reseteamos indicador y valores para recarga
            //activityIndicator.running = false;
            var destinos = messageObject.posteInfo.destinos;
            for(var i = 0; i< destinos.length ; i++){
                console.log(destinos[i].primero);
                infoBusModel.append({"linea": destinos[i].linea,
                                       "destino":destinos[i].destino,
                                       "primero":destinos[i].primero,
                                       "segundo":destinos[i].segundo});
            }
			infoPostePage.state = "LOADED"
        }
    }

    ListModel{
        id:infoBusModel
    }
	//estados de carga y muestra de la info
	state: "LOADING"
	states: [
		State{
			name: "LOADING"
			PropertyChanges{target: activityIndicator; opacity:1}
			PropertyChanges{target: infoPosteItem; opacity: 0}
		},
		State{
			name: "READY"
			PropertyChanges{target: activityIndicator; opacity:0}
			PropertyChanges{target: infoPosteItem; opacity: 1}
		}
			
	]
	
	 head.actions: [
        Action {
            id: addFavoriteAction

            iconName: "add"
            text: "Add to favorites"

            onTriggered: {
				if (addToFavorites("BUS", posteId, posteName)) {
					PopupUtils.open(addFavoritePopover)
				}
           }
        },
        Action {
            id: reloadAction
            iconName: "reload"
            text: "reload"
            onTriggered: queryPosteWorker.sendMessage({'posteId': posteId});
        }

    ]
	
    AddFavoritePopover{
        id:addFavoritePopover
    }
	
	ActivityIndicator {
        id: activityIndicator
        anchors{
            horizontalCenter: parent.horizontalCenter;
            verticalCenter: parent.verticalCenter;
        }
        width: units.gu(6);
        height: units.gu(6);
        running:true;
        opacity: 1;
    }

    Item{
        id: infoPosteItem
        anchors.fill: parent;
		opacity:0;
        ListView {
            clip: true
            anchors.fill:parent
            model: infoBusModel
            header: headerDelegate

            footer: Rectangle {
                width: parent.width;
                height: units.gu(1);
                color: InfoZgzColor.redTitle
            }
            delegate: lineaInfoDelegate
        }
		Component{ 
			id:headerDelegate
			Item{
				anchors{
					left: parent.left
					right: parent.right
				}
				height:units.gu(8)
				Rectangle {
					width: parent.width;
					height: units.gu(8);
					color: InfoZgzColor.redTitle
				}
				Label{
					id: hInfoPoste
					text: posteId+" - "+posteName
					height: units.gu(4)
					anchors {
						top: parent.top
						left: parent.left
						right: parent.right
						margins: units.gu(1)
					}
				}
				Label {
					id:hLinea
					text: i18n.tr("Linea");
					width: units.gu(5)
					fontSize: "medium"
					anchors {
						top: hInfoPoste.bottom
						bottom: parent.bottom
						left: parent.left
						margins: units.gu(1)
					}
					color: UbuntuColors.white
				}
				Label {
					id: hPrimero
					text: primero
					width: units.gu(10)
					fontSize: "medium"
					anchors {
						top: hInfoPoste.bottom
						bottom: parent.bottom
						left: hLinea.right
						margins: units.gu(1)
					}
					color: UbuntuColors.white
				}
				Label {
					id:hSegundo
					text: segundo
					width: units.gu(10)
					fontSize: "medium"
					anchors {
						top: hInfoPoste.bottom
						bottom: parent.bottom
						left: hPrimero.right
						margins: units.gu(1)
					}
					color: UbuntuColors.white
				}
			}
			
		}
		
        Component {
            id: lineaInfoDelegate
            Item{
                anchors{
                    left: parent.left
                    right: parent.right
                }
                height: units.gu(4)
                Rectangle {
                    anchors{
                        left: parent.left
                        right: parent.right
                    }
                    height: units.gu(4)
                    color: index % 2 == 0 ? "white" : InfoZgzColors.redLink
                }
                Label {
					id:lblLinea
                    text: linea
                    width: units.gu(5)
                    fontSize: "medium"
                    anchors {
                        top: parent.top
                        bottom: parent.bottom
                        left: parent.left
                        margins: units.gu(1)
                    }
                    color: index % 2 == 1 ? "white" : InfoZgzColors.redLink
                }
				Label {
					id: lblPrimero
                    text: primero
                    width: units.gu(10)
                    fontSize: "medium"
                    anchors {
                        top: parent.top
                        bottom: parent.bottom
                        left: lblLinea.right
                        margins: units.gu(1)
                    }
                    color: index % 2 == 1 ? "white" : InfoZgzColors.redLink
                }
				Label {
					id:lblSegundo
                    text: segundo
                    width: units.gu(10)
                    fontSize: "medium"
                    anchors {
                        top: parent.top
                        bottom: parent.bottom
                        left: lblPrimero.right
                        margins: units.gu(1)
                    }
                    color: index % 2 == 1 ? "white" : InfoZgzColors.redLink
                }
            }
        }
    }
}
