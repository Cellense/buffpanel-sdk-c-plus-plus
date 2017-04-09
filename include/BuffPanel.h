#ifndef BUFFPANEL_H
#define BUFFPANEL_H

#ifdef _WIN32
#ifdef BUFFPANEL_SDK_EXPORTS	
#define BUFFPANEL_SDK_API __declspec(dllexport)
#else
#define BUFFPANEL_SDK_API __declspec(dllimport)
#endif
#endif

#include <string>

namespace BuffPanel {
	class BuffPanel {
	public:
		static BUFFPANEL_SDK_API void track(
			const std::string& gameToken,
			const std::string& playerToken,
			const bool isFirstRun
		);
	};
}

#endif
