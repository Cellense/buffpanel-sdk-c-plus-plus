#include "../../Include/BuffPanel.h"

#include <Poco/Exception.h>
#include <Poco/URI.h>
#include <Poco/Net/HTTPClientSession.h>
#include <Poco/Net/HTTPMessage.h>
#include <Poco/Net/HTTPRequest.h>
#include <Poco/Net/HTTPResponse.h>
#include <Poco/JSON/Object.h>
#include <Poco/JSON/Parser.h>

#include <iostream>
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
	_isTracked = true;

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

		// Configure the iteration variables.
		bool isRequestSuccessfull(false);
		double retryOffset(_initialRetryOffset);

		for (int retryCount = 0; retryCount < _maxRetryCount; ++retryCount) {
			try {
				// Send the request.
				std::ostream& requestPayloadStream = session.sendRequest(request);
				jsonPayload.stringify(requestPayloadStream);

				// Receive the response.
				Poco::Net::HTTPResponse response;
				std::istream& responsePayloadStream = session.receiveResponse(response);
				
				// Validate the response.
				if (response.getStatus() == Poco::Net::HTTPResponse::HTTPStatus::HTTP_OK) {
					isRequestSuccessfull = true;
					result.errorMessage = "";
				} else {
					result.errorMessage = "An invalid response was recieved from the server";
				}
			} catch (Poco::Exception& exception) {
				result.errorMessage = exception.displayText();
			}

			// Break if the request was successful.
			if (isRequestSuccessfull) {
				break;
			}

			// Wait for a certain ammount of time otherwise.
			yield return new WaitForSeconds(retryOffset);
			retryOffset *= 2;
		}

		
	} catch (Poco::Exception& exception) {
		result.isSuccessful = false;
		result.errorMessage = exception.displayText();
	}

	return result;
}
