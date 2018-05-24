#include "BuffPanel/UuidUtil.h"

#include <Poco/UUIDGenerator.h>
#include <Poco/File.h>
#include <Poco/FileStream.h>
#include <Poco/StreamCopier.h>
#include <shlobj.h>
#include <Poco/Path.h>
#ifdef _WIN32 
#	include <Poco/UnicodeConverter.h>
#endif


std::string BuffPanel::UuidUtil::generateUuid()
{
	return Poco::UUIDGenerator().createRandom().toString();
}

Poco::Path BuffPanel::UuidUtil::getUuidPersistPath()
{
	Poco::Path uuidPersistPath;
#ifdef _WIN32 
	wchar_t wpath[MAX_PATH];
	HRESULT rc = SHGetFolderPathW(
		NULL,
		CSIDL_LOCAL_APPDATA | CSIDL_FLAG_CREATE,
		NULL, SHGFP_TYPE_CURRENT,
		wpath);
	if (SUCCEEDED(rc))
	{
		std::string localAppData;
		Poco::UnicodeConverter::toUTF8(wpath, localAppData);
		uuidPersistPath = Poco::Path(localAppData);
		uuidPersistPath.makeDirectory();
		uuidPersistPath.pushDirectory("BuffPanel");
	}
#elif __APPLE__
	uuidPersistPath = Poco::Path(Poco::Path::home());
	uuidPersistPath.pushDirectory("Library");
	uuidPersistPath.pushDirectory("Application Support");
	uuidPersistPath.pushDirectory(vendorName);
	uuidPersistPath.pushDirectory(applicationName);
#elif __linux__
	uuidPersistPath = Poco::Path(Poco::Path::home());
	uuidPersistPath.pushDirectory("." + "BuffPanel");
#endif
	return uuidPersistPath;
}

std::string BuffPanel::UuidUtil::readSavedUuid()
{
	std::string path = getUuidPersistPath().toString() + UUID_FILE_NAME;

	if (!Poco::File(path).exists() || !Poco::File(path).canRead()) {
		return std::string("");
	}
	std::string result;
	Poco::FileInputStream inStream(path);
	Poco::StreamCopier::copyToString(inStream, result);
	inStream.close();
	return result;
}

bool BuffPanel::UuidUtil::saveUuid(std::string uuid)
{
	std::string path = getUuidPersistPath().toString();

	Poco::File buffPanelDir(path);
	buffPanelDir.createDirectory();

	path = path + UUID_FILE_NAME;
	Poco::File file(path);

	if (file.exists()) {
		file.remove();
	}
	file.createFile();
	Poco::FileOutputStream outStream(file.path());
	outStream.close();
	return true;
}

