WorkerScript.onMessage = function(msg){
    var xmlHttp = new XMLHttpRequest();
    var url = "http://www.zaragoza.es/api/recurso/urbanismo-infraestructuras/tranvia.json?rf=html&results_only=false&srsname=wgs84";
    xmlHttp.open("GET", url, true);
    xmlHttp.send(null);
    xmlHttp.onreadystatechange = function() {
        console.log(xmlHttp.readyState+"-"+xmlHttp.status);
        if (xmlHttp.readyState == 4 && xmlHttp.status == 200) {
            console.log("vamos");
            var msg = xmlHttp.responseText;
            console.log(msg);
            var stations = JSON.parse(msg);
            console.log(stations);
            if (typeof stations != "undefined") {
                WorkerScript.sendMessage({'stations': stations.result});
            }
        }
    }
}
