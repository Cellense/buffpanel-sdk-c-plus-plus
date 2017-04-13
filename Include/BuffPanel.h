#ifndef BUFFPANEL_H
#define BUFFPANEL_H

#ifdef _WIN32
#	ifdef BUFFPANEL_SDK_EXPORTS
#		define BUFFPANEL_SDK_API __declspec(dllexport)
#	else
#		define BUFFPANEL_SDK_API __declspec(dllimport)
#	endif
#else
#	define BUFFPANEL_SDK_API
#endif

#include <string>

namespace BuffPanel {
	struct Result {
		bool isSuccessful;
		std::string message;

		Result()
			: isSuccessful(false)
			, message("An unknown error had ocurred")
		{}
	};

	class BuffPanel {
	public:
		static BUFFPANEL_SDK_API Result track(
			const std::string& gameToken,
			const std::string& playerToken,
			const bool isFirstRun
		);
	private:
		static bool _isTracked;

		static std::string _endpointUrl;
		static std::string _version;

		static double _initialRetryOffset;
		static int _maxRetryCount;
	};
}

#endif
