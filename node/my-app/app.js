'use strict';

var http = require('http');

var server = http.createServer(function (req, res) {
  res.writeHead(200, {"Content-Type": "text/plain"});
  res.write("It worked!\n");
  res.end("Environment: " + process.env.NODE_ENV);
});

server.listen(3000);
