const tls = require('tls');
const fs = require('fs');
const https = require('https');

const options = {
  key: fs.readFileSync('server-key.pem'),
  cert: fs.readFileSync('server-crt.pem'),
  ca: fs.readFileSync('../ca-crt.pem'),
  requestCert: true,
  rejectUnauthorized: true
};

https.createServer(options, function (req, res) {
  console.log('server connected',
       res.socket.authorized ? 'authorized' : 'unauthorized');
    console.log(new Date()+' '+
        req.connection.remoteAddress+' '+
        req.method+' '+req.url);
    res.writeHead(200);
    res.end("hello world\n");
}).listen(8000);
