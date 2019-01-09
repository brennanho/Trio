const http = require('http');
const public_ip = require('public-ip');
public_ip.v4().then(ip => {
    const message = 'brian';
    const options = {
        method: 'GET',
        host: ip,
        port: 9090,
        path: '/',
        headers: {
            'content-type': 'text/plain',
            'content-length': message.length
        }
    };

    const req = http.request(options, res => {
        let content = '';

        // append data as it comes in
        res.on('data', data => {
            content += data;
        });

        // do something after all the data comes in
        res.on('end', () => {
            console.log(content);
        });
    });

    // send the request
    req.write(message);
    req.end();
});