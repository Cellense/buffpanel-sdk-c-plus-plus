#include "../../Include/BuffPanel.h"

#include <iostream>

int main(int argc, char* argv[]) {
	BuffPanel::Result result = BuffPanel::BuffPanel::track("demo_game", "demo_player", true);

	if (result.isSuccessful) {
		std::cout << "The run event was tracked successfully." << std::endl;
	} else {
		std::cout << "Tracking the run event has failed with the following error message:" << std::endl << result.message << std::endl;
	}

	return result.isSuccessful
		? 0
		: -1;
}
