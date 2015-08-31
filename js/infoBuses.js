//http://www.zaragoza.es/api/recurso/urbanismo-infraestructuras/transporte-urbano/poste/tuzsa-119.json
WorkerScript.onMessage = function(sentMessage){
    var xmlHttp = new XMLHttpRequest();
    var posteId = sentMessage.posteId;
    console.log("posteId:"+posteId);
    var url = "http://www.zaragoza.es/api/recurso/urbanismo-infraestructuras/transporte-urbano/poste/tuzsa-"+posteId+".json";
    console.log(url);
    xmlHttp.open("GET", url, true);
    xmlHttp.send(null);
    xmlHttp.onreadystatechange = function() {
        console.log(xmlHttp.readyState+"-"+xmlHttp.status);
        if (xmlHttp.readyState===4 && xmlHttp.status===200){
            var msg = xmlHttp.responseText;
            console.log(msg);
            var poste = JSON.parse(msg);
            if (typeof poste  != 'undefined'){
                WorkerScript.sendMessage({"posteInfo":poste});
            }
        }
    }
}

function getComponent(componentPath){
    var component = Qt.createComponent(componentPath);
    if( component.status !== Component.Ready )
    {
        console.log(component.status);
        if( component.status === Component.Error )
            console.debug("Error:"+ component.errorString() );
        return;
    } else {
        console.log("parece ok");
        var elmodelico = component.createObject(tranviaZgzPage);
        return elmodelico;
    }

}

