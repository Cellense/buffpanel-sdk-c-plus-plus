#ifndef BUFFPANEL_SDK_UUIDUTIL_H
#define BUFFPANEL_SDK_UUIDUTIL_H

// Include the standard headers.
#include <string>

namespace BuffPanel {
	class UuidUtil {
	public:
		static std::string getPlayerToken(const std::string& gameToken);
	private:
		static std::string generateUuid();
		static std::string getUuidPersistPath();
		static std::string readSavedUuid(const std::string& path);
		static void saveUuid(const std::string& filePath, const std::string& folderPath, const std::string& uuid);
	};
}
#endif
