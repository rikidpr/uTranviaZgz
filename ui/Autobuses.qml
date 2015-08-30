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
                switch(linea.idLinea){
                case "21":
                    destinoSelector.model =linea21Destinos; break;
                case "22":
                    destinoSelector.model=linea22Destinos; break;
                case "23":
                    destinoSelector.model =linea23Destinos; break;
                /*case "24":
                     var linea24Dest = Qt.createComponent("../model/linea24Destinos.qml");
                    console.log(linea24Dest);
                    destinoSelector.model = linea24Dest;
                    break;*/
                case "41":
                    destinoSelector.model = linea41Destinos; break;
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
                var destino = "";
                var linea= lineasModel.get(lineasSelector.selectedIndex);
                switch(linea.idLinea){
                case "21":
                    destinoSelector.model =linea21Destinos; break;
                case "22":
                    destinoSelector.model=linea22Destinos; break;
                case "23":
                    destinoSelector.model =linea23Destinos; break;
                /*case "24":
                     var linea24Dest = Qt.createComponent("../model/linea24Destinos.qml");
                    console.log(linea24Dest);
                    destinoSelector.model = linea24Dest;
                    break;*/
                case "41":
                    destinoSelector.model = linea41Destinos;
                    destino = linea41Destinos.get(destinoSelector.selectedIndex);
                    break;
                }
                console.log(destinoSelector.selectedIndex+"-"+destino);
                if (destino.idDestino === "ROSALESDELCANAL") {
                    posteSelector.model = linea41RosalesCanal;
                    postesOpacity =1;
                } else {
                    posteSelector.model = linea41PuertaCarmen;
                    postesOpacity =1;
                }

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
                var posteId = linea41PuertaCarmen.get(posteSelector.selectedIndex).idParada;
                getInfoPoste(posteId);
            }//getInfoPoste();
        }


    }


   /*Component {
        id: resultsDelegate
        Row{
            anchors.fill: parent
            Label{
                 //text: linea
                 text:idParada
                 width: units.gu(8)
            }
            Label{
                 //text: destino
                text:idDestino
                 width: units.gu(8)
            }
            Label{
                 //text: primero
                text:nombre
                 width: units.gu(8)
            }
            //Label{
            //     text: segundo
            //     width: units.gu(8)
            //}
        }
    }
*/

    //models
    Linea21Destinos{
        id:linea21Destinos
    }
    Linea21OLIVER{
        id:linea21Oliver
    }

    Linea22Destinos{
        id:linea22Destinos
    }
    Linea23Destinos{
        id:linea23Destinos
    }
    Linea41Destinos{
        id:linea41Destinos
    }
    Linea41PUERTACARMEN{
        id:linea41PuertaCarmen
    }
    Linea41ROSALESDELCANAL{
        id:linea41RosalesCanal
    }
}

