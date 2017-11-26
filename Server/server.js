var http = require('http');
var urlPackage = require('url');
var formidable = require('formidable');
var fs = require ('fs');
var mysql = require ('mysql');
var apn = require('apn');

var con = mysql.createConnection({
  host: "localhost",
  user: "root",
  password: "",
  database: "Snipchat"
});
con.connect(function(err) {
  if (err) throw err;
  console.log("Connected!");
});

var options = {
  token: {
    key: "AuthKey_9V33ARG2VU.p8",
    keyId: "9V33ARG2VU",
    teamId: "2YGP292648"
  },
  production: false
};
var apnProvider = new apn.Provider(options);


http.createServer(function (req, res) {

  url=urlPackage.parse(req.url, true);

  if (url.pathname == '/setDeviceToken') {
    var sql = "SELECT username FROM sessions WHERE id=\""+url.query["sessionId"]+"\";";
    con.query(sql, function (err, result, fields) {
      if (err) throw err;
      var username=result[0]["username"];
      var sql = "UPDATE users SET deviceToken=\""+url.query["deviceToken"]+"\" WHERE username=\""+username+"\";";
      con.query(sql, function (err, result) {
        if (err) throw err;
        console.log("Set device token for "+username);
        res.writeHead(200, {'Content-Type': 'text/html'});
        res.write('Success');
        res.end();
      });
    });

  }else if (url.pathname == '/login') {
    console.log('Logging in...');

    var sql = "SELECT * FROM users WHERE username=\""+url.query["username"]+"\" AND password=\""+url.query["password"]+"\";";
    con.query(sql, function (err, result) {
      if (err) throw err;
      if (result==""){ //wrong credentials
        console.log("Wrond username or password")
        res.writeHead(404, {'Content-Type': 'application/json'});
        res.write('{"reason":"Wrong username or password"}');
        res.end();
      }else{
        var timestamp=parseInt(Date.now()/1000);
        var sql = "INSERT INTO sessions (username, startTime) VALUES (\""+url.query["username"]+"\", "+timestamp+");";
        con.query(sql, function (err, result) {
          if (err) throw err;
          console.log("Made session Id:"+result.insertId);
          res.writeHead(200, {'Content-Type': 'application/json'});
          res.write('{"sessionId":'+result.insertId+'}');
          res.end();
        });
      }
    });

  }else if (url.pathname == '/getSnips') {

    var sql = "SELECT username FROM sessions WHERE id=\""+url.query["sessionId"]+"\";";
    con.query(sql, function (err, result, fields) {
      if (err) throw err;
      var username=result[0]["username"];
      var sql = "SELECT * FROM snips WHERE toUsername=\""+username+"\" OR fromUsername=\""+username+"\" ORDER BY id DESC;";
      con.query(sql, function (err, result, fields) {
        if (err) throw err;
        res.writeHead(200, {'Content-Type': 'application/json'});
        var snips=[];
        for (var i in result){
          var row =result[i];
          snips.push(JSON.parse(JSON.stringify(row)));
        }
        console.log("Sent snips");
        res.write(JSON.stringify(snips));
        res.end();
      });
    });

  }else if (url.pathname == '/sendSnip') {
    console.log("Sending snip");

    var sql = "SELECT username FROM sessions WHERE id=\""+url.query["sessionId"]+"\";";
    con.query(sql, function (err, result, fields) {
      if (err) throw err;
      var username=result[0]["username"];

      var sql = "SELECT username,deviceToken FROM users WHERE username=\""+url.query["toUsername"]+"\";";
      con.query(sql, function (err, result, fields) {
        if (err) throw err;
        var deviceToken=result[0]["deviceToken"];
        if (result=="" || url.query["toUsername"]==username){//User doesn't exist
          console.log("Send user doesn't exist.");
          res.writeHead(404, {'Content-Type': 'application/json'});
          res.write('{"reason":"User doesn\'t exist."}');
          res.end();

        }else{ //User exists

          var sql="SELECT id FROM snips ORDER BY id DESC LIMIT 1;"; //Get Snip ID
          con.query(sql, function (err, result, fields) {
            if (err) throw err;
            var snipNum=parseInt(result[0]["id"])+1;
            var timestamp=parseInt(Date.now()/1000);
            var sql = "INSERT INTO snips (fromUsername, toUsername, timestamp, filename) VALUES (\""+username+
              "\", \""+url.query["toUsername"]+"\", "+timestamp+", \"snip_"+snipNum+".jpg\");"; //Create Snip
            con.query(sql, function (err, result, fields) {
              if (err) throw err;
              console.log("Snip created.");
            });

            var form = new formidable.IncomingForm();
            form.parse(req, function (err, fields, files) {
              if (err) throw err;
              var oldpath = files.snip.path;
              var newpath = "Snips/snip_"+snipNum+".jpg";

              fs.rename(oldpath, newpath, function (err) { //Create Snip image file
                if (err) throw err;
                console.log("Snip saved.");
            
                res.writeHead(200, {'Content-Type': 'text/html'});
                res.write("Success");
                res.end();
              });
            });
          });

          var notification = new apn.Notification();
          notification.topic = 'azuleng.Snipchat';
          notification.expiry = Math.floor(Date.now() / 1000) + 3600;
          // notification.badge = 3;
          notification.sound = 'default';
          notification.alert = 'from '+username;

          apnProvider.send(notification, deviceToken).then(function(result) {
              console.log("Notification: "+result);
          });


        }
      });
    });
    // });

  }else if (url.pathname == '/viewSnip') {

    console.log("Viewing snip:"+url.query["filename"]);

    var sql = "UPDATE snips SET seen=1 WHERE filename=\""+url.query["filename"]+"\";";
    con.query(sql, function (err, result, fields) {
      if (err) throw err;
    });

    var img = fs.readFileSync('Snips/'+url.query["filename"]);

    fs.unlink('Snips/'+url.query["filename"]);

    res.writeHead(200, {'Content-Type': 'image/jpeg' });
    res.end(img, 'binary');

  }
}).listen(8080);