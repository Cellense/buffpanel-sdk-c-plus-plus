// Include the sdk header.
#include <BuffPanel/BuffPanel.h>

// Include the standard headers.
#include <iostream>

// Define a custom callback sub-class.
class DemoCallback: public BuffPanel::Callback {
public:
	DemoCallback(bool &newIsSuccessful)
		: isSuccessful(newIsSuccessful)
	{}

	virtual void success() const {
		isSuccessful = true;
		std::cout << "The run event was tracked successfully." << std::endl;
	};

	virtual void error(const std::string& message) const {
		isSuccessful = false;
		std::cout << "Tracking the run event has failed with the following error message:" << std::endl
			<< message << std::endl;
	};
private:
	bool &isSuccessful;
};

int main(int argc, char* argv[]) {
	// Declare the success flag.
	bool isSuccessful;

	// Track a simple run event.
	BuffPanel::Client::track("demo_game", "demo_player", DemoCallback(isSuccessful));
	
	// Exit the application.
	return isSuccessful
		? 0
		: -1;
}
