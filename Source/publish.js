// Initialize the global promise.
const Promise = require('bluebird');
global.Promise = Promise;

// Load npm modules.
const dotenv = require('dotenv');
const ssh2SftpClient = require('ssh2-sftp-client');

// Load node modules.
const fs = require('fs');

// Load environment variables.
dotenv.config();

// Instantiate an sftp client.
const sftpClient = new ssh2SftpClient();
const sshClient = sftpClient.client;

// Initialize the connection to the sftp server.
sftpClient.connect({
	host: process.env.APP_PUBLISH_HOST,
	username: process.env.APP_PUBLISH_USERNAME,
	privateKey: fs.readFileSync(process.env.APP_PUBLISH_PRIVATE_KEY_PATH, 'utf-8'),
	passphrase: process.env.APP_PUBLISH_PRIVATE_KEY_PASSPHRASE,
})
	.then(() => {
		console.log('Connection successful');

		return sftpClient.end();
	})
	.catch((err) => {
		throw err;
	});
