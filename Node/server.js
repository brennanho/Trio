const http = require('http');
const public_ip = require('public-ip');
public_ip.v4().then(ip => {
  console.log("your public ip address", ip);
});

const server = http.createServer((req, res) => {
    let content = 'ip';

    // append data as it comes in
    req.on('data', data => {
        content += data;
    });

    // write the data back to the client
    req.on('end', () => {
        console.log(content);
        res.write(content);
        res.end();
    });
});

server.listen(9090, '0.0.0.0');