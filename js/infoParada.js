//http://www.zaragoza.es/api/recurso/urbanismo-infraestructuras/tranvia/2102?rf=html&srsname=wgs84
WorkerScript.onMessage = function(sentMessage){
	var xmlHttp = new XmlHttpRequest();
	var idParada = sentMessage.idParada;
	var url = "http://www.zaragoza.es/api/recurso/urbanismo-infraestructuras/tranvia/"+idParada+"?rf=html&srsname=wgs84";
	xmlHttp.open("GET", url, true);
	xmlHttp.send(null);
	xmlHttp.onreadystatechange = function() {
        if (xmlHttp.readyState===4 && xmlHttp.status===200){
			var msg = xmlHttp.responseText;
			var info = JSON.parse(msg);
			if (typeof info  != 'undefined'){
                WorkerScript.sendMessage({"stationInfo":info});
			}
		}
	}
}
