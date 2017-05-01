IsLinux = $(filter Linux,$(shell uname -s))
IsMacOsX = $(filter Darwin,$(shell uname -s))

_DEPS = Api.h BuffPanel.h Callback.h Client.h
DEPS = $(patsubst %,$(IDIR)/%,$(_DEPS))

libBuffPanelSDK = $(if $(IsMacOsX),libBuffPanelSDK.dylib,libBuffPanelSDK.so)
_libBuffPanelSDKLFLAGSRELEASE = -lPocoUtil -lPocoJSON -lPocoNet -lPocoXML -lPocoFoundation
_libBuffPanelSDKLFLAGSDEBUG = -lPocoUtild -lPocoJSONd -lPocoNetd -lPocoXMLd -lPocoFoundationd
libBuffPanelSDKLFLAGS = -LReference/Library $(if $(DEBUG),$(_libBuffPanelSDKLFLAGSDEBUG),$(_libBuffPanelSDKLFLAGSRELEASE)) -lpthread$(if $(LEGACY), -lrt)

_BuffPanelSDKDemoOBJ = Main.o
BuffPanelSDKDemoOBJ = $(patsubst %,Build/BuffPanelSDKDemo/%,$(_BuffPanelSDKDemoOBJ))
_BuffPanelSDKOBJ = Client.o
BuffPanelSDKOBJ = $(patsubst %,Build/BuffPanelSDK/%,$(_BuffPanelSDKOBJ))

IDIR = Include

CXX = $(if $(LEGACY),g++ -std=c++0x,clang++ -std=c++11)$(if $(IsMacOsX), -stdlib=libc++,)
CXXFLAGS = -Wall $(if $(DEBUG),-g -DDEBUG,-g0)
CXXCFLAGS = -I$(IDIR)
CXXLFLAGS = -static-libgcc$(if $(LEGACY),, -static-libstdc++)

all: Dist/BuffPanelSDKDemo

Dist/BuffPanelSDKDemo: Dist Dist/$(libBuffPanelSDK) $(BuffPanelSDKDemoOBJ)
# Link the object files into the executable.
	$(if $(IsLinux),LD_RUN_PATH='$$ORIGIN',) $(CXX) $(CXXLFLAGS) $(CXXFLAGS) $(BuffPanelSDKDemoOBJ) -L$< -lBuffPanelSDK -o $@

Build/BuffPanelSDKDemo/%.o: Source/BuffPanelSDKDemo/%.cpp $(DEPS) Build/BuffPanelSDKDemo
# Build the object files from the source files.
	$(CXX) $(CXXCFLAGS) $(CXXFLAGS) -c $< -o $@

Dist/libBuffPanelSDK.so: $(BuffPanelSDKOBJ)
# Link the object files into the shared library.
	$(CXX) $(CXXLFLAGS) $(CXXFLAGS) $^ $(libBuffPanelSDKLFLAGS) -shared -o $@

Dist/libBuffPanelSDK.dylib: $(BuffPanelSDKOBJ)
	$(CXX) $(CXXLFLAGS) $(CXXFLAGS) $^ $(libBuffPanelSDKLFLAGS) -dynamiclib -install_name "@loader_path/libBuffPanelSDK.dylib" -o $@

Build/BuffPanelSDK/%.o: Source/BuffPanelSDK/%.cpp $(DEPS) Build/BuffPanelSDK
# Build the object files from the source files.
	$(CXX) $(CXXCFLAGS) $(CXXFLAGS) -c -IReference/Include -fPIC $< -o $@

Build/BuffPanelSDKDemo:
# Create the build directory.
	mkdir -p Build/BuffPanelSDKDemo

Build/BuffPanelSDK:
# Create the build directory.
	mkdir -p Build/BuffPanelSDK

Dist:
# Create the dist directory.
	mkdir -p $@

clean:
# Clear the build and dist directories.
	rm -rf Build
	rm -rf Dist
