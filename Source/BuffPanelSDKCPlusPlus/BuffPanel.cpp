#include "../../include/BuffPanel.h"

#include <iostream>
#include <string>

void BuffPanel::BuffPanel::track(
	const std::string& gameToken,
	const std::string& playerToken,
	const bool isFirstRun
) {
	std::cout << gameToken << " " << playerToken << " " << isFirstRun << std::endl;
}
