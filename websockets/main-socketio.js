
const port = 3402;
const server = require('http').createServer();
const io = require("socket.io")(server);

io.on('connection', client => {
    console.log("yay");

    client.on('event', data => {

    });

    client.on('disconnect', () => {

    });
});

io.listen(port);

console.log("localhost: listening on " + port);