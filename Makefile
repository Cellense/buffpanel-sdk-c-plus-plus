LinuxCOMPILER = clang++ -std=c++11 -Wall
MacOSXCOMPILER = clang++ -stdlib=libc++ -std=c++11 -Wall

LinuxBuffPanelSDKOBJ = Build/Linux/BuffPanelSDK/*.o
LinuxBuffPanelSDKDemoOBJ = Build/Linux/BuffPanelSDKDemo/*.o
MacOSXBuffPanelSDKOBJ = Build/MacOSX/BuffPanelSDK/*.o
MacOSXBuffPanelSDKDemoOBJ = Build/MacOSX/BuffPanelSDKDemo/*.o

BuffPanelSDKDEPS = Include/*.h

Linux: Dist/Linux/libBuffPanelSDK.so Dist/Linux/BuffPanelSDKDemo

Dist/Linux/libBuffPanelSDK.so: Dist/Linux $(LinuxBuffPanelSDKOBJ)
# Link the object files into the shared library.
	$(LinuxCOMPILER) -shared $^ -o $@

Build/Linux/BuffPanelSDK/%.o: Build/Linux Source/BuffPanelSDK/%.cpp $(BuffPanelSDKDEPS)
# Build the object files from the source files.
	$(LinuxCOMPILER) -c -fPIC $< -o $@

Dist/Linux/BuffPanelSDKDemo: Dist/Linux $(LinuxBuffPanelSDKDemoOBJ)
# Link the object files into the executable.
	LD_RUN_PATH='$$ORIGIN' $(LinuxCOMPILER) -L Dist/Linux/ $^ -lBuffPanelSDK -o $@

Dist/Linux/BuffPanelSDKDemo/%.o: Build/Linux Source/BuffPanelSDKDemo/%.cpp $(BuffPanelSDKDEPS)
# Build the object files from the source files.
	$(LinuxCOMPILER) -c Source/BuffPanelSDKDemo/*.cpp -o $@

Dist/%:
# Create the dist directory.
	mkdir -p $@

Build/%:
# Create the build directory.
	mkdir -p $@

clear:
# Clear the build and dist directories.
	rm -rf Build
	rm -rf Dist

Linux/BuffPanelSDKDemo: $(BuffPanelSDKDemoDEPS)
# Clear the build directory.
	rm -rf Build/$@
	mkdir -p Build/$@



MacOSX/BuffPanelSDK: $(BuffPanelSDKDEPS)
# Clear the build directory.
	rm -rf Build/$@
	mkdir -p Build/$@
# Build the object files from the source files.
	$(MacOSXCOMPILER) -c Source/BuffPanelSDK/BuffPanel.cpp -o Build/$@/BuffPanel.o
# Link the object files into the dynamic library.
	$(MacOSXCOMPILER) -dynamiclib -install_name "@loader_path/libBuffPanelSDK.dylib" Build/$@/BuffPanel.o -o Build/$@/libBuffPanelSDK.dylib

MacOSX/BuffPanelSDKDemo: $(BuffPanelSDKDemoDEPS)
# Clear the build directory.
	rm -rf Build/$@
	mkdir -p Build/$@
# Build the object files from the source files.
	$(MacOSXCOMPILER) -c Source/BuffPanelSDKDemo/Main.cpp -o Build/$@/Main.o
# Link the object files into the executable.
	$(MacOSXCOMPILER) -L Build/MacOSX/BuffPanelSDK Build/$@/Main.o -lBuffPanelSDK -o Build/$@/BuffPanelSDKDemo
