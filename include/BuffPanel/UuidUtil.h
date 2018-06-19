#ifndef BUFFPANEL_SDK_UUIDUTIL_H
#define BUFFPANEL_SDK_UUIDUTIL_H

// Include the standard headers.
#include <string>
#include <Poco/Path.h>

namespace BuffPanel {
	const static std::string UUID_FILE_NAME = "uuid";
	class UuidUtil {
	private:
		static std::string generateUuid();
		static std::string getUuidPersistPath();
		static std::string readSavedUuid(const std::string& path);
		static void saveUuid(const std::string& filePath, const std::string& folderPath, const std::string& uuid);
	public:
		static std::string getPlayerToken(const std::string& gameToken);
	};
}
#endif
