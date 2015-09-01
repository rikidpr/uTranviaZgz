import QtQuick 2.0
import Ubuntu.Components 1.2
import QtQuick.XmlListModel 2.0
import Ubuntu.Components.Popups 1.0
import "../components"

Page {
    id: mainPage

    title: i18n.tr("Tranvia Zgz")

    property int preSelectedStationId:0

    Component.onCompleted: {
		if (preSelectedStationId > 0){
           obtenerInfoEstacion(preSelectedStationId);
            //queryInfoStationWorker.sendMessage({"stationId": preSelectedStationId})
		}
    }

    function obtenerInfoEstacion (stationId){
        console.debug("StationId:"+stationId);
        var stationIndex = 0;
        for (var i = 0; i < stationsModelAcademia.count; i++) {
            if (stationId == stationsModelAcademia.get(i).idParada){
                stationIndex = i;
                destinoSelector.selectedIndex = 1;
                break;
            }
        }
        if (stationIndex == 0){
            for (var i = 0; i < stationsModelMagoOz.count; i++) {
                if (stationId == stationsModelMagoOz.get(i).idParada){
                    stationIndex = i;
                    destinoSelector.selectedIndex = 2;
                    break;
                }
            }
        }

        console.debug("Tranvia station index:"+stationIndex);
        stationSelector.selectedIndex = stationIndex;
    }

    WorkerScript {
        id: queryInfoStationWorker
        source: "../js/infoParada.js"

        onMessage: {
            //reseteamos indicador y valores para recarga
            activityIndicator.running = false;
            nextTramLabel.text = '';
            nextNextTramLabel.text = '';

            if (messageObject.stationInfo.destinos.length >=1){
                var infoNext = messageObject.stationInfo.destinos[0];
                nextTramLabel.text = infoNext.minutos;

                if (messageObject.stationInfo.destinos.length >=2){
                    var infoNextNext = messageObject.stationInfo.destinos[1];
                    nextNextTramLabel.text = infoNextNext.minutos;
                } else {
                    nextNextTramLabel.text = '-';
                }
            } else {
                nextTramLabel.text = '-';
                nextNextTramLabel.text = '-';
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
                    var stationId = stationSelector.model.get(stationSelector.selectedIndex).idParada;
                    var name = stationSelector.model.get(stationSelector.selectedIndex).name;
                    if (addToFavorites("TRAM", stationId, name)) {
                        PopupUtils.open(addFavoritePopover)
                    }
                }
           }
        },
        Action {
            id: reloadAction
            iconName: "reload"
            text: "reload"
            onTriggered: getInfoStation();
        }

    ]

    /*AboutPopover {
        id: aboutPopover
    }*/
    Row {
        id: selectDestinoRow
        Label {
            id: selectDestinoLabel
            text: "<b>Selecciona Destino:</b>"
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
        id: destinoRow

        spacing: -20

        anchors {
            top: selectDestinoRow.top
            left: parent.left
            right: parent.right

            topMargin: units.gu(4)
            margins: units.gu(2)
        }

		ListModel{
			id:destinosModel 
            ListElement{name:"Selecciona un destino"; description:"..."; destinoId:"0"}
			ListElement{name:"AVENIDA DE LA ACADEMIA"; description:"LINEA 1"; destinoId:"1"}
			ListElement{name:"MAGO DE OZ"; description:"LINEA 1"; destinoId:"2"}
		}

        OptionSelector {
            id: destinoSelector
            containerHeight: units.gu(21.5)
            expanded: false
            model: destinosModel

            delegate: OptionSelectorDelegate {
                text: name
                subText: description
            }

            onSelectedIndexChanged: {
				var idx = destinoSelector.selectedIndex;
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
            }
        }
	}

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



        ListModel {//sacar a otro file
            id: stationsModelAcademia
            ListElement { name: "Selecciona estación..."; description: ""; }
			ListElement{idParada:"2502"; text:"MAGO DE OZ"; name:"MAGO DE OZ"; linea:"L1"; destino:"AVENIDA ACADEMIA"; description:"L1-AVENIDA ACADEMIA"}
			ListElement{idParada:"2422"; text:"UN AMERICANO EN PARIS"; name:"UN AMERICANO EN PARIS"; linea:"L1"; destino:"AVENIDA ACADEMIA"; description:"L1-AVENIDA ACADEMIA"}
			ListElement{idParada:"2322"; text:"LA VENTANA INDISCRETA"; name:"LA VENTANA INDISCRETA"; linea:"L1"; destino:"AVENIDA ACADEMIA"; description:"L1-AVENIDA ACADEMIA"}
			ListElement{idParada:"2102"; text:"PASEO DE LOS OLVIDADOS"; name:"PASEO DE LOS OLVIDADOS"; linea:"L1"; destino:"AVENIDA ACADEMIA"; description:"L1-AVENIDA ACADEMIA"}
			ListElement{idParada:"2002"; text:"ARGUALAS"; name:"ARGUALAS"; linea:"L1"; destino:"AVENIDA ACADEMIA"; description:"L1-AVENIDA ACADEMIA"}
			ListElement{idParada:"1902"; text:"CASABLANCA"; name:"CASABLANCA"; linea:"L1"; destino:"AVENIDA ACADEMIA"; description:"L1-AVENIDA ACADEMIA"}
			ListElement{idParada:"1802"; text:"ROMAREDA"; name:"ROMAREDA"; linea:"L1"; destino:"AVENIDA ACADEMIA"; description:"L1-AVENIDA ACADEMIA"}
			ListElement{idParada:"1702"; text:"EMPERADOR CARLOS V"; name:"EMPERADOR CARLOS V"; linea:"L1"; destino:"AVENIDA ACADEMIA"; description:"L1-AVENIDA ACADEMIA"}
			ListElement{idParada:"1502"; text:"FERNANDO EL CATOLICO - GOYA"; name:"FERNANDO EL CATOLICO - GOYA"; linea:"L1"; destino:"AVENIDA ACADEMIA"; description:"L1-AVENIDA ACADEMIA"}
			ListElement{idParada:"1602"; text:"PLAZA SAN FRANCISCO"; name:"PLAZA SAN FRANCISCO"; linea:"L1"; destino:"AVENIDA ACADEMIA"; description:"L1-AVENIDA ACADEMIA"}
			ListElement{idParada:"1402"; text:"GRAN VIA"; name:"GRAN VIA"; linea:"L1"; destino:"AVENIDA ACADEMIA"; description:"L1-AVENIDA ACADEMIA"}
			ListElement{idParada:"1312"; text:"PLAZA ARAGON"; name:"PLAZA ARAGON"; linea:"L1"; destino:"AVENIDA ACADEMIA"; description:"L1-AVENIDA ACADEMIA"}
			ListElement{idParada:"1302"; text:"PLAZA ESPANA"; name:"PLAZA ESPANA"; linea:"L1"; destino:"AVENIDA ACADEMIA"; description:"L1-AVENIDA ACADEMIA"}
			ListElement{idParada:"1202"; text:"CESAR AUGUSTO"; name:"CESAR AUGUSTO"; linea:"L1"; destino:"AVENIDA ACADEMIA"; description:"L1-AVENIDA ACADEMIA"}
			ListElement{idParada:"1102"; text:"PLAZA DEL PILAR - MURALLAS"; name:"PLAZA DEL PILAR - MURALLAS"; linea:"L1"; destino:"AVENIDA ACADEMIA"; description:"L1-AVENIDA ACADEMIA"}
			ListElement{idParada:"1002"; text:"LA CHIMENEA"; name:"LA CHIMENEA"; linea:"L1"; destino:"AVENIDA ACADEMIA"; description:"L1-AVENIDA ACADEMIA"}
			ListElement{idParada:"902"; text:"MARIA MONTESSORI"; name:"MARIA MONTESSORI"; linea:"L1"; destino:"AVENIDA ACADEMIA"; description:"L1-AVENIDA ACADEMIA"}
			ListElement{idParada:"802"; text:"LEON FELIPE"; name:"LEON FELIPE"; linea:"L1"; destino:"AVENIDA ACADEMIA"; description:"L1-AVENIDA ACADEMIA"}
			ListElement{idParada:"702"; text:"PABLO NERUDA"; name:"PABLO NERUDA"; linea:"L1"; destino:"AVENIDA ACADEMIA"; description:"L1-AVENIDA ACADEMIA"}
			ListElement{idParada:"602"; text:"ADOLFO AZNAR"; name:"ADOLFO AZNAR"; linea:"L1"; destino:"AVENIDA ACADEMIA"; description:"L1-AVENIDA ACADEMIA"}
			ListElement{idParada:"502"; text:"GARCIA ABRIL"; name:"GARCIA ABRIL"; linea:"L1"; destino:"AVENIDA ACADEMIA"; description:"L1-AVENIDA ACADEMIA"}
			ListElement{idParada:"402"; text:"CAMPUS RIO EBRO"; name:"CAMPUS RIO EBRO"; linea:"L1"; destino:"AVENIDA ACADEMIA"; description:"L1-AVENIDA ACADEMIA"}
			ListElement{idParada:"302"; text:"JUSLIBOL"; name:"JUSLIBOL"; linea:"L1"; destino:"AVENIDA ACADEMIA"; description:"L1-AVENIDA ACADEMIA"}
			ListElement{idParada:"202"; text:"PARQUE GOYA"; name:"PARQUE GOYA"; linea:"L1"; destino:"AVENIDA ACADEMIA"; description:"L1-AVENIDA ACADEMIA"}
			ListElement{idParada:"102"; text:"AVENIDA DE LA ACADEMIA"; name:"AVENIDA DE LA ACADEMIA"; linea:"L1"; destino:"AVENIDA ACADEMIA"; description:"L1-AVENIDA ACADEMIA"}
		}
		
		ListModel {//sacar a otro file
            id: stationsModelMagoOz
            ListElement { name: "Selecciona estación..."; description: ""; }
			ListElement{idParada:"101"; text:"AVENIDA DE LA ACADEMIA"; name:"AVENIDA DE LA ACADEMIA"; linea:"L1"; destino:"MAGO DE OZ"; description:"L1-MAGO DE OZ"}
			ListElement{idParada:"201"; text:"PARQUE GOYA"; name:"PARQUE GOYA"; linea:"L1"; destino:"MAGO DE OZ"; description:"L1-MAGO DE OZ"}
			ListElement{idParada:"301"; text:"JUSLIBOL"; name:"JUSLIBOL"; linea:"L1"; destino:"MAGO DE OZ"; description:"L1-MAGO DE OZ"}
			ListElement{idParada:"401"; text:"CAMPUS RIO EBRO"; name:"CAMPUS RIO EBRO"; linea:"L1"; destino:"MAGO DE OZ"; description:"L1-MAGO DE OZ"}
			ListElement{idParada:"501"; text:"MARGARITA XIRGU"; name:"MARGARITA XIRGU"; linea:"L1"; destino:"MAGO DE OZ"; description:"L1-MAGO DE OZ"}
			ListElement{idParada:"601"; text:"LEGAZ LACAMBRA"; name:"LEGAZ LACAMBRA"; linea:"L1"; destino:"MAGO DE OZ"; description:"L1-MAGO DE OZ"}
			ListElement{idParada:"701"; text:"CLARA CAMPOAMOR"; name:"CLARA CAMPOAMOR"; linea:"L1"; destino:"MAGO DE OZ"; description:"L1-MAGO DE OZ"}
			ListElement{idParada:"801"; text:"ROSALIA DE CASTRO"; name:"ROSALIA DE CASTRO"; linea:"L1"; destino:"MAGO DE OZ"; description:"L1-MAGO DE OZ"}
			ListElement{idParada:"901"; text:"MARTINEZ SORIA"; name:"MARTINEZ SORIA"; linea:"L1"; destino:"MAGO DE OZ"; description:"L1-MAGO DE OZ"}
			ListElement{idParada:"1001"; text:"LA CHIMENEA"; name:"LA CHIMENEA"; linea:"L1"; destino:"MAGO DE OZ"; description:"L1-MAGO DE OZ"}
			ListElement{idParada:"1101"; text:"PLAZA DEL PILAR - MURALLAS"; name:"PLAZA DEL PILAR - MURALLAS"; linea:"L1"; destino:"MAGO DE OZ"; description:"L1-MAGO DE OZ"}
			ListElement{idParada:"1201"; text:"CESAR AUGUSTO"; name:"CESAR AUGUSTO"; linea:"L1"; destino:"MAGO DE OZ"; description:"L1-MAGO DE OZ"}
			ListElement{idParada:"1301"; text:"PLAZA ESPANA"; name:"PLAZA ESPANA"; linea:"L1"; destino:"MAGO DE OZ"; description:"L1-MAGO DE OZ"}
			ListElement{idParada:"1311"; text:"PLAZA ARAGON"; name:"PLAZA ARAGON"; linea:"L1"; destino:"MAGO DE OZ"; description:"L1-MAGO DE OZ"}
			ListElement{idParada:"1401"; text:"GRAN VIA"; name:"GRAN VIA"; linea:"L1"; destino:"MAGO DE OZ"; description:"L1-MAGO DE OZ"}
			ListElement{idParada:"1501"; text:"FERNANDO EL CATOLICO - GOYA"; name:"FERNANDO EL CATOLICO - GOYA"; linea:"L1"; destino:"MAGO DE OZ"; description:"L1-MAGO DE OZ"}
			ListElement{idParada:"1601"; text:"PLAZA SAN FRANCISCO"; name:"PLAZA SAN FRANCISCO"; linea:"L1"; destino:"MAGO DE OZ"; description:"L1-MAGO DE OZ"}
			ListElement{idParada:"1701"; text:"EMPERADOR CARLOS V"; name:"EMPERADOR CARLOS V"; linea:"L1"; destino:"MAGO DE OZ"; description:"L1-MAGO DE OZ"}
			ListElement{idParada:"1801"; text:"ROMAREDA"; name:"ROMAREDA"; linea:"L1"; destino:"MAGO DE OZ"; description:"L1-MAGO DE OZ"}
			ListElement{idParada:"1901"; text:"CASABLANCA"; name:"CASABLANCA"; linea:"L1"; destino:"MAGO DE OZ"; description:"L1-MAGO DE OZ"}
			ListElement{idParada:"2001"; text:"ARGUALAS"; name:"ARGUALAS"; linea:"L1"; destino:"MAGO DE OZ"; description:"L1-MAGO DE OZ"}
			ListElement{idParada:"2101"; text:"PASEO DE LOS OLVIDADOS"; name:"PASEO DE LOS OLVIDADOS"; linea:"L1"; destino:"MAGO DE OZ"; description:"L1-MAGO DE OZ"}
			ListElement{idParada:"2301"; text:"LOS PAJAROS"; name:"LOS PAJAROS"; linea:"L1"; destino:"MAGO DE OZ"; description:"L1-MAGO DE OZ"}
			ListElement{idParada:"2401"; text:"CANTANDO BAJO LA LLUVIA"; name:"CANTANDO BAJO LA LLUVIA"; linea:"L1"; destino:"MAGO DE OZ"; description:"L1-MAGO DE OZ"}
			ListElement{idParada:"2501"; text:"MAGO DE OZ"; name:"MAGO DE OZ"; linea:"L1"; destino:"MAGO DE OZ"; description:"L1-MAGO DE OZ"}
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
            color: getColors().darkRed

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
            color: getColors().pink
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

    /*
        id:realoadRow
        anchors {
            left: parent.left
            right: parent.right
            top: availabilityRow.bottom
            topMargin: units.gu(2)

            margins: units.gu(2)
        }
        Button {
          id:btnReload
          color: UbuntuColors.warmGrey
          iconName:"reload"
          height: units.gu(6)
          width: realoadRow.width
          onClicked: getInfoStation();
        }

    }
    */

}
