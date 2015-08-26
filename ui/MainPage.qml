import QtQuick 2.0
import Ubuntu.Components 1.1
import QtQuick.XmlListModel 2.0

Page {
    id: mainPage

    title: i18n.tr("Tranvia Zgz")

    property color nextColor: "#AA0000"
    property color nextNextColor: "#EEAAAA"
    property int preSelectedStationId:0

    function obtenerInfoEstacion (stationId){
        stationSelector.selectedIndex = getStationIndex(stationId, stationsModel)
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
					stationRow.model = null;
					break;
				case 1: 
					stationRow.model = stationsModelAcademia;
					break;
				case 2: 
					stationRow.model = stationsModelMagoOz;
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
