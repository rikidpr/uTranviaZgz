import QtQuick 2.0
import Ubuntu.Components 1.1
import QtQuick.Layouts 1.1
import U1db 1.0 as U1db
import "ui"
import "components"

MainView {
    id: mainView

    applicationName: "uinfozgz.andprsoft"
    property string version: "0.1"

    useDeprecatedToolbar: false

    width: units.gu(45)
    height: units.gu(78)


    Page {
        id:mainPage
        title: "Info Zgz"
        //head actions
		head.actions: [
			Action {
				id: aboutAction

				iconName: "info"
				text: "About"

				onTriggered: pageStack.push(Qt.resolvedUrl("ui/About.qml"));
			}
		]
		
        GridLayout {
            id: grid
            columns: 2
            width: parent.width/1.5
            height: parent.height/1.5
            anchors {
                horizontalCenter: parent.horizontalCenter
                verticalCenter: parent.verticalCenter
                verticalCenterOffset: -units.gu(10)
            }


            Rectangle {
                id: tranvias_circle
                color: "white"
                width: parent.width/2
                height: width
                radius: width/2

                MouseArea {
                    anchors.fill: parent
                    onPressed: {
                        pageStack.push(Qt.resolvedUrl("ui/Tranvias.qml"));
                    }
                }
                Icon {
                    id: tramIcon
                    source: "img/tram.png"
                    width: parent.width/1.5
                    height: width
                    anchors.centerIn: parent
                }

            }
            Rectangle {
                id: bus_circle
                color: "white"
                width: parent.width/2
                height: width
                radius: width/2
                MouseArea {
                    anchors.fill: parent
                    onPressed: {
                        pageStack.push(Qt.resolvedUrl("ui/Autobuses.qml"));
                    }
                }
                Icon {
                    id: busIcon
                    source: "img/bus.jpeg"
                    width: parent.width/1.5
                    height: width
                    anchors.centerIn: parent
                }
            }
            Rectangle {
                id: bizi_circle
                color: "white"
                width: parent.width/2
                height: width
                radius: width/2
                MouseArea {
                    anchors.fill: parent
                    onPressed: {
                        pageStack.push(Qt.resolvedUrl("ui/Bizi.qml"));
                    }
                }
                Icon {
                    id: biziIcon
                    source: "img/bizi.png"
                    width: parent.width/1.5
                    height: width
                    anchors.centerIn: parent
                }
            }
            Rectangle {
                id: favoritos_circle
                color: "white"
                width: parent.width/2
                height: width
                radius: width/2
                MouseArea {
                    anchors.fill: parent
                    onPressed: {
                        pageStack.push(Qt.resolvedUrl("ui/Favorites.qml"));
                    }
                }
                Icon {
                    id: favoriteIcon
                    name: "favorite-unselected"
                    width: parent.width/1.5
                    height: width
                    anchors.centerIn: parent
                }
            }
        }
    }

    PageStack {
        id: pageStack
        Component.onCompleted: push(mainPage)
    }

    InfoZgzColors{
        id:infoZgzColors
    }

    ////////////////////
    ///  javascript  ///
    ////////////////////

    function getColors(){
        return infoZgzColors;
    }

    function getInfoPoste(posteId, posteName){
        console.log("vamos a por la info del poste "+posteId);
        pageStack.push(Qt.resolvedUrl("ui/InfoPosteBus.qml"),{"posteId":posteId, "posteName":posteName});
    }

    function getParadaIndex(stationId, stationsModel) {
        for (var i = 0; i < stationsModel.count; i++) {
            if (stationId === stationsModel.get(i).id)
                return i;
        }
        return 0;
    }

    function setFavorite(type, stationId, name){
        console.debug(type+" / "+stationId+" / "+name);
		switch(type){
		case "BIZI":
			pageStack.push(Qt.resolvedUrl("ui/Bizi.qml"), {"preSelectedStationId":stationId});
			break;
		case "TRAM":
			pageStack.push(Qt.resolvedUrl("ui/Tranvias.qml"), {"preSelectedStationId":stationId});
			break;
		case "BUS":
			pageStack.push(Qt.resolvedUrl("ui/InfoPosteBus.qml"), {"posteId":stationId, "posteName":name});
			break;
        }
    }

	/**
	TYPES: TRAM, BUS, BIZI
	*/
    function addToFavorites(type, stationId, name){
        if (typeof stationId !== "undefined" && noExiste(type, stationId)){
			console.debug("no existe");
            infozgzAppDB.putDoc({"fav": {"type": type, "stationId": stationId, "name": name}});
			console.log("insertado ok "+type+"-"+stationId+"-"+name);
            return true;
        } else {
			console.log("existe");
            return false;
        }
    }

    function noExiste(type, stationId){
        var noExiste = true;
        var index = 0;
        while (typeof favoritosModel.get(index).docId !== "undefined"){
            var sFavorito = JSON.stringify(favoritosModel.get(index));
            var favorito= JSON.parse(sFavorito);
            if (typeof favorito.contents === "undefined"){
                continuar = false;
                break;
            } else if (favorito.contents.stationId === stationId 
				&& favorito.contents.type === type){
                noExiste= false;
                break;
            }
            index++;
            if (index>20){
                break;
            }
        }
        return noExiste;
    }

   function deleteFavorite(docId){
       infozgzAppDB.deleteDoc(docId);
       console.debug(docId+" deleted")
   }

    ////////////////////////
    ///  fin javascript  ///
    ////////////////////////


   ////////////////////
   ///   DATABASE   ///
   ////////////////////
   // U1DB backend to record the last-picked station. Makes it faster for users to get information for their usual station.
    U1db.Database {
        id: infozgzAppDB
        path: "UInfoZgzApp.u1db"
    }

    U1db.Index {
       database: infozgzAppDB
       id: favIdx

       expression: ["fav.type", "fav.stationId", "fav.name"]
   }
   U1db.Query {
       id: favoritesQuery
       index: favIdx
       //query: "*"
   }

   SortFilterModel {
       id:favoritosModel
       model: favoritesQuery
   }

}
