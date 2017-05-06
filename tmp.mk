

IsLinux = $(filter Linux,$(shell uname -s))
IsMacOsX = $(filter Darwin,$(shell uname -s))

_DEPS = Api.h BuffPanel.h Callback.h Client.h
DEPS = $(patsubst %,$(IDIR)/%,$(_DEPS))

libBuffPanelSdk = $(if $(IsMacOsX),libBuffPanelSdk.dylib,libBuffPanelSdk.so)
_libBuffPanelSdkLFLAGSRELEASE = -lPocoUtil -lPocoJSON -lPocoNet -lPocoXML -lPocoFoundation
_libBuffPanelSdkLFLAGSDEBUG = -lPocoUtild -lPocoJSONd -lPocoNetd -lPocoXMLd -lPocoFoundationd
libBuffPanelSdkLFLAGS = -LReference/Library $(if $(DEBUG),$(_libBuffPanelSdkLFLAGSDEBUG),$(_libBuffPanelSdkLFLAGSRELEASE)) -lpthread$(if $(LEGACY), -lrt)

_BuffPanelSdkDemoOBJ = Main.o
BuffPanelSdkDemoOBJ = $(patsubst %,Build/BuffPanelSdkDemo/%,$(_BuffPanelSdkDemoOBJ))
_BuffPanelSdkOBJ = Client.o
BuffPanelSdkOBJ = $(patsubst %,Build/BuffPanelSdk/%,$(_BuffPanelSdkOBJ))

CXX = $(if $(LEGACY),g++ -std=c++0x,clang++ -std=c++11)$(if $(IsMacOsX), -stdlib=libc++,)
CXXFLAGS = -Wall $(if $(DEBUG),-g -DDEBUG,-g0)
CXXLFLAGS = $(if $(IsLinux),-static-libgcc,) $(if $(LEGACY),,-static-libstdc++)

all: Dist/BuffPanelSdkDemo

Dist/BuffPanelSdkDemo: Dist Dist/$(libBuffPanelSdk) $(BuffPanelSdkDemoOBJ)
# Link the object files into the executable.
	$(if $(IsLinux),LD_RUN_PATH='$$ORIGIN',) $(CXX) $(CXXLFLAGS) $(CXXFLAGS) $(BuffPanelSdkDemoOBJ) -L$< -lBuffPanelSdk -o $@

Build/BuffPanelSdkDemo/%.o: Source/BuffPanelSdkDemo/%.cpp $(DEPS) Build/BuffPanelSdkDemo
# Build the object files from the source files.
	$(CXX) $(CXXCFLAGS) $(CXXFLAGS) -c $< -o $@

Dist/libBuffPanelSdk.so: $(BuffPanelSdkOBJ)
# Link the object files into the shared library.
	$(CXX) $(CXXLFLAGS) $(CXXFLAGS) $^ $(libBuffPanelSdkLFLAGS) -shared -o $@

Dist/libBuffPanelSdk.dylib: $(BuffPanelSdkOBJ)
	$(CXX) $(CXXLFLAGS) $(CXXFLAGS) $^ $(libBuffPanelSdkLFLAGS) -dynamiclib -install_name "@loader_path/libBuffPanelSdk.dylib" -o $@

Build/BuffPanelSdk/%.o: Source/BuffPanelSdk/%.cpp $(DEPS) Build/BuffPanelSdk
# Build the object files from the source files.
	$(CXX) $(CXXCFLAGS) $(CXXFLAGS) -c -IReference/Include -fPIC $< -o $@
