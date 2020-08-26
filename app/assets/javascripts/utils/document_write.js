document._write = document.write;

document.write = function(str){
  if(str.indexOf('https://github.githubassets.com/assets/gist-embed-') != -1) {
    return;
  }
  else if (str.indexOf('<div id=\"gist-') != 0) {
    var src = this.currentScript.src;
    var scripts = document.querySelectorAll("script[src='" + src + "']");
    scripts.forEach(function(script) {
      var childNodes = script.parentNode.getElementsByTagName('div');
      
      if (childNodes.length > 0) {
        script.parentNode.removeChild(childNodes[0]);
      }

      var div = document.createElement('div');
      div.innerHTML = str;
      script.parentNode.insertBefore(div, script.nextElementSibling);
    });
  }
  else {
    document._write(str);
  }
}
