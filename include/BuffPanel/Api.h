#ifndef BUFFPANEL_SDK_API_H
#define BUFFPANEL_SDK_API_H

#ifdef _WIN32
#	ifdef BUFFPANEL_SDK_EXPORTS
#		define BUFFPANEL_SDK_API __declspec(dllexport)
#	else
#		define BUFFPANEL_SDK_API __declspec(dllimport)
#	endif
#else
#	define BUFFPANEL_SDK_API
#endif

#endif
