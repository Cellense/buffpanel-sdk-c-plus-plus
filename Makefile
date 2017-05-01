IsLinux = $(filter Linux,$(shell uname -s))
IsMacOsX = $(filter Darwin,$(shell uname -s))

_DEPS = Api.h BuffPanel.h Callback.h Client.h
DEPS = $(patsubst %,$(IDIR)/%,$(_DEPS))

libBuffPanelSDK = $(if $(IsMacOsX),libBuffPanelSDK.dylib,libBuffPanelSDK.so)
_libBuffPanelSDKLFLAGSRELEASE = -LReference/Library -lPocoUtil -lPocoJSON -lPocoNet -lPocoXML -lPocoFoundation -lpthread
_libBuffPanelSDKLFLAGSDEBUG = -LReference/Library -lPocoUtild -lPocoJSONd -lPocoNetd -lPocoXMLd -lPocoFoundationd -lpthread
libBuffPanelSDKLFLAGS = $(if $(DEBUG),$(_libBuffPanelSDKLFLAGSDEBUG),$(_libBuffPanelSDKLFLAGSRELEASE))

_BuffPanelSDKDemoOBJ = Main.o
BuffPanelSDKDemoOBJ = $(patsubst %,Build/BuffPanelSDKDemo/%,$(_BuffPanelSDKDemoOBJ))
_BuffPanelSDKOBJ = Client.o
BuffPanelSDKOBJ = $(patsubst %,Build/BuffPanelSDK/%,$(_BuffPanelSDKOBJ))

IDIR = Include

CXX = clang++
CXXFLAGS = -std=c++11$(if $(IsMacOsX), -stdlib=libc++,) -Wall -I$(IDIR) $(if $(DEBUG),-g -DDEBUG,-g0)

all: Dist/BuffPanelSDKDemo

Dist/BuffPanelSDKDemo: Dist Dist/$(libBuffPanelSDK) $(BuffPanelSDKDemoOBJ)
# Link the object files into the executable.
	$(if $(IsLinux),LD_RUN_PATH='$$ORIGIN',) $(CXX) $(CXXFLAGS) $(BuffPanelSDKDemoOBJ) -L$< -lBuffPanelSDK -o $@

Build/BuffPanelSDKDemo/%.o: Source/BuffPanelSDKDemo/%.cpp $(DEPS)
# Create the build directory.
	mkdir -p Build/BuffPanelSDKDemo
# Build the object files from the source files.
	$(CXX) $(CXXFLAGS) -c $< -o $@

Dist/libBuffPanelSDK.so: $(BuffPanelSDKOBJ)
# Link the object files into the shared library.
	$(CXX) $(CXXFLAGS) $^ $(libBuffPanelSDKLFLAGS) -shared -o $@

Dist/libBuffPanelSDK.dylib: $(BuffPanelSDKOBJ)
	$(CXX) $(CXXFLAGS) $^ $(libBuffPanelSDKLFLAGS) -dynamiclib -install_name "@loader_path/libBuffPanelSDK.dylib" -o $@

Build/BuffPanelSDK/%.o: Source/BuffPanelSDK/%.cpp $(DEPS)
# Create the build directory.
	mkdir -p Build/BuffPanelSDK
# Build the object files from the source files.
	$(CXX) $(CXXFLAGS) -c -IReference/Include -fPIC $< -o $@

Dist:
# Create the dist directory.
	mkdir -p $@

clean:
# Clear the build and dist directories.
	rm -rf Build
	rm -rf Dist
