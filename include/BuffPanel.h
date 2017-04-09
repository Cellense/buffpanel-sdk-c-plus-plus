// BuffPanel.h - Contains declaration of Function class  
#pragma once

#ifdef BUFFPANEL_SDK_EXPORTS
#define BUFFPANEL_SDK_API __declspec(dllexport)
#else
#define BUFFPANEL_SDK_API __declspec(dllimport)
#endif

#include <string>

namespace BuffPanel {
	// This class is exported from the BuffPanelSDK.dll
	class BuffPanel {
	public:
		static BUFFPANEL_SDK_API void track(
			const std::string& gameToken,
			const std::string& playerToken,
			const bool isFirstRun
		);
	};
}
