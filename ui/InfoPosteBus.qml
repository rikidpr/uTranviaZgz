import QtQuick 2.0
import Ubuntu.Components 1.1
import QtQuick.XmlListModel 2.0
import Ubuntu.Components.ListItems 0.1


Page {
    id: infoPostePage

    title: i18n.tr("Info Poste")

    property string posteId;

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

        }
    }

    ListModel{
        id:infoBusModel
        ListElement{linea:"linea"; destino:"destino"; primero:"primero"; segundo:"segundo"}
    }

    Item{
        id:classificationResultsItem
        anchors.fill: parent;

        ListView {
            clip: true
            anchors.fill:parent
            model: infoBusModel
            header: Rectangle {
                width: parent.width;
                height: units.gu(3);
                color: "#555555"
            }

            footer: Rectangle {
                width: parent.width;
                height: units.gu(3);
                color: "#555555"
            }
            delegate: lineaInfoDelegate
            /*Standard {
                   objectName: "listadoResultadosPoste"
                   text: linea + "-"+primero+"-"+segundo
               }*/
        }
        Component {
            id: lineaInfoDelegate
            Item{
                anchors{
                    left: parent.left
                    right: parent.right
                }
                height: units.gu(3)
                Rectangle {
                    anchors{
                        left: parent.left
                        right: parent.right
                    }
                    height: units.gu(3)
                    color: "white"
                }
                Label {
                    text: linea + "-"+primero+"-"+segundo
                    width: units.gu(4)
                    fontSize: "small"
                    anchors {
                        top: parent.top
                        bottom: parent.bottom
                        left: parent.left
                        margins: units.gu(0.5)
                    }
                    color: "black"
                }
            }
        }
    }
}
