//http://www.zaragoza.es/api/recurso/urbanismo-infraestructuras/tranvia/2102?rf=html&srsname=wgs84
WorkerScript.onMessage = function(sentMessage){
    var xmlHttp = new XMLHttpRequest();
    var stationId = sentMessage.stationId;
    console.log("parada:"+stationId);
    var url = "http://www.zaragoza.es/api/recurso/urbanismo-infraestructuras/tranvia/"+stationId+".json?rf=html&srsname=wgs84";
    console.log(url);
	xmlHttp.open("GET", url, true);
	xmlHttp.send(null);
	xmlHttp.onreadystatechange = function() {
        console.log(xmlHttp.readyState+"-"+xmlHttp.status);
        if (xmlHttp.readyState===4 && xmlHttp.status===200){
			var msg = xmlHttp.responseText;
            console.log(msg);
			var info = JSON.parse(msg);
			if (typeof info  != 'undefined'){
                WorkerScript.sendMessage({"stationInfo":info});
            }
        }
	}
}
