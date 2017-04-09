// BuffPanel.cpp : Defines the exported functions for the DLL application.  
// Compile by using: cl /EHsc /DBUFFPANEL_SDK_EXPORTS /LD BuffPanel.cpp  

#include "../include/BuffPanel.h"

#include <iostream>
#include <string>

void BuffPanel::BuffPanel::track(
	const std::string& gameToken,
	const std::string& playerToken,
	const bool isFirstRun
) {
	std::cout << gameToken << " " << playerToken << " " << isFirstRun << std::endl;
}
