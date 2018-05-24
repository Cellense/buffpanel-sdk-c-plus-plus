#ifndef BUFFPANEL_SDK_CLIENT_H
#define BUFFPANEL_SDK_CLIENT_H

// Include the sdk headers.
#include "Api.h"
#include "Callback.h"

// Include the standard headers.
#include <map>
#include <string>

namespace BuffPanel {
	class Client {
	public:
		static void track(
			const std::string& gameToken,
			const Callback& callback
		) {
			track(gameToken, false, callback);
		}

		static void track(
			const std::string& gameToken,
			const bool isExistingPlayer,
			const Callback& callback
		) {
			track(gameToken, isExistingPlayer, std::map<std::string, std::string>(), callback);
		}

		static void track(
			const std::string& gameToken,
			const std::map<std::string, std::string>& attributes,
			const Callback& callback = DefaultCallback()
		) {
			track(gameToken, false, attributes, callback);
		}

		static BUFFPANEL_SDK_API void track(
			const std::string& gameToken,
			const bool isExistingPlayer = false,
			const std::map<std::string, std::string>& attributes = std::map<std::string, std::string>(),
			const Callback& callback = DefaultCallback()
		);
	private:
		static const std::string _endpointUrl;
		static const std::string _version;
		static const std::string _UuidPersistPath;
	};
}

#endif
