// Include the module header.
#include <BuffPanel/Client.h>

// Include internal headers.
#include <BuffPanel/Version.h>
#include <BuffPanel/UuidUtil.h>


// Include poco headers.
#include <Poco/Exception.h>
#include <Poco/URI.h>
#include <Poco/Net/HTTPClientSession.h>
#include <Poco/Net/HTTPMessage.h>
#include <Poco/Net/HTTPRequest.h>
#include <Poco/Net/HTTPResponse.h>
#include <Poco/JSON/Object.h>
#include <Poco/JSON/Parser.h>

// Include standard headers.
#include <istream>
#include <ostream>
#include <sstream>
#include <string>
#include <fstream>

// Define static constants.
const std::string BuffPanel::Client::_endpointUrl("http://staging.api.buffpanel.com/run_event/create");
const std::string BuffPanel::Client::_version(BUFFPANEL_SDK_VERSION);

void BuffPanel::Client::track(
	const std::string& gameToken,
	const bool isExistingPlayer,
	const std::map<std::string, std::string>& attributes,
	const Callback& callback
) {
	// Create local copies of the passed parameters.
	const std::string& _gameToken(gameToken);
	const std::map<std::string, std::string>& _attributes(attributes);
	const bool _isExistingPlayer(isExistingPlayer);
	
	std::string _playerToken;
	try 
	{
		_playerToken = BuffPanel::UuidUtil::getPlayerToken(gameToken);
	}
	catch (Poco::Exception& exception) {
		_playerToken = "unknown_player";
		callback.error("An error occured while attempting read or persist UUID: " + exception.displayText());
	}

	try {
		// Parse the endpoint URI.
		Poco::URI uri(_endpointUrl);
		std::string path(uri.getPathAndQuery());
		if (path.empty()) {
			path = "/";
		}

		// Extract the attributes parameter into the JSON.
		Poco::JSON::Object::Ptr jsonAttributes(new Poco::JSON::Object());
		for (auto it(_attributes.cbegin()); it != _attributes.cend(); ++it) {
			jsonAttributes->set(it->first, it->second);
		}

		// Initialize the JSON payload.
		Poco::JSON::Object jsonPayload;
		jsonPayload.set("game_token", _gameToken);
		jsonPayload.set("player_token", _playerToken);
		jsonPayload.set("is_existing_player", _isExistingPlayer);
		jsonPayload.set("attributes", jsonAttributes);
		jsonPayload.set("version", _version);

		// Convert the JSON object to a string stream.
		std::stringstream jsonPayloadStringStream;
		jsonPayload.stringify(jsonPayloadStringStream);

		// Initialize the HTTP client session.
		Poco::Net::HTTPClientSession session(uri.getHost(), uri.getPort());

		// Initialize the HTTP request.
		Poco::Net::HTTPRequest request(
			Poco::Net::HTTPRequest::HTTP_POST,
			path,
			Poco::Net::HTTPMessage::HTTP_1_1
		);
		request.setContentType("application/json");
		request.setContentLength(jsonPayloadStringStream.str().size());

		// Send the request to the server.
		std::ostream& requestPayloadStream = session.sendRequest(request);
		jsonPayload.stringify(requestPayloadStream);

		// Receive and parse the response.
		Poco::Net::HTTPResponse response;
		std::istream& responsePayloadStream = session.receiveResponse(response);
		Poco::JSON::Parser jsonParser;
		jsonParser.parse(responsePayloadStream);

		// Validate the response.
		if (response.getStatus() == Poco::Net::HTTPResponse::HTTPStatus::HTTP_OK) {
			// Notify the callback object that the event was successfully processed.
			callback.success();
		}
		else {
			// Notify the callback object that the server failed to process the request.
			callback.error("An invalid response was recieved from the server.");
		}
	}
	catch (Poco::Exception& exception) {
		// Notify the callback object that an error occured while attempting to communicate with the server.
		callback.error("An error occured while attempting to communicate with the server: " + exception.displayText());
	}
}
