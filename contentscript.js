// Based on http://stackoverflow.com/questions/14172138/

function loadXml(url) {
	request = new XMLHttpRequest();
	request.open("GET", url, false);
	request.send();

	if (request.responseXML == undefined) {
		throw "XHR failed for " + url;
	}

	return request.responseXML;
}

function transformXml() {
  var xml = loadXml(document.location.href);
  var xsl = loadXml(chrome.extension.getURL("cts2.xsl"));

  var processor = new XSLTProcessor();
  processor.importStylesheet(xsl);

  var result = processor.transformToFragment(xml, document);
  var serializer = new XMLSerializer();
  var plaintext = serializer.serializeToString(result);

  document.documentElement.innerHTML = plaintext;
}

transformXml();
