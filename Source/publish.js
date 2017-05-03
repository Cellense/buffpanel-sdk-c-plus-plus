// Initialize the global promise.
const Promise = require('bluebird');
global.Promise = Promise;

// Load npm modules.
const dotenv = require('dotenv');
const ssh2SftpClient = require('ssh2-sftp-client');

// Load node modules.
const fs = require('fs');
const path = require('path');

// Load environment variables.
dotenv.config();

// Load the repository version.
const version = JSON.parse(fs.readFileSync(path.join(__dirname, '..', 'package.json'))).version;

// Instantiate an sftp client.
const sftpClient = new ssh2SftpClient();

// Define promisified version of ssh execute.
const remoteExecute = (command) => {
	return new Proimse((resolve, reject) => {
		sftpClient.client.exec(command, (err, stream) => {
			if (err) {
				reject(err);
			}

			let outData = '';
			let errData = '';

			stream.on('close', (code, signal) => {
				resolve({
					code,
					signal,
					data: {
						out: outData,
						err: errData,
					},
				});
			}).on('data', (data) => {
				outData += data;
			}).stderr.on('data', (data) => {
				errData += data;
			});
		});
	});
};

// Initialize the connection to the server.
sftpClient.connect({
	host: process.env.APP_PUBLISH_HOST,
	username: process.env.APP_PUBLISH_USERNAME,
	privateKey: fs.readFileSync(process.env.APP_PUBLISH_PRIVATE_KEY_PATH, 'utf-8'),
	passphrase: process.env.APP_PUBLISH_PRIVATE_KEY_PASSPHRASE,
})
	.then(() => {
		// Check if the version's archive exists.
			// If yes extract it into a temp directory.
			// If no create a temp directory.
		
		// Recursiveley list the contents of the Include directory and upload them to the temp directory,
		// overwriting anything that's already there.
		// Recursiveley list the contents of the Library directory and upload them to the temp directory,
		// overwriting anything that's already there.

		// Remotely zip the contents of the temp directory into an archive named as the version,
		// while overwriting any existing archive with the same name.

		// Remove the temp directory.

		console.log('Connection successful');

		// Close the connection to the server.
		return sftpClient.end();
	})
	.catch((err) => {
		// Throw any error that may have occured.
		throw err;
	});
