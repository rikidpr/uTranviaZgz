import QtQuick 2.0
import Ubuntu.Components 1.1
import QtQuick.XmlListModel 2.0
import QtQuick.Layouts 1.1
import "../model"
import "../js/infoBuses.js" as IB

Page {
    id: mainPage

    title: i18n.tr("Urbanos Zgz")

    property color nextColor: "#AA0000"
    property color nextNextColor: "#EEAAAA"
    property int preSelectedStationId:0
    property int destinosOpacity:0;
    property int postesOpacity:0;

    function obtenerInfoEstacion (stationId){
        stationSelector.selectedIndex = getStationIndex(stationId, stationsModel)
    }

    WorkerScript {
        id: queryInfoStationWorker
        source: "../js/infoParada.js"

        onMessage: {
            //reseteamos indicador y valores para recarga
            activityIndicator.running = false;
            NextBusLabel.text = '';
            nextNextBusLabel.text = '';

            if (messageObject.stationInfo.destinos.length >=1){
                var infoNext = messageObject.stationInfo.destinos[0];
                NextBusLabel.text = infoNext.minutos;

                if (messageObject.stationInfo.destinos.length >=2){
                    var infoNextNext = messageObject.stationInfo.destinos[1];
                    nextNextBusLabel.text = infoNextNext.minutos;
                } else {
                    nextNextBusLabel.text = '-';
                }
            } else {
                NextBusLabel.text = '-';
                nextNextBusLabel.text = '-';
            }
        }
    }

    function getInfoStation(){
        if (stationSelector.selectedIndex > 0){
            activityIndicator.running = true
            var dest = destinosModel.get(destinoSelector.selectedIndex);
            var stationsModel;
            if (dest.destinoId === 1){
                stationsModel = stationsModelAcademia;
            } else {
                stationsModel = stationsModelMagoOz;
            }
            if (stationSelector.selected)
            console.log(stationSelector.selectedIndex);
            console.log(stationsModel.get(stationSelector.selectedIndex).idParada);
            queryInfoStationWorker.sendMessage({'stationId': stationsModel.get(stationSelector.selectedIndex).idParada})
        }
    }

/*
   head.actions: [
        Action {
            id: reloadAction
            iconName: "reload"
            text: "reload"
            onTriggered: getInfoStation();
        }

    ]

    AddFavoritePopover{
        id:addFavoritePopover
    }

    AboutPopover {
        id: aboutPopover
    }

*/
    Column {
        id:column
        anchors.fill: parent
        spacing: units.gu(1)

        Label {
            id: selectLineaLabel
            text: "<b>Selecciona Linea:</b>"
        }

        LineasBus{
            id:lineasModel
        }

        OptionSelector {
            id: lineasSelector
            containerHeight: units.gu(21.5)
            expanded: false
            model: lineasModel


            delegate: OptionSelectorDelegate {
                text: idLinea
                subText: descripcion
            }

            onSelectedIndexChanged: {
                if (lineasSelector.selectedIndex === 0){
                    destinosOpacity=0
                } else {
                    destinosOpacity=1
                }

                var linea= lineasModel.get(lineasSelector.selectedIndex);
                switch(linea.idLinea){
                case "21":
                    destinoSelector.model =linea21Destinos; break;
                case "22":
                    destinoSelector.model=linea22Destinos; break;
                case "23":
                    destinoSelector.model =linea23Destinos; break;
                case "24":
                     var linea24Dest = Qt.createComponent("../model/linea24Destinos.qml");
                    console.log(linea24Dest);
                    destinoSelector.model = linea24Dest;
                    break;
                }
            }
        }

        Label {
            id: selectDestinoLabel
            text: "<b>Selecciona Destino:</b>"
            opacity: destinosOpacity
        }

        OptionSelector {
            id: destinoSelector
            opacity: destinosOpacity
            containerHeight: units.gu(21.5)
            expanded: false

            delegate: OptionSelectorDelegate {
                text: destino
                subText:idLinea
            }

            onSelectedIndexChanged: {
           /*     var idx = destinoSelector.selectedIndex;
                switch (idx){
                case 0:
                    stationSelector.model = null;
                    break;
                case 1:
                    stationSelector.model = stationsModelAcademia;
                    break;
                case 2:
                    stationSelector.model = stationsModelMagoOz;
                    break;
                }
                */
            }
        }

    }
/*
    Row {
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
            top: destinoRow.bottom
            left: parent.left
            right: parent.right

            topMargin: units.gu(2)
            margins: units.gu(2)
        }
    }
    Row {
        id: stationRow

        anchors {
            top: selectStationRow.bottom
            left: parent.left
            right: parent.right

            topMargin: units.gu(4)
            margins: units.gu(2)
        }

        OptionSelector {
            id: stationSelector
            containerHeight: units.gu(21.5)
            expanded: false
            //model: stationsModel

            delegate: OptionSelectorDelegate {
                text: name
                subText: description
            }

            onSelectedIndexChanged: getInfoStation();
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
            id:nextBus
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
                id: nextBusLabel
                text: ""
                color: "white"
                fontSize: "x-large"
                anchors.centerIn: parent
            }
        }
        UbuntuShape {
            id: nextNextBus
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
                id: nextNextBusLabel
                text: ""
                color: "white"
                fontSize: "x-large"
                anchors.centerIn: parent
            }
        }
    }
*/

    //models
    Linea21Destinos{
        id:linea21Destinos
    }
    Linea22Destinos{
        id:linea22Destinos
    }
    Linea23Destinos{
        id:linea23Destinos
    }
}

