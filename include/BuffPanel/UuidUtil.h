#ifndef BUFFPANEL_SDK_UUIDUTIL_H
#define BUFFPANEL_SDK_UUIDUTIL_H

// Include the standard headers.
#include <string>
#include <Poco/Path.h>

namespace BuffPanel {
	const static std::string UUID_FILE_NAME = "uuid";
	class UuidUtil {
	public:
		static std::string generateUuid();
		static Poco::Path getUuidPersistPath();
		static std::string readSavedUuid();
		static bool saveUuid(std::string uuid);
	};
}
#endif
