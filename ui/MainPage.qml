import QtQuick 2.0
import Ubuntu.Components 1.1
import QtQuick.XmlListModel 2.0

Page {
    id: mainPage

    title: i18n.tr("Tranvia Zgz")

    property color nextColor: "#AA0000"
    property color nextNextColor: "#EEAAAA"
    property int preSelectedStationId:0

    // Always begin by loading the selected stop.
    Component.onCompleted: {
        queryStationsWorker.sendMessage()
    }

    function obtenerInfoEstacion (stationId){
        stationSelector.selectedIndex = getStationIndex(stationId, stationsModel)
    }

    WorkerScript {
        id: queryStationsWorker
        source: "../js/paradasTranvia.js"

        onMessage: {
            for (var i = 0; i < messageObject.stations.length; i++) {
                var station = messageObject.stations[i];
                var linea;
                var destino;
                if (typeof station.destinos !== 'undefined' && station.destinos.length>0){
                    var row = station.destinos[0];
                    linea = row.linea;
                    destino = row.destino;
                } else {
                    linea = "L1";
                    destino = "ACADEMIA";
                }

                stationsModel.append({ "idParada": station.id,
                                        "name": station.title,
                                        "linea": linea,
                                        "destino":destino,
                                         "description": linea+"-"+destino
                                     });
            }
            //stationSelector.selectedIndex = getStationIndex(preSelectedStationId, stationsModel)
        }
    }


    WorkerScript {
        id: queryInfoStationWorker
        source: "../js/infoParada.js"

        onMessage: {
            activityIndicator.running = false;
            var infoNext = messageObject.stationInfo.destinos[0];
            nextTramLabel.text = infoNext.minutos;
            var infoNextNext = messageObject.stationInfo.destinos[1];
            nextNextTramLabel.text = infoNextNext.minutos;
        }
    }

/*
    AddFavoritePopover{
        id:addFavoritePopover
    }


    head.actions: [
        Action {
            id: addFavoriteAction

            iconName: "add"
            text: "Add to favorites"

            onTriggered: {
                if (stationSelector.selectedIndex > 0){
                    var stationId = stationsModel.get(stationSelector.selectedIndex).id;
                    var name = stationsModel.get(stationSelector.selectedIndex).name;
                    if (addToFavorites(stationId, name)) {
                        PopupUtils.open(addFavoritePopover)
                    }
                }
           }
        },
        Action {
            id: favoritesAction

            iconName: "favorite-unselected"
            text: "Favoritos"

            onTriggered: {
                pageStack.push(Qt.resolvedUrl("Favorites.qml"))
            }
        },
        Action {
            id: aboutAction

            iconName: "info"
            text: "About"

            onTriggered: PopupUtils.open(aboutPopover)
        }
    ]*/

    /*AboutPopover {
        id: aboutPopover
    }*/

    Item {
        id: selectStationRow

        Label {
            id: selectStationLabel

            text: "<b>Select Station:</b>"
        }

        ActivityIndicator {
            id: activityIndicator

            anchors.right: parent.right

            y: selectStationLabel.y - 6
        }

        anchors {
            top: parent.top
            left: parent.left
            right: parent.right

            topMargin: units.gu(2)
            margins: units.gu(2)
        }
    }

    Row {
        id: stationRow

        spacing: -20

        anchors {
            top: selectStationRow.top
            left: parent.left
            right: parent.right

            topMargin: units.gu(4)
            margins: units.gu(2)
        }

        OptionSelector {
            id: stationSelector
            containerHeight: units.gu(21.5)
            expanded: false
            model: stationsModel

            delegate: OptionSelectorDelegate {
                text: name
                subText: description
            }

            onSelectedIndexChanged: {
                activityIndicator.running = true
                console.log(stationSelector.selectedIndex);
                console.log(stationsModel.get(stationSelector.selectedIndex).idParada);
                queryInfoStationWorker.sendMessage({'stationId': stationsModel.get(stationSelector.selectedIndex).idParada})
            }
        }

        ListModel {
            id: stationsModel
            ListElement { name: "Selecciona estación..."; description: ""; }
        }
    }

    Row {
        id: availabilityRow

        spacing: 5

        anchors {
            left: parent.left
            right: parent.right
            top: stationRow.bottom
            topMargin: units.gu(2)

            margins: units.gu(2)
        }
        UbuntuShape{
            id:nextTram
            width: parent.width / 2
            height: units.gu(13)
            radius: "medium"
            color: nextColor

            Label {
                text: "  Primero"
                anchors {
                    left: parent.left
                    right: parent.right
                    leftMargin: units.gu(1)
                }
                color: "white"
            }
            Label {
                id: nextTramLabel
                text: ""
                color: "white"
                fontSize: "x-large"
                anchors.centerIn: parent
            }
        }
        UbuntuShape {
            id: nextNextTram
            width: parent.width / 2
            height: units.gu(13)
            radius: "medium"
            color: nextNextColor
            Label {
                text: "Segundo"

                anchors {
                    left: parent.left
                    right: parent.right
                    leftMargin: units.gu(1)
                }
                color: "white"
            }

            Label {
                id: nextNextTramLabel
                text: ""
                color: "white"
                fontSize: "x-large"
                anchors.centerIn: parent
            }
        }
    }

 /*   Row{

        ListView {
            id: infoStationList
            anchors {
                top: stationRow.bottom
                left: parent.left
                right: parent.right
                margins: units.gu(2)
            }
            clip: true
            model: stationInfoModel
            delegate: infoDelegate
        }

        Component {
            id:infoDelegate
            Item{
                anchors{
                    left: parent.left
                    right: parent.right
                }
                height: units.gu(4)
                Label{
                    id: txtLinea
                    text: linea
                    width: units.gu(5)
                    fontSize: "small"
                    anchors {
                        top: parent.top
                        bottom: parent.bottom
                        left: parent.left
                        margins: units.gu(0.5)
                    }

                }
                Label{
                    text: destino
                    width: units.gu(15)
                    fontSize: "small"
                    anchors {
                        top: parent.top
                        bottom: parent.bottom
                        left: txtLinea.right
                        right: txtMinutos.left
                        margins: units.gu(0.5)
                    }
                }
                Label{
                    id:txtMinutos
                    text: minutos
                    fontSize: "x-large"
                    anchors {
                        top: parent.top
                        bottom: parent.bottom
                        right: parent.right
                        margins: units.gu(0.5)
                    }
                }
            }
        }

        ListModel{
            id:stationInfoModel
            ListElement{linea:"linea"; destino:"destino"; minutos:"minutos"}
        }

    }*/

}
