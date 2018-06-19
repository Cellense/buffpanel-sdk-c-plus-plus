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

std::string BuffPanel::UuidUtil::getUuidPersistPath()
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
	uuidPersistPath.pushDirectory(".local");
	uuidPersistPath.pushDirectory("BuffPanel");
#elif __linux__
	uuidPersistPath = Poco::Path(Poco::Path::home());
	uuidPersistPath.pushDirectory(".local");
	uuidPersistPath.pushDirectory("BuffPanel");
#endif
	return uuidPersistPath.toString();
}

std::string BuffPanel::UuidUtil::readSavedUuid(const std::string& path)
{
	if (!Poco::File(path).exists() || !Poco::File(path).canRead()) 
	{
		return std::string("");
	}
	std::string result;
	Poco::FileInputStream inStream(path);
	Poco::StreamCopier::copyToString(inStream, result);
	inStream.close();

	Poco::UUID pocoUuid;
	if (!pocoUuid.tryParse(result))
		return std::string("");

	return result;
}

void BuffPanel::UuidUtil::saveUuid(const std::string& filePath, const std::string& folderPath, const std::string& uuid)
{
	Poco::File buffPanelDir(folderPath);
	buffPanelDir.createDirectory();

	Poco::File buffPanelFile(filePath);

	if (buffPanelFile.exists())
	{
		buffPanelFile.remove();
	}
	buffPanelFile.createFile();
	Poco::FileOutputStream outStream(buffPanelFile.path());
	outStream << uuid << std::endl;
	outStream.close();
}

std::string BuffPanel::UuidUtil::getPlayerToken(const std::string& gameToken)
{
	const std::string folderPath = getUuidPersistPath();
	const std::string filePath = folderPath + "uuid_" + gameToken;
	std::string uuid = BuffPanel::UuidUtil::readSavedUuid(filePath);
	if (uuid.empty())
	{
		uuid = BuffPanel::UuidUtil::generateUuid();
		BuffPanel::UuidUtil::saveUuid(filePath, folderPath, uuid);
	}
	return uuid;
}

