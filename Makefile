LinuxCOMPILER = clang++ -std=c++11 -Wall
MacintoshCOMPILER = clang++ -stdlib=libc++ -std=c++11 -Wall

BuffPanelSDKCPlusPlusDEPS = Include/BuffPanel.h Source/BuffPanelSDKCPlusPlus/BuffPanel.cpp
BuffPanelSDKCPlusPlusDemoDEPS = Include/BuffPanel.h Source/BuffPanelSDKCPlusPlusDemo/Main.cpp

Linux: Linux/BuffPanelSDKCPlusPlus Linux/BuffPanelSDKCPlusPlusDemo
# Create the dist directory.
	rm -rf Dist/$@
	mkdir -p Dist/$@
# Copy the built files.
	cp Build/$@/BuffPanelSDKCPlusPlus/libBuffPanelSDKCPlusPlus.so Dist/$@/
	cp Build/$@/BuffPanelSDKCPlusPlusDemo/BuffPanelSDKCPlusPlusDemo Dist/$@/

Linux/BuffPanelSDKCPlusPlus: $(BuffPanelSDKCPlusPlusDEPS)
# Clear the build directory.
	rm -rf Build/$@
	mkdir -p Build/$@
# Build the object files from the source files.
	$(LinuxCOMPILER) -c -fPIC Source/BuffPanelSDKCPlusPlus/BuffPanel.cpp -o Build/$@/BuffPanel.o
# Link the object files into the shared library.
	$(LinuxCOMPILER) -shared Build/$@/BuffPanel.o -o Build/$@/libBuffPanelSDKCPlusPlus.so

Linux/BuffPanelSDKCPlusPlusDemo: $(BuffPanelSDKCPlusPlusDemoDEPS)
# Clear the build directory.
	rm -rf Build/$@
	mkdir -p Build/$@
# Build the object files from the source files.
	$(LinuxCOMPILER) -c Source/BuffPanelSDKCPlusPlusDemo/Main.cpp -o Build/$@/Main.o
# Link the object files into the executable.
	LD_RUN_PATH='$$ORIGIN' $(LinuxCOMPILER) -L Build/Linux/BuffPanelSDKCPlusPlus Build/$@/Main.o -lBuffPanelSDKCPlusPlus -o Build/$@/BuffPanelSDKCPlusPlusDemo

Macintosh: Macintosh/BuffPanelSDKCPlusPlus Macintosh/BuffPanelSDKCPlusPlusDemo
# Create the dist directory.
	rm -rf Dist/$@
	mkdir -p Dist/$@
# Copy the built files.
	cp Build/$@/BuffPanelSDKCPlusPlus/libBuffPanelSDKCPlusPlus.dylib Dist/$@/
	cp Build/$@/BuffPanelSDKCPlusPlusDemo/BuffPanelSDKCPlusPlusDemo Dist/$@/

Macintosh/BuffPanelSDKCPlusPlus: $(BuffPanelSDKCPlusPlusDEPS)
# Clear the build directory.
	rm -rf Build/$@
	mkdir -p Build/$@
# Build the object files from the source files.
	$(MacintoshCOMPILER) -c Source/BuffPanelSDKCPlusPlus/BuffPanel.cpp -o Build/$@/BuffPanel.o
# Link the object files into the dynamic library.
	$(MacintoshCOMPILER) -dynamiclib -install_name "@loader_path/libBuffPanelSDKCPlusPlus.dylib" Build/$@/BuffPanel.o -o Build/$@/libBuffPanelSDKCPlusPlus.dylib

Macintosh/BuffPanelSDKCPlusPlusDemo: $(BuffPanelSDKCPlusPlusDemoDEPS)
# Clear the build directory.
	rm -rf Build/$@
	mkdir -p Build/$@
# Build the object files from the source files.
	$(MacintoshCOMPILER) -c Source/BuffPanelSDKCPlusPlusDemo/Main.cpp -o Build/$@/Main.o
# Link the object files into the executable.
	$(MacintoshCOMPILER) -L Build/Macintosh/BuffPanelSDKCPlusPlus Build/$@/Main.o -lBuffPanelSDKCPlusPlus -o Build/$@/BuffPanelSDKCPlusPlusDemo

Clean: CleanBuild CleanDist

CleanBuild:
	rm -rf Build
	mkdir -p Build

CleanDist:
	rm -rf Dist
	mkdir -p Dist
