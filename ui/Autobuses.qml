import QtQuick 2.0
import Ubuntu.Components 1.1
import QtQuick.XmlListModel 2.0
import Ubuntu.Components.ListItems 0.1
import QtQuick.Layouts 1.1
import Ubuntu.Components.Popups 0.1
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

    WorkerScript {
        id: queryPosteWorker
        source: "../js/infoBuses.js"

        onMessage: {
            infoBusModel.clear();
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

    /*function getInfoPoste(){
        if (posteSelector.selectedIndex >= 0){
            //activityIndicator.running = true
            queryPosteWorker.sendMessage({'posteId': linea41PuertaCarmen.get(posteSelector.selectedIndex).idParada})
            PopupUtils.open(listInfoPoste)
        }
       }*/

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
        id:columnCombos
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
                postesOpacity = 0;
                var linea= lineasModel.get(lineasSelector.selectedIndex);
                var modelFile = "../model/Linea"+linea.idLinea+"Destinos.qml";
                console.log(modelFile);
                destinoSelector.model = Qt.createComponent(modelFile);
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
                var destino = destinoSelector.model.get(lineasSelector.selectedIndex);
                var modelFile = "../model/Linea"+destino.idLinea+destino.idDestino+".qml";
                console.log(modelFile);
                posteSelector.model = Qt.createComponent(modelFile);
            }
        }

        Label {
            id: selectPosteLabel
            text: "<b>Seleciona Poste:</b>"
            opacity: postesOpacity
        }

        OptionSelector {
            id: posteSelector
            containerHeight: units.gu(21.5)
            expanded: false
            opacity: postesOpacity
            //model: stationsModel

            delegate: OptionSelectorDelegate {
                text: nombre
                subText: idParada
            }

            onSelectedIndexChanged: {
                if (posteSelector.selectedIndex > 0){
                    var posteId = posteSelector.model.get(posteSelector.selectedIndex).idParada;
                    getInfoPoste(posteId);
                }
            }//getInfoPoste();
        }


    }


}

