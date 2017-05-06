#ifndef BUFFPANEL_SDK_CALLBACK_H
#define BUFFPANEL_SDK_CALLBACK_H

// Include the standard headers.
#include <string>

namespace BuffPanel {
	class Callback {
	public:
		virtual void success() const = 0;
		virtual void error(const std::string& message) const = 0;
	};

	class DefaultCallback: public Callback {
	public:
		virtual void success() const {};
		virtual void error(const std::string& message) const {};
	};
};

#endif
