import { server } from './app.ts';
import { env } from './../env.ts';
import { initializeSocketServer } from './lib/socket.ts';


const PORT = env.PORT || 3000;
async function startServer() {
    try {
        // background process like notifications: goes here
        initializeSocketServer(server);

        // start server
        server.listen(PORT, () => {
            console.log('Server is running on port: ', PORT);
        });
    } catch (error: unknown) {
        console.log('App failed to start');
    }
}

// start server
startServer(); 