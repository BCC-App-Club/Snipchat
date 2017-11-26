var http = require('http');
var fs = require('fs');
var urlPackage = require('url');
var formidable = require('formidable');

http.createServer(function (req, res) {
  
  var url = urlPackage.parse(req.url, true);

  if (url.pathname == "/page1"){
    fs.readFile('page 1.html', 'utf8', function (err, data) {
      if (err) throw err;
      res.writeHead(200, {'Content-Type': 'text/html'});
      res.write(data);
      res.end();
    });

  }else if (url.pathname == "/submitName"){

    var body = '';

    req.on('data', function (data) {
        body += data;
    });

    req.on('end', function () {
      name=JSON.parse(body);
      console.log(name["firstName"]);

      res.write('Done.');
      res.end();
    });

  }

}).listen(8080);