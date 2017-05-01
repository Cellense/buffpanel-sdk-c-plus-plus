IsLinux = $(filter Linux,$(shell uname -s))
IsMacOsX = $(filter Darwin,$(shell uname -s))

_DEPS = Api.h BuffPanel.h Callback.h Client.h
DEPS = $(patsubst %,$(IDIR)/%,$(_DEPS))

libBuffPanelSDK = $(if $(IsMacOsX),libBuffPanelSDK.dylib,libBuffPanelSDK.so)
_libBuffPanelSDKLFLAGSRELEASE = -lPocoUtil -lPocoJSON -lPocoNet -lPocoXML -lPocoFoundation
_libBuffPanelSDKLFLAGSDEBUG = -lPocoUtild -lPocoJSONd -lPocoNetd -lPocoXMLd -lPocoFoundationd
libBuffPanelSDKLFLAGS = -LReference/Library $(if $(DEBUG),$(_libBuffPanelSDKLFLAGSDEBUG),$(_libBuffPanelSDKLFLAGSRELEASE)) -lpthread

_BuffPanelSDKDemoOBJ = Main.o
BuffPanelSDKDemoOBJ = $(patsubst %,Build/BuffPanelSDKDemo/%,$(_BuffPanelSDKDemoOBJ))
_BuffPanelSDKOBJ = Client.o
BuffPanelSDKOBJ = $(patsubst %,Build/BuffPanelSDK/%,$(_BuffPanelSDKOBJ))

IDIR = Include

CXX = clang++
CXXFLAGS = -std=c++11$(if $(IsMacOsX), -stdlib=libc++,) -Wall $(if $(DEBUG),-g -DDEBUG,-g0)
CXXCFLAGS = -I$(IDIR)
CXXLFLAGS = -static-libgcc -static-libstdc++

all: Dist/BuffPanelSDKDemo

Dist/BuffPanelSDKDemo: Dist Dist/$(libBuffPanelSDK) $(BuffPanelSDKDemoOBJ)
# Link the object files into the executable.
	$(if $(IsLinux),LD_RUN_PATH='$$ORIGIN',) $(CXX) $(CXXLFLAGS) $(CXXFLAGS) $(BuffPanelSDKDemoOBJ) -L$< -lBuffPanelSDK -o $@

Build/BuffPanelSDKDemo/%.o: Source/BuffPanelSDKDemo/%.cpp $(DEPS)
# Create the build directory.
	mkdir -p Build/BuffPanelSDKDemo
# Build the object files from the source files.
	$(CXX) $(CXXCFLAGS) $(CXXFLAGS) -c $< -o $@

Dist/libBuffPanelSDK.so: $(BuffPanelSDKOBJ)
# Link the object files into the shared library.
	$(CXX) $(CXXLFLAGS) $(CXXFLAGS) $^ $(libBuffPanelSDKLFLAGS) -shared -o $@

Dist/libBuffPanelSDK.dylib: $(BuffPanelSDKOBJ)
	$(CXX) $(CXXLFLAGS) $(CXXFLAGS) $^ $(libBuffPanelSDKLFLAGS) -dynamiclib -install_name "@loader_path/libBuffPanelSDK.dylib" -o $@

Build/BuffPanelSDK/%.o: Source/BuffPanelSDK/%.cpp $(DEPS) Build
# Build the object files from the source files.
	$(CXX) $(CXXCFLAGS) $(CXXFLAGS) -c -IReference/Include -fPIC $< -o $@

Build:
# Create the build directory.
	mkdir -p Build/BuffPanelSDK
# Copy links to libraries
	ln -s `g++ -print-file-name=libstdc++.a` Build

Dist:
# Create the dist directory.
	mkdir -p $@

clean:
# Clear the build and dist directories.
	rm -rf Build
	rm -rf Dist
