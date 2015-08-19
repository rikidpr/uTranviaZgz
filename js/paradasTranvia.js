WorkerScript.onMessage = function(msg){
    var xmlHttp = new XMLHttpRequest();
    var url = "http://www.zaragoza.es/api/recurso/urbanismo-infraestructuras/tranvia?rf=html&results_only=false&srsname=wgs84";
    xmlHttp.open("GET", url, true);
    xmlHttp.send(null);
    xmlHttp.onreadystatechange = function() {
        if (xmlHttp.readyState == 4 && xmlHttp.status == 200) {
            var msg = xmlHttp.responseText;
            var paradas = JSON.parse(msg);
            if (typeof paradas != "undefined") {
                WorkerScript.sendMessage({'paradas': paradas.result});
            }
        }
    }
}