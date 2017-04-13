#include "../../Include/BuffPanel.h"

#include <Poco/Exception.h>
#include <Poco/URI.h>
#include <Poco/Net/HTTPClientSession.h>
#include <Poco/Net/HTTPMessage.h>
#include <Poco/Net/HTTPRequest.h>
#include <Poco/Net/HTTPResponse.h>
#include <Poco/JSON/Object.h>
#include <Poco/JSON/Parser.h>

#include <istream>
#include <ostream>
#include <sstream>
#include <string>

bool BuffPanel::BuffPanel::_isTracked = false;

std::string BuffPanel::BuffPanel::_endpointUrl = "http://buffpanel.com/api/run";
std::string BuffPanel::BuffPanel::_version = "1.0.0";

double BuffPanel::BuffPanel::_initialRetryOffset = 0.25f;
int BuffPanel::BuffPanel::_maxRetryCount = 10;

BuffPanel::Result BuffPanel::BuffPanel::track(
	const std::string& gameToken,
	const std::string& playerToken,
	const bool isFirstRun
)
{
	Result result;

	// Asure the library is being called only once.
	if (_isTracked) {
		return result;
	}

	try {
		// Parse the endpoint URI.
		Poco::URI uri(_endpointUrl);
		std::string path(uri.getPathAndQuery());
		if (path.empty()) {
			path = "/";
		}

		// Initialize the JSON payload.
		Poco::JSON::Object jsonPayload;

		jsonPayload.set("game_token", gameToken);
		jsonPayload.set("player_token", playerToken);
		jsonPayload.set("is_first_run", isFirstRun);
		jsonPayload.set("version", _version);

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
		request.setKeepAlive(true);
		request.setContentType("application/json");
		request.setContentLength(jsonPayloadStringStream.str().size());

		// Send the request.
		std::ostream& requestPayloadStream = session.sendRequest(request);
		jsonPayload.stringify(requestPayloadStream);

		// Receive and parse the response.
		Poco::Net::HTTPResponse response;
		std::istream& responsePayloadStream = session.receiveResponse(response);
		Poco::JSON::Parser jsonParser;
		jsonParser.parse(responsePayloadStream);
				
		// Validate the response.
		if (response.getStatus() == Poco::Net::HTTPResponse::HTTPStatus::HTTP_OK) {
			result.isSuccessful = true;
			result.message = "The run event was successfully tracked";

			_isTracked = true;
		} else {
			result.message = "An invalid response was recieved from the server";
		}		
	} catch (Poco::Exception& exception) {
		result.message = exception.displayText();
	}

	return result;
}
